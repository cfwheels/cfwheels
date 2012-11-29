<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<!--- multijoins --->
		<cfset belongsTo(name="FavouritePost", modelName="Post", foreignKey="favouritePostId")>
		<cfset belongsTo(name="LeastFavouritePost", modelName="Post", foreignKey="leastFavouritePostId")>
		<!--- crazy join to test the joinKey argument --->
		<cfset belongsTo(name="user", foreignKey="firstName", joinKey="firstName")>
		<cfset beforeSave("callbackThatReturnsTrue")>
		<cfset beforeDelete("callbackThatReturnsTrue")>
		<cfset property(name="firstName", label="First Name(s)", defaultValue="Dave")>
		<cfset property(name="lastName", label="Last name", defaultValue="")>
		<cfset nestedProperties(associations="profile", allowDelete=true)>
	</cffunction>

	<cffunction name="callbackThatReturnsTrue">
		<cfreturn true>
	</cffunction>

</cfcomponent>