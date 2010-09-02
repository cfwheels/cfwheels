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
	<cfreturn getTableNamePrefix() & variables.wheels.class.tableName>
</cffunction>

<!--- tableNamePrefix --->
<cffunction name="setTableNamePrefix" returntype="void" access="public" output="false" hint="Sets a prefix to prepend to the table name when this model runs SQL queries."
	examples='
		<!--- In `models/User.cfc`, add a prefix to the default table name of `tbl` --->
		<cffunction name="init">
			<cfset setTableNamePrefix("tbl")>
		</cffunction>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="prefix" type="string" required="true" hint="A prefix to prepend to the table name.">
	<cfset variables.wheels.class.tableNamePrefix =  arguments.prefix>
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

<cffunction name="setPrimaryKey" returntype="void" access="public" output="false" hint="Allows you to pass in the name(s) of the property(s) that should be used as the primary key(s). Pass as a list if defining a composite primary key. Also aliased as `setPrimaryKeys()`."
	examples='
		<!--- In `models/User.cfc`, define the primary key as a column called `userID` --->
		<cffunction name="init">
			<cfset setPrimaryKey("userID")>
		</cffunction>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="property" type="string" required="true" hint="Property (or list of properties) to set as the primary key.">
	<cfset var loc = {}>
	<cfloop list="#arguments.property#" index="loc.i">
		<cfset variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.i)>
	</cfloop>
</cffunction>

<cffunction name="setPrimaryKeys" returntype="void" access="public" output="false" hint="Alias for @setPrimaryKey. Use this for better readability when you're setting multiple properties as the primary key."
	examples='
		<!--- In `models/Subscription.cfc`, define the primary key as composite of the columns `customerId` and `publicationId` --->
		<cffunction name="init">
			<cfset setPrimaryKeys("customerId,publicationId")>
		</cffunction>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="property" type="string" required="true" hint="Property (or list of properties) to set as the primary key.">
	<cfset setPrimaryKey(argumentCollection=arguments)>
</cffunction>

<cffunction name="compareTo" access="public" output="false" returntype="boolean" hint="Pass in another Wheels model object to see if the two objects are the same."
	examples='
		<!--- Load a user requested in the URL/form and restrict access if it doesn''t match the user stored in the session --->
		<cfset user = model("user").findByKey(params.key)>
		<cfif not user.compareTo(session.user)>
			<cfset renderPage(action="accessDenied")>
		</cfif>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfargument name="object" type="component" required="true">
	<cfreturn Compare(this.$objectId(), arguments.object.$objectId()) eq 0 />
</cffunction>

<cffunction name="$objectId" access="public" output="false" returntype="string">
	<cfreturn variables.wheels.tickCountId />
</cffunction>

<cffunction name="setPagination" access="public" output="false" returntype="void" hint="allow you to set a pagination handle for a custom query so you can perform pagination in your view with paginationLinks()"
	examples=
	'
		<!--- In your model (ie. User.cfc), create a custom method for your custom query --->
		<cffunction name="myCustomQuery">
			<cfargument name="page" type="numeric" required="true">
			<cfquery name="customQuery" datasource="##get(''datasourcename'')##">
			select * from users
			</cfquery>
			
			<cfset setPagination(totalRecords="##customQuery.RecordCount##", currentPage="##arguments.page##", perPage="25", handle="myCustomQueryHandle")>
			<cfreturn customQuery>
		</cffunction>
		
		<!--- in your view you access using paginationLinks() --->
		<!--- controller code --->
		<cfparam name="params.page" default="1">
		<cfset allUsers = model("user").myCustomQuery(page="##params.page##")>

		<!--- view code --->
		<ul>
		    <cfoutput query="allAuthors">
		        <li>##firstName## ##lastName##</li>
		    </cfoutput>
		</ul>
		<cfoutput>##paginationLinks(handle="myCustomQueryHandle")##</cfoutput>
		
	'>
	<cfargument name="totalRecords" type="numeric" required="true">
	<cfargument name="currentPage" type="numeric" required="false" default="1">
	<cfargument name="perPage" type="numeric" required="false" default="25">
	<cfargument name="handle" type="string" required="false" default="query">
	<cfscript>
	var loc = {};
	// totalRecords cannot be negative
	if (arguments.totalRecords lt 0)
	{
		arguments.totalRecords = 0;
	}
	// perPage less then zero
	if (arguments.perPage lte 0)
	{
		arguments.perPage = 25;
	}
	// calculate the total pages the query will have
	arguments.totalPages = Ceiling(arguments.totalRecords/arguments.perPage);
	// currentPage shouldn't be less then 1 or greater then the number of pages
	if (arguments.currentPage gte arguments.totalPages)
	{
		arguments.currentPage = arguments.totalPages;
	}
	if (arguments.currentPage lt 1)
	{
		arguments.currentPage = 1;
	}
	// as a convinence for cfquery and cfloop when doing oldschool type pagination
	// startrow for cfquery and cfloop
	arguments.startRow = (arguments.currentPage * arguments.perPage) - arguments.perPage + 1;
	// maxrows for cfquery
	arguments.maxRows = arguments.perPage;
	// endrow for cfloop
	arguments.endRow = arguments.startRow + arguments.perPage;
	// endRow shouldn't be greater then the totalRecords or less than startRow
	if (arguments.endRow gte arguments.totalRecords)
	{
		arguments.endRow = arguments.totalRecords;
	}
	if (arguments.endRow lt arguments.startRow)
	{
		arguments.endRow = arguments.startRow;
	}
	loc.args = duplicate(arguments);
	structDelete(loc.args, "handle", false);
	request.wheels[arguments.handle] = loc.args;
	</cfscript>
</cffunction>