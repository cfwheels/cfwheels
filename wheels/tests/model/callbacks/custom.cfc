<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_existing_object">
		<cfset loc.args.type = "myCustomCallBack">
		<cfset model("tag").$registerCallback(type=loc.args.type, methods="methodOne")>
		<cfset loc.r = model("tag").$callbacks(argumentCollection=loc.args)>
		<cfset assert('IsArray(loc.r)')>
		<cfset assert('ArrayLen(loc.r) eq 1')>
	</cffunction>

</cfcomponent>