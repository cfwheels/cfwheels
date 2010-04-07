<cffunction name="assertRoute">
	<cfargument name="data" type="struct" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="pattern" type="string" required="false" default="">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="variables" type="string" required="false" default="">
	<cfloop list="controller,action,pattern,name,variables" index="loc.i">
		<cfif len(arguments[loc.i]) and arguments.data[loc.i] neq arguments[loc.i]>
			<cfreturn false>
		</cfif>
	</cfloop>
	<cfreturn true>
</cffunction>