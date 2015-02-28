<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="dataSource" returntype="void" access="public" output="false" hint="Use this method to override the data source connection information for this model."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell CFWheels to use the data source named `users_source` instead of the default one whenever this model makes SQL calls  --->
  			<cfset dataSource("users_source")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="using-multiple-data-sources" functions="">
	<cfargument name="datasource" type="string" required="true" hint="The data source name to connect to.">
	<cfargument name="username" type="string" required="false" default="" hint="The username for the data source.">
	<cfargument name="password" type="string" required="false" default="" hint="The password for the data source.">
	<cfscript>
		StructAppend(variables.wheels.class.connection, arguments);
	</cfscript>
</cffunction>

<cffunction name="table" returntype="void" access="public" output="false" hint="Use this method to tell CFWheels what database table to connect to for this model. You only need to use this method when your table naming does not follow the standard CFWheels convention of a singular object name mapping to a plural table name. To not use a table for your model at all, `call table(false)`."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell CFWheels to use the `tbl_USERS` table in the database for the `user` model instead of the default (which would be `users`) --->
			<cfset table("tbl_USERS")>
		</cffunction>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,tableName">
	<cfargument name="name" type="any" required="true" hint="Name of the table to map this model to.">
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
	<cfscript>
		variables.wheels.class.tableNamePrefix =  arguments.prefix;
	</cfscript>
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
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.property, loc.i);
			if (!ListFindNoCase(variables.wheels.class.keys, loc.item))
			{
				variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.item);
			}
		}
	</cfscript>
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
	<cfscript>
		setPrimaryKey(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="exists" returntype="boolean" access="public" output="false" hint="Checks if a record exists in the table. You can pass in either a primary key value to the `key` argument or a string to the `where` argument."
	examples=
	'
		<!--- Checking if Joe exists in the database --->
		<cfset result = model("user").exists(where="firstName=''Joe''")>

		<!--- Checking if a specific user exists based on a primary key valued passed in through the URL/form in an if statement --->
		<cfif model("user").exists(keyparams.key)>
			<!--- Do something... --->
		</cfif>

		<!--- If you have a `belongsTo` association setup from `comment` to `post`, you can do a scoped call. (The `hasPost` method below will call `model("post").exists(comment.postId)` internally.) --->
		<cfset comment = model("comment").findByKey(params.commentId)>
		<cfset commentHasAPost = comment.hasPost()>

		<!--- If you have a `hasOne` association setup from `user` to `profile`, you can do a scoped call. (The `hasProfile` method below will call `model("profile").exists(where="userId=##user.id##")` internally.) --->
		<cfset user = model("user").findByKey(params.userId)>
		<cfset userHasProfile = user.hasProfile()>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `hasComments` method below will call `model("comment").exists(where="postid=##post.id##")` internally.) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset postHasComments = post.hasComments()>
	'
	categories="model-class,miscellaneous" chapters="reading-records,associations" functions="belongsTo,hasMany,hasOne">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for @findByKey.">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfscript>
		var loc = {};
		$args(name="exists", args=arguments);
		if (application.wheels.showErrorInformation && Len(arguments.key) && Len(arguments.where))
		{
				$throw(type="Wheels.IncorrectArguments", message="You cannot pass in both `key` and `where`.");
		}
		if (Len(arguments.where))
		{
			loc.rv = findOne(select=primaryKey(), where=arguments.where, reload=arguments.reload, returnAs="query").recordCount >= 1;
		}
		else if (Len(arguments.key))
		{
			loc.rv = findByKey(key=arguments.key, select=primaryKey(), reload=arguments.reload, returnAs="query").recordCount == 1;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isNew" returntype="boolean" access="public" output="false" hint="Returns `true` if this object hasn't been saved yet. (In other words, no matching record exists in the database yet.) Returns `false` if a record exists."
	examples=
	'
		<!--- Create a new object and then check if it is new (yes, this example is ridiculous. It makes more sense in the context of callbacks for example) --->
		<cfset employee = model("employee").new()>
		<cfif employee.isNew()>
			<!--- Do something... --->
		</cfif>
	'
	categories="model-object,miscellaneous" chapters="" functions="">
	<cfscript>
		var loc = {};
		if (!StructKeyExists(variables, "$persistedProperties"))
		{
			// no values have been saved to the database so this object is new
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

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
	<cfscript>
		var loc = {};
		if (arguments.position > 0)
		{
			loc.rv = ListGetAt(variables.wheels.class.keys, arguments.position);
		}
		else
		{
			loc.rv = variables.wheels.class.keys;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="primaryKeys" returntype="string" access="public" output="false" hint="Alias for @primaryKey. Use this for better readability when you're accessing multiple primary keys."
	examples=
	'
		<!--- Get a list of the names of the primary keys in the table mapped to the `employee` model (which is the `employees` table by default) --->
		<cfset keyNames = model("employee").primaryKeys()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="primaryKey"
>
	<cfargument name="position" type="numeric" required="false" default="0" hint="See documentation for @primaryKey.">
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
			<cfset var loc = StructNew()>
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

<cffunction name="compareTo" access="public" output="false" returntype="boolean" hint="Pass in another CFWheels model object to see if the two objects are the same."
	examples='
		<!--- Load a user requested in the URL/form and restrict access if it doesn''t match the user stored in the session --->
		<cfset user = model("user").findByKey(params.key)>
		<cfif not user.compareTo(session.user)>
			<cfset renderPage(action="accessDenied")>
		</cfif>
	'
	categories="model-object,miscellaneous" chapters="" functions="">
	<cfargument name="object" type="component" required="true">
	<cfreturn Compare(this.$objectId(), arguments.object.$objectId()) IS 0>
</cffunction>

<cffunction name="$objectId" access="public" output="false" returntype="string">
	<cfreturn variables.wheels.tickCountId>
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

<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$buildQueryParamValues" returntype="struct" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = {};
		loc.rv.value = this[arguments.property];
		loc.rv.type = variables.wheels.class.properties[arguments.property].type;
		loc.rv.dataType = variables.wheels.class.properties[arguments.property].dataType;
		loc.rv.scale = variables.wheels.class.properties[arguments.property].scale;
		loc.rv.null = (!Len(this[arguments.property]) && variables.wheels.class.properties[arguments.property].nullable);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$keyLengthCheck" returntype="void" access="public" output="false" hint="Makes sure that the number of keys passed in is the same as the number of keys defined for the model. If not, an error is raised.">
	<cfargument name="key" type="any" required="true">
	<cfscript>
	if (ListLen(primaryKeys()) != ListLen(arguments.key))
	{
		$throw(type="Wheels.InvalidArgumentValue", message="The `key` argument contains an invalid value.", extendedInfo="The `key` argument contains a list, however this table doesn't have a composite key. A list of values is allowed for the `key` argument, but this only applies in the case when the table contains a composite key.");
	}
	</cfscript>
</cffunction>

<cffunction name="$timestampProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		this[arguments.property] = Now();
	</cfscript>
</cffunction>