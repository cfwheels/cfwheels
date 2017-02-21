<cfscript>
if (StructKeyExists(server, "lucee")) {
	include "caching.cfm";
	include "filters.cfm";
	include "flash.cfm";
	include "initialization.cfm";
	include "layouts.cfm";
	include "miscellaneous.cfm";
	include "processing.cfm";
	include "provides.cfm";
	include "redirection.cfm";
	include "rendering.cfm";
	include "verifies.cfm";
} else {
	include "wheels/controller/caching.cfm";
	include "wheels/controller/filters.cfm";
	include "wheels/controller/flash.cfm";
	include "wheels/controller/initialization.cfm";
	include "wheels/controller/layouts.cfm";
	include "wheels/controller/miscellaneous.cfm";
	include "wheels/controller/processing.cfm";
	include "wheels/controller/provides.cfm";
	include "wheels/controller/redirection.cfm";
	include "wheels/controller/rendering.cfm";
	include "wheels/controller/verifies.cfm";
}
</cfscript>
