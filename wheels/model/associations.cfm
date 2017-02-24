<cfscript>
	/*
	* PUBLIC MODEL INITIALIZATION METHODS
	*/

	public void function automaticAssociations(required boolean value) {
		variables.wheels.class.automaticAssociations = arguments.value;
	}

	public void function belongsTo(
		required string name,
		string modelName="",
		string foreignKey="",
		string joinKey="",
		string joinType
	) {
		$args(name="belongsTo", args=arguments);
		arguments.type = "belongsTo";
		arguments.methods = "#arguments.name#,has#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	}

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
		local.singularizeName = capitalize(singularize(arguments.name));
		local.capitalizeName = capitalize(arguments.name);
		arguments.type = "hasMany";
		arguments.methods = "#arguments.name#,#local.singularizeName#Count,add#local.singularizeName#,create#local.singularizeName#,delete#local.singularizeName#,deleteAll#local.capitalizeName#,findOne#local.singularizeName#,has#local.capitalizeName#,new#local.singularizeName#,remove#local.singularizeName#,removeAll#local.capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	}

	public void function hasOne(
		required string name,
		string modelName="",
		string foreignKey="",
		string joinKey="",
		string joinType,
		string dependent
	) {
		$args(name="hasOne", args=arguments);
		local.capitalizeName = capitalize(arguments.name);
		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#local.capitalizeName#,delete#local.capitalizeName#,has#local.capitalizeName#,new#local.capitalizeName#,remove#local.capitalizeName#,set#local.capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	}

	/*
	* PRIVATE METHODS
	*/

	public void function $registerAssociation() {

		// assign the name for the association
		local.associationName = arguments.name;

		// default our nesting to false and set other nesting properties
		arguments.nested = {};
		arguments.nested.allow = false;
		arguments.nested.delete = false;
		arguments.nested.autosave = false;
		arguments.nested.sortProperty = "";
		arguments.nested.rejectIfBlank = "";

		// remove the name argument from the arguments struct
		StructDelete(arguments, "name");

		// infer model name and foreign key from association name unless developer specified it already
		if (!Len(arguments.modelName))
		{
			if (arguments.type == "hasMany")
			{
				arguments.modelName = singularize(local.associationName);
			}
			else
			{
				arguments.modelName = local.associationName;
			}
		}

		// set pluralized association name, to be used when aliasing the table
		arguments.pluralizedName = pluralize(local.associationName);

		// store all the settings for the association in the class struct (one struct per association with the name of the association as the key)
		variables.wheels.class.associations[local.associationName] = arguments;
	}

	public void function $deleteDependents() {
		for (local.key in variables.wheels.class.associations)
		{
			if (ListFindNoCase("hasMany,hasOne", variables.wheels.class.associations[local.key].type) && variables.wheels.class.associations[local.key].dependent != false)
			{
				local.all = "";
				if (variables.wheels.class.associations[local.key].type == "hasMany")
				{
					local.all = "All";
				}
				switch (variables.wheels.class.associations[local.key].dependent)
				{
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
						$throw(type="Wheels.InvalidArgument", message="'#variables.wheels.class.associations[local.key].dependent#' is not a valid dependency.", extendedInfo="Use `delete`, `deleteAll`, `removeAll` or false.");
				}
			}
		}
	}
</cfscript>