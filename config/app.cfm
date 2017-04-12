<cfscript>

	// Use this file to set variables for the Application.cfc's "this" scope.

	// Examples:
	// this.name = "MyAppName";
	// this.sessionTimeout = CreateTimeSpan(0,0,5,0);

// Setup environment variables.
server.ENV = CreateObject("java", "java.lang.System").getenv();

// Setup data source.
this.DataSources["wheelstestdb"] = {
  "driver"=server.ENV.DB_TYPE,
  "host"=server.ENV.DB_HOST,
  "port"=server.ENV.DB_PORT,
  "database"=server.ENV.DB_DATABASE,
  "username"=server.ENV.DB_USERNAME,
  "password"=""
};

this.EnableRobustException = true;

</cfscript>
