<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="create" returntype="any" access="public" output="false" hint="Creates a new object, saves it to the database (if the validation permits it), and returns it. If the validation fails, the unsaved object (with errors added to it) is still returned. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument."
	examples=
	'
		<!--- Create a new author and save it to the database --->
		<cfset newAuthor = model("author").create(params.author)>

		<!--- Same as above using named arguments --->
		<cfset newAuthor = model("author").create(firstName="John", lastName="Doe")>

		<!--- Same as above using both named arguments and a struct --->
		<cfset newAuthor = model("author").create(active=1, properties=params.author)>

		<!--- If you have a `hasOne` or `hasMany` association setup from `customer` to `order`, you can do a scoped call. (The `createOrder` method below will call `model("order").create(customerId=aCustomer.id, shipping=params.shipping)` internally.) --->
		<cfset aCustomer = model("customer").findByKey(params.customerId)>
		<cfset anOrder = aCustomer.createOrder(shipping=params.shipping)>
	'
	categories="model-class,create" chapters="creating-records,associations" functions="hasOne,hasMany,new">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @save.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		$args(name="create", args=arguments);
		loc.parameterize = arguments.parameterize;
		StructDelete(arguments, "parameterize");
		loc.rv = new(argumentCollection=arguments);
		loc.rv.save(parameterize=loc.parameterize, reload=arguments.reload, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="new" returntype="any" access="public" output="false" hint="Creates a new object based on supplied properties and returns it. The object is not saved to the database; it only exists in memory. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument."
	examples=
	'
		<!--- Create a new author in memory (not saved to the database) --->
		<cfset newAuthor = model("author").new()>

		<!--- Create a new author based on properties in a struct --->
		<cfset newAuthor = model("author").new(params.authorStruct)>

		<!--- Create a new author by passing in named arguments --->
		<cfset newAuthor = model("author").new(firstName="John", lastName="Doe")>

		<!--- If you have a `hasOne` or `hasMany` association setup from `customer` to `order`, you can do a scoped call. (The `newOrder` method below will call `model("order").new(customerId=aCustomer.id)` internally.) --->
		<cfset aCustomer = model("customer").findByKey(params.customerId)>
		<cfset anOrder = aCustomer.newOrder(shipping=params.shipping)>
	'
	categories="model-class,create" chapters="creating-records,associations" functions="create,hasMany,hasOne">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="The properties you want to set on the object (can also be passed in as named arguments).">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="properties,reload,transaction,callbacks", setOnModel=false);
		loc.rv = $createInstance(properties=arguments.properties, persisted=false, callbacks=arguments.callbacks);
		loc.rv.$setDefaultValues();
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="save" returntype="boolean" access="public" output="false" hint="Saves the object if it passes validation and callbacks. Returns `true` if the object was saved successfully to the database, `false` if not."
	examples=
	'
		<!--- Save the user object to the database (will automatically do an `INSERT` or `UPDATE` statement depending on if the record is new or already exists --->
		<cfset user.save()>

		<!--- Save the user object directly in an if statement without using `cfqueryparam` and take appropriate action based on the result --->
		<cfif user.save(parameterize=false)>
			<cfset flashInsert(notice="The user was saved!")>
			<cfset redirectTo(action="edit")>
		<cfelse>
			<cfset flashInsert(alert="Error, please correct!")>
			<cfset renderPage(action="edit")>
		</cfif>
	'
	categories="model-object,crud" chapters="creating-records" functions="">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="Set to `true` to reload the object from the database once an insert/update has completed.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="Set to `false` to skip validations for this operation.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="Set this to `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="Set to `false` to disable callbacks for this operation.">
	<cfscript>
		var loc = {};
		$args(name="save", args=arguments);
		clearErrors();
		loc.rv = invokeWithTransaction(method="$save", argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE MODEL CLASS METHODS --->

<cffunction name="$createInstance" returntype="any" access="public" output="false">
	<cfargument name="properties" type="struct" required="true">
	<cfargument name="persisted" type="boolean" required="true">
	<cfargument name="row" type="numeric" required="false" default="1">
	<cfargument name="base" type="boolean" required="false" default="true">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		loc.fileName = $objectFileName(name=variables.wheels.class.modelName, objectPath=variables.wheels.class.path, type="model");
		loc.rv = $createObjectFromRoot(path=variables.wheels.class.path, fileName=loc.fileName, method="$initModelObject", name=variables.wheels.class.modelName, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row, base=arguments.base, useFilterLists=(!arguments.persisted));
		
		// if the object should be persisted, call afterFind else call afterNew
		if ((arguments.persisted && loc.rv.$callback("afterFind", arguments.callbacks)) || (!arguments.persisted && loc.rv.$callback("afterNew", arguments.callbacks)))
		{
			loc.rv.$callback("afterInitialization", arguments.callbacks);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$save" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true">
	<cfargument name="reload" type="boolean" required="true">
	<cfargument name="validate" type="boolean" required="true">
	<cfargument name="callbacks" type="boolean" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		
		// make sure all of our associations are set properly before saving
		$setAssociations();

		if ($callback("beforeValidation", arguments.callbacks))
		{
			if (isNew())
			{
				if ($validateAssociations() && $callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave,onCreate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeCreate", arguments.callbacks))
				{
					$create(parameterize=arguments.parameterize, reload=arguments.reload);
					if ($saveAssociations(argumentCollection=arguments, validate=false, callbacks=false) && $callback("afterCreate", arguments.callbacks) && $callback("afterSave", arguments.callbacks))
					{
						$updatePersistedProperties();
						loc.rv = true;
					}
				}
			}
			else
			{
				if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave,onUpdate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks) && $saveAssociations(argumentCollection=arguments) && $callback("beforeSave", arguments.callbacks) && $callback("beforeUpdate", arguments.callbacks))
				{
					$update(parameterize=arguments.parameterize, reload=arguments.reload);
					if ($callback("afterUpdate", arguments.callbacks) && $callback("afterSave", arguments.callbacks))
					{
						$updatePersistedProperties();
						loc.rv = true;
					}
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$create" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true">
	<cfargument name="reload" type="boolean" required="true">
	<cfscript>
		var loc = {};
		if (variables.wheels.class.timeStampingOnCreate)
		{
			$timestampProperty(property=variables.wheels.class.timeStampOnCreateProperty);
		}
		if (application.wheels.setUpdatedAtOnCreate && variables.wheels.class.timeStampingOnUpdate)
		{
			$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
		}

		// start by adding column names and values for the properties that exist on the object to two arrays
		loc.sql = [];
		loc.sql2 = [];
		for (loc.key in variables.wheels.class.properties)
		{
			if (StructKeyExists(this, loc.key))
			{
				ArrayAppend(loc.sql, variables.wheels.class.properties[loc.key].column);
				ArrayAppend(loc.sql, ",");
				ArrayAppend(loc.sql2, $buildQueryParamValues(loc.key));
				ArrayAppend(loc.sql2, ",");
			}
		}

		if (ArrayLen(loc.sql))
		{
			// create wrapping sql code and merge the second array that holds the values with the first one
			ArrayPrepend(loc.sql, "INSERT INTO #tableName()# (");
			ArrayPrepend(loc.sql2, " VALUES (");
			ArrayDeleteAt(loc.sql, ArrayLen(loc.sql));
			ArrayDeleteAt(loc.sql2, ArrayLen(loc.sql2));
			ArrayAppend(loc.sql, ")");
			ArrayAppend(loc.sql2, ")");
			loc.iEnd = ArrayLen(loc.sql);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				ArrayAppend(loc.sql, loc.sql2[loc.i]);
			}

			// map the primary keys down to the sql columns
			loc.primaryKeys = ListToArray(primaryKeys());
			loc.iEnd = ArrayLen(loc.primaryKeys);
			for(loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.primaryKeys[loc.i] = variables.wheels.class.properties[loc.primaryKeys[loc.i]].column;
			}
			loc.primaryKeys = ArrayToList(loc.primaryKeys);
		}
		else
		{
			// no properties were set on the object so we insert a record with only default values to the database
			loc.primaryKeys = primaryKey(0);
			ArrayAppend(loc.sql, "INSERT INTO #tableName()#" & variables.wheels.class.adapter.$defaultValues($primaryKey=loc.primaryKeys));
		}

		// run the insert sql statement and set the primary key value on the object (if one was returned from the database)
		loc.ins = variables.wheels.class.adapter.$query(sql=loc.sql, parameterize=arguments.parameterize, $primaryKey=loc.primaryKeys);
		loc.generatedKey = variables.wheels.class.adapter.$generatedKey();
		if (StructKeyExists(loc.ins.result, loc.generatedKey))
		{
			this[primaryKeys(1)] = loc.ins.result[loc.generatedKey];
		}

		if (arguments.reload)
		{
			this.reload();
		}
	</cfscript>
	<cfreturn true>
</cffunction>