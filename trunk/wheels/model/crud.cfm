<cffunction name="new" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="no" default="#structNew()#">
	<cfset var local = structNew()>

	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "attributes">
			<cfset arguments.attributes[local.i] = arguments[local.i]>
		</cfif>
	</cfloop>

	<cfreturn CFW_createModelObject(arguments.attributes)>
</cffunction>


<cffunction name="create" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="no" default="#structNew()#">
	<cfset var local = structNew()>

	<cfset local.object = new(argumentCollection=arguments)>
	<cfset local.object.save()>

	<cfreturn local.object>
</cffunction>


<cffunction name="update" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="no" default="#structNew()#">
	<cfset var local = structNew()>

	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "attributes">
			<cfset arguments.attributes[local.i] = arguments[local.i]>
		</cfif>
	</cfloop>

	<cfloop collection="#arguments.attributes#" item="local.i">
		<cfset this[local.i] = arguments.attributes[local.i]>
	</cfloop>

	<cfreturn save()>
</cffunction>


<cffunction name="updateAll" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="#structNew()#">
	<cfargument name="instantiate" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset local.records = findAll(select="#variables.class.primary_key# AS primary_key", where=arguments.where)>

	<cfif NOT arguments.instantiate>
		<!--- just do a regular update query --->
		<cfif local.records.recordcount IS NOT 0>
			<cfloop collection="#arguments#" item="local.i">
				<cfif local.i IS NOT "where" AND local.i IS NOT "attributes" AND local.i IS NOT "instantiate">
					<cfset arguments.attributes[local.i] = arguments[local.i]>
				</cfif>
			</cfloop>
			<cfquery name="local.update_records" datasource="#variables.class.database.update.datasource#" username="#variables.class.database.update.username#" password="#variables.class.database.update.password#" timeout="#variables.class.database.update.timeout#">
			UPDATE #variables.class.table_name#
			SET
			<cfloop collection="#arguments.attributes#" item="local.i">
			#local.i# = <cfqueryparam cfsqltype="#variables.class.columns[local.i].cfsqltype#" value="#arguments.attributes[local.i]#" null="#arguments.attributes[local.i] IS ''#">
			</cfloop>
			<cfif len(arguments.where) IS NOT 0>
				WHERE #variables.class.primary_key# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(local.records.primary_key)#">)
			</cfif>
			</cfquery>
		</cfif>
	<cfelse>
		<!--- find and instantiate each object and call it's update function --->
		<cfset update_arguments = duplicate(arguments)>
		<cfset structDelete(update_arguments, "where")>
		<cfset structDelete(update_arguments, "instantiate")>
		<cfloop query="local.records">
			<cfset local.object = findByID(primary_key)>
			<cfset local.object.update(argumentCollection=update_arguments)>
		</cfloop>
	</cfif>

	<cfreturn local.records.recordcount>
</cffunction>


<cffunction name="save" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfset clearErrors()>
	<cfif structKeyExists(variables, "beforeValidation")>
		<cfset local.callback_result = beforeValidation()>
		<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif CFW_isNew()>
		<cfif structKeyExists(variables, "beforeValidationOnCreate")>
			<cfset local.callback_result = beforeValidationOnCreate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfset CFW_validateOnCreate()>
		<cfif hasErrors()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterValidationOnCreate")>
			<cfset local.callback_result = afterValidationOnCreate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	<cfelse>
		<cfif structKeyExists(variables, "beforeValidationOnUpdate")>
			<cfset local.callback_result = beforeValidationOnUpdate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfset CFW_validateOnUpdate()>
		<cfif hasErrors()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterValidationOnUpdate")>
			<cfset local.callback_result = afterValidationOnUpdate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	<cfset CFW_validate()>
	<cfif hasErrors()>
		<cfreturn false>
	</cfif>
	<cfif structKeyExists(variables, "afterValidation")>
		<cfset local.callback_result = afterValidation()>
		<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif structKeyExists(variables, "beforeSave")>
		<cfset local.callback_result = beforeSave()>
		<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif CFW_isNew()>
		<cfif structKeyExists(variables, "beforeCreate")>
			<cfset local.callback_result = beforeCreate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif NOT CFW_insert()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterCreate")>
			<cfset local.callback_result = afterCreate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	<cfelse>
		<cfif structKeyExists(variables, "beforeUpdate")>
			<cfset local.callback_result = beforeUpdate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif NOT CFW_update()>
			<cfreturn false>
		</cfif>
		<cfif structKeyExists(variables, "afterUpdate")>
			<cfset local.callback_result = afterUpdate()>
			<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	<cfif structKeyExists(variables, "afterSave")>
		<cfset local.callback_result = afterSave()>
		<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfreturn true>
</cffunction>


<cffunction name="delete" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables, "beforeDelete")>
		<cfset local.callback_result = beforeDelete()>
		<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfquery name="local.check_deleted" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#" timeout="#variables.class.database.delete.timeout#">
	SELECT #variables.class.primary_key#
	FROM #variables.class.table_name#
	WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
	</cfquery>

	<cfif local.check_deleted.recordcount IS NOT 0>
		<cfif structKeyExists(variables.class.columns, "deleted_at") OR structKeyExists(variables.class.columns, "deleted_on")>
			<cfif structKeyExists(variables.class.columns, "deleted_at")>
				<cfset local.soft_delete_field = "deleted_at">
				<cfset local.soft_delete_timestamp = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
			<cfelseif structKeyExists(variables.class.columns, "deleted_on")>
				<cfset local.soft_delete_field = "deleted_on">
				<cfset local.soft_delete_timestamp = createDate(year(now()), month(now()), day(now()))>
			</cfif>
			<cfquery name="local.delete_record" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#" timeout="#variables.class.database.delete.timeout#">
			UPDATE #variables.class.table_name#
			SET #local.soft_delete_field# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.soft_delete_timestamp#">
			WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
			</cfquery>
		<cfelse>
			<cfquery name="local.delete_record" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#" timeout="#variables.class.database.delete.timeout#">
			DELETE
			FROM #variables.class.table_name#
			WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
			</cfquery>
		</cfif>
	</cfif>

	<cfif structKeyExists(variables, "afterDelete")>
		<cfset local.callback_result = afterDelete()>
		<cfif structKeyExists(local, "callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfreturn local.check_deleted.recordcount>
</cffunction>


<cffunction name="deleteAll" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="instantiate" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset local.records = findAll(select="#variables.class.primary_key# AS primary_key", where=arguments.where)>

	<cfif NOT arguments.instantiate>
		<!--- just do a regular delete query --->
		<cfif local.records.recordcount IS NOT 0>
			<cfif structKeyExists(variables.class.columns, "deleted_at") OR structKeyExists(variables.class.columns, "deleted_on")>
				<cfif structKeyExists(variables.class.columns, "deleted_at")>
					<cfset local.soft_delete_field = "deleted_at">
					<cfset local.soft_delete_timestamp = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
				<cfelseif structKeyExists(variables.class.columns, "deleted_on")>
					<cfset local.soft_delete_field = "deleted_on">
					<cfset local.soft_delete_timestamp = createDate(year(now()), month(now()), day(now()))>
				</cfif>
				<cfquery name="local.delete_records" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#" timeout="#variables.class.database.delete.timeout#">
				UPDATE #variables.class.table_name#
				SET #local.soft_delete_field# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.soft_delete_timestamp#">
				<cfif len(arguments.where) IS NOT 0>
					WHERE #variables.class.primary_key# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(local.records.primary_key)#">)
				</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="local.delete_records" datasource="#variables.class.database.delete.datasource#" username="#variables.class.database.delete.username#" password="#variables.class.database.delete.password#" timeout="#variables.class.database.delete.timeout#">
				DELETE
				FROM #variables.class.table_name#
				<cfif len(arguments.where) IS NOT 0>
					WHERE #variables.class.primary_key# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(local.records.primary_key)#">)
				</cfif>
				</cfquery>
			</cfif>
		</cfif>
	<cfelse>
		<!--- find and instantiate each object and call it's delete function --->
		<cfloop query="local.records">
			<cfset local.object = findByID(primary_key)>
			<cfset local.object.delete()>
		</cfloop>
	</cfif>

	<cfreturn local.records.recordcount>
</cffunction>


<cffunction name="CFW_isNew" returntype="any" access="private" output="false">
	<cfif structKeyExists(this, variables.class.primary_key) AND this[variables.class.primary_key] IS NOT 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>


<cffunction name="CFW_insert" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables.class.columns, "created_at")>
		<cfset this.created_at = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
	</cfif>

	<cfif structKeyExists(variables.class.columns, "created_on")>
		<cfset this.created_on = createDate(year(now()), month(now()), day(now()))>
	</cfif>

	<cfset variables.modified_fields = "">
	<cfloop collection="#variables.class.columns#" item="local.i">
		<cfif structKeyExists(this, local.i) AND local.i IS NOT variables.class.primary_key>
			<cfset variables.modified_fields = listAppend(variables.modified_fields, local.i)>
		</cfif>
	</cfloop>

	<cfquery name="local.insert_query" datasource="#variables.class.database.create.datasource#" username="#variables.class.database.create.username#" password="#variables.class.database.create.password#" timeout="#variables.class.database.create.timeout#">
	INSERT INTO	#variables.class.table_name# (#variables.modified_fields#)
	VALUES
	(
	<cfset local.pos = 0>
	<cfloop list="#variables.modified_fields#" index="local.i">
		<cfset local.pos = local.pos + 1>
		<cfqueryparam cfsqltype="#variables.class.columns[local.i].cfsqltype#" value="#this[local.i]#" null="#this[local.i] IS ''#">
		<cfif listLen(variables.modified_fields) GT local.pos>
			,
		</cfif>
	</cfloop>
	)
	</cfquery>
	<cfquery name="local.get_id_query" datasource="#variables.class.database.create.datasource#" username="#variables.class.database.create.username#" password="#variables.class.database.create.password#" timeout="#variables.class.database.create.timeout#">
	SELECT #application.wheels.adapter.selectLastID()# AS last_id
	</cfquery>
	<cfset this[variables.class.primary_key] = local.get_id_query.last_id>

	<cfreturn true>
</cffunction>


<cffunction name="CFW_update" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables.class.columns, "updated_at")>
		<cfset this.updated_at = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
	</cfif>

	<cfif structKeyExists(variables.class.columns, "updated_on")>
		<cfset this.updated_on = createDate(year(now()), month(now()), day(now()))>
	</cfif>

	<cfquery name="local.get_data_query" datasource="#variables.class.database.update.datasource#" username="#variables.class.database.update.username#" password="#variables.class.database.update.password#" timeout="#variables.class.database.update.timeout#">
	SELECT #structKeyList(variables.class.columns)#
	FROM #variables.class.table_name#
	WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
	</cfquery>

	<cfset variables.modified_fields = "">
	<cfloop collection="#variables.class.columns#" item="local.i">
		<cfif structKeyExists(this, local.i) AND local.i IS NOT variables.class.primary_key AND this[local.i] IS NOT local.get_data_query[local.i][1]>
			<cfset variables.modified_fields = listAppend(variables.modified_fields, local.i)>
		</cfif>
	</cfloop>

	<cfif local.get_data_query.recordcount IS NOT 0>
		<cfif variables.modified_fields IS NOT "">
			<cfquery name="local.update_query" datasource="#variables.class.database.update.datasource#" username="#variables.class.database.update.username#" password="#variables.class.database.update.password#" timeout="#variables.class.database.update.timeout#">
			UPDATE #variables.class.table_name#
			SET
			<cfset local.pos = 0>
			<cfloop list="#variables.modified_fields#" index="local.i">
				<cfset local.pos = local.pos + 1>
				#local.i# = <cfqueryparam cfsqltype="#variables.class.columns[local.i].cfsqltype#" value="#this[local.i]#" null="#this[local.i] IS ''#">
				<cfif listLen(variables.modified_fields) GT local.pos>
					,
				</cfif>
			</cfloop>
			WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
			</cfquery>
		</cfif>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>