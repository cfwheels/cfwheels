<!---
	CLI & GUI Uses this file to talk to wheels via JSON when in maintenance/testing/development mode
--->
<cfscript>
	include "../dbmigrate/basefunctions.cfm";
	setting showDebugOutput="no";
	dbmigrate = application.wheels.dbmigrate;
	try {
		"data"={};
		data["success"]			= true;
		data["datasource"]    	= application.wheels.dataSourceName;
		data["wheelsVersion"]   = application.wheels.version;
		data["currentVersion"] 	= dbmigrate.getCurrentMigrationVersion();
		data["databaseType"]   	= $getDBType();
		data["migrations"]    	= dbmigrate.getAvailableMigrations();
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
						data.message=dbmigrate.createMigration(
							params.migrationName,
							params.templateName,
							params.migrationPrefix);
					} else {
						data.message=dbmigrate.createMigration(
							params.migrationName,
							params.templateName);
					}
				break;
				case "migrateTo":
					if(structKeyExists(params,"version")){
						data.message=dbmigrate.migrateTo(params.version);
					}
				break;
				case "redoMigration":
					if(structKeyExists(params,"version")){
						local.redoVersion = params.version;
					} else {
						local.redoVersion = data.lastVersion;
					}
					data.message=dbmigrate.redoMigration(local.redoVersion);
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
