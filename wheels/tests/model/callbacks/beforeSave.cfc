<cfcomponent extends="wheelsMapping.Test">

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

	<cffunction name="test_aborting_on_false">
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

	<cffunction name="test_setting_property_with_skipped_callback">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="callbackThatSetsProperty")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.existBefore = StructKeyExists(loc.obj, "setByCallback")>
		<cfset loc.obj.save(callbacks=false, transaction="rollback")>
		<cfset loc.existAfter = StructKeyExists(loc.obj, "setByCallback")>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("NOT loc.existBefore AND NOT loc.existAfter")>
	</cffunction>

	<cffunction name="test_execution_order">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="firstCallback,secondCallback")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("loc.obj.orderTest IS 'first,second'")>
	</cffunction>

	<cffunction name="test_aborting_chain">
		<cfset model("tag").$registerCallback(type="beforeSave", methods="firstCallback,callbackThatReturnsFalse,secondCallback")>
		<cfset loc.obj = model("tag").findOne(order="id")>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeSave")>
		<cfset assert("loc.obj.orderTest IS 'first'")>
	</cffunction>

	<cffunction name="test_setting_in_init_and_clearing">
		<cfset loc.callbacks = model("author").$callbacks()>
		<cfset assert("loc.callbacks.beforeSave[1] IS 'callbackThatReturnsTrue'")>
		<cfset model("author").$clearCallbacks(type="beforeSave")>
		<cfset assert("ArrayLen(loc.callbacks.beforeSave) IS 0 AND loc.callbacks.beforeDelete[1] IS 'callbackThatReturnsTrue'")>
		<cfset model("author").$clearCallbacks()>
		<cfset assert("ArrayLen(loc.callbacks.beforeDelete) IS 0")>
	</cffunction>

</cfcomponent>