<cffunction name="flash" returntype="any" access="public" output="false">
	<cfif structCount(arguments) IS 0>
		<!--- return true unless flash is empty --->
		<cflock scope="session" type="readonly" timeout="30">
			<cfif structIsEmpty(session.flash)>
				<cfreturn false>
			<cfelse>
				<cfreturn true>
			</cfif>
		</cflock>
	<cfelseif structKeyExists(arguments, "1")>
		<!--- return value in flash --->
		<cflock scope="session" type="readonly" timeout="30">
			<cfif structKeyExists(session.flash, arguments[1])>
				<cfreturn session.flash[arguments[1]]>
			<cfelse>
				<cfreturn "">
			</cfif>
		</cflock>
	<cfelse>
		<!--- add value to flash --->
		<cflock scope="session" type="exclusive" timeout="30">
			<cfset session.flash[structKeyList(arguments)] = arguments[1]>
		</cflock>
		<cfreturn true>
	</cfif>
</cffunction>