<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="belongsTo" returntype="void" access="public" output="false" hint="Sets up a `belongsTo` association between this model and the specified one."
	examples=
	'
		<!--- Specify that instances of this model belongs to an author (the table for this model should have a foreign key set on it, typically named `authorid`) --->
		<cfset belongsTo("author")>

		<!--- Same as above but since we give the association a different name we have to set `modelName` and `foreignKey` since Wheels won''t be able to figure it out based on the association name anymore --->
		<cfset belongsTo(name="bookWriter", modelName="author", foreignKey="authorId")>
	'
	categories="model-initialization,associations" chapters="associations" functions="hasOne,hasMany">
	<cfargument name="name" type="string" required="true" hint="Gives the association a name that you refer to when working with the association (in the `include` argument to @findAll to name one example).">
	<cfargument name="modelName" type="string" required="false" default="" hint="Name of associated model (usually not needed if you follow the Wheels conventions since the model name will be deduced from the `name` argument).">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name (usually not needed if you follow the Wheels conventions since the foreign key name will be deduced from the `name` argument).">
	<cfargument name="joinType" type="string" required="false" hint="Use to set the join type when joining associated tables, possible values are `inner` (for `INNER JOIN`) and `outer` (for `LEFT OUTER JOIN`).">
	<cfscript>
		$args(name="belongsTo", args=arguments);
		// deprecate the class argument (change of name only)
		if (StructKeyExists(arguments, "class"))
		{
			$deprecated("The `class` argument will be deprecated in a future version of Wheels, please use the `modelName` argument instead");
			arguments.modelName = arguments.class;
			StructDelete(arguments, "class");
		}

		arguments.type = "belongsTo";
		arguments.methods = "#arguments.name#,has#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasMany" returntype="void" access="public" output="false" hint="Sets up a `hasMany` association between this model and the specified one."
	examples=
	'
		<!--- Specify that instances of this model has many comments (the table for the associated model, not the current, should have the foreign key set on it) --->
		<cfset hasMany("comments")>

		<!--- Specify that this model (let''s call it `reader` in this case) has many subscriptions and setup a shortcut to the `magazine` model (useful when dealing with many to many relationships) --->
		<cfset hasMany(name="subscriptions", shortcut="magazines")>
	'
	categories="model-initialization,associations" chapters="associations" functions="belongsTo,hasOne">
	<cfargument name="name" type="string" required="true" hint="See documentation for @belongsTo.">
	<cfargument name="modelName" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinType" type="string" required="false" hint="See documentation for @belongsTo.">
	<cfargument name="dependent" type="string" required="false" hint="Set to `delete` to instantiate associated models and call their delete method, `deleteAll` to delete without instantiating, `nullify` to remove the foreign key or `false` to do nothing.">
	<cfargument name="shortcut" type="string" required="false" default="" hint="Set this argument to create an additional dynamic method that gets the objects for a many-to-many association.">
	<cfargument name="through" type="string" required="false" default="#singularize(arguments.shortcut)#,#arguments.name#" hint="Set this argument if you need to override the Wheels convention when using the `shortcut` argument.">
	<cfscript>
		var singularizeName = capitalize(singularize(arguments.name));
		var capitalizeName = capitalize(arguments.name);
		$args(name="hasMany", args=arguments);
		// deprecate the class argument (change of name only)
		if (StructKeyExists(arguments, "class"))
		{
			$deprecated("The `class` argument will be deprecated in a future version of Wheels, please use the `modelName` argument instead");
			arguments.modelName = arguments.class;
			StructDelete(arguments, "class");
		}

		arguments.type = "hasMany";
		arguments.methods = "#arguments.name#,#singularizeName#Count,add#singularizeName#,create#singularizeName#,delete#singularizeName#,deleteAll#capitalizeName#,findOne#singularizeName#,has#capitalizeName#,new#singularizeName#,remove#singularizeName#,removeAll#capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasOne" returntype="void" access="public" output="false" hint="Sets up a `hasOne` association between this model and the specified one."
	examples=
	'
		<!--- Specify that instances of this model has one profile (the table for the associated model, not the current, should have the foreign key set on it) --->
		<cfset hasOne("profile")>

		<!--- Same as above but setting the `joinType` to `inner` which basically means this model should always have a record in the `profiles` table --->
		<cfset hasOne(name="profile", joinType="inner")>
	'
	categories="model-initialization,associations" chapters="associations" functions="belongsTo,hasMany">
	<cfargument name="name" type="string" required="true" hint="See documentation for @belongsTo.">
	<cfargument name="modelName" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinType" type="string" required="false" hint="See documentation for @belongsTo.">
	<cfargument name="dependent" type="string" required="false" hint="See documentation for @hasMany.">
	<cfscript>
		var capitalizeName = capitalize(arguments.name);
		$args(name="hasOne", args=arguments);
		// deprecate the class argument (change of name only)
		if (StructKeyExists(arguments, "class"))
		{
			$deprecated("The `class` argument will be deprecated in a future version of Wheels, please use the `modelName` argument instead");
			arguments.modelName = arguments.class;
			StructDelete(arguments, "class");
		}

		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#capitalizeName#,delete#capitalizeName#,has#capitalizeName#,new#capitalizeName#,remove#capitalizeName#,set#capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PRIVATE MODEL INITIALIZATION METHODS --->

<cffunction name="$registerAssociation" returntype="void" access="public" output="false" hint="Called from the association methods above to save the data to the class struct of the model.">
	<cfscript>
		// assign the name for the association
		var associationName = arguments.name;
		
		// default our nesting to false and set other nesting properties
		arguments.nested = {};
		arguments.nested.allow = false;
		arguments.nested.delete = false;
		arguments.nested.autosave = false;
		arguments.nested.sortProperty = "";
		arguments.nested.rejectIfBlank = "";
		// remove the name argument from the arguments struct
		structDelete(arguments, "name", false);
		// infer model name and foreign key from association name unless developer specified it already
		if (!Len(arguments.modelName))
		{
			if (arguments.type == "hasMany")
				arguments.modelName = singularize(associationName);
			else
				arguments.modelName = associationName;
		}
		// store all the settings for the association in the class struct (one struct per association with the name of the association as the key)
		variables.wheels.class.associations[associationName] = arguments;
	</cfscript>
</cffunction>


<cffunction name="$deleteDependents" returntype="void" access="public" output="false">
	<cfscript>
	var loc = {};
	for (loc.key in variables.wheels.class.associations)
	{
		if (ListFindNoCase("hasMany,hasOne", variables.wheels.class.associations[loc.key].type) and variables.wheels.class.associations[loc.key].dependent neq false)
		{
			switch(variables.wheels.class.associations[loc.key].dependent)
			{
				case "delete":
				{
					$invoke(componentReference=this, method="deleteAll#(loc.key)#", instantiate=true);
					break;
				}
				case "deleteAll":
				{
					$invoke(componentReference=this, method="deleteAll#(loc.key)#");
					break;
				}
				case "removeAll":
				{
					$invoke(componentReference=this, method="removeAll#(loc.key)#");
					break;
				}
				default:
				{
					$throw(type="Wheels.InvalidArgument", message="'#variables.wheels.class.associations[loc.key].dependent#' is not a valid dependency.", extendedInfo="Use `delete`, `deleteAll`, `removeAll` or false.");
				}
			}
		}	
	}
	</cfscript>
</cffunction>

