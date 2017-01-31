<cfscript>
	/*
	* PUBLIC MODEL INITIALIZATION METHODS
	*/

	public void function accessibleProperties(string properties="") {
		if (StructKeyExists(arguments, "property"))
		{
			arguments.properties = ListAppend(arguments.properties, arguments.property);
		}

		// see if any associations should be included in the white list
		for (local.association in variables.wheels.class.associations)
		{
			if (variables.wheels.class.associations[local.association].nested.allow)
			{
				arguments.properties = ListAppend(arguments.properties, local.association);
			}
		}
		variables.wheels.class.accessibleProperties.whiteList = $listClean(arguments.properties);
	}

	public void function protectedProperties(string properties="") {
		if (StructKeyExists(arguments, "property"))
		{
			arguments.properties = ListAppend(arguments.properties, arguments.property);
		}
		variables.wheels.class.accessibleProperties.blackList = $listClean(arguments.properties);
	}

	public void function property(
		required string name,
		string column="",
		string sql="",
		string label="",
		string defaultValue,
		boolean select="true",
		string dataType="char"
	) {
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
			variables.wheels.class.mapping[arguments.name].select = arguments.select;
			variables.wheels.class.mapping[arguments.name].dataType = arguments.dataType;
		}
		if (Len(arguments.label))
		{
			variables.wheels.class.mapping[arguments.name].label = arguments.label;
		}
		if (StructKeyExists(arguments, "defaultValue"))
		{
			variables.wheels.class.mapping[arguments.name].defaultValue = arguments.defaultValue;
		}
	}

	/*
	* PUBLIC MODEL CLASS METHODS
	*/
	public string function propertyNames() {
		local.rv = variables.wheels.class.propertyList;
		if (ListLen(variables.wheels.class.calculatedPropertyList))
		{
			local.rv = ListAppend(local.rv, variables.wheels.class.calculatedPropertyList);
		}
		return local.rv;
	}

	public array function columns() {
		return ListToArray(variables.wheels.class.columnList);
	}

	public any function columnForProperty(required string property) {
		local.rv = false;
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			local.rv = variables.wheels.class.properties[arguments.property].column;
		}
		return local.rv;
	}

	public any function columnDataForProperty(required string property) {
		local.rv = false;
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			local.rv = variables.wheels.class.properties[arguments.property];
		}
		return local.rv;
	}

	public any function validationTypeForProperty(required string property) {
		local.rv = "string";
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			local.rv = variables.wheels.class.properties[arguments.property].validationtype;
		}
		return local.rv;
	}

	/*
	* PUBLIC MODEL OBJECT METHODS
	*/

	public any function toParam() {
		return key();
	}

	public string function key(boolean $persisted="false", boolean $returnTickCountWhenNew="false") {
		local.rv = "";
		local.iEnd = ListLen(primaryKeys());
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.property = primaryKeys(local.i);
			if (StructKeyExists(this, local.property))
			{
				if (arguments.$persisted && hasChanged(local.property))
				{
					local.rv = ListAppend(local.rv, changedFrom(local.property));
				}
				else
				{
					local.rv = ListAppend(local.rv, this[local.property]);
				}
			}
		}
		if (!Len(local.rv) && arguments.$returnTickCountWhenNew)
		{
			local.rv = variables.wheels.tickCountId;
		}
		return local.rv;
	}

	public boolean function hasProperty(required string property) {
		local.rv = false;
		if (StructKeyExists(this, arguments.property) && !IsCustomFunction(this[arguments.property]))
		{
			local.rv = true;
		}
		return local.rv;
	}

	public boolean function propertyIsPresent(required string property) {
		local.rv = false;
		if (this.hasProperty(arguments.property) && IsSimpleValue(this[arguments.property]) && Len(this[arguments.property]))
		{
			local.rv = true;
		}
		return local.rv;
	}

	public boolean function propertyIsBlank(required string property) {
		return !this.propertyIsPresent(arguments.property);
	}

	public boolean function toggle(required string property, boolean save) {
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
		local.rv = true;
		if (arguments.save)
		{
			local.rv = updateProperty(property=arguments.property, value=this[arguments.property]);
		}
		return local.rv;
	}

	public struct function properties(boolean simple="false") {
		local.rv = {};
		// loop through all properties and functions in the this scope
		for (local.key in this)
		{
			// we return anything that is not a function
			if (!IsCustomFunction(this[local.key]))
			{
				// try to get the property name from the list set on the object, this is just to avoid returning everything in ugly upper case which Adobe ColdFusion does by default
				if (ListFindNoCase(propertyNames(), local.key))
				{
					local.key = ListGetAt(propertyNames(), ListFindNoCase(propertyNames(), local.key));
				}
				// if it's a nested property, apply this function recursively
				if (IsObject(this[local.key]) && arguments.simple)
				{
					local.rv[local.key] = this[local.key].properties(argumentCollection=arguments);
				}
				// loop thru the array and apply this function to each item
				else if (IsArray(this[local.key]) && arguments.simple)
				{
					local.rv[local.key] = [];
					for (local.i=1; local.i <= ArrayLen(this[local.key]); local.i++)
					{
						local.rv[local.key][local.i] = this[local.key][local.i].properties(argumentCollection=arguments);
					}
				}
				// set property from the this scope in the struct that we will return
				else
				{
					local.rv[local.key] = this[local.key];
				}
			}
		}
		return local.rv;
	}

	public void function setProperties(struct properties="#StructNew()#") {
		$setProperties(argumentCollection=arguments);
	}

	public boolean function hasChanged(string property="") {
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
		local.iEnd = ArrayLen(arguments.property);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.key = arguments.property[local.i];
			if (StructKeyExists(this, local.key))
			{
				if (!StructKeyExists(variables.$persistedProperties, local.key))
				{
					return true;
				}
				else
				{
					// convert each datatype to a string for easier comparision
					local.type = validationTypeForProperty(local.key);
					local.a = $convertToString(this[local.key], local.type);
					local.b = $convertToString(variables.$persistedProperties[local.key], local.type);
					if (Compare(local.a, local.b) != 0)
					{
						return true;
					}
				}
			}
		}
		// if we get here, it means that all of the properties that were checked had a value in
		// $persistedProperties and it matched or some of the properties did not exist in the this scope
		return false;
	}

	public string function changedProperties() {
		local.rv = "";
		for (local.key in variables.wheels.class.properties)
		{
			if (hasChanged(local.key))
			{
				local.rv = ListAppend(local.rv, local.key);
			}
		}
		return local.rv;
	}

	public string function changedFrom(required string property) {
		local.rv = "";
		if (StructKeyExists(variables, "$persistedProperties") && StructKeyExists(variables.$persistedProperties, arguments.property))
		{
			local.rv = variables.$persistedProperties[arguments.property];
		}
		return local.rv;
	}

	public struct function allChanges() {
		local.rv = {};
		if (hasChanged())
		{
			local.changedProperties = changedProperties();
			local.iEnd = ListLen(local.changedProperties);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.item = ListGetAt(local.changedProperties, local.i);
				local.rv[local.item] = {};
				local.rv[local.item].changedFrom = changedFrom(local.item);
				if (StructKeyExists(this, local.item))
				{
					local.rv[local.item].changedTo = this[local.item];
				}
				else
				{
					local.rv[local.item].changedTo = "";
				}
			}
		}
		return local.rv;
	}

	public void function clearChangeInformation(string property) {
		$updatePersistedProperties(argumentCollection=arguments);
	}

	/*
	* PRIVATE METHODS
	*/

	public any function $setProperties(
		required struct properties,
		string filterList="",
		boolean setOnModel="true",
		boolean $useFilterLists="true"
	) {
		local.rv = {};
		arguments.filterList = ListAppend(arguments.filterList, "properties,filterList,setOnModel,$useFilterLists");

		// add eventual named arguments to properties struct (named arguments will take precedence)
		for (local.key in arguments)
		{
			if (!ListFindNoCase(arguments.filterList, local.key))
			{
				arguments.properties[local.key] = arguments[local.key];
			}
		}

		// loop through the properties and see if they can be set based off of the accessible properties lists
		for (local.key in arguments.properties)
		{
			if (StructKeyExists(arguments.properties, local.key)) // required to ignore null keys
			{
				local.accessible = true;
				if (arguments.$useFilterLists && StructKeyExists(variables.wheels.class.accessibleProperties, "whiteList") && !ListFindNoCase(variables.wheels.class.accessibleProperties.whiteList, local.key))
				{
					local.accessible = false;
				}
				if (arguments.$useFilterLists && StructKeyExists(variables.wheels.class.accessibleProperties, "blackList") && ListFindNoCase(variables.wheels.class.accessibleProperties.blackList, local.key))
				{
					local.accessible = false;
				}
				if (local.accessible)
				{
					local.rv[local.key] = arguments.properties[local.key];
				}
				if (local.accessible && arguments.setOnModel)
				{
					$setProperty(property=local.key, value=local.rv[local.key]);
				}
			}
		}

		if (arguments.setOnModel)
		{
			return;
		}
		return local.rv;
	}

	public void function $setProperty(
		required string property,
		required any value,
		struct associations="#variables.wheels.class.associations#"
	) {
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
	}

	public void function $updatePersistedProperties(string property) {
		variables.$persistedProperties = {};
		for (local.key in variables.wheels.class.properties)
		{
			if (StructKeyExists(this, local.key) && (!StructKeyExists(arguments, "property") || arguments.property == local.key))
			{
				variables.$persistedProperties[local.key] = this[local.key];
			}
		}
	}
	public any function $setDefaultValues(){
		// persisted properties
		for (local.key in variables.wheels.class.properties)
		{
			if (StructKeyExists(variables.wheels.class.properties[local.key], "defaultValue") && (!StructKeyExists(this, local.key) || !Len(this[local.key])))
			{
				// set the default value unless it is blank or a value already exists for that property on the object
				this[local.key] = variables.wheels.class.properties[local.key].defaultValue;
			}
		}
		// non-persisted properties
		for (local.key in variables.wheels.class.mapping)
		{
			if (StructKeyExists(variables.wheels.class.mapping[local.key], "defaultValue") && (!StructKeyExists(this, local.key) || !Len(this[local.key])))
			{
				// set the default value unless it is blank or a value already exists for that property on the object
				this[local.key] = variables.wheels.class.mapping[local.key].defaultValue;
			}
		}
	}

	public struct function $propertyInfo(required string property) {
		local.rv = {};
		if (StructKeyExists(variables.wheels.class.properties, arguments.property))
		{
			local.rv = variables.wheels.class.properties[arguments.property];
		}
		return local.rv;
	}

	public string function $label(required string property) {
		// Prefer label set via `properties` intializer if it exists.
		if (StructKeyExists(variables.wheels.class.properties, arguments.property) && StructKeyExists(variables.wheels.class.properties[arguments.property], "label")) {
			local.rv = variables.wheels.class.properties[arguments.property].label;
		// Check to see if the mapping has a label to base the name on.
		} else if (StructKeyExists(variables.wheels.class.mapping, arguments.property) && StructKeyExists(variables.wheels.class.mapping[arguments.property], "label")) {
			local.rv = variables.wheels.class.mapping[arguments.property].label;
		// Fall back on property name otherwise.
		} else {
			local.rv = humanize(arguments.property);
		}

		return local.rv;
	}
</cfscript>
