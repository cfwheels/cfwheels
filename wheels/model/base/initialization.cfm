<cffunction name="$initModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="path" type="string" required="true">
	<cfscript>
		var loc = {};
		
		// tells us if this class has been extended
		variables._IsExtended = false;
		
		if (StructKeyExists(getmetaData(this).extends, "extends"))
		{
			variables._IsExtended = true;
		}
			
		variables.wheels = {};
		variables.wheels.class = {};
		variables.wheels.class.alias = arguments.name;
		variables.wheels.class.modelName = arguments.name;
		variables.wheels.class.modelId = hash(GetMetaData(this).name);
		variables.wheels.class.path = arguments.path;

		// if our name has pathing in it, remove it and add it to the end of of the $class.path variable
		if (Find("/", arguments.name))
		{
			variables.wheels.class.modelName = ListLast(arguments.name, "/");
			variables.wheels.class.path = ListAppend(arguments.path, ListDeleteAt(arguments.name, ListLen(arguments.name, "/"), "/"), "/");
		}

		variables.wheels.class.properties = {};
		variables.wheels.class.accessibleProperties = {};
		variables.wheels.class.callbacks = {};
		variables.wheels.class.validations = {};
		
		loc.callbacks = "afterNew,afterInitialization,beforeValidation,afterValidation";
		$initalizeCallBacks(loc.callbacks);
		
		loc.validations = "onSave";
		$initalizeValidations(loc.validations);
		
		variables.wheels.class.propertyList = "";

		// run developer's init method if it exists and we aren't extended
		// when extended this class it is assumed that extending class will
		// handle this.
		if (!variables._IsExtended && StructKeyExists(variables, "init"))
		{
			init();
		}
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="$initModelObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="properties" type="any" required="true">
	<cfargument name="persisted" type="boolean" required="true">
	<cfargument name="row" type="numeric" required="false" default="1">
	<cfargument name="base" type="boolean" required="false" default="true">
	<cfargument name="useFilterLists" type="boolean" required="false" default="true">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};

		variables.wheels = {};
		variables.wheels.instance = {};
		variables.wheels.instance.errors = [];
		// assign an object id for the instance
		variables.wheels.instance.tickCountId = $assignObjectId();
		// copy class variables from the object in the application scope
		if (!StructKeyExists(variables.wheels, "class"))
			variables.wheels.class = $simpleLock(name="classLock", type="readOnly", object=application.wheels.models[arguments.name], execute="$classData");
	</cfscript>
	<cfreturn this>
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
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="@save.">
	<cfscript>
		var loc = {};
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="properties,reload,transaction,callbacks", setOnModel=false);
		loc.returnValue = $createInstance(properties=arguments.properties, persisted=false, callbacks=arguments.callbacks);
		loc.returnValue.$setDefaultValues();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createInstance" returntype="any" access="public" output="false">
	<cfargument name="properties" type="struct" required="true">
	<cfargument name="persisted" type="boolean" required="true">
	<cfargument name="row" type="numeric" required="false" default="1">
	<cfargument name="base" type="boolean" required="false" default="true">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="@save.">
	<cfscript>
		var loc = {};
		loc.fileName = $objectFileName(name=variables.wheels.class.modelName, objectPath=variables.wheels.class.path, type="model");
		loc.returnValue = $createObjectFromRoot(path=variables.wheels.class.path, fileName=loc.fileName, method="$initModelObject", name=variables.wheels.class.modelName, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row, base=arguments.base, useFilterLists=(!arguments.persisted), callbacks=arguments.callbacks);
		// if the object should be persisted, call afterFind else call afterNew
		if ((arguments.persisted && loc.returnValue.$callback("afterFind", arguments.callbacks)) || (!arguments.persisted && loc.returnValue.$callback("afterNew", arguments.callbacks)))
			loc.returnValue.$callback("afterInitialization", arguments.callbacks);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$classData" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels.class>
</cffunction>