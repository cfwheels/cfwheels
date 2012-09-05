# isSecure()

## Description
Returns whether Wheels is communicating over a secure port.

## Function Syntax
	isSecure(  )



## Examples
	
		<!--- Redirect non-secure connections to the secure version --->
		<cfif not isSecure()>
			<cfset redirectTo(protocol="https")>
		</cfif>
