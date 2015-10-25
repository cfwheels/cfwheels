<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<!--- crazy join to test the joinKey argument --->
		<cfset belongsTo(name="user", foreignKey="firstName", joinKey="firstName")>
		<cfset beforeSave("callbackThatReturnsTrue")>
		<cfset beforeDelete("callbackThatReturnsTrue")>
		<cfset property(name="firstName", label="First name(s)", defaultValue="Dave")>
		<cfset property(name="numberofitems", sql="SELECT COUNT(id) FROM posts WHERE authorid = authors.id", select=false)>
		<cfset property(name="lastName", label="Last name", defaultValue="")>
		<cfset nestedProperties(associations="profile", allowDelete=true)>
		<cfset validatesPresenceOf("firstName")>
	</cffunction>

	<cffunction name="callbackThatReturnsTrue">
		<cfreturn true>
	</cffunction>

</cfcomponent>
