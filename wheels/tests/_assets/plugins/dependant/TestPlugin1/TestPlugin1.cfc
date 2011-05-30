<cfcomponent dependency="TestPlugin2,   TestPlugin3">

	<cffunction name="init">
		<cfset this.version = "99.9.9">
		<cfreturn this>
	</cffunction>

	<cffunction name="$PluginMethod" returntype="void">
	</cffunction>

</cfcomponent>