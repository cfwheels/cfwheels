<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="yes">

	<cfif application.settings.environment IS "development" OR NOT structKeyExists(application.wheels.models, arguments.name)>
		<cfset "application.wheels.models.#arguments.name#" = createObject("component", "app.models.#arguments.name#").init()>
		<!--- Remove object functions --->
		<cfloop list="#application.wheels.object_functions#" index="i">
			<cfset "application.wheels.models.#arguments.name#.#i#" = "Object function (only available for individual objects)">
		</cfloop>
	</cfif>

	<cfreturn application.wheels.models[arguments.name]>
</cffunction>