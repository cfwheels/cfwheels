<cfscript>

// Note: lots of naming collisions here with the move from loc-> local due to scope search in CF10 (quelle surprise).
// Have added underscores to all local variables to assure uniqueness for now, but really this needs revisiting.

/**
* Allows for nested objects, structs, and arrays to be set from params and other generated data.
*
* [section: Model Configuration]
* [category: Miscellaneous Functions]
*
* @association The association (or list of associations) you want to allow to be set through the params. This argument is also aliased as associations.
* @autoSave boolean false true Whether to save the association(s) when the parent object is saved.
* @allowDelete false Set allowDelete to true to tell CFWheels to look for the property _delete in your model. If present and set to a value that evaluates to true, the model will be deleted when saving the parent.
* @sortProperty Set sortProperty to a property on the object that you would like to sort by. The property should be numeric, should start with 1, and should be consecutive. Only valid with hasMany associations.
* @rejectIfBlank A list of properties that should not be blank. If any of the properties are blank, any CRUD operations will be rejected.
*/
public void function nestedProperties(
	string association="",
	boolean autoSave,
	boolean allowDelete,
	string sortProperty,
	string rejectIfBlank
) {
	$args(args=arguments, name="nestedProperties", combine="association/associations");
	arguments.association = $listClean(arguments.association);
	local._iEnd = ListLen(arguments.association);
	for (local._i=1; local._i <= local._iEnd; local._i++) {
		local._association = ListGetAt(arguments.association, local._i);
		if (StructKeyExists(variables.wheels.class.associations, local._association)) {
			variables.wheels.class.associations[local._association].nested.allow = true;
			variables.wheels.class.associations[local._association].nested.delete = arguments.allowDelete;
			variables.wheels.class.associations[local._association].nested.autoSave = arguments.autoSave;
			variables.wheels.class.associations[local._association].nested.sortProperty = arguments.sortProperty;
			variables.wheels.class.associations[local._association].nested.rejectIfBlank = $listClean(arguments.rejectIfBlank);

			// Add to the white list if it exists.
			if (StructKeyExists(variables.wheels.class.accessibleProperties, "whiteList")) {
				variables.wheels.class.accessibleProperties.whiteList = ListAppend(variables.wheels.class.accessibleProperties.whiteList, local._association, ",");
			}

		} else if (application.wheels.showErrorInformation) {
			Throw(
				type="Wheels.AssociationNotFound",
				message="The `#local._association#` assocation was not found on the #variables.wheels.class.modelName# model.",
				extendedInfo="Make sure you have called `hasMany()`, `hasOne()`, or `belongsTo()` before calling the `nestedProperties()` method."
			);
		}
	}
}

/**
* Internal Function
*/
public boolean function $validateAssociations(required boolean callbacks) {
	local._associations = variables.wheels.class.associations;
	for (local._association in local._associations) {
		if (local._associations[local._association].nested.allow && local._associations[local._association].nested.autoSave && StructKeyExists(this, local._association)) {
			local._array = this[local._association];
			if (IsObject(this[local._association])) {
				local._array = [this[local._association]];
			}
			if (IsArray(local._array)) {
				for (local._i=1; local._i <= ArrayLen(local._array); local._i++) {
					$invoke(componentReference=local._array[local._i], method="valid", invokeArgs=arguments);
				}
			}
		}
	}
	return true;
}

/**
* Internal Function
*/
public boolean function $saveAssociations(
	required any parameterize,
	required boolean reload,
	required boolean validate,
	required boolean callbacks
) {
	local._rv = true;
	local._associations = variables.wheels.class.associations;
	for (local._association in local._associations) {
		if (local._associations[local._association].nested.allow && local._associations[local._association].nested.autoSave && StructKeyExists(this, local._association)) {
			local._array = this[local._association];
			if (IsObject(this[local._association])) {
				local._array = [this[local._association]];
			}
			if (IsArray(local._array)) {

				// Get our expanded information for this association.
				local._info = $expandedAssociations(include=local._association);
				local._info = local._info[1];

				for (local._i=1; local._i <= ArrayLen(local._array); local._i++) {
					if (ListFindNoCase("hasMany,hasOne", local._associations[local._association].type)) {
						$setForeignKeyValues(missingMethodArguments=local._array[local._i], keys=local._info.foreignKey);
					}
					local._saveResult = $invoke(componentReference=local._array[local._i], method="save", invokeArgs=arguments);
					if (local._rv) {

						// Don't change the return value when we have already received a false.
						local._rv = local._saveResult;

					}
				}
			}
		}
	}

	// If the associations were not saved correctly, roll them back to their new state but keep the errors.
	if (!local._rv) {
		$resetAssociationsToNew();
	}

	return local._rv;
}

/**
* Internal Function
*/
public boolean function $setAssociations() {
	local._associations = variables.wheels.class.associations;
	for (local._item in local._associations) {
		local._association = local._associations[local._item];
		if (local._association.nested.allow && local._association.nested.autoSave && StructKeyExists(this, local._item)) {
			if (ListFindNoCase("belongsTo,hasOne", local._association.type) && IsStruct(this[local._item])) {
				$setOneToOneAssociationProperty(property=local._item, value=this[local._item], association=local._association, delete=true);
			} else if (local._association.type == "hasMany" && IsArray(this[local._item]) && ArrayLen(this[local._item])) {
				$setCollectionAssociationProperty(property=local._item, value=this[local._item], association=local._association, delete=true);
			}
		}
	}
	return true;
}

/**
* Internal Function
*/
public void function $setOneToOneAssociationProperty(
	required string property,
	required struct value,
	required struct association,
	boolean delete="false"
) {
	if (!StructKeyExists(this, arguments.property) || !IsObject(this[arguments.property]) || StructKeyExists(this[arguments.property], "_delete")) {
		this[arguments.property] = $getAssociationObject(argumentCollection=arguments);
	}
	if (IsObject(this[arguments.property])) {
		this[arguments.property].setProperties(properties=arguments.value);
	} else {
		StructDelete(this, arguments.property);
	}
}

/**
* Internal Function
*/
public void function $setCollectionAssociationProperty(
	required string property,
	required any value,
	required struct association,
	boolean delete=false
) {
	local._model = model(arguments.association.modelName);
	if (!StructKeyExists(this, arguments.property) || !IsArray(this[arguments.property])) {
		this[arguments.property] = [];
	}
	if (IsStruct(arguments.value)) {
		for (local._item in arguments.value) {
			// check to see if the id is a tickcount, if so the object is new
			if (IsNumeric(local._item) && Ceiling(Right(GetTickCount(), 12) / 900000000) == Ceiling(local._item / 900000000)) {
				ArrayAppend(this[arguments.property], $getAssociationObject(property=arguments.property, value=arguments.value[local._item], association=arguments.association, delete=arguments.delete));
				$updateCollectionObject(property=arguments.property, value=arguments.value[local._item]);
			} else {
				// get our primary keys
				local._keys = local._model.primaryKey();
				local._itemArray = ListToArray(local._item, ",", true);
				local._iEnd = ListLen(local._keys);
				for (local._i=1; local._i <= local._iEnd; local._i++) {
					arguments.value[local._item][ListGetAt(local._keys, local._i)] = local._itemArray[local._i];
				}
				ArrayAppend(this[arguments.property], $getAssociationObject(property=arguments.property, value=arguments.value[local._item], association=arguments.association, delete=arguments.delete));
				$updateCollectionObject(property=arguments.property, value=arguments.value[local._item]);
			}
		}
	} else if (IsArray(arguments.value)) {
		for (local._i=1; local._i <= ArrayLen(arguments.value); local._i++) {
			if (IsObject(arguments.value[local._i]) && ArrayLen(this[arguments.property]) >= local._i && IsObject(this[arguments.property][local._i]) && this[arguments.property][local._i].compareTo(arguments.value[local._i])) {
				this[arguments.property][local._i] = $getAssociationObject(property=arguments.property, value=arguments.value[local._i], association=arguments.association, delete=arguments.delete);
				if (!IsStruct(this[arguments.property][local._i]) && !this[arguments.property][local._i]) {
					ArrayDeleteAt(this[arguments.property], local._i);
					local._i--;
				} else {
					$updateCollectionObject(property=arguments.property, value=arguments.value[local._i], position=local._i);
				}
			} else if (IsStruct(arguments.value[local._i]) && ArrayLen(this[arguments.property]) >= local._i && IsObject(this[arguments.property][local._i])) {
				this[arguments.property][local._i] = $getAssociationObject(property=arguments.property, value=arguments.value[local._i], association=arguments.association, delete=arguments.delete);
				if (!IsStruct(this[arguments.property][local._i]) && !this[arguments.property][local._i]) {
					ArrayDeleteAt(this[arguments.property], local._i);
					local._i--;
				} else {
					$updateCollectionObject(property=arguments.property, value=arguments.value[local._i], position=local._i);
				}
			} else {
				ArrayAppend(this[arguments.property], $getAssociationObject(property=arguments.property, value=arguments.value[local._i], association=arguments.association, delete=arguments.delete));
				$updateCollectionObject(property=arguments.property, value=arguments.value[local._i]);
			}
		}
	}
	// sort the order of the objects in the array if the property is set
	if (Len(arguments.association.nested.sortProperty)) {
		local._sortedArray = [];
		local._iEnd = ArrayLen(this[arguments.property]);
		for (local._i=1; local._i <= local._iEnd; local._i++) {
			if (!IsNumeric(this[arguments.property][local._i][arguments.association.nested.sortProperty])) {
				return;
			}
			local._sortedArray[this[arguments.property][local._i][arguments.association.nested.sortProperty]] = this[arguments.property][local._i];
		}
		this[arguments.property] = local._sortedArray;
	}
}

/**
* Internal Function
*/
public void function $updateCollectionObject(required string property, required struct value, numeric position=0) {
	if (!arguments.position) {
		arguments.position = ArrayLen(this[arguments.property]);
	}
	if (IsObject(this[arguments.property][arguments.position])) {
		this[arguments.property][arguments.position].setProperties(properties=arguments.value);
	} else {
		ArrayDeleteAt(this[arguments.property], arguments.position);
	}
}

/**
 * Internal function.
 */
public any function $getAssociationObject(
	required string property,
	required struct value,
	required struct association,
	required boolean delete
) {
	local.method = "";
	local.object = false;
	local.delete = false;
	local.args = {};
	local.model = model(arguments.association.modelName);

	// Check to see if the struct has all of the keys we need from rejectIfBlank.
	if ($structKeysExist(struct=arguments.value, properties=arguments.association.nested.rejectIfBlank)) {

		// Get our primary keys, if they don't exist, then we create a new object.
		local.args.key = $createPrimaryKeyList(params=arguments.value, keys=local.model.primaryKey());
		if (IsObject(arguments.value)) {
			local.object = arguments.value;
		} else if (Len(local.args.key)) {
			local.object = local.model.findByKey(argumentCollection=local.args);
		}

		if (StructKeyExists(arguments.value, "_delete") && IsBoolean(arguments.value["_delete"]) && arguments.value["_delete"]) {
			local.delete = true;
		}
		if (!IsObject(local.object) && !local.delete) {
			StructDelete(local.args, "key");
			return $invoke(componentReference=local.model, method="new", invokeArgs=local.args);
		} else if (Len(local.args.key) && local.delete && arguments.association.nested.delete && arguments.delete) {
			$invoke(componentReference=local.model, method="deleteByKey", invokeArgs=local.args);
			return false;
		}
	}
	return local.object;
}

/**
 * Internal function.
 */
public string function $createPrimaryKeyList(required struct params, required string keys) {
	local.rv = "";
	local.iEnd = ListLen(arguments.keys);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.key = ListGetAt(arguments.keys, local.i);
		if (!StructKeyExists(arguments.params, local.key) || !Len(arguments.params[local.key])) {
			return "";
		}
		local.rv = ListAppend(local.rv, arguments.params[local.key]);
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $resetToNew() {
	if ($persistedOnInitialization()) {
		return;
	}

	// Remove the persisted properties container.
	StructDelete(variables, "$persistedProperties");

	// Remove any primary keys set by the save.
	local.keys = primaryKeys();
	local.iEnd = ListLen(local.keys);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(local.keys, local.i);
		StructDelete(this, local.item);
	}

}

/**
 * Internal function.
 */
public void function $resetAssociationsToNew() {
	local.associations = variables.wheels.class.associations;
	for (local.association in local.associations) {
		local.nested = local.associations[local.association].nested;
		if (local.nested.allow && local.nested.autoSave && StructKeyExists(this, local.association)) {
			local.array = this[local.association];
			if (IsObject(this[local.association])) {
				local.array = [this[local.association]];
			}
			if (IsArray(local.array)) {
				local.iEnd = ArrayLen(local.array);
				for (local.i = 1; local.i <= local.iEnd; local.i++) {
					local.array[local.i].$resetToNew();
				}
			}
		}
	}
}

/**
 * Internal function.
 */
public boolean function $persistedOnInitialization() {
	if (StructKeyExists(variables.wheels.instance, "persistedOnInitialization") && variables.wheels.instance.persistedOnInitialization) {
		return true;
	} else {
		return false;
	}
}

</cfscript>
