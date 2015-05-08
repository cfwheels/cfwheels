<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="dataSource" returntype="void" access="public" output="false">
	<cfargument name="datasource" type="string" required="true">
	<cfargument name="username" type="string" required="false" default="">
	<cfargument name="password" type="string" required="false" default="">
	<cfscript>
		StructAppend(variables.wheels.class.connection, arguments);
	</cfscript>
</cffunction>

<cffunction name="table" returntype="void" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.wheels.class.tableName = arguments.name>
</cffunction>

<cffunction name="setTableNamePrefix" returntype="void" access="public" output="false">
	<cfargument name="prefix" type="string" required="true">
	<cfscript>
		variables.wheels.class.tableNamePrefix =  arguments.prefix;
	</cfscript>
</cffunction>

<cffunction name="setPrimaryKey" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
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

<cffunction name="setPrimaryKeys" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		setPrimaryKey(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="exists" returntype="boolean" access="public" output="false">
	<cfargument name="key" type="any" required="false">
	<cfargument name="where" type="string" required="false">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="exists", args=arguments);
		if (get("showErrorInformation") && StructKeyExists(arguments, "key") && StructKeyExists(arguments, "where"))
		{
				$throw(type="Wheels.IncorrectArguments", message="You cannot pass in both `key` and `where`.");
		}
		arguments.select = primaryKey();
		arguments.returnAs = "query";
		if (StructKeyExists(arguments, "key"))
		{
			loc.rv = findByKey(argumentCollection=arguments).recordCount;
		}
		else
		{
			loc.rv = findOne(argumentCollection=arguments).recordCount;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="columnNames" returntype="string" access="public" output="false">
	<cfreturn variables.wheels.class.columnList>
</cffunction>

<cffunction name="primaryKey" returntype="string" access="public" output="false">
	<cfargument name="position" type="numeric" required="false" default="0">
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

<cffunction name="primaryKeys" returntype="string" access="public" output="false">
	<cfargument name="position" type="numeric" required="false" default="0">
	<cfreturn primaryKey(argumentCollection=arguments)>
</cffunction>

<cffunction name="tableName" returntype="string" access="public" output="false">
	<cfreturn variables.wheels.class.tableName>
</cffunction>

<cffunction name="getTableNamePrefix" returntype="string" access="public" output="false">
	<cfreturn variables.wheels.class.tableNamePrefix>
</cffunction>

<cffunction name="isClass" returntype="boolean" access="public" output="false">
	<cfreturn !isInstance(argumentCollection=arguments)>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="isNew" returntype="boolean" access="public" output="false">
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

<cffunction name="compareTo" access="public" output="false" returntype="boolean">
	<cfargument name="object" type="component" required="true">
	<cfreturn Compare(this.$objectId(), arguments.object.$objectId()) IS 0>
</cffunction>

<cffunction name="isInstance" returntype="boolean" access="public" output="false">
	<cfreturn StructKeyExists(variables.wheels, "instance")>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$objectId" access="public" output="false" returntype="string">
	<cfreturn variables.wheels.tickCountId>
</cffunction>

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

<cffunction name="$keyLengthCheck" returntype="void" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfscript>
	// throw error if the number of keys passed in is not the same as the number of keys defined for the model
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