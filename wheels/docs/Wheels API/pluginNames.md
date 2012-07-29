# pluginNames()

## Description
Returns a list of all installed plugins' names.

## Function Syntax
	pluginNames(  )



## Examples
	
		<!--- Check if the Scaffold plugin is installed --->
		<cfif ListFindNoCase("scaffold", pluginNames())>
			<!--- do something cool --->
		</cfif>
