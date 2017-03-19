<cfscript>
if (!StructKeyExists(variables, "$wheelsInclude") || ListFind(variables.$wheelsInclude, "cfml")) {
	include "cfml.cfm";
}
if (!StructKeyExists(variables, "$wheelsInclude") || ListFind(variables.$wheelsInclude, "internal")) {
	include "internal.cfm";
}
if (!StructKeyExists(variables, "$wheelsInclude") || ListFind(variables.$wheelsInclude, "misc")) {
	include "misc.cfm";
}
if (!StructKeyExists(variables, "$wheelsInclude") || ListFind(variables.$wheelsInclude, "util")) {
	include "util.cfm";
}
include "../../global/functions.cfm";
</cfscript>
