component output="false" displayName="Controller" {
	include "controller/functions.cfm";
	include "global/functions.cfm";
	include "view/functions.cfm";
	include "plugins/standalone/injection.cfm";
	if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "viewPath")) {
		include "../#application.wheels.viewPath#/helpers.cfm";
	}
}
