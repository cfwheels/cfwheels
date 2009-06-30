<cffunction name="hasMany" returntype="void" access="public" output="false" hint="Sets up a `has many` association between this class and the specified one.">
	<cfargument name="name" type="string" required="true" hint="Name of the association">
	<cfargument name="class" type="string" required="false" default="" hint="Name of associated class">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name">
	<cfargument name="dependent" type="boolean" required="false" default="#application.wheels.hasMany.dependent#" hint="When set to `true` the association will be retrieved with an inner join (otherwise with a left outer join) and when this object is deleted all associated objects will be deleted as well">
	<cfargument name="instantiate" type="boolean" required="false" default="#application.wheels.hasMany.instantiate#" hint="When set to `true` all associated objects will be instantiated before deletion thus invoking any callbacks set on them">
	<cfscript>
		arguments.type = "hasMany";
		arguments.methods = "#arguments.name#,#capitalize(singularize(arguments.name))#Count,add#capitalize(singularize(arguments.name))#,create#capitalize(singularize(arguments.name))#,delete#capitalize(singularize(arguments.name))#,deleteAll#capitalize(arguments.name)#,findOne#capitalize(singularize(arguments.name))#,has#capitalize(arguments.name)#,new#capitalize(singularize(arguments.name))#,remove#capitalize(singularize(arguments.name))#,removeAll#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasOne" returntype="void" access="public" output="false" hint="Sets up a `has one` association between this class and the specified one.">
	<cfargument name="name" type="string" required="true" hint="Name of the association">
	<cfargument name="class" type="string" required="false" default="" hint="Name of associated class">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name">
	<cfargument name="dependent" type="boolean" required="false" default="#application.wheels.hasOne.dependent#" hint="When set to `true` the association will be retrieved with an inner join (otherwise with a left outer join) and when this object is deleted the associated object will be deleted as well">
	<cfargument name="instantiate" type="boolean" required="false" default="#application.wheels.hasOne.instantiate#" hint="When set to `true` the associated object will be instantiated before deletion thus invoking any callbacks set on it">
	<cfscript>
		arguments.type = "hasOne";
		arguments.methods = "#arguments.name#,create#capitalize(arguments.name)#,delete#capitalize(arguments.name)#,has#capitalize(arguments.name)#,new#capitalize(arguments.name)#,remove#capitalize(arguments.name)#,set#capitalize(arguments.name)#";
		$registerAssociation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="belongsTo" returntype="void" access="public" output="false" hint="Sets up a `belongs to` association between this class and the specified one.">
	<cfargument name="name" type="string" required="true" hint="Name of the association">
	<cfargument name="class" type="string" required="false" default="" hint="Name of associated class">
	<cfargument name="foreignKey" type="string" required="false" default="" hint="Foreign key property name">
	<cfargument name="dependent" type="boolean" required="false" default="#application.wheels.belongsTo.dependent#" hint="When set to `true` the association will be retrieved with an inner join (otherwise with a left outer join)">
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