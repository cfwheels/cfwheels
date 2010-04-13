<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="belongsTo" returntype="void" access="public" output="false" hint="Sets up a `belongsTo` association between this model and the specified one."
	examples=
	'
		<!--- Specify that instances of this model belongs to an author (the table for this model should have a foreign key set on it, typically named `authorid`) --->
		<cfset belongsTo("author")>

		<!--- Same as above but since we give the association a different name we have to set `class` and `foreignKey` since Wheels won''t be able to figure it out based on the association name anymore --->
		<cfset belongsTo(name="bookWriter", class="author", foreignKey="authorId")>
	'
	categories="model-initialization,associations" chapters="associations" functions="hasOne,hasMany">
	<cfargument name="name" type="string" required="true" hint="Gives the association a name that you refer to when working with the association (in the `include` argument to @findAll to name one example).">
	<cfargument name="class" type="string" required="false" default="" hint="Name of associated class (usually not needed if you follow the Wheels conventions since the model name will be deduced from the `name` argument).">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name (usually not needed if you follow the Wheels conventions since the foreign key name will be deduced from the `name` argument).">
	<cfargument name="joinType" type="string" required="false" default="#application.wheels.functions.belongsTo.joinType#" hint="Use to set the join type when joining associated tables, possible values are `inner` (for `INNER JOIN`) and `outer` (for `LEFT OUTER JOIN`).">
	<cfscript>
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
	<cfargument name="class" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinType" type="string" required="false" default="#application.wheels.functions.hasMany.joinType#" hint="See documentation for @belongsTo.">
	<cfargument name="shortcut" type="string" required="false" default="" hint="Set this argument to create an additional dynamic method that gets the objects for a many-to-many association.">
	<cfargument name="through" type="string" required="false" default="#singularize(arguments.shortcut)#,#arguments.name#" hint="Set this argument if you need to override the Wheels convention when using the `shortcut` argument.">
	<cfscript>
		arguments.type = "hasMany";
		arguments.methods = "#arguments.name#,#capitalize(singularize(arguments.name))#Count,add#capitalize(singularize(arguments.name))#,create#capitalize(singularize(arguments.name))#,delete#capitalize(singularize(arguments.name))#,deleteAll#capitalize(arguments.name)#,findOne#capitalize(singularize(arguments.name))#,has#capitalize(arguments.name)#,new#capitalize(singularize(arguments.name))#,remove#capitalize(singularize(arguments.name))#,removeAll#capitalize(arguments.name)#";
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
	<cfargument name="class" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for @belongsTo.">
	<cfargument name="joinType" type="string" required="false" default="#application.wheels.functions.hasOne.joinType#" hint="See documentation for @belongsTo.">
	<cfscript>
		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#capitalize(arguments.name)#,delete#capitalize(arguments.name)#,has#capitalize(arguments.name)#,new#capitalize(arguments.name)#,remove#capitalize(arguments.name)#,set#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PRIVATE MODEL INITIALIZATION METHODS --->

<cffunction name="$registerAssociation" returntype="void" access="public" output="false" hint="Called from the association methods above to save the data to the `class` struct of the model.">
	<cfscript>
		var key = "";

		// infer model name from association name unless developer specified it already
		if (!Len(arguments.class))
		{
			if (arguments.type == "hasMany")
				arguments.class = singularize(arguments.name);
			else
				arguments.class = arguments.name;
		}

		variables.wheels.class.associations[arguments.name] = {};
		for (key in arguments)
			if (key != "name")
				variables.wheels.class.associations[arguments.name][key] = arguments[key];
	</cfscript>
</cffunction>