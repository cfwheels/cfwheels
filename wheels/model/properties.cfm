<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="accessibleProperties" returntype="void" access="public" output="false" hint="Use this method to specify which properties can be set through mass assignment."
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="protectedProperties">
	<cfargument name="properties" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "property"))
			arguments.properties = ListAppend(arguments.properties, arguments.property);
		// see if any associations should be included in the white list
		for (loc.association in variables.wheels.class.associations)
			if (variables.wheels.class.associations[loc.association].nested.allow)
				arguments.properties = ListAppend(arguments.properties, loc.association);
		variables.wheels.class.accessibleProperties.whiteList = $listClean(arguments.properties);
	</cfscript>
</cffunction>

<cffunction name="protectedProperties" returntype="void" access="public" output="false" hint="Use this method to specify which properties cannot be set through mass assignment."
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="accessibleProperties">
	<cfargument name="properties" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "property"))
			arguments.properties = ListAppend(arguments.properties, arguments.property);
		variables.wheels.class.accessibleProperties.blackList = $listClean(arguments.properties);
	</cfscript>
</cffunction>

<cffunction name="property" returntype="void" access="public" output="false" hint="Use this method to map an object property to either a table column with a different name than the property or to a specific SQL function. You only need to use this method when you want to override the default mapping that Wheels performs."
	examples=
	'
		<!--- Tell Wheels that when we are referring to `firstName` in the CFML code it should translate to the `STR_USERS_FNAME` column when interacting with the database instead of the default (which would be the `firstname` column) --->
		<cfset property(name="firstName", column="STR_USERS_FNAME")>

		<!--- Tell Wheels that when we are referring to `fullName` in the CFML code it should concatenate the `STR_USERS_FNAME` and `STR_USERS_LNAME` columns --->
		<cfset property(name="fullName", sql="STR_USERS_FNAME + '' '' + STR_USERS_LNAME")>

		<!--- Tell Wheels that when displaying error messages or labels for form fields, we want to use `First name(s)` as the label for the `STR_USERS_FNAME` column --->
		<cfset property(name="firstName", label="First name(s)")>

		<!--- Tell Wheels that when creating new objects we want them to be auto-populated with a `firstName` property with a value of `Dave` --->
		<cfset property(name="firstName", defaultValue="Dave")>
	'
	categories="model-initialization,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,propertyNames,table,tableName">
	<cfargument name="name" type="string" required="true" hint="The name that you want to use for the column or SQL function result in the CFML code.">
	<cfargument name="column" type="string" required="false" default="" hint="The name of the column in the database table to map the property to.">
	<cfargument name="sql" type="string" required="false" default="" hint="An SQL function to use to calculate the property value.">
	<cfargument name="label" type="string" required="false" default="" hint="A custom label for this property.">
	<cfargument name="defaultValue" type="string" required="false" default="" hint="A default value for this property.">
	<cfscript>
		// validate setup
		if (Len(arguments.column) and Len(arguments.sql))
			$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="You cannot specify both a column and a sql statement when setting up the mapping for this property.");
		if (Len(arguments.sql) and Len(arguments.defaultValue))
			$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="You cannot specify a default value for calculated properties.");
		
		// create the key
		if (!StructKeyExists(variables.wheels.class.mapping, arguments.name))
			variables.wheels.class.mapping[arguments.name] = {};
			
		if (Len(arguments.column))
		{
			variables.wheels.class.mapping[arguments.name].type = "column";
			variables.wheels.class.mapping[arguments.name].value = arguments.column;
		}
		
		if (Len(arguments.sql))
		{
			variables.wheels.class.mapping[arguments.name].type = "sql";
			variables.wheels.class.mapping[arguments.name].value = arguments.sql;
		}
		
		if (Len(arguments.label)) 
			variables.wheels.class.mapping[arguments.name].label = arguments.label;
		
		if (Len(arguments.defaultValue)) 
			variables.wheels.class.mapping[arguments.name].defaultValue = arguments.defaultValue;
	</cfscript>
</cffunction>

<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="propertyNames" returntype="string" access="public" output="false" hint="Returns a list of property names ordered by their respective column's ordinal position in the database table and with eventual calculated properties at the end."
	examples=
	'
		<!--- Get a list of the property names in use in the user model --->
  		<cfset propNames = model("user").propertyNames()>
	'
	categories="model-class,miscellaneous" chapters="object-relational-mapping" functions="columnNames,dataSource,property,table,tableName">
	<cfscript>
		var loc = {};
		loc.returnValue = variables.wheels.class.propertyList;
		if (ListLen(variables.wheels.class.calculatedPropertyList))
			loc.returnValue = ListAppend(loc.returnValue, variables.wheels.class.calculatedPropertyList);
		</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<!--- get / set properties --->

<cffunction name="key" returntype="string" access="public" output="false" hint="Returns the value of the primary key for the object. If you have a single primary key named `id` then `someObject.key()` is functionally equivalent to `someObject.id`. This method is more useful when you do dynamic programming and don't know the name of the primary key or when you use composite keys (in which case it's convenient to use this method to get a list of both key values returned)."
	examples=
	'
		<!--- Get an object and then get the primary key value(s) --->
		<cfset anEmployee = model("employee").findByKey(params.key)>
		<cfset val = anEmployee.key()>
	'
	categories="model-object,miscellaneous" chapters="" functions="">
	<cfargument name="$persisted" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.iEnd = ListLen(variables.wheels.class.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.property = ListGetAt(variables.wheels.class.keys, loc.i);
			if (StructKeyExists(this, loc.property))
			{
				if (arguments.$persisted && hasChanged(loc.property))
					loc.returnValue = ListAppend(loc.returnValue, changedFrom(loc.property));
				else
					loc.returnValue = ListAppend(loc.returnValue, this[loc.property]);
			}
		}
		</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="properties" returntype="struct" access="public" output="false" hint="Returns a structure of all the properties with their names as keys and the values of the property as values."
	examples=
	'
		<!--- Get a structure of all the properties for an object --->
		<cfset user = model("user").findByKey(1)>
		<cfset props = user.properties()>
	'
	categories="model-object,miscellaneous" chapters="" functions="setProperties">
	<cfscript>
		var loc = {};
		loc.returnValue = {};

		// loop through all properties and functions in the this scope
		for (loc.key in this)
		{
			// we return anything that is not a function
			if (!IsCustomFunction(this[loc.key]))
			{
				// try to get the property name from the list set on the object, this is just to avoid returning everything in ugly upper case which Adobe ColdFusion does by default
				if (ListFindNoCase(propertyNames(), loc.key))
					loc.key = ListGetAt(propertyNames(), ListFindNoCase(propertyNames(), loc.key));

				// set property from the this scope in the struct that we will return
				loc.returnValue[loc.key] = this[loc.key];
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="setProperties" returntype="void" access="public" output="false" hint="Allows you to set all the properties of an object at once by passing in a structure with keys matching the property names."
	examples=
	'
		<!--- update the properties of the object with the params struct containing the values of a form post --->
		<cfset user = model("user").findByKey(1)>
		<cfset user.setProperties(params)>
	'
	categories="model-object,miscellaneous" chapters="" functions="properties">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfset $setProperties(argumentCollection=arguments) />
</cffunction>

<!--- changes --->

<cffunction name="hasChanged" returntype="boolean" access="public" output="false" hint="Returns `true` if the specified object property (or any if none was passed in) have been changed but not yet saved to the database. Will also return `true` if the object is new and no record for it exists in the database."
	examples=
	'
		<!--- Get a member object and change the `email` property on it --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.email = params.newEmail>

		<!--- Check if the `email` property has changed --->
		<cfif member.hasChanged(property="email")>
			<!--- Do something... --->
		</cfif>

		<!--- The above can also be done using a dynamic function like this --->
		<cfif member.emailHasChanged()>
			<!--- Do something... --->
		</cfif>
	'
	categories="model-object,changes" chapters="dirty-records" functions="allChanges,changedFrom,changedProperties">
	<cfargument name="property" type="string" required="false" default="" hint="Name of property to check for change.">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		for (loc.key in variables.wheels.class.properties)
			if (!StructKeyExists(variables, "$persistedProperties") || (StructKeyExists(this, loc.key) && StructKeyExists(variables.$persistedProperties, loc.key) && Compare(this[loc.key], variables.$persistedProperties[loc.key])) && (!Len(arguments.property) || loc.key == arguments.property))
				loc.returnValue = true;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="changedProperties" returntype="string" access="public" output="false" hint="Returns a list of the object properties that have been changed but not yet saved to the database."
	examples=
	'
		<!--- Get an object, change it and then ask for its changes (will return a list of the property names that have changed, not the values themselves) --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.firstName = params.newFirstName>
		<cfset member.email = params.newEmail>
		<cfset changes = member.changedProperties()>
	'
	categories="model-object,changes" chapters="dirty-records" functions="allChanges,changedFrom,hasChanged">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		for (loc.key in variables.wheels.class.properties)
			if (hasChanged(loc.key))
				loc.returnValue = ListAppend(loc.returnValue, loc.key);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="changedFrom" returntype="string" access="public" output="false" hint="Returns the previous value of a property that has changed. Returns an empty string if no previous value exists. Wheels will keep a note of the previous property value until the object is saved to the database."
	examples=
	'
		<!--- Get a member object and change the `email` property on it --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.email = params.newEmail>

		<!---Get the previous value (what the `email` property was before it was changed)--->
		<cfset oldValue = member.changedFrom(property="email")>

		<!--- The above can also be done using a dynamic function like this --->
		<cfset oldValue = member.emailChangedFrom()>
	'
	categories="model-object,changes" chapters="dirty-records" functions="allChanges,changedProperties,hasChanged">
	<cfargument name="property" type="string" required="true" hint="Name of property to get the previous value for.">
	<cfscript>
		var returnValue = "";
		if (StructKeyExists(variables, "$persistedProperties") && StructKeyExists(variables.$persistedProperties, arguments.property))
			returnValue = variables.$persistedProperties[arguments.property];
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="allChanges" returntype="struct" access="public" output="false" hint="Returns a struct detailing all changes that have been made on the object but not yet saved to the database."
	examples=
	'
		<!--- Get an object, change it and then ask for its changes (will return a struct containing the changes, both property names and their values) --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.firstName = params.newFirstName>
		<cfset member.email = params.newEmail>
		<cfset allChangesAsStruct = member.allChanges()>
	'
	categories="model-object,changes" chapters="dirty-records" functions="changedFrom,changedProperties,hasChanged">
	<cfscript>
		var loc = {};
		loc.returnValue = {};
		if (hasChanged())
		{
			loc.changedProperties = changedProperties();
			loc.iEnd = ListLen(loc.changedProperties);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(loc.changedProperties, loc.i);
				loc.returnValue[loc.item] = {};
				loc.returnValue[loc.item].changedFrom = changedFrom(loc.item);
				if (StructKeyExists(this, loc.item))
					loc.returnValue[loc.item].changedTo = this[loc.item];
				else
					loc.returnValue[loc.item].changedTo = "";
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$setProperties" returntype="any" access="public" output="false" hint="I am the behind the scenes method to turn arguments into the properties argument.">
	<cfargument name="properties" type="struct" required="true" />
	<cfargument name="filterList" type="string" required="false" default="" />
	<cfargument name="setOnModel" type="boolean" required="false" default="true" />
	<cfargument name="$useFilterLists" type="boolean" required="false" default="true" />
	<cfscript>
		var loc = {};

		loc.allowedProperties = {};

		arguments.filterList = ListAppend(arguments.filterList, "properties,filterList,setOnModel,$useFilterLists");

		// add eventual named arguments to properties struct (named arguments will take precedence)
		for (loc.key in arguments)
			if (!ListFindNoCase(arguments.filterList, loc.key))
				arguments.properties[loc.key] = arguments[loc.key];

		for (loc.key in arguments.properties) // loop throug the properties and see if they can be set based off of the accessible properties lists
		{
			loc.accessible = true;
			if (arguments.$useFilterLists && StructKeyExists(variables.wheels.class.accessibleProperties, "whiteList") && !ListFindNoCase(variables.wheels.class.accessibleProperties.whiteList, loc.key))
				loc.accessible = false;
			if (arguments.$useFilterLists && StructKeyExists(variables.wheels.class.accessibleProperties, "blackList") && ListFindNoCase(variables.wheels.class.accessibleProperties.blackList, loc.key))
				loc.accessible = false;
			if (loc.accessible)
				loc.allowedProperties[loc.key] = arguments.properties[loc.key];
			if (loc.accessible && arguments.setOnModel)
				$setProperty(property=loc.key, value=loc.allowedProperties[loc.key]);
		}

		if (arguments.setOnModel)
			return;
	</cfscript>
	<cfreturn loc.allowedProperties />
</cffunction>

<cffunction name="$setProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="value" type="any" required="true" />
	<cfargument name="associations" type="struct" required="false" default="#variables.wheels.class.associations#" />
	<cfscript>
		if (IsStruct(arguments.value) && StructKeyExists(arguments.associations, arguments.property) && arguments.associations[arguments.property].nested.allow && ListFindNoCase("belongsTo,hasOne", arguments.associations[arguments.property].type))
			$setOneToOneAssociationProperty(property=arguments.property, value=arguments.value, association=arguments.associations[arguments.property]);
		else if ((IsStruct(arguments.value) || IsArray(arguments.value)) && StructKeyExists(arguments.associations, arguments.property) && arguments.associations[arguments.property].nested.allow && arguments.associations[arguments.property].type == "hasMany")
			$setCollectionAssociationProperty(property=arguments.property, value=arguments.value, association=arguments.associations[arguments.property]);
		else
			this[arguments.property] = arguments.value;
	</cfscript>
	<cfreturn />
</cffunction>

<cffunction name="$updatePersistedProperties" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		variables.$persistedProperties = {};
		for (loc.key in variables.wheels.class.properties)
			if (StructKeyExists(this, loc.key))
				variables.$persistedProperties[loc.key] = this[loc.key];
	</cfscript>
</cffunction>

<cffunction name="$setDefaultValues" returntype="any" access="public" output="false">
	<cfscript>
	var loc = {};
	for (loc.key in variables.wheels.class.properties)
	{
		if (Len(variables.wheels.class.properties[loc.key].defaultValue) && (!StructKeyExists(this, loc.key) || !Len(this[loc.key])))
		{
			// set the default value unless it is blank or a value already exists for that property on the object
			this[loc.key] = variables.wheels.class.properties[loc.key].defaultValue;
		}
	}
	</cfscript>
</cffunction>

<cffunction name="$propertyInfo" returntype="struct" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var returnValue = {};
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
			returnValue = variables.wheels.class.properties[arguments.property];
	</cfscript>
	<cfreturn returnValue />
</cffunction>