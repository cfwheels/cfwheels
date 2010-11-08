<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset verifies(only="actionGet", get="true")>
		<cfset verifies(only="actionPost", post="true")>
		<cfset verifies(only="actionPostWithRedirect", post="true", action="index", controller="somewhere", error="invalid")>
		<cfset verifies(only="actionPostWithTypesValid", post="true", params="userid,authorid", paramsTypes="integer,guid")>
		<cfset verifies(only="actionPostWithTypesInValid", post="true", params="userid,authorid", paramsTypes="integer,guid")>
		<cfset verifies(only="actionPostWithString", post="true", params="username,password", paramsTypes="string,blank")>
	</cffunction>

	<cffunction name="actionGet">
		<cfset renderText("actionGet")>
	</cffunction>

	<cffunction name="actionPost">
		<cfset renderText("actionPost")>
	</cffunction>

	<cffunction name="actionPostWithRedirect">
		<cfset renderText("actionPostWithRedirect")>
	</cffunction>

	<cffunction name="actionPostWithTypesValid">
		<cfset renderText("actionPostWithTypesValid")>
	</cffunction>

	<cffunction name="actionPostWithTypesInValid">
		<cfset renderText("actionPostWithTypesInValid")>
	</cffunction>

	<cffunction name="actionPostWithString">
		<cfset renderText("actionPostWithString")>
	</cffunction>

</cfcomponent>