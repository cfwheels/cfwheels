# response()

## Description
Returns content that Wheels will send to the client in response to the request.

## Function Syntax
	response(  )



## Examples
	
		<!--- In a controller --->
		<cffunction name="init">
			<cfset filters(type="after", through="translateResponse")>
		</cffunction>
		
		<!--- After filter translates response and sets it --->
		<cffunction name="translateResponse">
			<cfset var wheelsResponse = response()>
			<cfset var translatedResponse = someTranslationMethod(wheelsResponse)>
			<cfset setResponse(translatedResponse)>
		</cffunction>
