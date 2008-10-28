<cffunction name="onRequest" output="true">
	<cfargument name="targetpage">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="#arguments.targetpage#">
	</cflock>
</cffunction>
