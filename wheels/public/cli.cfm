<!---
	CLI Uses this file to talk to wheels via JSON when in design/development mode
--->
<cfinclude template="../dbmigrate/basefunctions.cfm">
<cfscript>
	dbmigrate = application.wheels.dbmigrate;
	try {
		"data"={};
		data["success"]			= true;
		data["datasource"]    	= application.wheels.dataSourceName;
		data["currentVersion"] 	= dbmigrate.getCurrentMigrationVersion();
		data["databaseType"]   	= $getDBType();
		data["migrations"]    	= dbmigrate.getAvailableMigrations();
		data["lastVersion"]    	= 0;
		data["messages"]		= "";
		data["command"]         = "";

		if(ArrayLen(data.migrations)){
			data.lastVersion = data.migrations[ArrayLen(data.migrations)].version;
		}

		if(structKeyExists(params, "command")){
			data.command=params.command;
			switch(params.command){
				case "migrateTo":
				if(structKeyExists(params,"version")){
					data.message=dbmigrate.migrateTo(params.version);
				}
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