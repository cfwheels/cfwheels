<!--- class methods --->
<cffunction name="nestedProperties" output="false" access="public" returntype="void" hint="I allow nested objects and arrays to be set from params.">
	<cfargument name="association" type="string" required="false" default="" hint="The association (or list of associations) you want to allow to be set through the params. This argument is also aliased as `associations`" />
	<cfargument name="autoSave" type="boolean" required="false" hint="Whether to save the association(s) when the parent object is saved." />
	<cfargument name="allowDelete" type="boolean" required="false" hint="Set `allowDelete` to true to tell wheels to look for the property _delete in your model that will be evaluated to see if the model should be deleted." />
	<cfargument name="sortProperty" type="string" required="false" hint="Set `sortProperty` to a property on the object that you would like to sort by. The property should be numeric and should start with 1 and should be consecutive. Only valid with hasMany associations." />
	<cfargument name="rejectIfBlank" type="string" required="false" hint="A list of properties that should not be blank, if anyone of the properties are blank, the submission will be rejected." />
	<cfscript>
		var loc = {};
		$args(args=arguments, name="nestedProperties", combine="association/associations");
		arguments.association = $listClean(arguments.association);
		loc.iEnd = ListLen(arguments.association);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.association = ListGetAt(arguments.association, loc.i);
			if (StructKeyExists(variables.wheels.class.associations, loc.association))
			{
				variables.wheels.class.associations[loc.association].nested.allow = true;
				variables.wheels.class.associations[loc.association].nested.delete = arguments.allowDelete;
				variables.wheels.class.associations[loc.association].nested.autoSave = arguments.autoSave;
				variables.wheels.class.associations[loc.association].nested.sortProperty = arguments.sortProperty;
				variables.wheels.class.associations[loc.association].nested.rejectIfBlank = $listClean(arguments.rejectIfBlank);
				// add to the white list if it exists
				if (StructKeyExists(variables.wheels.class.accessibleProperties, "whiteList"))
					variables.wheels.class.accessibleProperties.whiteList = ListAppend(variables.wheels.class.accessibleProperties.whiteList, loc.association, ",");
			}
			else if (application.wheels.showErrorInformation)
			{
				$throw(type="Wheels.AssociationNotFound", message="The `#loc.association#` assocation was not found on the #variables.wheels.class.modelName# model.", extendedInfo="Make sure you have called `hasMany()`, `hasOne()`, or `belongsTo()` before calling the `nestedProperties()` method.");
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validateAssociations" returntype="boolean" access="public" output="false">
	<cfset $traverseAssociations(method="valid") />
	<cfreturn true />
</cffunction>

<cffunction name="$saveAssociations" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true" />
	<cfargument name="reload" type="boolean" required="true" />
	<cfargument name="validate" type="boolean" required="true" />
	<cfargument name="callbacks" type="boolean" required="true" />
	<cfreturn $traverseAssociations(method="save", argumentCollection=arguments) />
</cffunction>

<cffunction name="$traverseAssociations" returntype="boolean" access="public" output="false">
	<cfargument name="method" type="string" required="true" />
	<cfscript>
		var loc = {};
		loc.returnValue = true;
		loc.associations = variables.wheels.class.associations;
		for (loc.association in loc.associations)
		{
			if (loc.associations[loc.association].nested.allow && loc.associations[loc.association].nested.autoSave && StructKeyExists(this, loc.association))
			{
				loc.array = this[loc.association];
				
				if (IsObject(this[loc.association]))
					loc.array = [ this[loc.association] ];
			
				if (IsArray(loc.array))
				{
					// get our expanded information for this association
					if (arguments.method == "save")
					{
						loc.info = $expandedAssociations(include=loc.association);
						loc.info = loc.info[1];
					}
					
					loc.iEnd = ArrayLen(loc.array);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					{
						if (arguments.method == "save")
							if (ListFindNoCase("hasMany,hasOne", loc.associations[loc.association].type))
								$setForeignKeyValues(missingMethodArguments=loc.array[loc.i], keys=loc.info.foreignKey);
						loc.saveResult = $invoke(componentReference=loc.array[loc.i], argumentCollection=arguments);
						if (loc.returnValue) // don't change the return value if we have already received a false
							loc.returnValue = loc.saveResult;
					}
				}
			}
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="$setOneToOneAssociationProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="value" type="struct" required="true" />
	<cfargument name="association" type="struct" required="true" />
	<cfscript>
		this[arguments.property] = $getAssociationObject(argumentCollection=arguments);
	
		if (IsObject(this[arguments.property]))
			this[arguments.property].setProperties(properties=arguments.value);
		else
			StructDelete(this, arguments.property, false);
	</cfscript>
	<cfreturn />
</cffunction>

<cffunction name="$setCollectionAssociationProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="value" type="any" required="true" />
	<cfargument name="association" type="struct" required="true" />
	<cfscript>
		var loc = {};
		loc.model = model(arguments.association.modelName);

		this[arguments.property] = [];
		if (IsStruct(arguments.value))
		{
			for (loc.item in arguments.value)
			{
				if (loc.item == "new")
				{
					loc.keyList = ListSort(StructKeyList(arguments.value[loc.item]), "numeric", "asc");
					loc.iEnd = ListLen(loc.keyList);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					{
						loc.item2 = ListGetAt(loc.keyList, loc.i);
						ArrayAppend(this[arguments.property], $getAssociationObject(property=arguments.property, value=arguments.value[loc.item][loc.item2], association=arguments.association));
						$updateCollectionObject(property=arguments.property, value=arguments.value[loc.item][loc.item2]);
					}
				}
				else
				{
					// get our primary keys
					loc.keys = loc.model.primaryKey();
					loc.itemArray = ListToArray(loc.item, ",", true);
					loc.iEnd = ListLen(loc.keys);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
						arguments.value[loc.item][ListGetAt(loc.keys, loc.i)] = loc.itemArray[loc.i];
					ArrayAppend(this[arguments.property], $getAssociationObject(property=arguments.property, value=arguments.value[loc.item], association=arguments.association));	
					$updateCollectionObject(property=arguments.property, value=arguments.value[loc.item]);
				}
			}
		}
		else if (IsArray(arguments.value)) // we also accept arrays even though it is not how wheels normally works, this is for more advanced form that must use oridinal positioning
		{
			loc.iEnd = ArrayLen(arguments.value);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				ArrayAppend(this[arguments.property], $getAssociationObject(property=arguments.property, value=arguments.value[loc.i], association=arguments.association));
				$updateCollectionObject(property=arguments.property, value=arguments.value[loc.i]);
			}
		}
		// sort the order of the objects in the array if the property is set
		if (Len(arguments.association.nested.sortProperty))
		{
			loc.sortedArray = [];
			loc.iEnd = ArrayLen(this[arguments.property]);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				if (!IsNumeric(this[arguments.property][loc.i][arguments.association.nested.sortProperty]))
					return;
				loc.sortedArray[this[arguments.property][loc.i][arguments.association.nested.sortProperty]] = this[arguments.property][loc.i];
			}
			
			this[arguments.property] = loc.sortedArray;
		}
	</cfscript>
	<cfreturn />
</cffunction>

<cffunction name="$updateCollectionObject" returntype="void" output="false" access="public">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="value" type="struct" required="true" />
	<cfscript>
		var loc = {};
		loc.position = ArrayLen(this[arguments.property]);
		if (IsObject(this[arguments.property][loc.position]))
			this[arguments.property][loc.position].setProperties(properties=arguments.value);
		else
			ArrayDeleteAt(this[arguments.property], loc.position);
	</cfscript>
</cffunction>

<cffunction name="$getAssociationObject" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="value" type="struct" required="true" />
	<cfargument name="association" type="struct" required="true" />
	<cfscript>
		var loc = {};
		loc.method = "";
		loc.object = false;
		loc.delete = false;
		loc.arguments = {};
		loc.model = model(arguments.association.modelName);
		
		// check to see if the struct has all of the keys we need from rejectIfBlank
		if ($structKeysExist(struct=arguments.value, properties=arguments.association.nested.rejectIfBlank))
		{
			// get our primary keys, if they don't exist, then we create a new object
			loc.arguments.key = $createPrimaryKeyList(params=arguments.value, keys=loc.model.primaryKey());

			if (Len(loc.arguments.key))
				loc.object = loc.model.findByKey(argumentCollection=loc.arguments);
		
			if (StructKeyExists(arguments.value, "_delete") && IsBoolean(arguments.value["_delete"]) && arguments.value["_delete"])
				loc.delete = true;
			
			if (!IsObject(loc.object) && !loc.delete)
			{
				loc.method = "new";
				StructDelete(loc.arguments, "key", false);
			}
			else if (Len(loc.arguments.key) && loc.delete && arguments.association.nested.delete)
			{
				loc.method = "deleteByKey";
			}
			
			if (Len(loc.method))
				loc.object = $invoke(componentReference=loc.model, method=loc.method, argumentCollection=loc.arguments);
		}	
	</cfscript>
	<cfreturn loc.object />
</cffunction>

<cffunction name="$createPrimaryKeyList" returntype="string" access="public" output="false">
	<cfargument name="params" type="struct" required="true" />
	<cfargument name="keys" type="string" required="true" />
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.key = ListGetAt(arguments.keys, loc.i);
			if (!StructKeyExists(arguments.params, loc.key) || !Len(arguments.params[loc.key]))
				return "";
			loc.returnValue = ListAppend(loc.returnValue, arguments.params[loc.key]);	
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>



