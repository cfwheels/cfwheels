<cfscript>

/**
 * Configure and return migrator object. Now uses /app mapping
 */
public struct function init(
	string migratePath="/app/migrator/migrations/",
	string sqlPath="/app/migrator/sql/",
	string templatePath="/wheels/migrator/templates/"
) {
	this.paths.migrate = ExpandPath(arguments.migratePath);
	this.paths.sql = ExpandPath(arguments.sqlPath);
	this.paths.templates = ExpandPath(arguments.templatePath);
	this.paths.migrateComponents = ArrayToList(ListToArray(arguments.migratePath, "/"), ".");
	return this;
}

/**
 * Migrates database to a specified version. Whilst you can use this in your application, the recommended useage is via either the CLI or the provided GUI interface
 *
 * [section: Configuration]
 * [category: Database Migrations]
 *
 * @version The Database schema version to migrate to
 */
public string function migrateTo(string version="") {
	local.rv = "";
	local.currentVersion = getCurrentMigrationVersion();
	if (local.currentVersion == arguments.version) {
		local.rv = "Database is currently at version #arguments.version#. No migration required.#chr(13)#";
	} else {
		if (!DirectoryExists(this.paths.sql) && application.wheels.writeMigratorSQLFiles) {
			DirectoryCreate(this.paths.sql);
		}
		local.migrations = getAvailableMigrations();
		if (local.currentVersion > arguments.version) {
			local.rv = "Migrating from #local.currentVersion# down to #arguments.version#.#chr(13)#";
			for (local.i = ArrayLen(local.migrations); local.i >= 1; local.i--) {
				local.migration = local.migrations[local.i];
				if (local.migration.version <= arguments.version) {
					break;
				}
				if (local.migration.status == "migrated" && application.wheels.allowMigrationDown) {
					transaction action="begin" {
						try {
							local.rv = local.rv & "#Chr(13)#------- " & local.migration.cfcfile & " #RepeatString("-",Max(5,50-Len(local.migration.cfcfile)))##Chr(13)#";
							request.$wheelsMigrationOutput = "";
							request.$wheelsMigrationSQLFile = "#this.paths.sql#/#local.migration.cfcfile#_down.sql";
							if (application.wheels.writeMigratorSQLFiles) {
								FileWrite(request.$wheelsMigrationSQLFile, "");
							}
							local.migration.cfc.down();
							local.rv = local.rv & request.$wheelsMigrationOutput;
							$removeVersionAsMigrated(local.migration.version);
						} catch (any e) {
							local.rv = local.rv & "Error migrating to #local.migration.version#.#Chr(13)##e.message##Chr(13)##e.detail##Chr(13)#";
							transaction action="rollback";
							break;
						}
						transaction action="commit";
					}
				}
			}
		} else {
			local.rv = "Migrating from #local.currentVersion# up to #arguments.version#.#Chr(13)#";
			for (local.migration in local.migrations) {
				if (local.migration.version <= arguments.version && local.migration.status != "migrated") {
					transaction {
						try {
							local.rv = local.rv & "#Chr(13)#-------- " & local.migration.cfcfile & " #RepeatString("-",Max(5,50-Len(local.migration.cfcfile)))##Chr(13)#";
							request.$wheelsMigrationOutput = "";
							request.$wheelsMigrationSQLFile = "#this.paths.sql#/#local.migration.cfcfile#_up.sql";
							if (application.wheels.writeMigratorSQLFiles) {
								FileWrite(request.$wheelsMigrationSQLFile, "");
							}
							local.migration.cfc.up();
							local.rv = local.rv & request.$wheelsMigrationOutput;
							$setVersionAsMigrated(local.migration.version);
						} catch (any e) {
							local.rv = local.rv & "Error migrating to #local.migration.version#.#Chr(13)##e.message##Chr(13)##e.detail##Chr(13)#";
							transaction action="rollback";
							break;
						}
						transaction action="commit";
					}
				} else if (local.migration.version > arguments.version) {
					break;
				}
			};
		}
	}
	return local.rv;
}

/**
 * Shortcut function to migrate to the latest version
 *
 * [section: Configuration]
 * [category: Database Migrations]
 */
public string function migrateToLatest() {
	local.migrations=getAvailableMigrations();
	if (ArrayLen(local.migrations)) {
		local.latest=local.migrations[ArrayLen(local.migrations)].version;
	} else {
		local.latest=0;
	}
	return migrateTo(local.latest);
}

/**
 * Returns current database version. Whilst you can use this in your application, the recommended useage is via either the CLI or the provided GUI interface
 *
 * [section: Configuration]
 * [category: Database Migrations]
 */
public string function getCurrentMigrationVersion() {
	return ListLast($getVersionsPreviouslyMigrated());
}

/**
 * Creates a migration file. Whilst you can use this in your application, the recommended useage is via either the CLI or the provided GUI interface
 *
 * [section: Configuration]
 * [category: Database Migrations]
 */
public string function createMigration(
	required string migrationName,
	string templateName="",
	string migrationPrefix="timestamp"
) {
	if (Len(Trim(arguments.migrationName))) {
		return $copyTemplateMigrationAndRename(argumentCollection=arguments);
	} else {
		return "You must supply a migration name (e.g. 'creates member table')";
	}
}

/**
 * Searches db/migrate folder for migrations. Whilst you can use this in your application, the recommended useage is via either the CLI or the provided GUI interface
 *
 * [section: Configuration]
 * [category: Database Migrations]
 *
 * @path Path to Migration Files: defaults to /migrator/migrations/
 */
public array function getAvailableMigrations(string path=this.paths.migrate) {
	local.rv = [];
	local.previousMigrationList = $getVersionsPreviouslyMigrated();
	local.migrationRE = "^([\d]{3,14})_([^\.]*)\.cfc$";
	if (!DirectoryExists(this.paths.migrate)) {
		DirectoryCreate(this.paths.migrate);
	}
	local.files = DirectoryList(this.paths.migrate, false, "query", "*.cfc", "name");
	for (local.row in local.files) {
		if (REFind(local.migrationRE, local.row.name)) {
			local.migration = {};
			local.migration.version = REReplace(local.row.name, local.migrationRE,"\1");
			local.migration.name = REReplace(local.row.name, local.migrationRE,"\2");
			local.migration.cfcfile = REReplace(local.row.name, local.migrationRE,"\1_\2");
			local.migration.loadError = "";
			local.migration.details = "description unavailable";
			local.migration.status = "";
			try {
				local.migration.cfc = $createObjectFromRoot(path=this.paths.migrateComponents, fileName=local.migration.cfcfile, method="init");
				local.metaData = GetMetaData(local.migration.cfc);
				if (StructKeyExists(local.metaData,"hint")) {
					local.migration.details = local.metaData.hint;
				}
				if (ListFind(local.previousMigrationList, local.migration.version)) {
					local.migration.status = "migrated";
				}
			} catch (any e) {
				local.migration.loadError = e.message;
			}
			ArrayAppend(local.rv, local.migration);
		}
	};
	return local.rv;
}

/**
 * Reruns the specified migration version. Whilst you can use this in your application, the recommended useage is via either the CLI or the provided GUI interface
 *
 * [section: Configuration]
 * [category: Database Migrations]
 *
 * @version The Database schema version to rerun
 */
public string function redoMigration(string version="") {
	var currentVersion = getCurrentMigrationVersion();
	if (Len(arguments.version)) {
		currentVersion = arguments.version;
	}
	local.migrationArray = ArrayFilter(getAvailableMigrations(), function(i) {
		return i.version == currentVersion;
	});
	if (!ArrayLen(local.migrationArray)) {
		return "Error re-running #arguments.version#.#Chr(13)#This version was not found#Chr(13)#";
	}

	local.migration = local.migrationArray[1];
	local.rv = "";
	try {
		local.rv = local.rv & "#Chr(13)#------- " & local.migration.cfcfile & " #RepeatString("-", Max(5, 50-Len(local.migration.cfcfile)))##Chr(13)#";
		request.$wheelsMigrationOutput = "";
		request.$wheelsMigrationSQLFile = "#this.paths.sql#/#local.migration.cfcfile#_redo.sql";
		if (application.wheels.writeMigratorSQLFiles) {
			FileWrite(request.$wheelsMigrationSQLFile, "");
		}
		if (application.wheels.allowMigrationDown) {
			local.migration.cfc.down();
		}
		local.migration.cfc.up();
		local.rv = local.rv & request.$wheelsMigrationOutput;
	} catch (any e) {
		local.rv = local.rv & "Error re-running #local.migration.version#.#Chr(13)##e.message##Chr(13)##e.detail##Chr(13)#";
	}
	return local.rv;
}

/**
 * Inserts a record to flag a version as migrated.
 */
private void function $setVersionAsMigrated(required string version) {
	$query(
		datasource=application.wheels.dataSourceName,
		sql="INSERT INTO #application.wheels.migratorTableName# (version) VALUES ('#$sanitiseVersion(arguments.version)#')"
	);
}

/**
 * Deletes a record to flag a version as not migrated.
 */
private void function $removeVersionAsMigrated(required string version) {
	$query(
		datasource=application.wheels.dataSourceName,
		sql="DELETE FROM #application.wheels.migratorTableName# WHERE version = '#$sanitiseVersion(arguments.version)#'"
	);
}

/**
 * Returns the next migration.
 */
public string function $getNextMigrationNumber(string migrationPrefix="") {
	local.migrationNumber = DateFormat(Now(),'yyyymmdd') & TimeFormat(Now(),'HHMMSS');
	if (arguments.migrationPrefix != "timestamp") {
		local.migrations = getAvailableMigrations();
		if (!ArrayLen(local.migrations)) {
			if (arguments.migrationPrefix == "numeric") {
				local.migrationNumber = "001";
			}
		} else {

			// Determine current numbering system.
			local.lastMigration = local.migrations[ArrayLen(local.migrations)];
			if (Len(local.lastMigration.version) == 3) {

				// Use numeric numbering.
				local.migrationNumber = NumberFormat(Val(local.lastMigration.version)+1,"009");

			}

		}
	}
	return local.migrationNumber;
}

/**
 * Creates a migration file based on a template.
 */
private string function $copyTemplateMigrationAndRename(
	required string migrationName,
	required string templateName,
	string migrationPrefix=""
) {
	local.templateFile = this.paths.templates & "/" & arguments.templateName & ".cfc";
	local.extendsPath = "wheels.migrator.Migration";
	if (!FileExists(local.templateFile)) {
		return "Template #arguments.templateName# could not be found";
	}
	if (!DirectoryExists(this.paths.migrate)) {
		DirectoryCreate(this.paths.migrate);
	}
	try {
		local.templateContent = FileRead(local.templateFile);
		if (Len(Trim(application.wheels.rootcomponentpath))) {
			local.extendsPath = application.wheels.rootcomponentpath & ".wheels.migrator.Migration";
		}
		local.templateContent = Replace(local.templateContent, "[extends]", local.extendsPath);
		local.templateContent = Replace(local.templateContent, "[description]", Replace(arguments.migrationName, """", "&quot;", "all"));
		local.migrationFile = REREplace(arguments.migrationName,"[^A-z0-9]+", " ", "all");
		local.migrationFile = REREplace(Trim(local.migrationFile),"[\s]+", "_", "all");
		local.migrationFile = $getNextMigrationNumber(arguments.migrationPrefix) & "_#local.migrationFile#.cfc";
		FileWrite("#this.paths.migrate#/#local.migrationFile#", local.templateContent);
	} catch (any e) {
		return "There was an error when creating the migration: #e.message#";
	}
	return "The migration #local.migrationFile# file was created";
}

/**
 * Returns previously migrated versions as a list.
 */
private string function $getVersionsPreviouslyMigrated() {
	local.appKey = $appKey();
	try {
		local.migratedVersions = $query(
			datasource=application[local.appKey].dataSourceName,
			sql="SELECT version FROM #application[local.appKey].migratorTableName# ORDER BY version ASC"
		);
		if (!local.migratedVersions.recordcount) {
			return 0;
		} else {
			return ValueList(local.migratedVersions.version);
		}
	} catch (any e) {
		if (application[local.appKey].createMigratorTable) {
			$query(
				datasource=application[local.appKey].dataSourceName,
				sql="CREATE TABLE #application[local.appKey].migratorTableName# (version VARCHAR(25))"
			);
		}
		return 0;
	}
}

/**
 * Ensures a version as user input is numeric.
 */
private string function $sanitiseVersion(required string version) {
	return REReplaceNoCase(arguments.version, "[^0-9]", "" ,"all");
}

</cfscript>
