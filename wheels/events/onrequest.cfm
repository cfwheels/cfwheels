<cffunction name="onRequest" returntype="void" access="public" output="true">
	<cfargument name="targetpage" type="any" required="true">
	<cflock name="wheels" type="readOnly" timeout="30">
		<cfinclude template="#arguments.targetpage#">
	</cflock>
</cffunction>