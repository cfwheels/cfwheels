<cfcomponent output="false" mixin="none" environment="design,development,maintenance">

	<cfscript>
	include "../global/cfml.cfm";

	public dbmigrate function init(
		string migratePath = "/db/migrate/",
		string sqlPath = "/db/sql/",
		string templatePath = "wheels/dbmigrate/templates/"
	) {
		this.paths.migrate   = ExpandPath(arguments.migratePath);
		this.paths.sql       = ExpandPath(arguments.sqlPath);
		this.paths.templates = ExpandPath(arguments.templatePath);
		this.paths.migrateComponents = ArrayToList(ListToArray(arguments.migratePath, "/"), ".");
		return this;
	}

	/**
	* migrates database to a specified version
	*/
	public string function migrateTo(string version = "") {
		var loc = {};
		loc.feedback = "";
		loc.versionsCurrentlyMigrated = $getVersionsPreviouslyMigrated();
		loc.currentVersion = ListLast(loc.versionsCurrentlyMigrated);
		if (loc.currentVersion eq arguments.version) {
			loc.feedback = "Database is currently at version #arguments.version#. No migration required.#chr(13)#";
		} else {
			if (! DirectoryExists(this.paths.sql)) {
				directoryCreate(this.paths.sql);
			}
			loc.migrations = getAvailableMigrations();
			if (loc.currentVersion gt arguments.version) {
				loc.feedback = "Migrating from #loc.currentVersion# down to #arguments.version#.#chr(13)#";
				for ( loc.i=ArrayLen( loc.migrations ); loc.i >= 1; loc.i-- ) {
					loc.migration = loc.migrations[loc.i];
					if (loc.migration.version lte arguments.version) {
						break;
					}
					if (loc.migration.status eq "migrated") {
            transaction action="begin" {
							try {
  							loc.feedback = loc.feedback & "#chr(13)#------- " & loc.migration.cfcfile & " #RepeatString("-",Max(5,50-Len(loc.migration.cfcfile)))##chr(13)#";
  							Request.migrationOutput = "";
  							Request.migrationSQLFile = "#this.paths.sql#/#loc.migration.cfcfile#_down.sql";
  							fileWrite(Request.migrationSQLFile, "");
  							loc.migration.cfc.down();
  							loc.feedback = loc.feedback & Request.migrationOutput;
  							$removeVersionAsMigrated(loc.migration.version);
							} catch(any e) {
  							loc.feedback = loc.feedback & "Error migrating to #loc.migration.version#.#chr(13)##CFCATCH.Message##chr(13)##CFCATCH.Detail##chr(13)#";
                transaction action="rollback";
  							break;
  						}
              transaction action="commit";
						}
					}
				}
			} else {
				loc.feedback = "Migrating from #loc.currentVersion# up to #arguments.version#.#chr(13)#";
				for (loc.migration in loc.migrations) {
					if (loc.migration.version lte arguments.version and loc.migration.status neq "migrated") {
	          transaction {
							try {
  							loc.feedback = loc.feedback & "#chr(13)#-------- " & loc.migration.cfcfile & " #RepeatString("-",Max(5,50-Len(loc.migration.cfcfile)))##chr(13)#";
  							Request.migrationOutput = "";
  							Request.migrationSQLFile = "#this.paths.sql#/#loc.migration.cfcfile#_up.sql";
  							fileWrite(Request.migrationSQLFile, "");
  							loc.migration.cfc.up();
  							loc.feedback = loc.feedback & Request.migrationOutput;
  							$setVersionAsMigrated(loc.migration.version);
	  					} catch(any e) {
								loc.feedback = loc.feedback & "Error migrating to #loc.migration.version#.#chr(13)##CFCATCH.Message##chr(13)##CFCATCH.Detail##chr(13)#";
                transaction action="rollback";
               	break;
							}
	            transaction action="commit";
	        	}
					} else if (loc.migration.version gt arguments.version) {
						break;
					}
				};
			}
		}
		return loc.feedback;
	}

	// returns current database version
	public string function getCurrentMigrationVersion(){
		return ListLast($getVersionsPreviouslyMigrated());
	}

	// Create a migration File
	public string function createMigration(
		required string migrationName,
		string templateName="",
		string migrationPrefix="timestamp"
	){
		if(len(trim(arguments.migrationName)) GT 0){
			return $copyTemplateMigrationAndRename(argumentCollection=arguments);
		} else {
			return "You must supply a migration name (e.g. 'creates member table')";
		}
	}
	</cfscript>

	<cffunction name="getAvailableMigrations" access="public" returntype="array" hint="searches db/migrate folder for migrations">
		<cfargument name="path" type="string" required="false" default="#this.paths.migrate#">
		<cfscript>
			var loc = {};
			loc.listVersionsPreviouslyMigrated = $getVersionsPreviouslyMigrated();
			loc.migrations = ArrayNew(1);
			loc.migrationRE = "^([\d]{3,14})_([^\.]*)\.cfc$";
		</cfscript>
		<cfset var loc = {}>
		<cfset loc.listVersionsPreviouslyMigrated = $getVersionsPreviouslyMigrated()>
		<cfset loc.migrations = ArrayNew(1)>
		<cfset loc.migrationRE = "^([\d]{3,14})_([^\.]*)\.cfc$">
		<cfif !DirectoryExists(this.paths.migrate)>
			<cfdirectory action="create" directory="#this.paths.migrate#">
		</cfif>
		<cfdirectory action="list" name="qMigrationFiles" directory="#this.paths.migrate#" sort="Name" filter="*.cfc" type="file" />

		<cfloop query="qMigrationFiles">
			<cfif REFind(loc.migrationRE,Name)>
				<cfset loc.migration = {}>
				<cfset loc.migration.version = REReplace(Name,loc.migrationRE,"\1")>
				<cfset loc.migration.name = REReplace(Name,loc.migrationRE,"\2")>
				<cfset loc.migration.cfcfile = REReplace(Name,loc.migrationRE,"\1_\2")>
				<cfset loc.migration.loadError = "">
				<cfset loc.migration.details = "description unavailable">
				<cfset loc.migration.status = "">
				<cftry>
					<cfset loc.migration.cfc = $createObjectFromRoot(path=this.paths.migrateComponents, fileName=loc.migration.cfcfile, method="init")>

					<cfset loc.metaData = GetMetaData(loc.migration.cfc)>
					<cfif structKeyExists(loc.metaData,"hint")>
						<cfset loc.migration.details = loc.metaData.hint>
					</cfif>
					<cfif ListFind(loc.listVersionsPreviouslyMigrated, loc.migration.version) neq 0>
						<cfset loc.migration.status = "migrated">
					</cfif>
					<cfcatch type="any"><cfset loc.migration.loadError = CFCATCH.Message></cfcatch>
				</cftry>
				<cfset ArrayAppend(loc.migrations,loc.migration)>
			</cfif>
		</cfloop>
		<cfreturn loc.migrations>
	</cffunction>

	<!--- it would be nice to script these, but the $query helper doesn't support cfqueryparam --->
	<cffunction name="$setVersionAsMigrated" access="private">
		<cfargument name="version" required="true" type="string">
		<cfquery datasource="#application.wheels.dataSourceName#">
		INSERT INTO schemainfo (version) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">)
		</cfquery>
	</cffunction>

	<cffunction name="$removeVersionAsMigrated" access="private">
		<cfargument name="version" required="true" type="string">
		<cfquery datasource="#application.wheels.dataSourceName#" >
		DELETE FROM schemainfo WHERE version = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.version#">
		</cfquery>
	</cffunction>

	<cfscript>

	// TODO: is this required? it's a private core function.
	public any function $createObjectFromRoot(
		required string path,
		required string fileName,
			required string method
	) {
		var returnValue = "";
		local.returnVariable = "returnValue";
		local.method = arguments.method;
		local.component = ListChangeDelims(arguments.path, ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
		local.argumentCollection = arguments;
		include "../../root.cfm";
		return returnValue;
	}

	public string function $getNextMigrationNumber(string migrationPrefix="") {
		local.migrationNumber = dateformat(now(),'yyyymmdd') & timeformat(now(),'HHMMSS');
		if(arguments.migrationPrefix != "timestamp") {
			local.migrations = getAvailableMigrations();
			if(ArrayLen(local.migrations) eq 0) {
				if(arguments.migrationPrefix == "numeric") {
					local.migrationNumber = "001";
				}
			} else {
				// determine current numbering system
				local.lastMigration = local.migrations[ArrayLen(local.migrations)];
				if(Len(local.lastMigration.version) eq 3) {
					// use numeric numbering
					local.migrationNumber = NumberFormat(Val(local.lastMigration.version)+1,"009");
				}
			}
		}
		return local.migrationNumber;
	}
	</cfscript>

	<cffunction name="$copyTemplateMigrationAndRename" displayname="$copyTemplateMigrationAndRename" access="private" returntype="string">
		<cfargument name="migrationName" type="string" required="true" />
		<cfargument name="templateName" type="string" required="true" />
		<cfargument name="migrationPrefix" type="string" required="false" default="" />

		<cfset var loc = {}/>
		<cfset loc.templateFile = this.paths.templates & "/" & arguments.templateName & ".cfc"/>
		<cfset loc.extendsPath = "wheels.dbmigrate.Migration"/>
		<cfif not FileExists(loc.templateFile)>
			<cfreturn "Template #arguments.templateName# could not be found">
		</cfif>
		<cfif not DirectoryExists(this.paths.migrate)>
			<cfdirectory action="create" directory="#this.paths.migrate#">
		</cfif>
		<cftry>
			<cffile action="read" file="#loc.templateFile#" variable="loc.templateContent">

			<cfif Len(Trim(application.wheels.rootcomponentpath)) GT 0>
			  <cfset loc.extendsPath = application.wheels.rootcomponentpath & ".wheels.dbmigrate.Migration"/>
			</cfif>

			<cfset loc.templateContent = replace(loc.templateContent, "[extends]", loc.extendsPath)>
			<cfset loc.templateContent = replace(loc.templateContent, "[description]", replace(arguments.migrationName,'"','&quot;','ALL'))>

			<cfset loc.migrationFile = REREplace(arguments.migrationName,"[^A-z0-9]+"," ","ALL")>
			<cfset loc.migrationFile = REREplace(Trim(loc.migrationFile),"[\s]+","_","ALL")>
			<cfset loc.migrationFile = $getNextMigrationNumber(arguments.migrationPrefix) & "_#loc.migrationFile#.cfc">

			<cffile action="write" file="#this.paths.migrate#/#loc.migrationFile#" output="#loc.templateContent#">

			<cfcatch type="any">
				<cfreturn "There was an error when creating the migration: #cfcatch.message#">
			</cfcatch>
		</cftry>
		<cfreturn "The migration #loc.migrationFile# file was created" />
	</cffunction>

	<cfscript>
	private string function $getVersionsPreviouslyMigrated() {
		var loc = {};
		try {
			loc.qMigratedVersions = $query(
				datasource=application.wheels.dataSourceName,
				sql="SELECT version FROM schemainfo ORDER BY version ASC"
			);
			if (loc.qMigratedVersions.recordcount eq 0) {
				return 0;
			} else {
				return ValueList(loc.qMigratedVersions.version);
			}
		} catch(any e) {
			$query(
				datasource=application.wheels.dataSourceName,
				sql="CREATE TABLE schemainfo (version VARCHAR(25))"
			);
			return 0;
		}
	}
	</cfscript>

</cfcomponent>
