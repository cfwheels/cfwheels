<cfscript>

	// Use this file to configure your application.
	// You can also use the environment specific files (e.g. /config/production/settings.cfm) to override settings set here.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See http://docs.cfwheels.org/docs/configuration-and-defaults for more info.

	// If you leave the settings below commented out, CFWheels will set the data source name to the same name as the folder the application resides in.
	// set(dataSourceName="");
	// set(dataSourceUserName="");
	// set(dataSourcePassword="");

// Data source and ORM
set(dataSourceName="wheelstestdb");
set(useExpandedColumnAliases=true);

// SMTP Server
smtpArgs = {};

for (setting in server.ENV) {
  setting = Trim(setting);
  value = Trim(server.ENV[setting]);

  if (setting.startsWith("SMTP_") && Len(value)) {
    functionKey = Replace(setting, "SMTP_", "");
    smtpArgs[functionKey] = value;
  }
}

if (StructCount(smtpArgs)) {
  set(functionName="sendEmail", argumentCollection=smtpArgs);
}

</cfscript>
