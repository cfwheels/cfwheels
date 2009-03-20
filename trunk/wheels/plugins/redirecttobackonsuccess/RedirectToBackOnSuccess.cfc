<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9.1">
		<cfreturn this>
	</cffunction>

	<cffunction name="back">
		<cfset var loc = StructNew()>
		<cfif NOT IsNumeric(StructKeyList(arguments))>
			<cfset loc.str = StructKeyList(arguments)>
		<cfelse>
			<cfset loc.str = "success">
		</cfif>
		<cfset loc.args[loc.str] = arguments[1]>
		<cfset flashInsert(argumentCollection=loc.args)>
		<cftry>
			<cfset redirectTo(back=true)>
			<cfcatch type="Wheels.RedirectBackError">
				<cfset redirectTo(route="home")>
			</cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>