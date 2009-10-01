<cfcomponent extends="wheelsMapping.model">
	<cffunction name="init">
		<cfset table("will_throw_error_since_table_does_not_exist")>
	</cffunction>
</cfcomponent>