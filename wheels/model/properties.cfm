<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="accessibleProperties" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "property"))
		{
			arguments.properties = ListAppend(arguments.properties, arguments.property);
		}

		// see if any associations should be included in the white list
		for (loc.association in variables.wheels.class.associations)
		{
			if (variables.wheels.class.associations[loc.association].nested.allow)
			{
				arguments.properties = ListAppend(arguments.properties, loc.association);
			}
		}
		variables.wheels.class.accessibleProperties.whiteList = $listClean(arguments.properties);
	</cfscript>
</cffunction>

<cffunction name="protectedProperties" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "property"))
		{
			arguments.properties = ListAppend(arguments.properties, arguments.property);
		}
		variables.wheels.class.accessibleProperties.blackList = $listClean(arguments.properties);
	</cfscript>
</cffunction>

<cffunction name="property" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="column" type="string" required="false" default="">
	<cfargument name="sql" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false" default="">
	<cfargument name="defaultValue" type="string" required="false">
	<cfscript>
		// validate setup
		if (Len(arguments.column) && Len(arguments.sql))
		{
			$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="You cannot specify both a column and a sql statement when setting up the mapping for this property.");
		}
		if (Len(arguments.sql) && StructKeyExists(arguments, "defaultValue"))
		{
			$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="You cannot specify a default value for calculated properties.");
		}

		// create the key
		if (!StructKeyExists(variables.wheels.class.mapping, arguments.name))
		{
			variables.wheels.class.mapping[arguments.name] = {};
		}

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
		{
			variables.wheels.class.mapping[arguments.name].label = arguments.label;
		}
		if (StructKeyExists(arguments, "defaultValue"))
		{
			variables.wheels.class.mapping[arguments.name].defaultValue = arguments.defaultValue;
		}
	</cfscript>
</cffunction>

<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="propertyNames" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = variables.wheels.class.propertyList;
		if (ListLen(variables.wheels.class.calculatedPropertyList))
		{
			loc.rv = ListAppend(loc.rv, variables.wheels.class.calculatedPropertyList);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="columns" returntype="array" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = ListToArray(variables.wheels.class.columnList);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="columnForProperty" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			loc.rv = variables.wheels.class.properties[arguments.property].column;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="columnDataForProperty" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			loc.rv = variables.wheels.class.properties[arguments.property];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="validationTypeForProperty" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "string";
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			loc.rv = variables.wheels.class.properties[arguments.property].validationtype;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="key" returntype="string" access="public" output="false">
	<cfargument name="$persisted" type="boolean" required="false" default="false">
	<cfargument name="$returnTickCountWhenNew" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.rv = "";
		loc.iEnd = ListLen(primaryKeys());
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.property = primaryKeys(loc.i);
			if (StructKeyExists(this, loc.property))
			{
				if (arguments.$persisted && hasChanged(loc.property))
				{
					loc.rv = ListAppend(loc.rv, changedFrom(loc.property));
				}
				else
				{
					loc.rv = ListAppend(loc.rv, this[loc.property]);
				}
			}
		}
		if (!Len(loc.rv) && arguments.$returnTickCountWhenNew)
		{
			loc.rv = variables.wheels.tickCountId;
		}
		</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="hasProperty" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (StructKeyExists(this, arguments.property) && !IsCustomFunction(this[arguments.property]))
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="propertyIsPresent" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (StructKeyExists(this, arguments.property) && !IsCustomFunction(this[arguments.property]) && IsSimpleValue(this[arguments.property]) && Len(this[arguments.property]))
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="toggle" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="save" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="toggle", args=arguments);
		if (!StructKeyExists(this, arguments.property))
		{
			$throw(type="Wheels.PropertyDoesNotExist", message="Property Does Not Exist", extendedInfo="You may only toggle a property that exists on this model.");
		}
		if (!IsBoolean(this[arguments.property]))
		{
			$throw(type="Wheels.PropertyIsIncorrectType", message="Incorrect Arguments", extendedInfo="You may only toggle a property that evaluates to the boolean value.");
		}
		this[arguments.property] = !this[arguments.property];
		loc.rv = true;
		if (arguments.save)
		{
			loc.rv = updateProperty(property=arguments.property, value=this[arguments.property]);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="properties" returntype="struct" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = {};
		for (loc.key in this)
		{
			// we return anything that is not a function
			if (!IsCustomFunction(this[loc.key]))
			{
				// try to get the property name from the list set on the object, this is just to avoid returning everything in ugly upper case which Adobe ColdFusion does by default
				if (ListFindNoCase(propertyNames(), loc.key))
				{
					loc.key = ListGetAt(propertyNames(), ListFindNoCase(propertyNames(), loc.key));
				}

				// set property from the this scope in the struct that we will return
				loc.rv[loc.key] = this[loc.key];
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="setProperties" returntype="void" access="public" output="false">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		$setProperties(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasChanged" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfscript>
		var loc = {};

		// always return true if $persistedProperties does not exists
		if (!StructKeyExists(variables, "$persistedProperties"))
		{
			return true;
		}

		if (!Len(arguments.property))
		{
			// they haven't specified a particular property so loop through them all
			arguments.property = StructKeyList(variables.wheels.class.properties);
		}
		arguments.property = ListToArray(arguments.property);
		loc.iEnd = ArrayLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.key = arguments.property[loc.i];
			if (StructKeyExists(this, loc.key))
			{
				if (!StructKeyExists(variables.$persistedProperties, loc.key))
				{
					return true;
				}
				else
				{
					// convert each datatype to a string for easier comparision
					loc.type = validationTypeForProperty(loc.key);
					loc.a = $convertToString(this[loc.key], loc.type);
					loc.b = $convertToString(variables.$persistedProperties[loc.key], loc.type);
					if (Compare(loc.a, loc.b) != 0)
					{
						return true;
					}
				}
			}
		}
		// if we get here, it means that all of the properties that were checked had a value in
		// $persistedProperties and it matched or some of the properties did not exist in the this scope
	</cfscript>
	<cfreturn false>
</cffunction>

<cffunction name="changedProperties" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = "";
		for (loc.key in variables.wheels.class.properties)
		{
			if (hasChanged(loc.key))
			{
				loc.rv = ListAppend(loc.rv, loc.key);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="changedFrom" returntype="string" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		if (StructKeyExists(variables, "$persistedProperties") && StructKeyExists(variables.$persistedProperties, arguments.property))
		{
			loc.rv = variables.$persistedProperties[arguments.property];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="allChanges" returntype="struct" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = {};
		if (hasChanged())
		{
			loc.changedProperties = changedProperties();
			loc.iEnd = ListLen(loc.changedProperties);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(loc.changedProperties, loc.i);
				loc.rv[loc.item] = {};
				loc.rv[loc.item].changedFrom = changedFrom(loc.item);
				if (StructKeyExists(this, loc.item))
				{
					loc.rv[loc.item].changedTo = this[loc.item];
				}
				else
				{
					loc.rv[loc.item].changedTo = "";
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="clearChangeInformation" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="false">
	<cfscript>
		$updatePersistedProperties(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$setProperties" returntype="any" access="public" output="false">
	<cfargument name="properties" type="struct" required="true">
	<cfargument name="filterList" type="string" required="false" default="">
	<cfargument name="setOnModel" type="boolean" required="false" default="true">
	<cfargument name="$useFilterLists" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		loc.rv = {};
		arguments.filterList = ListAppend(arguments.filterList, "properties,filterList,setOnModel,$useFilterLists");

		// add eventual named arguments to properties struct (named arguments will take precedence)
		for (loc.key in arguments)
		{
			if (!ListFindNoCase(arguments.filterList, loc.key))
			{
				arguments.properties[loc.key] = arguments[loc.key];
			}
		}

		// loop through the properties and see if they can be set based off of the accessible properties lists
		for (loc.key in arguments.properties)
		{
			loc.accessible = true;
			if (arguments.$useFilterLists && StructKeyExists(variables.wheels.class.accessibleProperties, "whiteList") && !ListFindNoCase(variables.wheels.class.accessibleProperties.whiteList, loc.key))
			{
				loc.accessible = false;
			}
			if (arguments.$useFilterLists && StructKeyExists(variables.wheels.class.accessibleProperties, "blackList") && ListFindNoCase(variables.wheels.class.accessibleProperties.blackList, loc.key))
			{
				loc.accessible = false;
			}
			if (loc.accessible)
			{
				loc.rv[loc.key] = arguments.properties[loc.key];
			}
			if (loc.accessible && arguments.setOnModel)
			{
				$setProperty(property=loc.key, value=loc.rv[loc.key]);
			}
		}

		if (arguments.setOnModel)
		{
			return;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$setProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="associations" type="struct" required="false" default="#variables.wheels.class.associations#">
	<cfscript>
		if (IsObject(arguments.value))
		{
			this[arguments.property] = arguments.value;
		}
		else if (IsStruct(arguments.value) && StructKeyExists(arguments.associations, arguments.property) && arguments.associations[arguments.property].nested.allow && ListFindNoCase("belongsTo,hasOne", arguments.associations[arguments.property].type))
		{
			$setOneToOneAssociationProperty(property=arguments.property, value=arguments.value, association=arguments.associations[arguments.property]);
		}
		else if (IsStruct(arguments.value) && StructKeyExists(arguments.associations, arguments.property) && arguments.associations[arguments.property].nested.allow && arguments.associations[arguments.property].type == "hasMany")
		{
			$setCollectionAssociationProperty(property=arguments.property, value=arguments.value, association=arguments.associations[arguments.property]);
		}
		else if (IsArray(arguments.value) && ArrayLen(arguments.value) && !IsObject(arguments.value[1]) && StructKeyExists(arguments.associations, arguments.property) && arguments.associations[arguments.property].nested.allow && arguments.associations[arguments.property].type == "hasMany")
		{
			$setCollectionAssociationProperty(property=arguments.property, value=arguments.value, association=arguments.associations[arguments.property]);
		}
		else
		{
			this[arguments.property] = arguments.value;
		}
	</cfscript>
</cffunction>

<cffunction name="$updatePersistedProperties" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="false">
	<cfscript>
		var loc = {};
		variables.$persistedProperties = {};
		for (loc.key in variables.wheels.class.properties)
		{
			if (StructKeyExists(this, loc.key) && (!StructKeyExists(arguments, "property") || arguments.property == loc.key))
			{
				variables.$persistedProperties[loc.key] = this[loc.key];
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$setDefaultValues" returntype="any" access="public" output="false">
	<cfscript>
	var loc = {};
	for (loc.key in variables.wheels.class.properties)
	{
		if (StructKeyExists(variables.wheels.class.properties[loc.key], "defaultValue") && (!StructKeyExists(this, loc.key) || !Len(this[loc.key])))
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
		var loc = {};
		loc.rv = {};
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			loc.rv = variables.wheels.class.properties[arguments.property];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$label" returntype="string" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(variables.wheels.class.properties, arguments.property) && StructKeyExists(variables.wheels.class.properties[arguments.property], "label"))
		{
			loc.rv = variables.wheels.class.properties[arguments.property].label;
		}
		else if (StructKeyExists(variables.wheels.class.mapping, arguments.property) && StructKeyExists(variables.wheels.class.mapping[arguments.property], "label"))
		{
			loc.rv = variables.wheels.class.mapping[arguments.property].label;
		}
		else
		{
			loc.rv = Humanize(arguments.property);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>