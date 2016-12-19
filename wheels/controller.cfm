<cfscript>
	include "controller/functions.cfm";
	include "global/functions.cfm";
	include "view/functions.cfm";
	include "plugins/functions.cfm";

	if( StructKeyExists(application, "wheels") AND StructKeyExists(application.wheels, "viewPath")){
		include "../#application.wheels.viewPath#/helpers.cfm";
	}
</cfscript>
