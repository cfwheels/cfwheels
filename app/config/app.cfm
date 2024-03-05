<cfscript>
	/*
		Use this file to set variables for the Application.cfc's "this" scope.

		Examples:
		this.name = "MyAppName";
		this.sessionTimeout = CreateTimeSpan(0,0,5,0);
	*/

	this.name = "wheels.fw";

	this.datasources['wheels.fw'] = {
		class: 'org.h2.Driver'
	, connectionString: 'jdbc:h2:file:./db/h2/wheels.fw;MODE=MySQL'
	, username = 'sa'
	};

	// CLI-Appends-Here
</cfscript>
