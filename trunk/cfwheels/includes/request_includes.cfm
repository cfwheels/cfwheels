<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="yes">

	<cfset var model_query = "">
	<cfset var model_file = "">
	<cfset var model_hash = "">
	<cfset var i = "">

	<cfif application.settings.environment IS "development">

		<cfquery name="model_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT 
		<cfif application.database.type IS "sqlserver">
			(column_name + '' + data_type + '' + is_nullable + '' + character_maximum_length + '' + column_default) AS info
		<cfelseif application.database.type IS "mysql5">
			CONCAT((CASE WHEN column_name IS NULL THEN '' ELSE column_name END),(CASE WHEN data_type IS NULL THEN '' ELSE data_type END),(CASE WHEN is_nullable IS NULL THEN '' ELSE is_nullable END),(CASE WHEN character_maximum_length IS NULL THEN '' ELSE character_maximum_length END),(CASE WHEN column_default IS NULL THEN '' ELSE column_default END)) AS info
		</cfif>
		FROM information_schema.columns
		WHERE table_schema = '#application.database.name#'
		</cfquery>
	
		<cffile action="read" file="#expandPath(application.filePathTo.models & '/' & arguments.name & '.cfc')#" variable="model_file">
		<cfset model_hash = hash(valueList(model_query.info)) & hash(model_file)>

	</cfif>

	<cfif (NOT structKeyExists(application.wheels.models, arguments.name)) OR (application.settings.environment IS "development" AND NOT structKeyExists(application.wheels.models, "#arguments.name#_hash")) OR (application.settings.environment IS "development" AND application.wheels.models[arguments.name & "_hash"] IS NOT model_hash)>
		<cflock name="model_lock" type="exclusive" timeout="5">
	        <cfif (NOT structKeyExists(application.wheels.models, arguments.name)) OR (application.settings.environment IS "development" AND NOT structKeyExists(application.wheels.models, "#arguments.name#_hash")) OR (application.settings.environment IS "development" AND application.wheels.models[arguments.name & "_hash"] IS NOT model_hash)>
				<cfset "application.wheels.models.#arguments.name#" = createObject("component", "app.models.#arguments.name#").init()>
				<cfloop list="#application.wheels.object_functions#" index="i">
					<cfset "application.wheels.models.#arguments.name#.#i#" = "Object function (only available for individual objects)">
				</cfloop>
	        </cfif>
	    </cflock>
	</cfif>

	<cfset "application.wheels.models.#arguments.name#_hash" = model_hash>

	<cfreturn application.wheels.models[arguments.name]>
</cffunction>