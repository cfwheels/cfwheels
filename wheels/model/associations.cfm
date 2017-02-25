<cfscript>

/*
 * Model initialization method.
 * Sets up a "belongsTo" association between this model and the specified one.
 */
public void function belongsTo(
	required string name,
	string modelName="",
	string foreignKey="",
	string joinKey="",
	string joinType
) {
	$args(name="belongsTo", args=arguments);
	arguments.type = "belongsTo";

	// The dynamic shortcut methods to add to this class (e.g. "post" , "hasPost").
	arguments.methods = "";
	arguments.methods = ListAppend(arguments.methods, arguments.name);
	arguments.methods = ListAppend(arguments.methods, "has#capitalize(arguments.name)#");

	$registerAssociation(argumentCollection=arguments);
}

/*
 * Model initialization method.
 * Sets up a "hasMany" association between this model and the specified one.
 */
public void function hasMany(
	required string name,
	string modelName="",
	string foreignKey="",
	string joinKey="",
	string joinType,
	string dependent,
	string shortcut="",
	string through="#singularize(arguments.shortcut)#,#arguments.name#"
) {
	$args(name="hasMany", args=arguments);
	local.singularizedName = capitalize(singularize(arguments.name));
	local.capitalizedName = capitalize(arguments.name);
	arguments.type = "hasMany";

	// The dynamic shortcut methods to add to this class (e.g. "comment", "commentCount", "addComment", "createComment" etc).
	arguments.methods = "";
	arguments.methods = ListAppend(arguments.methods, arguments.name);
	arguments.methods = ListAppend(arguments.methods, "#local.singularizedName#Count");
	arguments.methods = ListAppend(arguments.methods, "add#local.singularizedName#");
	arguments.methods = ListAppend(arguments.methods, "create#local.singularizedName#");
	arguments.methods = ListAppend(arguments.methods, "delete#local.singularizedName#");
	arguments.methods = ListAppend(arguments.methods, "deleteAll#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "findOne#local.singularizedName#");
	arguments.methods = ListAppend(arguments.methods, "has#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "new#local.singularizedName#");
	arguments.methods = ListAppend(arguments.methods, "remove#local.singularizedName#");
	arguments.methods = ListAppend(arguments.methods, "removeAll#local.capitalizedName#");

	$registerAssociation(argumentCollection=arguments);
}

/*
 * Model initialization method.
 * Sets up a "hasOne" association between this model and the specified one.
 */
public void function hasOne(
	required string name,
	string modelName="",
	string foreignKey="",
	string joinKey="",
	string joinType,
	string dependent
) {
	$args(name="hasOne", args=arguments);
	local.capitalizedName = capitalize(arguments.name);
	arguments.type = "hasOne";

	// The dynamic shortcut methods to add to this class (e.g. "profile", "createProfile", "deleteProfile" etc).
	arguments.methods = "";
	arguments.methods = ListAppend(arguments.methods, arguments.name);
	arguments.methods = ListAppend(arguments.methods, "create#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "delete#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "has#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "new#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "remove#local.capitalizedName#");
	arguments.methods = ListAppend(arguments.methods, "set#local.capitalizedName#");

	$registerAssociation(argumentCollection=arguments);
}

/*
 * Internal function.
 * Registers the association info in the model object on the application scope.
 */
public void function $registerAssociation() {

	// Assign the name for the association.
	local.associationName = arguments.name;

	// Default our nesting to false and set other nesting properties.
	arguments.nested = {};
	arguments.nested.allow = false;
	arguments.nested.delete = false;
	arguments.nested.autosave = false;
	arguments.nested.sortProperty = "";
	arguments.nested.rejectIfBlank = "";

	// Infer model name from association name unless developer specified it already.
	if (!Len(arguments.modelName)) {
		if (arguments.type == "hasMany") {
			arguments.modelName = singularize(local.associationName);
		} else {
			arguments.modelName = local.associationName;
		}
	}

	// Set pluralized association name, to be used when aliasing the table.
	arguments.pluralizedName = pluralize(local.associationName);

	// Store all the settings for the association in the class data.
	// One struct per association with the name of the association as the key.
	// We delete the name from the arguments because we use it as the key and don't need to store it elsewhere.
	StructDelete(arguments, "name");
	variables.wheels.class.associations[local.associationName] = arguments;
}

/*
 * Internal function.
 * Called when a model object is deleted (e.g. post.delete()).
 * Deletes all associated records (or sets their foreign key values to NULL).
 */
public void function $deleteDependents() {
	for (local.key in variables.wheels.class.associations) {
		if (ListFindNoCase("hasMany,hasOne", variables.wheels.class.associations[local.key].type) && variables.wheels.class.associations[local.key].dependent != false) {
			local.all = "";
			if (variables.wheels.class.associations[local.key].type == "hasMany") {
				local.all = "All";
			}
			switch (variables.wheels.class.associations[local.key].dependent) {
				case "delete":
					local.invokeArgs = {};
					local.invokeArgs.instantiate = true;
					$invoke(componentReference=this, method="delete#local.all##local.key#", invokeArgs=local.invokeArgs);
					break;
				case "remove":
					local.invokeArgs = {};
					local.invokeArgs.instantiate = true;
					$invoke(componentReference=this, method="remove#local.all##local.key#", invokeArgs=local.invokeArgs);
					break;
				case "deleteAll":
					$invoke(componentReference=this, method="delete#local.all##local.key#");
					break;
				case "removeAll":
					$invoke(componentReference=this, method="remove#local.all##local.key#");
					break;
				default:
					$throw(
						type="Wheels.InvalidArgument",
						message="'#variables.wheels.class.associations[local.key].dependent#' is not a valid dependency.",
						extendedInfo="Use `delete`, `deleteAll`, `remove`, `removeAll` or `false`."
					);
			}
		}
	}
}

</cfscript>
