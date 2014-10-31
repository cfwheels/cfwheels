<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("tag").$registerCallback(type="beforeValidation", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">	
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="beforeValidation")>
	</cffunction>

	<cffunction name="test_saving_object">
		<cfset loc.obj.save()>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_saving_object_without_callbacks">
		<cfset loc.obj.save(callbacks=false, transaction="rollback")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_validating_nested_property_object_should_register_callback">
		<cfset loc = $setGalleryNestedProperties()>
		<cfset loc.gallery.valid()>
		<cfset assert("StructKeyExists(loc.gallery.photos[1].properties(), 'beforeValidationCallbackRegistered')")>
	</cffunction>

	<cffunction name="test_saving_nested_property_object_should_register_callback_only_once">
		<cftransaction>
			<cfset loc = $setGalleryNestedProperties()>
			<cfset loc.gallery.save()>
			<cfset assert("loc.gallery.photos[1].beforeValidationCallbackCount IS 1")>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="$setGalleryNestedProperties" access="private">
		<cfset var loc = {}>
		<!--- User --->
		<cfset loc.user = model("user").findOneByLastName("Petruzzi")>
		<!--- Gallery --->
		<cfset loc.gallery = model("gallery").new(userId=loc.user.id, title="Nested Properties Gallery", description="A gallery testing nested properties.")>
		<cfset loc.gallery.photos = 
			[
				model("photo").new(userId=loc.user.id, filename="Nested Properties Photo Test 1", DESCRIPTION1="test photo 1 for nested properties gallery")
			]
		>
		<cfreturn loc>
	</cffunction>

</cfcomponent>