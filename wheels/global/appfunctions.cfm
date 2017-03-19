<cfscript>
if (StructKeyExists(server, "lucee")) {
	include "cfml.cfm";
	include "internal.cfm";
	include "misc.cfm";
	include "util.cfm";
	include "../../global/functions.cfm";
} else {
	include "wheels/global/cfml.cfm";
	include "wheels/global/internal.cfm";
	include "wheels/global/misc.cfm";
	include "wheels/global/util.cfm";
	include "global/functions.cfm";
}
</cfscript>
