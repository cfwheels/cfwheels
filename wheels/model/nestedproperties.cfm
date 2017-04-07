<cfscript>

/**
 * Allows for nested objects, structs, and arrays to be set from params and other generated data.
 *
 * [section: Model Configuration]
 * [category: Miscellaneous Functions]
 *
 * @association The association (or list of associations) you want to allow to be set through the params. This argument is also aliased as `associations`.
 * @autoSave Whether to save the association(s) when the parent object is saved.
 * @allowDelete Set this to `true` to tell CFWheels to look for the property `_delete` in your model. If present and set to a value that evaluates to true, the model will be deleted when saving the parent.
 * @sortProperty Set this to a property on the object that you would like to sort by. The property should be numeric, should start with 1, and should be consecutive. Only valid with `hasMany` associations.
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
	local.iEnd = ListLen(arguments.association);
	for (local.i=1; local.i <= local.iEnd; local.i++) {
		local.association = ListGetAt(arguments.association, local.i);
		if (StructKeyExists(variables.wheels.class.associations, local.association)) {
			variables.wheels.class.associations[local.association].nested.allow = true;
			variables.wheels.class.associations[local.association].nested.delete = arguments.allowDelete;
			variables.wheels.class.associations[local.association].nested.autoSave = arguments.autoSave;
			variables.wheels.class.associations[local.association].nested.sortProperty = arguments.sortProperty;
			variables.wheels.class.associations[local.association].nested.rejectIfBlank = $listClean(arguments.rejectIfBlank);

			// Add to the white list if it exists.
			if (StructKeyExists(variables.wheels.class.accessibleProperties, "whiteList")) {
				variables.wheels.class.accessibleProperties.whiteList = ListAppend(variables.wheels.class.accessibleProperties.whiteList, local.association, ",");
			}

		} else if (application.wheels.showErrorInformation) {
			Throw(
				type="Wheels.AssociationNotFound",
				message="The `#local.association#` assocation was not found on the `#variables.wheels.class.modelName#` model.",
				extendedInfo="Make sure you have called `hasMany()`, `hasOne()`, or `belongsTo()` before calling the `nestedProperties()` method."
			);
		}
	}
}

/**
 * Internal function.
 */
public boolean function $validateAssociations(required boolean callbacks) {
	local.associations = variables.wheels.class.associations;
	for (local.association in local.associations) {
		if (local.associations[local.association].nested.allow && local.associations[local.association].nested.autoSave && StructKeyExists(this, local.association)) {
			local.array = this[local.association];
			if (IsObject(this[local.association])) {
				local.array = [this[local.association]];
			}
			if (IsArray(local.array)) {
				for (local.i = 1; local.i <= ArrayLen(local.array); local.i++) {
					$invoke(componentReference=local.array[local.i], method="valid", invokeArgs=arguments);
				}
			}
		}
	}
	return true;
}

/**
 * Internal function.
 */
public boolean function $saveAssociations(
	required any parameterize,
	required boolean reload,
	required boolean validate,
	required boolean callbacks
) {
	local.rv = true;
	local.associations = variables.wheels.class.associations;
	for (local.association in local.associations) {
		if (local.associations[local.association].nested.allow && local.associations[local.association].nested.autoSave && StructKeyExists(this, local.association)) {
			local.array = this[local.association];
			if (IsObject(this[local.association])) {
				local.array = [this[local.association]];
			}
			if (IsArray(local.array)) {

				// Get our expanded information for this association.
				local.info = $expandedAssociations(include=local.association);
				local.info = local.info[1];

				loc.iEnd = ArrayLen(local.array);
				for (local.i=1; local.i <= loc.iEnd; local.i++) {
					if (ListFindNoCase("hasMany,hasOne", local.associations[local.association].type)) {
						$setForeignKeyValues(missingMethodArguments=local.array[local.i], keys=local.info.foreignKey);
					}
					local.saveResult = $invoke(componentReference=local.array[local.i], method="save", invokeArgs=arguments);
					if (local.rv) {

						// Don't change the return value when we have already received a false.
						local.rv = local.saveResult;

					}
				}
			}
		}
	}

	// If the associations were not saved correctly, roll them back to their new state but keep the errors.
	if (!local.rv) {
		$resetAssociationsToNew();
	}

	return local.rv;
}

/**
 * Internal function.
 */
public boolean function $setAssociations() {
	local.associations = variables.wheels.class.associations;
	for (local.item in local.associations) {
		local.association = local.associations[local.item];
		if (local.association.nested.allow && local.association.nested.autoSave && StructKeyExists(this, local.item)) {
			if (ListFindNoCase("belongsTo,hasOne", local.association.type) && IsStruct(this[local.item])) {
				$setOneToOneAssociationProperty(property=local.item, value=this[local.item], association=local.association, delete=true);
			} else if (local.association.type == "hasMany" && IsArray(this[local.item]) && ArrayLen(this[local.item])) {
				$setCollectionAssociationProperty(property=local.item, value=this[local.item], association=local.association, delete=true);
			}
		}
	}
	return true;
}

/**
 * Internal function.
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
 * Internal function.
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
* Internal Function
*/
public any function $getAssociationObject(
	required string property,
	required struct value,
	required struct association,
	required boolean delete
) {
	local._method = "";
	local._object = false;
	local._delete = false;
	local._arguments = {};
	local._model = model(arguments.association.modelName);

	// check to see if the struct has all of the keys we need from rejectIfBlank
	if ($structKeysExist(struct=arguments.value, properties=arguments.association.nested.rejectIfBlank)) {
		// get our primary keys, if they don't exist, then we create a new object
		local._arguments.key = $createPrimaryKeyList(params=arguments.value, keys=local._model.primaryKey());

		if (IsObject(arguments.value)) {
			local._object = arguments.value;
		} else if (Len(local._arguments.key)) {
			local._object = local._model.findByKey(argumentCollection=local._arguments);
		}
		if (StructKeyExists(arguments.value, "_delete") && IsBoolean(arguments.value["_delete"]) && arguments.value["_delete"]) {
			local._delete = true;
		}
		if (!IsObject(local._object) && !local._delete) {
			StructDelete(local._arguments, "key");
			return $invoke(componentReference=local._model, method="new", invokeArgs=local._arguments);
		} else if (Len(local._arguments.key) && local._delete && arguments.association.nested.delete && arguments.delete) {
			$invoke(componentReference=local._model, method="deleteByKey", invokeArgs=local._arguments);
			return false;
		}
	}
	return local._object;
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
	if (StructKeyExists(variables.wheels.instance, "persistedOnInitialization") && variables.wheels.instance.persistedOnInitialization){
		return true;
	} else {
		return false;
	}
}

</cfscript>
