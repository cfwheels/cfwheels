# renderNothing()

## Description
Instructs the controller to render an empty string when it's finished processing the action. This is very similar to calling `cfabort` with the advantage that any after filters you have set on the action will still be run.

## Function Syntax
	renderNothing(  )



## Examples
	
		<!--- Render a blank white page to the client --->
		<cfset renderNothing()>
