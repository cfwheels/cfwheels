# setResponse()

## Description
Sets content that Wheels will send to the client in response to the request.

## Function Syntax
	setResponse( content )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>content</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The content to set as the response.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In a controller --->
		<cffunction name="init">
			<cfset filters(type="after", through="translateResponse")>
		</cffunction>
		
		<!--- After filter translates response and sets it --->
		<cffunction name="translateResponse">
			<cfset var wheelsResponse = response()>
			<cfset var translatedResponse = someTranslationFunction(wheelsResponse)>
			<cfset setResponse(translatedResponse)>
		</cffunction>
