<cffunction name="model" output="false" returntype="any" hint="Returns a model object">
	<cfargument name="objectName" type="string" required="yes" hint="The name of the model to return">
	
	<!--- Initialize the model --->
	<cfset var theModel = createObject("component","#application.componentPathTo.models#.#arguments.objectName#").initModel()>
	
	<!--- If some code was regenerated, re-initialize the model --->
	<cfif application.settings.environment IS "development" AND theModel._reload>
		<cfset theModel = createObject("component","#application.componentPathTo.models#.#arguments.objectName#").initModel()>
	</cfif>
	
	<cfreturn theModel>
</cffunction>

<cfset application.core.model = model>