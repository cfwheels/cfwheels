<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="updateAll" returntype="numeric" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="instantiate" type="boolean" required="false">
	<cfargument name="validate" type="boolean" required="false" default="true">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		$args(name="updateAll", args=arguments);
		arguments.include = $listClean(arguments.include);
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="where,include,properties,reload,parameterize,instantiate,validate,transaction,callbacks,includeSoftDeletes", setOnModel=false);

		// find and instantiate each object and call its update function
		if (arguments.instantiate)
		{
			loc.rv = 0;
			loc.objects = findAll(select=propertyNames(), where=arguments.where, include=arguments.include, reload=arguments.reload, parameterize=arguments.parameterize, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, returnIncluded=false, returnAs="objects");
			loc.iEnd = ArrayLen(loc.objects);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (loc.objects[loc.i].update(properties=arguments.properties, parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks))
				{
					loc.rv++;
				}
			}
		}
		else
		{
			arguments.sql = [];
			ArrayAppend(arguments.sql, "UPDATE #tableName()# SET");
			loc.pos = 0;
			for (loc.key in arguments.properties)
			{
				loc.pos++;
				ArrayAppend(arguments.sql, "#variables.wheels.class.properties[loc.key].column# = ");
				loc.param = {value=arguments.properties[loc.key], type=variables.wheels.class.properties[loc.key].type, dataType=variables.wheels.class.properties[loc.key].dataType, scale=variables.wheels.class.properties[loc.key].scale, null=!Len(arguments.properties[loc.key])};
				ArrayAppend(arguments.sql, loc.param);
				if (StructCount(arguments.properties) > loc.pos)
				{
					ArrayAppend(arguments.sql, ",");
				}
			}
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			loc.rv = invokeWithTransaction(method="$updateAll", argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateByKey" returntype="boolean" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="validate" type="boolean" required="false" default="true">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		$args(name="updateByKey", args=arguments);
		$keyLengthCheck(arguments.key);
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		loc.rv = updateOne(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateOne" returntype="boolean" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="order" type="string" required="false" default="">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="validate" type="boolean" required="false" default="true">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		$args(name="updateOne", args=arguments);
		loc.object = findOne(where=arguments.where, order=arguments.order, reload=arguments.reload, includeSoftDeletes=arguments.includeSoftDeletes);
		StructDelete(arguments, "where");
		StructDelete(arguments, "order");
		if (IsObject(loc.object))
		{
			loc.rv = loc.object.update(argumentCollection=arguments);
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="update" returntype="boolean" access="public" output="false">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="validate" type="boolean" required="false" default="true">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="update", args=arguments);
		$setProperties(argumentCollection=arguments, filterList="properties,parameterize,reload,validate,transaction,callbacks");
		loc.rv = save(parameterize=arguments.parameterize, reload=arguments.reload, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateProperty" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="updateProperty", args=arguments);
		arguments.validate = false;
		this[arguments.property] = arguments.value;
		loc.rv = save(parameterize=arguments.parameterize, reload=false, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="updateProperties" returntype="boolean" access="public" output="false">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="validate" type="boolean" required="false" default="true">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="updateProperties", args=arguments);
		$setProperties(argumentCollection=arguments, filterList="properties,parameterize,validate,transaction,callbacks");
		loc.rv = save(parameterize=arguments.parameterize, reload=false, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$updateAll" returntype="numeric" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize).result.recordCount;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$update" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true">
	<cfargument name="reload" type="boolean" required="true">
	<cfscript>
		var loc = {};
		if (hasChanged())
		{
			// perform update since changes have been made
			if (variables.wheels.class.timeStampingOnUpdate)
			{
				$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
			}
			loc.sql = [];
			ArrayAppend(loc.sql, "UPDATE #tableName()# SET ");
			for (loc.key in variables.wheels.class.properties)
			{
				// include all changed non-key values in the update
				if (StructKeyExists(this, loc.key) && !ListFindNoCase(primaryKeys(), loc.key) && hasChanged(loc.key))
				{
					ArrayAppend(loc.sql, "#variables.wheels.class.properties[loc.key].column# = ");
					loc.param = $buildQueryParamValues(loc.key);
					ArrayAppend(loc.sql, loc.param);
					ArrayAppend(loc.sql, ",");
				}
			}

			// only submit the update if we generated an sql set statement
			if (ArrayLen(loc.sql) > 1)
			{
				ArrayDeleteAt(loc.sql, ArrayLen(loc.sql));
				loc.sql = $addKeyWhereClause(sql=loc.sql);
				loc.upd = variables.wheels.class.adapter.$query(sql=loc.sql, parameterize=arguments.parameterize);
				if (arguments.reload)
				{
					this.reload();
				}
			}
		}
	</cfscript>
	<cfreturn true>
</cffunction>