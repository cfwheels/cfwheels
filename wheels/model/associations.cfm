<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="belongsTo" returntype="void" access="public" output="false" hint="Sets up a `belongsTo` association between this model and the specified one. Use this association when this model contains a foreign key referencing another model."
	examples=
	'
		<!--- Specify that instances of this model belong to an author. (The table for this model should have a foreign key set on it, typically named `authorid`.) --->
		<cfset belongsTo("author")>

		<!--- Same as above, but because we have broken away from the foreign key naming convention, we need to set `modelName` and `foreignKey` --->
		<cfset belongsTo(name="bookWriter", modelName="author", foreignKey="authorId")>
	'
	categories="model-initialization,associations" chapters="associations" functions="hasOne,hasMany">
	<cfargument name="name" type="string" required="true" hint="Gives the association a name that you refer to when working with the association (in the `include` argument to @findAll, to name one example).">
	<cfargument name="modelName" type="string" required="false" default="" hint="Name of associated model (usually not needed if you follow Wheels conventions because the model name will be deduced from the `name` argument).">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name (usually not needed if you follow Wheels conventions since the foreign key name will be deduced from the `name` argument).">
	<cfargument name="joinKey" type="string" required="false" default="" hint="Column name to join to if not the primary key (usually not needed if you follow wheels conventions since the join key will be the tables primary key/keys).">
	<cfargument name="joinType" type="string" required="false" hint="Use to set the join type when joining associated tables. Possible values are `inner` (for `INNER JOIN`) and `outer` (for `LEFT OUTER JOIN`).">
	<cfscript>
		$args(name="belongsTo", args=arguments);
		arguments.type = "belongsTo";
		arguments.methods = "#arguments.name#,has#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasMany" returntype="void" access="public" output="false" hint="Sets up a `hasMany` association between this model and the specified one."
	examples=
	'
		<!---
			Example1: Specify that instances of this model has many comments.
			(The table for the associated model, not the current, should have the foreign key set on it.)
		--->
		<cfset hasMany("comments")>

		<!---
			Example 2: Specify that this model (let''s call it `reader` in this case) has many subscriptions and setup a shortcut to the `publication` model.
			(Useful when dealing with many-to-many relationships.)
		--->
		<cfset hasMany(name="subscriptions", shortcut="publications")>
		
		<!--- Example 3: Automatically delete all associated `comments` whenever this object is deleted --->
		<cfset hasMany(name="comments", dependent="deleteAll")>
		
		<!---
			Example 4: When not following Wheels naming conventions for associations, it can get complex to define how a `shortcut` works.
			In this example, we are naming our `shortcut` differently than the actual model''s name.
		--->
		<!--- In the models/Customer.cfc `init()` method --->
		<cfset hasMany(name="subscriptions", shortcut="magazines", through="publication,subscriptions")>
		
		<!--- In the models/Subscriptions.cfc `init()` method --->
		<cfset belongsTo("customer")>
		<cfset belongsTo("publication")>
		
		<!--- In the models/Publication `init()` method --->
		<cfset hasMany("subscriptions")>
	'
	categories="model-initialization,associations" chapters="associations" functions="belongsTo,hasOne">
	<cfargument name="name" type="string" required="true" hint="See documentation for @belongsTo.">
	<cfargument name="modelName" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinType" type="string" required="false" hint="See documentation for @belongsTo.">
	<cfargument name="dependent" type="string" required="false" hint="Defines how to handle dependent models when you delete a record from this model. Set to `delete` to instantiate associated models and call their @delete method, `deleteAll` to delete without instantiating, `removeAll` to remove the foreign key, or `false` to do nothing.">
	<cfargument name="shortcut" type="string" required="false" default="" hint="Set this argument to create an additional dynamic method that gets the object(s) from the other side of a many-to-many association.">
	<cfargument name="through" type="string" required="false" default="#singularize(arguments.shortcut)#,#arguments.name#" hint="Set this argument if you need to override Wheels conventions when using the `shortcut` argument. Accepts a list of two association names representing the chain from the opposite side of the many-to-many relationship to this model.">
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

<cffunction name="hasOne" returntype="void" access="public" output="false" hint="Sets up a `hasOne` association between this model and the specified one."
	examples=
	'
		<!--- Specify that instances of this model has one profile. (The table for the associated model, not the current, should have the foreign key set on it.) --->
		<cfset hasOne("profile")>

		<!--- Same as above but setting the `joinType` to `inner`, which basically means this model should always have a record in the `profiles` table --->
		<cfset hasOne(name="profile", joinType="inner")>
		
		<!--- Automatically delete the associated `profile` whenever this object is deleted --->
		<cfset hasMany(name="comments", dependent="delete")>
	'
	categories="model-initialization,associations" chapters="associations" functions="belongsTo,hasMany">
	<cfargument name="name" type="string" required="true" hint="See documentation for @belongsTo.">
	<cfargument name="modelName" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinType" type="string" required="false" hint="See documentation for @belongsTo.">
	<cfargument name="dependent" type="string" required="false" hint="See documentation for @hasMany.">
	<cfscript>
		var loc = {};
		$args(name="hasOne", args=arguments);
		loc.capitalizeName = capitalize(arguments.name);
		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#loc.capitalizeName#,delete#loc.capitalizeName#,has#loc.capitalizeName#,new#loc.capitalizeName#,remove#loc.capitalizeName#,set#loc.capitalizeName#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PRIVATE MODEL INITIALIZATION METHODS --->

<cffunction name="$registerAssociation" returntype="void" access="public" output="false" hint="Called from the association methods above to save the data to the class struct of the model.">
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