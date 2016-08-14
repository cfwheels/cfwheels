<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="belongsTo" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="modelName" type="string" required="false" default="">
	<cfargument name="foreignKey" type="string" required="false" default="">
	<cfargument name="joinKey" type="string" required="false" default="">
	<cfargument name="joinType" type="string" required="false">
	<cfscript>
		$args(name="belongsTo", args=arguments);
		arguments.type = "belongsTo";
		arguments.methods = "#arguments.name#,has#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasMany" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="modelName" type="string" required="false" default="">
	<cfargument name="foreignKey" type="string" required="false" default="">
	<cfargument name="joinKey" type="string" required="false" default="">
	<cfargument name="joinType" type="string" required="false">
	<cfargument name="dependent" type="string" required="false">
	<cfargument name="shortcut" type="string" required="false" default="">
	<cfargument name="through" type="string" required="false" default="#singularize(arguments.shortcut)#,#arguments.name#">
	<cfscript>
		var loc = {};
		$args(name="hasMany", args=arguments);
		loc.singularizeName = capitalize(singularize(arguments.name));
		loc.capitalizeName = capitalize(arguments.name);
		arguments.type = "hasMany";
		arguments.methods = "#arguments.name#,#loc.singularizeName#Count,add#loc.singularizeName#,create#loc.singularizeName#,delete#loc.singularizeName#,deleteAll#loc.capitalizeName#,findOne#loc.singularizeName#,has#loc.capitalizeName#,new#loc.singularizeName#,remove#loc.singularizeName#,removeAll#loc.capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasOne" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="modelName" type="string" required="false" default="">
	<cfargument name="foreignKey" type="string" required="false" default="">
	<cfargument name="joinKey" type="string" required="false" default="">
	<cfargument name="joinType" type="string" required="false">
	<cfargument name="dependent" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="hasOne", args=arguments);
		loc.capitalizeName = capitalize(arguments.name);
		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#loc.capitalizeName#,delete#loc.capitalizeName#,has#loc.capitalizeName#,new#loc.capitalizeName#,remove#loc.capitalizeName#,set#loc.capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$registerAssociation" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};

		// assign the name for the association
		loc.associationName = arguments.name;

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
				arguments.modelName = singularize(loc.associationName);
			}
			else
			{
				arguments.modelName = loc.associationName;
			}
		}

		// set pluralized association name, to be used when aliasing the table
		arguments.pluralizedName = pluralize(loc.associationName);

		// store all the settings for the association in the class struct (one struct per association with the name of the association as the key)
		variables.wheels.class.associations[loc.associationName] = arguments;
	</cfscript>
</cffunction>

<cffunction name="$deleteDependents" returntype="void" access="public" output="false">
	<cfscript>
	var loc = {};
	for (loc.key in variables.wheels.class.associations)
	{
		if (ListFindNoCase("hasMany,hasOne", variables.wheels.class.associations[loc.key].type) && variables.wheels.class.associations[loc.key].dependent != false)
		{
			loc.all = "";
			if (variables.wheels.class.associations[loc.key].type == "hasMany")
			{
				loc.all = "All";
			}
			switch (variables.wheels.class.associations[loc.key].dependent)
			{
				case "delete":
					loc.invokeArgs = {};
					loc.invokeArgs.instantiate = true;
					$invoke(componentReference=this, method="delete#loc.all##loc.key#", invokeArgs=loc.invokeArgs);
					break;
				case "remove":
					loc.invokeArgs = {};
					loc.invokeArgs.instantiate = true;
					$invoke(componentReference=this, method="remove#loc.all##loc.key#", invokeArgs=loc.invokeArgs);
					break;
				case "deleteAll":
					$invoke(componentReference=this, method="delete#loc.all##loc.key#");
					break;
				case "removeAll":
					$invoke(componentReference=this, method="remove#loc.all##loc.key#");
					break;
				default:
					$throw(type="Wheels.InvalidArgument", message="'#variables.wheels.class.associations[loc.key].dependent#' is not a valid dependency.", extendedInfo="Use `delete`, `deleteAll`, `removeAll` or false.");
			}
		}
	}
	</cfscript>
</cffunction>