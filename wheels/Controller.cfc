component output="false" displayName="Controller" {

	include "/wheels/controller/functions.cfm";
	include "/wheels/global/functions.cfm";
	include "/wheels/view/functions.cfm";
	include "/wheels/plugins/standalone/injection.cfm";
	if (
		IsDefined("application") && StructKeyExists(application, "wheels") && StructKeyExists(
			application.wheels,
			"viewPath"
		)
	) {
		include "/app/#application.wheels.viewPath#/helpers.cfm";
	}

}
