<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="dataSource" returntype="void" access="public" output="false" hint="Use this method to override the data source connection information for this model."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels to use the data source named `users_source` instead of the default one whenever this model makes SQL calls  --->
  			<cfset dataSource("users_source")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="using-multiple-data-sources" functions="">
	<cfargument name="datasource" type="string" required="true" hint="The data source name to connect to.">
	<cfargument name="username" type="string" required="false" default="" hint="The username for the data source.">
	<cfargument name="password" type="string" required="false" default="" hint="The password for the data source.">
	<cfscript>
		StructAppend(variables.wheels.class.connection, arguments, true);
	</cfscript>
</cffunction>

<cffunction name="table" returntype="void" access="public" output="false" hint="Use this method to tell Wheels what database table to connect to for this model. You only need to use this method when your table naming does not follow the standard Wheels convention of a singular object name mapping to a plural table name."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels to use the `tbl_USERS` table in the database for the `user` model instead of the default (which would be `users`) --->
			<cfset table("tbl_USERS")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,tableName">
	<cfargument name="name" type="string" required="true" hint="Name of the table to map this model to.">
	<cfset variables.wheels.class.tableName = arguments.name>
</cffunction>

<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="columnNames" returntype="string" access="public" output="false" hint="Returns a list of column names in the table mapped to this model. The list is ordered according to the columns ordinal position in the database table."
	examples=
	'
		<!--- Get a list of all the column names in the table mapped to the author model --->
		<cfset columns = model("author").columnNames()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="dataSource,property,propertyNames,table,tableName">
	<cfreturn variables.wheels.class.columnList>
</cffunction>

<cffunction name="primaryKey" returntype="string" access="public" output="false" hint="Returns the name of the primary key for this model's table. This is determined through database introspection. If composite primary keys have been used they will both be returned in a list."
	examples=
	'
		<!--- Get the name of the primary key of the table mapped to the `employee` model (the `employees` table by default) --->
		<cfset theKeyName = model("employee").primaryKey()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="">
	<cfreturn variables.wheels.class.keys>
</cffunction>

<cffunction name="primaryKeys" returntype="string" access="public" output="false" hint="Alias for primaryKey()">
	<cfreturn primaryKey()>
</cffunction>

<cffunction name="tableName" returntype="string" access="public" output="false" hint="Returns the name of the database table that this model is mapped to."
	examples=
	'
		<!--- Check what table the user model uses --->
		<cfset whatAmIMappedTo = model("user").tableName()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfreturn getTableNamePrefix() & variables.wheels.class.tableName>
</cffunction>

<!--- tableNamePrefix --->
<cffunction name="setTableNamePrefix" returntype="void" access="public" output="false" hint="sets the tablename prefix for the table">
	<cfargument name="prefix" type="string" required="true" hint="the prefix to prepend to the table name">
	<cfset variables.wheels.class.tableNamePrefix =  arguments.prefix>
</cffunction>

<cffunction name="getTableNamePrefix" returntype="string" access="public" output="false" hint="returnss the tablename prefix for the table">
	<cfreturn variables.wheels.class.tableNamePrefix>
</cffunction>

<cffunction name="setPrimaryKey" returntype="void" access="public" output="false" hint="allows you to pass in the names of the property that should be used as the primary key(s)">
	<cfargument name="property" type="string" required="true">
	<cfset var loc = {}>
	<cfloop list="#arguments.property#" index="loc.i">
		<cfset variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.i)>
	</cfloop>
</cffunction>

<cffunction name="setPrimaryKeys" returntype="void" access="public" output="false" hint="Alias for setPrimaryKey()">
	<cfargument name="property" type="string" required="true">
	<cfset setPrimaryKey(argumentCollection=arguments)>
</cffunction>