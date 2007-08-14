<cffunction name="new" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="no" default="#structNew()#">
	<cfset var local = structNew()>

	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "attributes">
			<cfset arguments.attributes[local.i] = arguments[local.i]>
		</cfif>
	</cfloop>

	<cfreturn FL_new(arguments.attributes)>
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
			<cfquery name="local.update_records" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
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

	<cfset clearErrors()>
	<cfif isDefined("beforeValidation")>
		<cfset local.callback_result = beforeValidation()>
		<cfif isDefined("local.callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif FL_isNew()>
		<cfif isDefined("beforeValidationOnCreate")>
			<cfset local.callback_result = beforeValidationOnCreate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfset FL_validateOnCreate()>
		<cfif hasErrors()>
			<cfreturn false>
		</cfif>
		<cfif isDefined("afterValidationOnCreate")>
			<cfset local.callback_result = afterValidationOnCreate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	<cfelse>
		<cfif isDefined("beforeValidationOnUpdate")>
			<cfset local.callback_result = beforeValidationOnUpdate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfset FL_validateOnUpdate()>
		<cfif hasErrors()>
			<cfreturn false>
		</cfif>
		<cfif isDefined("afterValidationOnUpdate")>
			<cfset local.callback_result = afterValidationOnUpdate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	<cfset FL_validate()>
	<cfif hasErrors()>
		<cfreturn false>
	</cfif>
	<cfif isDefined("afterValidation")>
		<cfset local.callback_result = afterValidation()>
		<cfif isDefined("local.callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif isDefined("beforeSave")>
		<cfset local.callback_result = beforeSave()>
		<cfif isDefined("local.callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>
	<cfif FL_isNew()>
		<cfif isDefined("beforeCreate")>
			<cfset local.callback_result = beforeCreate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif NOT FL_insert()>
			<cfreturn false>
		</cfif>
		<cfif isDefined("afterCreate")>
			<cfset local.callback_result = afterCreate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	<cfelse>
		<cfif isDefined("beforeUpdate")>
			<cfset local.callback_result = beforeUpdate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif NOT FL_update()>
			<cfreturn false>
		</cfif>
		<cfif isDefined("afterUpdate")>
			<cfset local.callback_result = afterUpdate()>
			<cfif isDefined("local.callback_result") AND NOT local.callback_result>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	<cfif isDefined("afterSave")>
		<cfset local.callback_result = afterSave()>
		<cfif isDefined("local.callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfreturn true>
</cffunction>


<cffunction name="delete" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfif isDefined("beforeDelete")>
		<cfset local.callback_result = beforeDelete()>
		<cfif isDefined("local.callback_result") AND NOT local.callback_result>
			<cfreturn false>
		</cfif>
	</cfif>

	<cfquery name="local.check_deleted" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
	SELECT #variables.class.primary_key#
	FROM #variables.class.table_name#
	WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
	</cfquery>

	<cfif local.check_deleted.recordcount IS NOT 0>
		<cfif structKeyExists(variables.class.columns, "deleted_at")>
			<cfquery name="local.delete_record" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
			UPDATE #variables.class.table_name#
			SET deleted_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
			</cfquery>
		<cfelse>
			<cfquery name="local.delete_record" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
			DELETE
			FROM #variables.class.table_name#
			WHERE #variables.class.primary_key# = <cfqueryparam cfsqltype="cf_sql_integer" value="#this[variables.class.primary_key]#">
			</cfquery>
		</cfif>
	</cfif>

	<cfif isDefined("afterDelete")>
		<cfset local.callback_result = afterDelete()>
		<cfif isDefined("local.callback_result") AND NOT local.callback_result>
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
			<cfif structKeyExists(variables.class.columns, "deleted_at")>
				<cfquery name="local.delete_records" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
				UPDATE #variables.class.table_name#
				SET deleted_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				<cfif len(arguments.where) IS NOT 0>
					WHERE #variables.class.primary_key# IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(local.records.primary_key)#">)
				</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="local.delete_records" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
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


<cffunction name="FL_new" returntype="any" access="private" output="false">
	<cfargument name="attributes" type="any" required="no" default="">
	<cfset var local = structNew()>

	<cfset local.object = createObject("component", "#application.wheels.cfc_path#models.#variables.class.model_name#").FL_initObject(arguments.attributes)>

	<cfreturn local.object>
</cffunction>


<cffunction name="FL_isNew" returntype="any" access="private" output="false">
	<cfif structKeyExists(this, variables.class.primary_key) AND this[variables.class.primary_key] IS NOT 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>


<cffunction name="FL_insert" returntype="any" access="private" output="false">
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

	<cfquery name="local.insert_query" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
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
	<cfquery name="local.get_id_query" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
	SELECT #application.wheels.adapter.selectLastID()# AS last_id
	</cfquery>
	<cfset this[variables.class.primary_key] = local.get_id_query.last_id>

	<cfreturn true>
</cffunction>


<cffunction name="FL_update" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables.class.columns, "updated_at")>
		<cfset this.updated_at = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>
	</cfif>

	<cfif structKeyExists(variables.class.columns, "updated_on")>
		<cfset this.updated_on = createDate(year(now()), month(now()), day(now()))>
	</cfif>

	<cfquery name="local.get_data_query" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
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
			<cfquery name="local.update_query" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
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