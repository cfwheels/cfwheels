<!---
	CLI & GUI Uses this file to talk to wheels via JSON when in maintenance/testing/development mode
--->
<cfscript>
	include "../migrator/basefunctions.cfm";
	setting showDebugOutput="no";
	migrator = application.wheels.migrator;
	try {
		"data"={};
		data["success"]			= true;
		data["datasource"]    	= application.wheels.dataSourceName;
		data["wheelsVersion"]   = application.wheels.version;
		data["currentVersion"] 	= migrator.getCurrentMigrationVersion();
		data["databaseType"]   	= $getDBType();
		data["migrations"]    	= migrator.getAvailableMigrations();
		data["lastVersion"]    	= 0;
		data["message"]			= "";
		data["messages"]		= "";
		data["command"]         = "";

		if(ArrayLen(data.migrations)){
			data.lastVersion = data.migrations[ArrayLen(data.migrations)].version;
		}

		if(structKeyExists(params, "command")){
			data.command=params.command;
			switch(params.command){
				case "createMigration":
					if(structKeyExists(params, "migrationPrefix") && len(params.migrationPrefix)){
						data.message=migrator.createMigration(
							params.migrationName,
							params.templateName,
							params.migrationPrefix);
					} else {
						data.message=migrator.createMigration(
							params.migrationName,
							params.templateName);
					}
				break;
				case "migrateTo":
					if(structKeyExists(params,"version")){
						data.message=migrator.migrateTo(params.version);
					}
				break;
				case "migrateToLatest":
					data.message=migrator.migrateToLatest();
				break;
				case "redoMigration":
					if(structKeyExists(params,"version")){
						local.redoVersion = params.version;
					} else {
						local.redoVersion = data.lastVersion;
					}
					data.message=migrator.redoMigration(local.redoVersion);
				break;
				case "info":
					data.message="Returning what I know..";
				break;
			}
		}
	} catch (any e){
		 data.success = false;
		 data.messages = e.message & ': ' & e.detail;
	}
</cfscript>
<cfcontent reset="true" type="application/json"><cfoutput>#serializeJSON(data)#</cfoutput><cfabort>
