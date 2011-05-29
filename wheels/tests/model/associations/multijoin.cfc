<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_multiple_joins">
		<cfset loc.author = model("Author").findOne(include="FavouritePost,LeastFavouritePost")>
		<cfset assert("true")>
	</cffunction>

</cfcomponent>