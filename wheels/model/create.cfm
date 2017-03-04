<cfscript>

/**
 * Creates a new object, saves it to the database (if the validation permits it), and returns it.
 * If the validation fails, the unsaved object (with errors added to it) is still returned.
 * Property names and values can be passed in either using named arguments or as a struct to the `properties` argument.
 *
 * ```
 * // Create a new author and save it to the database.
 * newAuthor = model("author").create(params.author);
 *
 * // Same as above using named arguments.
 * newAuthor = model("author").create(firstName="John", lastName="Doe");
 *
 * // Same as above using both named arguments and a struct.
 * newAuthor = model("author").create(active=1, properties=params.author);
 *
 * // If you have a `hasOne` or `hasMany` association setup from `customer` to `order` you can do a scoped call (the `createOrder` method below will call `model("order").create(customerId=aCustomer.id, shipping=params.shipping)` internally).
 * aCustomer = model("customer").findByKey(params.customerId);
 * anOrder = aCustomer.createOrder(shipping=params.shipping);
 * ```
 *
 * @doc.section Model Class
 * @doc.category Create Functions
 *
 * @properties See documentation for `new`.
 * @parameterize See documentation for `findAll`.
 * @reload See documentation for `save`.
 * @validate See documentation for `save`.
 * @transaction See documentation for `save`.
 * @callbacks See documentation for `save`.
 *
 */
public any function create(
	struct properties={},
	any parameterize,
	boolean reload,
	boolean validate=true,
	string transaction=get("transactionMode"),
	boolean callbacks=true
) {
	$args(name="create", args=arguments);
	local.parameterize = arguments.parameterize;
	StructDelete(arguments, "parameterize");
	local.validate = arguments.validate;
	StructDelete(arguments, "validate");
	local.rv = new(argumentCollection=arguments);
	local.rv.save(
		callbacks=arguments.callbacks,
		parameterize=local.parameterize,
		reload=arguments.reload,
		transaction=arguments.transaction,
		validate=local.validate
	);
	return local.rv;
}

/**
 * Creates a new object based on supplied properties and returns it.
 * The object is not saved to the database, it only exists in memory.
 * Property names and values can be passed in either using named arguments or as a struct to the `properties` argument.
 *
 * ```
 * Create a new author in memory (not saved to the database).
 * newAuthor = model("author").new();
 *
 * Create a new author based on properties in a struct.
 * newAuthor = model("author").new(params.authorStruct);
 *
 * Create a new author by passing in named arguments.
 * newAuthor = model("author").new(firstName="John", lastName="Doe");
 *
 * If you have a `hasOne` or `hasMany` association setup from `customer` to `order` you can do a scoped call (the `newOrder` method below will call `model("order").new(customerId=aCustomer.id)` internally).
 * aCustomer = model("customer").findByKey(params.customerId);
 * anOrder = aCustomer.newOrder(shipping=params.shipping);
 * ```
 *
 * @doc.section Model Class
 * @doc.category Create Functions
 *
 * @properties The properties you want to set on the object (can also be passed in as named arguments).
 * @callbacks See documentation for `save`.
 *
 */
public any function new(struct properties={}, boolean callbacks=true) {
	arguments.properties = $setProperties(
		argumentCollection=arguments,
		filterList="properties,reload,transaction,callbacks",
		setOnModel=false
	);
	local.rv = $createInstance(callbacks=arguments.callbacks, persisted=false, properties=arguments.properties);
	local.rv.$setDefaultValues();
	return local.rv;
}

/**
 * Saves the object if it passes validation and callbacks.
 * Returns `true` if the object was saved successfully to the database, `false` if not.
 *
 * ```
 * Save the user object to the database (will automatically do an `INSERT` or `UPDATE` statement depending on if the record is new or already exists.
 * user.save();
 *
 * Save the user object directly in an if statement without using `cfqueryparam` and take appropriate action based on the result.
 * if (user.save(parameterize=false)) {
 *   flashInsert(notice="The user was saved!");
 *   redirectTo(action="edit");
 * } else {
 *   flashInsert(alert="Error, please correct!");
 *   renderPage(action="edit");
 * }
 * ```
 *
 * @doc.section Model Object
 * @doc.category CRUD Functions
 *
 * @parameterize See documentation for `findAll`.
 * @reload Set to `true` to reload the object from the database once an insert / update has completed.
 * @validate Set to `false` to skip validations for this operation.
 * @transaction Set this to `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.
 * @callbacks Set to `false` to disable callbacks for this operation.
 *
 */
public boolean function save(
	any parameterize,
	boolean reload,
	boolean validate=true,
	string transaction=get("transactionMode"),
	boolean callbacks=true
) {
	$args(name="save", args=arguments);
	clearErrors();
	return invokeWithTransaction(method="$save", argumentCollection=arguments);
}

/**
 * Internal function
 */
public any function $createInstance(
	required struct properties,
	required boolean persisted,
	numeric row=1,
	boolean base=true,
	boolean callbacks=true
) {
	local.fileName = $objectFileName(
		name=variables.wheels.class.modelName,
		objectPath=variables.wheels.class.path,
		type="model"
	);
	local.rv = $createObjectFromRoot(
		base=arguments.base,
		fileName=local.fileName,
		path=variables.wheels.class.path,
		method="$initModelObject",
		name=variables.wheels.class.modelName,
		persisted=arguments.persisted,
		properties=arguments.properties,
		row=arguments.row,
		useFilterLists=(!arguments.persisted)
	);

	// If the object should be persisted, call afterFind, else call afterNew.
	if ((arguments.persisted && local.rv.$callback("afterFind", arguments.callbacks)) || (!arguments.persisted && local.rv.$callback("afterNew", arguments.callbacks))) {
		local.rv.$callback("afterInitialization", arguments.callbacks);
	}

	return local.rv;
}

/**
 * Internal function
 */
public boolean function $save(
	required any parameterize,
	required boolean reload,
	required boolean validate,
	required boolean callbacks
) {
	local.rv = false;

	// Make sure all of our associations are set properly before saving.
	$setAssociations();

	if ($callback("beforeValidation", arguments.callbacks)) {
		if (isNew()) {
			if ($callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave,onCreate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeCreate", arguments.callbacks)) {
				local.rollback = false;
				if (!Len(key())) {
					local.rollback = true;
				}
				$create(parameterize=arguments.parameterize, reload=arguments.reload);
				if ($saveAssociations(argumentCollection=arguments) && $callback("afterCreate", arguments.callbacks) && $callback("afterSave", arguments.callbacks)) {
					$updatePersistedProperties();
					local.rv = true;
				} else if (local.rollback) {
					$resetToNew();
				}
			} else {
				$validateAssociations(callbacks=arguments.callbacks);
			}
		} else {
			if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave,onUpdate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeUpdate", arguments.callbacks)) {
				$update(parameterize=arguments.parameterize, reload=arguments.reload);
				if ($saveAssociations(argumentCollection=arguments) && $callback("afterUpdate", arguments.callbacks) && $callback("afterSave", arguments.callbacks)) {
					$updatePersistedProperties();
					local.rv = true;
				}
			} else {
				$validateAssociations(callbacks=arguments.callbacks);
			}
		}
	} else {
		$validateAssociations(callbacks=arguments.callbacks);
	}
	return local.rv;
}

/**
 * Internal function
 */
public boolean function $create(required any parameterize, required boolean reload) {
	if (variables.wheels.class.timeStampingOnCreate) {
		$timestampProperty(property=variables.wheels.class.timeStampOnCreateProperty);
	}
	if (get("setUpdatedAtOnCreate") && variables.wheels.class.timeStampingOnUpdate) {
		$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
	}

	// Start by adding column names and values for the properties that exist on the object to two arrays.
	local.sql = [];
	local.sql2 = [];
	for (local.key in variables.wheels.class.properties) {

		// Only include this property if it has a value, or the column is not nullable and has no default set.
		if (StructKeyExists(this, local.key) && (Len(this[local.key]) || (!variables.wheels.class.properties[local.key].nullable && !Len(variables.wheels.class.properties[local.key].columndefault)))) {
			ArrayAppend(local.sql, variables.wheels.class.properties[local.key].column);
			ArrayAppend(local.sql, ",");
			ArrayAppend(local.sql2, $buildQueryParamValues(local.key));
			ArrayAppend(local.sql2, ",");
		}

	}

	if (ArrayLen(local.sql)) {

		// Create wrapping SQL code and merge the second array that holds the values with the first one.
		ArrayPrepend(local.sql, "INSERT INTO #tableName()# (");
		ArrayPrepend(local.sql2, " VALUES (");
		ArrayDeleteAt(local.sql, ArrayLen(local.sql));
		ArrayDeleteAt(local.sql2, ArrayLen(local.sql2));
		ArrayAppend(local.sql, ")");
		ArrayAppend(local.sql2, ")");
		local.iEnd = ArrayLen(local.sql);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			ArrayAppend(local.sql, local.sql2[local.i]);
		}

		// Map the primary keys down to the SQL columns.
		local.pks = ListToArray(primaryKeys());
		local.iEnd = ArrayLen(local.pks);
		for(local.i = 1; local.i <= local.iEnd; local.i++) {
			local.pks[local.i] = variables.wheels.class.properties[local.pks[local.i]].column;
		}
		local.pks = ArrayToList(local.pks);

	} else {

		// No properties were set on the object so we insert a record with only default values to the database.
		local.pks = primaryKey(0);
		ArrayAppend(local.sql, "INSERT INTO #tableName()#" & variables.wheels.class.adapter.$defaultValues($primaryKey=local.pks));

	}

	// Run the insert sql statement and set the primary key value on the object (if one was returned from the database).
	local.ins = variables.wheels.class.adapter.$querySetup(
		parameterize=arguments.parameterize,
		sql=local.sql,
		$primaryKey=local.pks
	);
	local.generatedKey = variables.wheels.class.adapter.$generatedKey();
	if (StructKeyExists(local.ins.result, local.generatedKey)) {
		this[primaryKeys(1)] = local.ins.result[local.generatedKey];
	}

	if (arguments.reload) {
		this.reload();
	}
	return true;
}

</cfscript>
