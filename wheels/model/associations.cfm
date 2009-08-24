<cffunction name="hasMany" returntype="void" access="public" output="false" hint="Sets up a `has many` association between this class and the specified one.">
	<cfargument name="name" type="string" required="true" hint="Name of the association">
	<cfargument name="class" type="string" required="false" default="" hint="Name of associated class">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name">
	<cfargument name="joinType" type="string" required="false" default="#application.wheels.hasMany.joinType#" hint="Use to set the join type when joining associated tables, possible values are `inner` and `outer`">
	<cfargument name="shortcut" type="string" required="false" default="" hint="">
	<cfargument name="through" type="string" required="false" default="#singularize(arguments.shortcut)#,#arguments.name#" hint="">
	<cfscript>
		arguments.type = "hasMany";
		arguments.methods = "#arguments.name#,#capitalize(singularize(arguments.name))#Count,add#capitalize(singularize(arguments.name))#,create#capitalize(singularize(arguments.name))#,delete#capitalize(singularize(arguments.name))#,deleteAll#capitalize(arguments.name)#,findOne#capitalize(singularize(arguments.name))#,has#capitalize(arguments.name)#,new#capitalize(singularize(arguments.name))#,remove#capitalize(singularize(arguments.name))#,removeAll#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasOne" returntype="void" access="public" output="false" hint="Sets up a `has one` association between this class and the specified one.">
	<cfargument name="name" type="string" required="true" hint="See documentation for `hasMany`">
	<cfargument name="class" type="string" required="false" default="" hint="See documentation for `hasMany`">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for `hasMany`">
	<cfargument name="joinType" type="string" required="false" default="#application.wheels.hasOne.joinType#" hint="See documentation for `hasMany`">
	<cfscript>
		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#capitalize(arguments.name)#,delete#capitalize(arguments.name)#,has#capitalize(arguments.name)#,new#capitalize(arguments.name)#,remove#capitalize(arguments.name)#,set#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="belongsTo" returntype="void" access="public" output="false" hint="Sets up a `belongs to` association between this class and the specified one.">
	<cfargument name="name" type="string" required="true" hint="See documentation for `hasMany`">
	<cfargument name="class" type="string" required="false" default="" hint="See documentation for `hasMany`">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="See documentation for `hasMany`">
	<cfargument name="joinType" type="string" required="false" default="#application.wheels.belongsTo.joinType#" hint="See documentation for `hasMany`">
	<cfscript>
		arguments.type = "belongsTo";
		arguments.methods = "#arguments.name#,has#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="$registerAssociation" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		variables.wheels.class.associations[arguments.name] = {};
		for (loc.key in arguments)
			if (loc.key != "name")
				variables.wheels.class.associations[arguments.name][loc.key] = arguments[loc.key];
	</cfscript>
</cffunction>