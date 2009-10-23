<cfif not structkeyexists(variables, "model")>
	<cfinclude template="/wheelsMapping/global/functions.cfm">
</cfif>

<cffunction name="load_Models" hint="allows you to load all or specific models into the test case">
	<cfargument name="models" type="string" required="false" default="" hint="a comma delimited list of the model you want to load. leave blank to load all models.">
	<cfset var loc = {}>
	
	<cfif !len(arguments.models)>
		<cfdirectory action="list" directory="#expandpath(application.wheels.modelPath)#" name="loc.models" filter="*.cfc" type="file">
		<cfset arguments.models = valuelist(loc.models.name)>
	</cfif>
	
	<cfloop list="#arguments.models#" index="loc.model">
		<cfset global[singularize(listfirst(loc.model, "."))] = model(listfirst(loc.model, "."))>
	</cfloop>
</cffunction>