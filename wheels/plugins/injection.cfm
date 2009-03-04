<cfloop list="#StructKeyList(application.wheels.plugins)#" index="loc.i">
	<cfloop list="#StructKeyList(application.wheels.plugins[loc.i])#" index="loc.j">
		<cfif NOT ListFindNoCase("init,version", loc.j)>
			<cfif StructKeyExists(variables, loc.j)>
				<cfset variables.core[loc.j] = variables[loc.j]>
			</cfif>	
			<cfset variables[loc.j] = application.wheels.plugins[loc.i][loc.j]>	
		</cfif>
	</cfloop>
</cfloop>