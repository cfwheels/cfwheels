<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_should_be_able_to_query_views_on_a_column">
		<cfset loc.view = model("ViewUserPhotoKeyUserId").findAll(where="username = 'tonyp'")>
		<cfset assert('loc.view.recordcount neq 0')>
		<cfset loc.view = model("ViewUserPhotoKeyPhotoGalleryId").findAll(where="username = 'tonyp'")>
		<cfset assert('loc.view.recordcount neq 0')>
	</cffunction>

	<cffunction name="test_should_be_able_to_query_views_on_the_specified_primary_key">
		<cfset loc.view = model("ViewUserPhotoKeyUserId").findOne(order="userid")>
		<cfset loc.view = model("ViewUserPhotoKeyUserId").findByKey(loc.view.userid)>
		<cfset assert('IsObject(loc.view)')>
		<cfset loc.view = model("ViewUserPhotoKeyPhotoGalleryId").findOne(order="galleryid")>
		<cfset loc.view = model("ViewUserPhotoKeyPhotoGalleryId").findByKey(loc.view.galleryid)>
		<cfset assert('IsObject(loc.view)')>
	</cffunction>

	<cffunction name="test_associations_should_still_work">
		<cfset loc.view = model("ViewUserPhotoKeyPhotoGalleryId").findAll(
				include="photos"
				,where="username = 'tonyp'"
			)>
		<cfset assert('loc.view.recordcount neq 0')>
	</cffunction>

</cfcomponent>