<cfscript>
if (StructKeyExists(server, "lucee")) {
	include "cfml.cfm";
	include "internal.cfm";
	include "public.cfm";
	include "../../global/functions.cfm";
} else {
	include "wheels/global/cfml.cfm";
	include "wheels/global/internal.cfm";
	include "wheels/global/public.cfm";
	include "global/functions.cfm";
}
</cfscript>
