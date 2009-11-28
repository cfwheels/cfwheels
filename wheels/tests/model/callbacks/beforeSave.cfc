<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_proceeding_on_true_and_nothing">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="callbackThatReturnsTrue,callbackThatReturnsNothing")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.oldName = loc.obj.name>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset loc.obj.reload()>
		<cfset loc.name = loc.obj.name>
		<cfset loc.obj.name = loc.oldName>
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("loc.name IS NOT loc.oldName")>
	</cffunction>

	<cffunction name="test_abort_on_false">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.oldName = loc.obj.name>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset loc.obj.reload()>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("loc.obj.name IS loc.oldName")>
	</cffunction>

	<cffunction name="test_setting_property">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="callbackThatSetsProperty")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.existBefore = StructKeyExists(loc.obj, "setByCallback")>
		<cfset loc.obj.save()>
		<cfset loc.existAfter = StructKeyExists(loc.obj, "setByCallback")>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("NOT loc.existBefore AND loc.existAfter")>
	</cffunction>

	<cffunction name="test_execution_order">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="firstCallback,secondCallback")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("loc.obj.orderTest IS 'first,second'")>
	</cffunction>

</cfcomponent>