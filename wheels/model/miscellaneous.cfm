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

<cffunction name="tableless" returntype="void" access="public" output="false" hint="allows this model to be used without a database"
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tells wheels to not to use a database for this model --->
  			<cfset tableless()>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="">
	<cfscript>
		variables.wheels.class.connection = {};
	</cfscript>
</cffunction>

<cffunction name="getDataSource" returntype="struct" access="public" output="false" hint="returns the connection (datasource) information for the model."
	examples=
	'
		<!--- get the datasource information so we can write custom queries --->
		<cfquery name="q" datasource="##getDataSource().datasource##">
		select * from mytable
		</cfquery>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="">
	<cfreturn variables.wheels.class.connection>
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

<cffunction name="setTableNamePrefix" returntype="void" access="public" output="false" hint="Sets a prefix to prepend to the table name when this model runs SQL queries."
	examples='
		<!--- In `models/User.cfc`, add a prefix to the default table name of `tbl` --->
		<cffunction name="init">
			<cfset setTableNamePrefix("tbl")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="prefix" type="string" required="true" hint="A prefix to prepend to the table name.">
	<cfset variables.wheels.class.tableNamePrefix =  arguments.prefix>
</cffunction>

<cffunction name="setPrimaryKey" returntype="void" access="public" output="false" hint="Allows you to pass in the name(s) of the property(s) that should be used as the primary key(s). Pass as a list if defining a composite primary key. Also aliased as `setPrimaryKeys()`."
	examples='
		<!--- In `models/User.cfc`, define the primary key as a column called `userID` --->
		<cffunction name="init">
			<cfset setPrimaryKey("userID")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="property" type="string" required="true" hint="Property (or list of properties) to set as the primary key.">
	<cfset var loc = {}>
	<cfloop list="#arguments.property#" index="loc.i">
                <cfif !ListFindNoCase(variables.wheels.class.keys, loc.i)>
		        <cfset variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.i)>
                </cfif>
	</cfloop>
</cffunction>

<cffunction name="setPrimaryKeys" returntype="void" access="public" output="false" hint="Alias for @setPrimaryKey. Use this for better readability when you're setting multiple properties as the primary key."
	examples='
		<!--- In `models/Subscription.cfc`, define the primary key as composite of the columns `customerId` and `publicationId` --->
		<cffunction name="init">
			<cfset setPrimaryKeys("customerId,publicationId")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="property" type="string" required="true" hint="Property (or list of properties) to set as the primary key.">
	<cfset setPrimaryKey(argumentCollection=arguments)>
</cffunction>

<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="columnNames" returntype="string" access="public" output="false" hint="Returns a list of column names in the table mapped to this model. The list is ordered according to the columns' ordinal positions in the database table."
	examples=
	'
		<!--- Get a list of all the column names in the table mapped to the `author` model --->
		<cfset columns = model("author").columnNames()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="dataSource,property,propertyNames,table,tableName">
	<cfreturn variables.wheels.class.columnList>
</cffunction>

<cffunction name="primaryKey" returntype="string" access="public" output="false" hint="Returns the name of the primary key for this model's table. This is determined through database introspection. If composite primary keys have been used, they will both be returned in a list. This function is also aliased as `primaryKeys()`."
	examples=
	'
		<!--- Get the name of the primary key of the table mapped to the `employee` model (which is the `employees` table by default) --->
		<cfset keyName = model("employee").primaryKey()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="primaryKeys">
	<cfargument name="position" type="numeric" required="false" default="0" hint="If you are accessing a composite primary key, pass the position of a single key to fetch.">
	<cfif arguments.position gt 0>
		<cfreturn ListGetAt(variables.wheels.class.keys, arguments.position)>
	</cfif>
	<cfreturn variables.wheels.class.keys>
</cffunction>

<cffunction name="primaryKeys" returntype="string" access="public" output="false" hint="Alias for @primaryKey. Use this for better readability when you're accessing multiple primary keys."
	examples=
	'
		<!--- Get a list of the names of the primary keys in the table mapped to the `employee` model (which is the `employees` table by default) --->
		<cfset keyNames = model("employee").primaryKeys()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="primaryKey"
>
	<cfargument name="position" type="numeric" required="false" default="0" hint="@primaryKey.">
	<cfreturn primaryKey(argumentCollection=arguments)>
</cffunction>

<cffunction name="tableName" returntype="string" access="public" output="false" hint="Returns the name of the database table that this model is mapped to."
	examples=
	'
		<!--- Check what table the user model uses --->
		<cfset whatAmIMappedTo = model("user").tableName()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfreturn variables.wheels.class.tableName>
</cffunction>

<cffunction name="getTableNamePrefix" returntype="string" access="public" output="false" hint="Returns the table name prefix set for the table."
	examples='
		<!--- Get the table name prefix for this user when running a custom query --->
		<cffunction name="getDisabledUsers" returntype="query">
			<cfset var loc = {}>
			<cfquery datasource="##get(''dataSourceName'')##" name="loc.disabledUsers">
				SELECT
					*
				FROM
					##this.getTableNamePrefix()##users
				WHERE
					disabled = 1
			</cfquery>
			<cfreturn loc.disabledUsers>
		</cffunction>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfreturn variables.wheels.class.tableNamePrefix>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="compareTo" access="public" output="false" returntype="boolean" hint="Pass in another Wheels model object to see if the two objects are the same."
	examples='
		<!--- Load a user requested in the URL/form and restrict access if it doesn''t match the user stored in the session --->
		<cfset user = model("user").findByKey(params.key)>
		<cfif not user.compareTo(session.user)>
			<cfset renderView(action="accessDenied")>
		</cfif>
	'
	categories="model-object,miscellaneous" chapters="" functions="">
	<cfargument name="object" type="component" required="true">
	<cfreturn Compare(this.$objectId(), arguments.object.$objectId()) eq 0 />
</cffunction>

<cffunction name="$assignObjectId" access="public" output="false" returntype="numeric">
	<cflock type="exclusive" name="AssignObjectIdLock" timeout="5" throwontimeout="true">
		<cfif !StructKeyExists(request.wheels, "tickCountId")>
			<cfset request.wheels.tickCountId = GetTickCount()>
		</cfif>
		<cfset request.wheels.tickCountId = PrecisionEvaluate(request.wheels.tickCountId + 1)>
	</cflock>
	<cfreturn request.wheels.tickCountId>
</cffunction>

<cffunction name="$objectId" access="public" output="false" returntype="numeric">
	<cfreturn variables.wheels.instance.tickCountId />
</cffunction>

<cffunction name="$alias" access="public" output="false" returntype="void">
	<cfargument name="associationName" type="string" required="true">
	<cfargument name="alias" type="string" required="true">
	<cfset variables.wheels.class.aliases[arguments.associationName] = arguments.alias>
</cffunction>

<cffunction name="$aliasName" access="public" output="false" returntype="string">
	<cfargument name="associationName" type="string" required="false" default="">
	<cfscript>
		if (!Len(arguments.associationName) or !StructKeyExists(variables.wheels.class.aliases, arguments.associationName))
			return tableName();
	</cfscript>
	<cfreturn variables.wheels.class.aliases[arguments.associationName]>
</cffunction>

<cffunction name="isInstance" returntype="boolean" access="public" output="false" hint="Use this method to check whether you are currently in an instance object."
	examples='
		<!--- Use the passed in `id` when we''re not already in an instance --->
		<cffunction name="memberIsAdmin">
			<cfif isInstance()>
				<cfreturn this.admin>
			<cfelse>
				<cfreturn this.findByKey(arguments.id).admin>
			</cfif>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="isClass">
	<cfreturn StructKeyExists(variables.wheels, "instance")>
</cffunction>

<cffunction name="isClass" returntype="boolean" access="public" output="false" hint="Use this method within a model's method to check whether you are currently in a class-level object."
	examples='
		<!--- Use the passed in `id` when we''re already in an instance --->
		<cffunction name="memberIsAdmin">
			<cfif isClass()>
				<cfreturn this.findByKey(arguments.id).admin>
			<cfelse>
				<cfreturn this.admin>
			</cfif>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="isInstance">
	<cfreturn !isInstance(argumentCollection=arguments)>
</cffunction>
