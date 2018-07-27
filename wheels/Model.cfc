component output="false" displayName="Model" {
	include "model/functions.cfm";
	include "global/functions.cfm";
	if (isDefined("application")){
		include "plugins/standalone/injection.cfm";
	}
}
