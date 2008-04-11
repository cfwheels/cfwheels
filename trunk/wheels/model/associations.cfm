<cffunction name="hasOne" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="modelName" type="any" required="false" default="#variables.class.name#">
	<cfargument name="associatedModelName" type="any" required="false" default="#arguments.name#">
	<cfargument name="tableName" type="any" required="false" default="#lCase(_pluralize(arguments.modelName))#">
	<cfargument name="associatedTableName" type="any" required="false" default="#lCase(_pluralize(arguments.associatedModelName))#">
	<cfargument name="primaryKey" type="any" required="false" default="id">
	<cfargument name="foreignKey" type="any" required="false" default="#lCase(arguments.modelName)#Id">
	<cfset "variables.class.associations.#arguments.name#.type" = "hasOne">
	<cfset "variables.class.associations.#arguments.name#.modelName" = arguments.modelName>
	<cfset "variables.class.associations.#arguments.name#.associatedModelName" = arguments.associatedModelName>
	<cfset "variables.class.associations.#arguments.name#.tableName" = arguments.tableName>
	<cfset "variables.class.associations.#arguments.name#.associatedTableName" = arguments.associatedTableName>
	<cfset "variables.class.associations.#arguments.name#.primaryKey" = arguments.primaryKey>
	<cfset "variables.class.associations.#arguments.name#.foreignKey" = arguments.foreignKey>
	<cfset "variables.class.associations.#arguments.name#.joinString" = "LEFT OUTER JOIN #arguments.associatedTableName# ON #arguments.tableName#.#arguments.primaryKey# = #arguments.associatedTableName#.#arguments.foreignKey#">
	<cfset "variables.class.associations.#arguments.name#.methods" = "#lCase(arguments.associatedModelName)#,set#arguments.associatedModelName#,new#arguments.associatedModelName#,create#arguments.associatedModelName#,has#arguments.associatedModelName#">
</cffunction>


<cffunction name="hasMany" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="modelName" type="any" required="false" default="#variables.class.name#">
	<cfargument name="associatedModelName" type="any" required="false" default="#_singularize(arguments.name)#">
	<cfargument name="tableName" type="any" required="false" default="#lCase(_pluralize(arguments.modelName))#">
	<cfargument name="associatedTableName" type="any" required="false" default="#lCase(_pluralize(arguments.associatedModelName))#">
	<cfargument name="primaryKey" type="any" required="false" default="id">
	<cfargument name="foreignKey" type="any" required="false" default="#lCase(arguments.modelName)#Id">
	<cfset "variables.class.associations.#arguments.name#.type" = "hasMany">
	<cfset "variables.class.associations.#arguments.name#.modelName" = arguments.modelName>
	<cfset "variables.class.associations.#arguments.name#.associatedModelName" = arguments.associatedModelName>
	<cfset "variables.class.associations.#arguments.name#.tableName" = arguments.tableName>
	<cfset "variables.class.associations.#arguments.name#.associatedTableName" = arguments.associatedTableName>
	<cfset "variables.class.associations.#arguments.name#.primaryKey" = arguments.primaryKey>
	<cfset "variables.class.associations.#arguments.name#.foreignKey" = arguments.foreignKey>
	<cfset "variables.class.associations.#arguments.name#.joinString" = "LEFT OUTER JOIN #arguments.associatedTableName# ON #arguments.tableName#.#arguments.primaryKey# = #arguments.associatedTableName#.#arguments.foreignKey#">
	<cfset "variables.class.associations.#arguments.name#.methods" = "#lCase(_pluralize(arguments.associatedModelName))#,add#arguments.associatedModelName#,delete#arguments.associatedModelName#,clear#_pluralize(arguments.associatedModelName)#,new#arguments.associatedModelName#,create#arguments.associatedModelName#,findOne#arguments.associatedModelName#,find#arguments.associatedModelName#ById,has#_pluralize(arguments.associatedModelName)#,#lCase(arguments.associatedModelName)#Count">
</cffunction>


<cffunction name="belongsTo" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="modelName" type="any" required="false" default="#variables.class.name#">
	<cfargument name="associatedModelName" type="any" required="false" default="#arguments.name#">
	<cfargument name="tableName" type="any" required="false" default="#lCase(_pluralize(arguments.modelName))#">
	<cfargument name="associatedTableName" type="any" required="false" default="#lCase(_pluralize(arguments.associatedModelName))#">
	<cfargument name="primaryKey" type="any" required="false" default="id">
	<cfargument name="foreignKey" type="any" required="false" default="#lCase(arguments.associatedModelName)#Id">
	<cfset "variables.class.associations.#arguments.name#.type" = "belongsTo">
	<cfset "variables.class.associations.#arguments.name#.modelName" = arguments.modelName>
	<cfset "variables.class.associations.#arguments.name#.associatedModelName" = arguments.associatedModelName>
	<cfset "variables.class.associations.#arguments.name#.tableName" = arguments.tableName>
	<cfset "variables.class.associations.#arguments.name#.associatedTableName" = arguments.associatedTableName>
	<cfset "variables.class.associations.#arguments.name#.primaryKey" = arguments.primaryKey>
	<cfset "variables.class.associations.#arguments.name#.foreignKey" = arguments.foreignKey>
	<cfset "variables.class.associations.#arguments.name#.joinString" = "LEFT OUTER JOIN #arguments.associatedTableName# ON #arguments.tableName#.#arguments.foreignKey# = #arguments.associatedTableName#.#arguments.primaryKey#">
	<cfset "variables.class.associations.#arguments.name#.methods" = "#lCase(arguments.associatedModelName)#,set#arguments.associatedModelName#,new#arguments.associatedModelName#,create#arguments.associatedModelName#,has#arguments.associatedModelName#">
</cffunction>