<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.tagModel = model("tag")>
		<cfset loc.postModel = model("post")>
	</cffunction>

	<cffunction name="test_self_join">
		<cfset loc.tag = loc.tagModel.findOne(where="name = 'pear'", include="parent", order="id, id")>
		<cfset assert("IsObject(loc.tag) and IsObject(loc.tag.parent)")>
	</cffunction>

	<cffunction name="test_self_join_with_other_associations">
		<cfset loc.post = loc.postModel.findByKey(key=1, include="classifications(tag(parent))", returnAs="query")>
		<cfset assert("IsQuery(loc.post) and loc.post.recordcount")>
	</cffunction>

</cfcomponent>