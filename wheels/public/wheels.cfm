<cfscript>
if (StructKeyExists(params, "view")) {
	if (application.wheels.environment eq "production") {
		abort;
	} else {
		include "#params.view#.cfm";
	}
} else {
	include "congratulations.cfm";
}
</cfscript>
