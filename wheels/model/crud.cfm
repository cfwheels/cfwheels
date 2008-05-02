<cffunction name="new" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="no" default="#structNew()#">
	<cfset var locals = structNew()>
	<cfloop collection="#arguments#" item="locals.i">
		<cfif locals.i IS NOT "properties">
			<cfset arguments.properties[locals.i] = arguments[locals.i]>
		</cfif>
	</cfloop>
	<cfreturn _createModelObject(properties=arguments.properties)>
</cffunction>


<cffunction name="create" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="no" default="#structNew()#">
	<cfset var locals = structNew()>
	<cfset locals.object = new(argumentCollection=arguments)>
	<cfset locals.object.save()>
	<cfreturn locals.object>
</cffunction>


<cffunction name="update" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="false" default="#structNew()#">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var locals = structNew()>

	<cfloop collection="#arguments#" item="locals.i">
		<cfif NOT listFindNoCase("properties,property,value", locals.i)>
			<cfset arguments.properties[locals.i] = arguments[locals.i]>
		</cfif>
	</cfloop>
	<cfif len(arguments.property) IS NOT 0>
		<cfset arguments.properties[arguments.property] = arguments.value>
	</cfif>

	<cfloop collection="#arguments.properties#" item="locals.i">
		<cfset this[locals.i] = arguments.properties[locals.i]>
	</cfloop>

	<cfreturn save()>
</cffunction>


<cffunction name="updateById" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="false" default="#structNew()#">
	<cfargument name="id" type="any" required="true">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var locals = structNew()>
	<cfset locals.object = findById(arguments.id)>
	<cfset structDelete(arguments, "id")>
	<cfreturn locals.object.update(argumentCollection=arguments)>
</cffunction>


<cffunction name="updateOne" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="false" default="#structNew()#">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="order" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var locals = structNew()>
	<cfset locals.object = findOne(where=arguments.where, order=arguments.order)>
	<cfset structDelete(arguments, "where")>
	<cfset structDelete(arguments, "order")>
	<cfreturn locals.object.update(argumentCollection=arguments)>
</cffunction>


<cffunction name="updateAll" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="false" default="#structNew()#">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="instantiate" type="any" required="false" default="false">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var locals = structNew()>

	<cfset locals.records = findAll(select="#variables.class.primaryKey# AS primaryKey", where=arguments.where)>

	<cfif NOT arguments.instantiate>
		<!--- just do a regular update query --->
		<cfif locals.records.recordCount IS NOT 0>
			<cfloop collection="#arguments#" item="locals.i">
				<cfif NOT listFindNoCase("properties,property,value,where,instantiate", locals.i)>
					<cfset arguments.properties[locals.i] = arguments[locals.i]>
				</cfif>
			</cfloop>
			<cfif len(arguments.property) IS NOT 0>
				<cfset arguments.properties[arguments.property] = arguments.value>
			</cfif>
			<cfquery name="locals.updateRecords" datasource="#variables.class.database.update.datasource#" username="#variables.class.database.update.username#" password="#variables.class.database.update.password#">
			UPDATE #variables.class.tableName#
			SET
			<cfset locals.pos = 0>
			<cfloop collection="#arguments.properties#" item="locals.i">
				<cfset locals.pos = locals.pos + 1>
				#locals.i# = <cfqueryparam cfsqltype="#variables.class.fields[locals.i].cfsqltype#" value="#arguments.properties[locals.i]#" null="#arguments.properties[locals.i] IS ''#">
				<cfif listLen(structKeyList(arguments.properties)) GT locals.pos>
					,
				</cfif>
			</cfloop>
			<cfif len(arguments.where) IS NOT 0>
				WHERE #variables.class.primaryKey# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(locals.records.primaryKey)#">)
			</cfif>
			</cfquery>
		</cfif>
	<cfelse>
		<!--- find and instantiate each object and call it's update function --->
		<cfset structDelete(arguments, "where")>
		<cfset structDelete(arguments, "instantiate")>
		<cfloop list="#valueList(locals.records.primaryKey)#" index="locals.i">
			<cfset locals.object = findById(locals.i)>
			<cfset locals.object.update(argumentCollection=arguments)>
		</cfloop>
	</cfif>

	<cfreturn locals.records.recordCount>
</cffunction>


<cffunction name="save" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>

	<cfset clearErrors()>
	<cfif structKeyExists(variables, "beforeValidation")>
		<cfset locals.callbackResult = beforeValidation()>
		<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif _isNew()>
		<cfif structKeyExists(variables, "beforeValidationOnCreate")>
			<cfset locals.callbackResult = beforeValidationOnCreate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfset _validateOnCreate()>
		<cfif hasErrors()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterValidationOnCreate")>
			<cfset locals.callbackResult = afterValidationOnCreate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
	<cfelse>
		<cfif structKeyExists(variables, "beforeValidationOnUpdate")>
			<cfset locals.callbackResult = beforeValidationOnUpdate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfset _validateOnUpdate()>
		<cfif hasErrors()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterValidationOnUpdate")>
			<cfset locals.callbackResult = afterValidationOnUpdate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	<cfset _validate()>
	<cfif hasErrors()>
		<cfreturn false>
	</cfif>
	<cfif structKeyExists(variables, "afterValidation")>
		<cfset locals.callbackResult = afterValidation()>
		<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif structKeyExists(variables, "beforeSave")>
		<cfset locals.callbackResult = beforeSave()>
		<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif _isNew()>
		<cfif structKeyExists(variables, "beforeCreate")>
			<cfset locals.callbackResult = beforeCreate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif NOT _insert()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterCreate")>
			<cfset locals.callbackResult = afterCreate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
	<cfelse>
		<cfif structKeyExists(variables, "beforeUpdate")>
			<cfset locals.callbackResult = beforeUpdate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif NOT _update()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterUpdate")>
			<cfset locals.callbackResult = afterUpdate()>
			<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	<cfif structKeyExists(variables, "afterSave")>
		<cfset locals.callbackResult = afterSave()>
		<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfreturn true>
</cffunction>


<cffunction name="delete" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>

	<cfif structKeyExists(variables, "beforeDelete")>
		<cfset locals.callbackResult = beforeDelete()>
		<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfquery name="locals.checkDeleted" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#">
	SELECT #variables.class.primaryKey#
	FROM #variables.class.tableName#
	WHERE #variables.class.primaryKey# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primaryKey]#">
	</cfquery>

	<cfif locals.checkDeleted.recordCount IS NOT 0>
		<cfif structKeyExists(variables.class.fields, "deletedAt") OR structKeyExists(variables.class.fields, "deletedOn")>
			<cfif structKeyExists(variables.class.fields, "deletedAt")>
				<cfset locals.softDeleteField = "deletedAt">
				<cfset locals.softDeleteTimestamp = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
			<cfelseif structKeyExists(variables.class.fields, "deletedOn")>
				<cfset locals.softDeleteField = "deletedOn">
				<cfset locals.softDeleteTimestamp = createDate(year(now()), month(now()), day(now()))>
			</cfif>
			<cfquery name="locals.deleteRecord" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#">
			UPDATE #variables.class.tableName#
			SET #locals.softDeleteField# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#locals.softDeleteTimestamp#">
			WHERE #variables.class.primaryKey# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primaryKey]#">
			</cfquery>
		<cfelse>
			<cfquery name="locals.deleteRecord" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#">
			DELETE
			FROM #variables.class.tableName#
			WHERE #variables.class.primaryKey# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primaryKey]#">
			</cfquery>
		</cfif>
	</cfif>

	<cfif structKeyExists(variables, "afterDelete")>
		<cfset locals.callbackResult = afterDelete()>
		<cfif structKeyExists(locals, "callbackResult") AND NOT locals.callbackResult>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfif locals.checkDeleted.recordCount IS NOT 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>

</cffunction>


<cffunction name="deleteById" returntype="any" access="public" output="false">
	<cfargument name="id" type="any" required="true">
	<cfset var locals = structNew()>
	<cfset locals.object = findById(arguments.id)>
	<cfif locals.object.found>
		<cfset locals.result = locals.object.delete()>
		<cfif locals.result IS 1>
			<cfset locals.result = true>
		<cfelse>
			<cfset locals.result = false>
		</cfif>
	<cfelse>
		<cfset locals.result = false>
	</cfif>
	<cfreturn locals.result>
</cffunction>


<cffunction name="deleteOne" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="order" type="any" required="false" default="">
	<cfset var locals = structNew()>
	<cfset locals.object = findOne(where=arguments.where, order=arguments.order)>
	<cfif locals.object.found>
		<cfset locals.result = locals.object.delete()>
		<cfif locals.result IS 1>
			<cfset locals.result = true>
		<cfelse>
			<cfset locals.result = false>
		</cfif>
	<cfelse>
		<cfset locals.result = false>
	</cfif>
	<cfreturn locals.result>
</cffunction>


<cffunction name="deleteAll" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="instantiate" type="any" required="false" default="false">
	<cfset var locals = structNew()>

	<cfset locals.records = findAll(select="#variables.class.primaryKey# AS primaryKey", where=arguments.where)>

	<cfif NOT arguments.instantiate>
		<!--- just do a regular delete query --->
		<cfif locals.records.recordCount IS NOT 0>
			<cfif structKeyExists(variables.class.fields, "deletedAt") OR structKeyExists(variables.class.fields, "deletedOn")>
				<cfif structKeyExists(variables.class.fields, "deletedAt")>
					<cfset locals.softDeleteField = "deletedAt">
					<cfset locals.softDeleteTimestamp = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
				<cfelseif structKeyExists(variables.class.fields, "deletedOn")>
					<cfset locals.softDeleteField = "deletedOn">
					<cfset locals.softDeleteTimestamp = createDate(year(now()), month(now()), day(now()))>
				</cfif>
				<cfquery name="locals.deleteRecords" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#">
				UPDATE #variables.class.tableName#
				SET #locals.softDeleteField# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#locals.softDeleteTimestamp#">
				<cfif len(arguments.where) IS NOT 0>
					WHERE #variables.class.primaryKey# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(locals.records.primaryKey)#">)
				</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="locals.deleteRecords" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#">
				DELETE
				FROM #variables.class.tableName#
				<cfif len(arguments.where) IS NOT 0>
					WHERE #variables.class.primaryKey# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(locals.records.primaryKey)#">)
				</cfif>
				</cfquery>
			</cfif>
		</cfif>
	<cfelse>
		<!--- find and instantiate each object and call it's delete function --->
		<cfloop list="#valueList(locals.records.primaryKey)#" index="locals.i">
			<cfset locals.object = findById(locals.i)>
			<cfset locals.object.delete()>
		</cfloop>
	</cfif>

	<cfreturn locals.records.recordCount>
</cffunction>


<cffunction name="_isNew" returntype="any" access="private" output="false">
	<cfif structKeyExists(this, variables.class.primaryKey) AND this[variables.class.primaryKey] IS NOT 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>


<cffunction name="_insert" returntype="any" access="private" output="false">
	<cfset var locals = structNew()>

	<cfif structKeyExists(variables.class.fields, "createdAt")>
		<cfset this.createdAt = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
	</cfif>

	<cfif structKeyExists(variables.class.fields, "createdOn")>
		<cfset this.createdOn = createDate(year(now()), month(now()), day(now()))>
	</cfif>

	<cfset variables.modifiedFields = "">
	<cfloop collection="#variables.class.fields#" item="locals.i">
		<cfif structKeyExists(this, locals.i) AND locals.i IS NOT variables.class.primaryKey>
			<cfset variables.modifiedFields = listAppend(variables.modifiedFields, locals.i)>
		</cfif>
	</cfloop>

	<cfquery name="locals.insertQuery" datasource="#variables.class.database.create.datasource#" username="#variables.class.database.create.username#" password="#variables.class.database.create.password#">
	INSERT INTO	#variables.class.tableName# (#variables.modifiedFields#)
	VALUES
	(
	<cfset locals.pos = 0>
	<cfloop list="#variables.modifiedFields#" index="locals.i">
		<cfset locals.pos = locals.pos + 1>
		<cfqueryparam cfsqltype="#variables.class.fields[locals.i].cfsqltype#" value="#this[locals.i]#" null="#this[locals.i] IS ''#">
		<cfif listLen(variables.modifiedFields) GT locals.pos>
			,
		</cfif>
	</cfloop>
	)

		<!---
		sql server supports multiple statements. using this and scope_identity() we
		can guarentee that we are returning the correct identity value that was last
		inserted
		 --->
		<cfif application.wheels.database.type IS "sqlserver">
		SELECT #application.wheels.adapter.selectLastID()# AS lastId
		</cfif>

	</cfquery>

	<!--- for sqlserver we need to get the identity from multi statement insert --->
	<cfif application.wheels.database.type IS "sqlserver">
		<cfset this[variables.class.primaryKey] = locals.insertQuery.lastId>
	</cfif>

	<!--- getting identity value from a mysql database --->
	<cfif application.wheels.database.type IS "mysql">

		<cfquery name="locals.getIdQuery" datasource="#variables.class.database.create.datasource#" username="#variables.class.database.create.username#" password="#variables.class.database.create.password#">
		SELECT #application.wheels.adapter.selectLastID()# AS lastId
		</cfquery>
		<cfset this[variables.class.primaryKey] = locals.getIdQuery.lastId>

	</cfif>

	<cfreturn true>
</cffunction>


<cffunction name="_update" returntype="any" access="private" output="false">
	<cfset var locals = structNew()>

	<cfif structKeyExists(variables.class.fields, "updatedAt")>
		<cfset this.updatedAt = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
	</cfif>

	<cfif structKeyExists(variables.class.fields, "updatedOn")>
		<cfset this.updatedOn = createDate(year(now()), month(now()), day(now()))>
	</cfif>

	<cfquery name="locals.getDataQuery" datasource="#variables.class.database.update.datasource#" username="#variables.class.database.update.username#" password="#variables.class.database.update.password#">
	SELECT #structKeyList(variables.class.fields)#
	FROM #variables.class.tableName#
	WHERE #variables.class.primaryKey# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primaryKey]#">
	</cfquery>

	<cfset variables.modifiedFields = "">
	<cfloop collection="#variables.class.fields#" item="locals.i">
		<cfif structKeyExists(this, locals.i) AND locals.i IS NOT variables.class.primaryKey AND this[locals.i] IS NOT locals.getDataQuery[locals.i][1]>
			<cfset variables.modifiedFields = listAppend(variables.modifiedFields, locals.i)>
		</cfif>
	</cfloop>

	<cfif locals.getDataQuery.recordCount IS NOT 0>
		<cfif variables.modifiedFields IS NOT "">
			<cfquery name="locals.updateQuery" datasource="#variables.class.database.update.datasource#" username="#variables.class.database.update.username#" password="#variables.class.database.update.password#">
			UPDATE #variables.class.tableName#
			SET
			<cfset locals.pos = 0>
			<cfloop list="#variables.modifiedFields#" index="locals.i">
				<cfset locals.pos = locals.pos + 1>
				#locals.i# = <cfqueryparam cfsqltype="#variables.class.fields[locals.i].cfsqltype#" value="#this[locals.i]#" null="#this[locals.i] IS ''#">
				<cfif listLen(variables.modifiedFields) GT locals.pos>
					,
				</cfif>
			</cfloop>
			WHERE #variables.class.primaryKey# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primaryKey]#">
			</cfquery>
		</cfif>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>