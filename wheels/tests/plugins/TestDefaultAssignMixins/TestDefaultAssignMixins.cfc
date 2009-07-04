<cfcomponent mixin="wheels.Controller,wheels.Model">

	<cffunction name="init">
		<cfset this.version = "99.9.9">
		<cfreturn this>
	</cffunction>

	<cffunction name="$DefaultMixin1" returntype="void">
	</cffunction>

	<cffunction name="$DefaultMixin2" returntype="void">
	</cffunction>

</cfcomponent>