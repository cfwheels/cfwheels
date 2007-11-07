<cffunction name="hasOne" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="model_name" type="any" required="false" default="#variables.class.name#">
	<cfargument name="associated_model_name" type="any" required="false" default="#arguments.name#">
	<cfargument name="table_name" type="any" required="false" default="#lCase(pluralize(arguments.model_name))#">
	<cfargument name="associated_table_name" type="any" required="false" default="#lCase(pluralize(arguments.associated_model_name))#">
	<cfargument name="primary_key" type="any" required="false" default="id">
	<cfargument name="foreign_key" type="any" required="false" default="#lCase(arguments.model_name)#_id">
	<cfset "variables.class.associations.#arguments.name#.type" = "has_one">
	<cfset "variables.class.associations.#arguments.name#.model_name" = arguments.model_name>
	<cfset "variables.class.associations.#arguments.name#.associated_model_name" = arguments.associated_model_name>
	<cfset "variables.class.associations.#arguments.name#.table_name" = arguments.table_name>
	<cfset "variables.class.associations.#arguments.name#.associated_table_name" = arguments.associated_table_name>
	<cfset "variables.class.associations.#arguments.name#.primary_key" = arguments.primary_key>
	<cfset "variables.class.associations.#arguments.name#.foreign_key" = arguments.foreign_key>
	<cfset "variables.class.associations.#arguments.name#.join_string" = "LEFT OUTER JOIN #arguments.associated_table_name# ON #arguments.table_name#.#arguments.primary_key# = #arguments.associated_table_name#.#arguments.foreign_key#">
	<cfset "variables.class.associations.#arguments.name#.methods" = "#lCase(arguments.associated_model_name)#,set#arguments.associated_model_name#,new#arguments.associated_model_name#,create#arguments.associated_model_name#,has#arguments.associated_model_name#">
</cffunction>


<cffunction name="hasMany" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="model_name" type="any" required="false" default="#capitalize(variables.class.name)#">
	<cfargument name="associated_model_name" type="any" required="false" default="#capitalize(singularize(arguments.name))#">
	<cfargument name="table_name" type="any" required="false" default="#lCase(pluralize(arguments.model_name))#">
	<cfargument name="associated_table_name" type="any" required="false" default="#lCase(pluralize(arguments.associated_model_name))#">
	<cfargument name="primary_key" type="any" required="false" default="id">
	<cfargument name="foreign_key" type="any" required="false" default="#lCase(arguments.model_name)#_id">
	<cfset "variables.class.associations.#arguments.name#.type" = "has_many">
	<cfset "variables.class.associations.#arguments.name#.model_name" = arguments.model_name>
	<cfset "variables.class.associations.#arguments.name#.associated_model_name" = arguments.associated_model_name>
	<cfset "variables.class.associations.#arguments.name#.table_name" = arguments.table_name>
	<cfset "variables.class.associations.#arguments.name#.associated_table_name" = arguments.associated_table_name>
	<cfset "variables.class.associations.#arguments.name#.primary_key" = arguments.primary_key>
	<cfset "variables.class.associations.#arguments.name#.foreign_key" = arguments.foreign_key>
	<cfset "variables.class.associations.#arguments.name#.join_string" = "LEFT OUTER JOIN #arguments.associated_table_name# ON #arguments.table_name#.#arguments.primary_key# = #arguments.associated_table_name#.#arguments.foreign_key#">
	<cfset "variables.class.associations.#arguments.name#.methods" = "#lCase(pluralize(arguments.associated_model_name))#,add#arguments.associated_model_name#,delete#arguments.associated_model_name#,clear#pluralize(arguments.associated_model_name)#,new#arguments.associated_model_name#,create#arguments.associated_model_name#,findOne#arguments.associated_model_name#,find#arguments.associated_model_name#ByID,has#pluralize(arguments.associated_model_name)#,#lCase(arguments.associated_model_name)#Count">
</cffunction>


<cffunction name="belongsTo" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="model_name" type="any" required="false" default="#variables.class.name#">
	<cfargument name="associated_model_name" type="any" required="false" default="#arguments.name#">
	<cfargument name="table_name" type="any" required="false" default="#lCase(pluralize(arguments.model_name))#">
	<cfargument name="associated_table_name" type="any" required="false" default="#lCase(pluralize(arguments.associated_model_name))#">
	<cfargument name="primary_key" type="any" required="false" default="id">
	<cfargument name="foreign_key" type="any" required="false" default="#lCase(arguments.associated_model_name)#_id">
	<cfset "variables.class.associations.#arguments.name#.type" = "belongs_to">
	<cfset "variables.class.associations.#arguments.name#.model_name" = arguments.model_name>
	<cfset "variables.class.associations.#arguments.name#.associated_model_name" = arguments.associated_model_name>
	<cfset "variables.class.associations.#arguments.name#.table_name" = arguments.table_name>
	<cfset "variables.class.associations.#arguments.name#.associated_table_name" = arguments.associated_table_name>
	<cfset "variables.class.associations.#arguments.name#.primary_key" = arguments.primary_key>
	<cfset "variables.class.associations.#arguments.name#.foreign_key" = arguments.foreign_key>
	<cfset "variables.class.associations.#arguments.name#.join_string" = "LEFT OUTER JOIN #arguments.associated_table_name# ON #arguments.table_name#.#arguments.foreign_key# = #arguments.associated_table_name#.#arguments.primary_key#">
	<cfset "variables.class.associations.#arguments.name#.methods" = "#lCase(arguments.associated_model_name)#,set#arguments.associated_model_name#,new#arguments.associated_model_name#,create#arguments.associated_model_name#,has#arguments.associated_model_name#">
</cffunction>