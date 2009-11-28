<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_abort_on_false">
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.obj.oldName = loc.obj.name>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset loc.obj.reload()>
		<cfset assert("loc.obj.name IS loc.obj.oldName")>
	</cffunction>

</cfcomponent>