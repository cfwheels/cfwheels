<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="beforeCreate,beforeUpdate")>
	</cffunction>

	<cffunction name="test_existing_object">
		<cfset model("tag").$registerCallback(type="beforeCreate", methods="callbackThatSetsProperty")>
		<cfset model("tag").$registerCallback(type="beforeUpdate", methods="callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>
	
	<cffunction name="test_new_object">
		<cfset model("tag").$registerCallback(type="beforeUpdate", methods="callbackThatSetsProperty")>
		<cfset model("tag").$registerCallback(type="beforeCreate", methods="callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create()>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>
	
</cfcomponent>