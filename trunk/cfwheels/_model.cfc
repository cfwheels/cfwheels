<cfcomponent name="Model">

	<!--- Global variables --->
	<cfset this.model_functions = "findByID,findAll,findOne,new,create,init,getColumnInfo,getColumnList,setTableName,getTableName,setPrimaryKey,getPrimaryKey">
	<cfset this.object_functions = "init,update,destroy,save,model,isNewRecord">

	<!--- Include common functions --->
	<cfinclude template="#application.pathTo.includes#/request_includes.cfm">


	<!--- Initialize the current object (do it from the model file stored in application scope if it is available to speed things up) --->
	<cffunction name="init" returntype="any" access="public" output="false">
		<cfset var get_columns_query = "">	
	
		<cfset variables.model_name = listLast(getMetaData(this).name, ".")>
	
		<cfif structKeyExists(application.wheels.models, variables.model_name)>
		
			<cfset variables.table_name = application.wheels.models[variables.model_name].getTableName()>
			<cfset variables.primary_key = application.wheels.models[variables.model_name].getPrimaryKey()>
			<cfset variables.column_list = application.wheels.models[variables.model_name].getColumnList()>
			<cfset variables.column_info = duplicate(application.wheels.models[variables.model_name].getColumnInfo())>
	
		<cfelse>
		
			<cfif NOT structKeyExists(variables, "table_name")>
				<cfset variables.table_name = pluralize(variables.model_name)>
			</cfif>
			<cfif NOT structKeyExists(variables, "primary_key")>
				<cfset variables.primary_key = "id">
			</cfif>
		
			<cfquery name="get_columns_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			SELECT column_name, data_type, is_nullable, character_maximum_length, column_default
			FROM information_schema.columns
			WHERE table_name = '#variables.table_name#' AND table_schema = '#application.database.name#'
			</cfquery>

			<cfset variables.column_list = valueList(get_columns_query.column_name)>
			<cfloop query="get_columns_query">
				<cfset "variables.column_info.#column_name#.db_sql_type" = data_type>		
				<cfset "variables.column_info.#column_name#.cf_sql_type" = getCFSQLType(data_type)>		
				<cfset "variables.column_info.#column_name#.cf_data_type" = getCFDataType(data_type)>
				<cfset "variables.column_info.#column_name#.nullable" = is_nullable>		
				<cfset "variables.column_info.#column_name#.max_length" = character_maximum_length>		
				<cfset "variables.column_info.#column_name#.default" = column_default>		
			</cfloop>
		
		</cfif>
	
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="getCFSQLType" returntype="string" access="private" output="false">
		<cfargument name="db_sql_type" type="string" required="yes">	
		<cfset var result = "">
		<cfinclude template="includes/db_#application.database.type#.cfm">
		<cfreturn result>
	</cffunction>
	
	
	<cffunction name="getCFDataType" returntype="string" access="private" output="false">
		<cfargument name="db_sql_type" type="string" required="yes">	
		<cfset var result = "">
		<cfinclude template="includes/cf_#application.database.type#.cfm">
		<cfreturn result>
	</cffunction>


	<cffunction name="setTableName" returntype="void" access="public" output="false">
		<cfargument name="name" type="string" required="yes">
		<cfset variables.table_name = arguments.name>
	</cffunction>
	
	
	<cffunction name="setPrimaryKey" returntype="void" access="public" output="false">
		<cfargument name="name" type="string" required="yes">
		<cfset variables.primary_key = arguments.name>
	</cffunction>
	
	
	<cffunction name="getTableName" returntype="string" access="public" output="false">
		<cfreturn variables.table_name>
	</cffunction>
	
	
	<cffunction name="getPrimaryKey" returntype="string" access="public" output="false">
		<cfreturn variables.primary_key>
	</cffunction>
	
	
	<cffunction name="getColumnList" returntype="string" access="public" output="false">
		<cfreturn variables.column_list>
	</cffunction>
	
	
	<cffunction name="getColumnInfo" returntype="struct" access="public" output="false">
		<cfreturn variables.column_info>
	</cffunction>
	
	
	<cffunction name="new" returntype="any" access="public" output="false">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#">

		<cfset var i = "">

		<cfloop collection="#arguments#" item="i">
			<cfif i IS NOT "attributes">
				<cfset arguments.attributes[i] = arguments[i]>
			</cfif>
		</cfloop>
		
		<cfreturn newObject(arguments.attributes)>
	</cffunction>


	<cffunction name="create" returntype="any" access="public" output="false">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#">

		<cfset var new_object = "">

		<cfset new_object = new(argumentCollection=arguments)>
		<cfset new_object.save()>
		
		<cfreturn new_object>
	</cffunction>


	<cffunction name="newObject" returntype="any" access="private" output="false">
		<cfargument name="value_collection" type="any" required="yes">
	
		<cfset var i = "">
		<cfset var new_object = "">
		
		<cfset new_object = createObject("component", "app.models.#variables.model_name#").init()>
		<cfset new_object.recordfound = false>
		<cfset new_object.recordcount = 0>

		<cfif isQuery(arguments.value_collection) AND arguments.value_collection.recordcount GT 0>
			<cfset new_object.query = arguments.value_collection>
			<cfset new_object.recordfound = true>
			<cfset new_object.recordcount = arguments.value_collection.recordcount>
			<cfloop list="#arguments.value_collection.columnlist#" index="i">
				<cfif listFindNoCase(variables.column_list, i) IS NOT 0>
					<cfset new_object[replaceNoCase(i, (variables.model_name & "_"), "")] = arguments.value_collection[i][1]>
				</cfif>
			</cfloop>
		<cfelseif isStruct(arguments.value_collection) AND structCount(arguments.value_collection) GT 0>
			<cfset new_object.query = queryNew(structKeyList(arguments.value_collection))>
			<cfset queryAddRow(new_object.query, 1)>
			<cfloop collection="#arguments.value_collection#" item="i">
				<cfset querySetCell(new_object.query, i, arguments.value_collection[i])>
			</cfloop>
			<cfset new_object.recordfound = true>
			<cfset new_object.recordcount = structCount(arguments.value_collection)>
			<cfloop collection="#arguments.value_collection#" item="i">
				<cfif listFindNoCase(variables.column_list, i) IS NOT 0>
					<cfset new_object[i] = arguments.value_collection[i]>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Remove model functions --->
		<cfloop list="#this.model_functions#" index="i">
			<cfset "new_object.#i#" = "Model function (not available for individual objects)">
		</cfloop>
	
		<cfreturn new_object>
	</cffunction>
	
	
	<cffunction name="save" returntype="boolean" access="public" output="false">

		<cfif isNewRecord()>
			<cfif NOT insertRecord()>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfif NOT updateRecord()>
				<cfreturn false>
			</cfif>
		</cfif>
	
		<cfreturn true>
	</cffunction>


	<cffunction name="isNewRecord" returntype="boolean" access="public" output="false">
		<cfif structKeyExists(this, variables.primary_key) AND this[variables.primary_key] GT 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	
	<cffunction name="insertRecord" returntype="boolean" access="private" output="false">
		<cfset var insert_columns = "">
		<cfset var insert_query = "">
		<cfset var get_id_query = "">
		<cfset var pos = 0>
		<cfset var i = "">
	
		<cfloop list="#variables.column_list#" index="i">
			<cfif structKeyExists(this, i) AND i IS NOT variables.primary_key>
				<cfset insert_columns = listAppend(insert_columns, i)>
			</cfif>
		</cfloop>
	
		<cfquery name="insert_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		INSERT INTO	#variables.table_name#(#insert_columns#)
		VALUES (
		<cfset pos = 0>
		<cfloop list="#insert_columns#" index="i">
			<cfset pos = pos + 1>
			<cfqueryparam cfsqltype="#variables.column_info[i].cf_sql_type#" value="#this[i]#" null="#this[i] IS ''#">
			<cfif listLen(insert_columns) GT pos>
				,
			</cfif>
		</cfloop>
		)
		</cfquery>
		<cfquery name="get_id_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT
		<cfif application.database.type IS "sqlserver">
			SCOPE_IDENTITY() AS last_id
		<cfelseif application.database.type IS "mysql5">
			LAST_INSERTED_ID() AS last_id
		</cfif>
		</cfquery>
		<cfset this[variables.primary_key] = get_id_query.last_id>
		
		<!--- If the database sets any defaults, set them here if they're not already defined --->
		<cfloop list="#insert_columns#" index="i">
			<cfif NOT structKeyExists(this, i) AND variables.column_info[i].default IS NOT "">
				<cfset this[i] = replaceList(variables.column_info[i].default, "',(,)", ",,")>
			</cfif>
		</cfloop>
		
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="updateRecord" returntype="boolean" access="private" output="false">
		<cfset var update_columns = "">
		<cfset var update_query = "">
		<cfset var get_id_query = "">
		<cfset var pos = 0>
		<cfset var i = "">
	
		<cfloop list="#variables.column_list#" index="i">
			<cfif structKeyExists(this, i) AND i IS NOT variables.primary_key>
				<cfset update_columns = listAppend(update_columns, i)>
			</cfif>
		</cfloop>
	
		<cfquery name="get_id_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#" maxrows="1">
		SELECT #variables.primary_key#
		FROM #variables.table_name#
		WHERE #variables.primary_key# = #this[variables.primary_key]#
		</cfquery>
	
		<cfif get_id_query.recordcount IS NOT 0>
	
			<cfquery name="update_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			UPDATE #variables.table_name#
			SET
			<cfloop list="#update_columns#" index="i">
				<cfset pos = pos + 1>
				#i# = <cfqueryparam cfsqltype="#variables.column_info[i].cf_sql_type#" value="#this[i]#" null="#this[i] IS ''#">
				<cfif listLen(update_columns) GT pos>
					,
				</cfif>
			</cfloop>
			WHERE #variables.primary_key# = #this[variables.primary_key]#
			</cfquery>		
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	

	<cffunction name="findByID" access="public" returntype="any" output="false">
		<cfargument name="id" required="yes" type="numeric">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
	
		<cfset var returned_object = "">

		<cfset structInsert(arguments, "where", "#variables.table_name#.#variables.primary_key# = #arguments.id#")>
		<cfset structDelete(arguments, "id")>
		<cfset returned_object = findAll(argumentCollection=arguments)>
	
		<cfif returned_object.recordfound>
			<cfreturn returned_object>
		<cfelse>
			<cfthrow type="wheels.record_not_found" message="Record Not Found: a record with an id of #arguments.id# was not found in the '#variables.table_name#' table." detail="Correct the '#variables.table_name#' table by adding a record with an id of #arguments.id# or look for a different record.">
		</cfif>
		
	</cffunction>
	
	
	<cffunction name="findOne" access="public" returntype="any" output="false">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="order" type="string" required="no" default="">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
	
		<cfset var returned_object = "">

		<cfset structInsert(arguments, "limit", 1)>
		<cfset returned_object = findAll(argumentCollection=arguments)>
	
		<cfreturn returned_object>
	</cffunction>

	
	<cffunction name="findAll" access="public" output="false" hint="">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="order" type="string" required="no" default="">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
		<cfargument name="limit" type="numeric" required="no" default=0>

		<cfset var finder_query = "">

		<cfset select_clause = createSelectClause(argumentCollection=arguments)>
		<cfset from_clause = createfromClause(argumentCollection=arguments)>
		<cfset where_clause = createWhereClause(argumentCollection=arguments)>
		<cfset order_clause = createOrderClause(argumentCollection=arguments)>
		
		<cfquery name="finder_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT
		<cfif application.database.type IS "sqlserver" AND arguments.limit IS NOT 0>
			TOP #arguments.limit#
		</cfif>
		#select_clause#
		FROM #from_clause#
		<cfif where_clause IS NOT "">
			WHERE #preserveSingleQuotes(where_clause)#
		</cfif>
		ORDER BY #order_clause#
		<cfif application.database.type IS "mysql5" AND arguments.limit IS NOT 0>
			LIMIT #arguments.limit#
		</cfif>
		</cfquery>

		<cfreturn newObject(finder_query)>
	</cffunction>


	<cffunction name="createSelectClause" returntype="string" access="private" output="false">
	
		<cfset var select_clause = "">
		<cfset var i = "">
		
		<cfif arguments.select IS NOT "">
			<!--- Loop through the fields the developer supplied, prepend table name where necessary --->
			<cfloop list="#arguments.select#" index="i">
				<cfif i Contains ".">
					<cfset select_clause = listAppend(select_clause, "#trim(i)# AS #variables.model_name#_#listLast(trim(i), '.')#")>
				<cfelse>
					<cfset select_clause = listAppend(select_clause, "#variables.table_name#.#trim(i)# AS #variables.model_name#_#trim(i)#")>
				</cfif>
			</cfloop>
		<cfelse>
			<!--- Loop through list of columns and select all of them in the query --->
			<cfloop list="#variables.column_list#" index="i">
				<cfset select_clause = listAppend(select_clause, "#variables.table_name#.#trim(i)# AS #variables.model_name#_#trim(i)#")>
			</cfloop>
		</cfif>
	
		<cfreturn select_clause>
	</cffunction>
	

	<cffunction name="createFromClause" returntype="string" access="private" output="false">
	
		<cfset var from_clause = "">
		
		<cfset from_clause = variables.table_name>
		<cfif arguments.joins IS NOT "">
			<cfset from_clause = from_clause & " " & arguments.joins>	
		</cfif>
	
		<cfreturn from_clause>
	</cffunction>


	<cffunction name="createWhereClause" returntype="string" access="private" output="false">
	
		<cfset var where_clause = "">
		
		<cfif arguments.where IS NOT "">
			<cfset where_clause = arguments.where>	
		</cfif>
	
		<cfreturn where_clause>
	</cffunction>


	<cffunction name="createOrderClause" returntype="string" access="private" output="false">
	
		<cfset var order_clause = "">
		<cfset var i = "">
		
		<cfif arguments.order IS NOT "">
			<cfloop list="#arguments.order#" index="i">
				<cfif i Does Not Contain "ASC" AND i Does Not Contain "DESC">
					<cfset i = trim(i) & " ASC">
				</cfif>
				<cfif i Contains ".">
					<cfset order_clause = listAppend(order_clause, trim(i))>
				<cfelse>
					<cfset order_clause = listAppend(order_clause, "#variables.table_name#.#trim(i)#")>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset order_clause = variables.table_name & "." & variables.primary_key & " ASC">
		</cfif>
	
		<cfreturn order_clause>
	</cffunction>


	<cffunction name="update" returntype="boolean" access="public" output="false">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#">
	
		<cfset var i = "">
	
		<cfloop collection="#arguments#" item="i">
			<cfif i IS NOT "attributes">
				<cfset arguments.attributes[i] = arguments[i]>
			</cfif>
		</cfloop>
	
		<cfloop collection="#arguments.attributes#" item="i">
			<cfset this[i] = arguments.attributes[i]>
		</cfloop>
	
		<cfreturn save()>
	</cffunction>
	
	
	<cffunction name="destroy" returntype="boolean" access="public" output="false">
	
		<cfset var check_deleted = "">
		<cfset var delete_record = "">
	
		<cfquery name="check_deleted" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT #variables.primary_key#
		FROM #variables.table_name#
		WHERE #variables.primary_key# = #this[variables.primary_key]#
		</cfquery>
	
		<cfif check_deleted.recordCount IS NOT 0>
			<cfquery name="delete_record" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			DELETE
			FROM #variables.table_name#
			WHERE #variables.primary_key# = #this[variables.primary_key]#
			</cfquery>
		</cfif>
	
		<cfreturn check_deleted.recordcount>
	</cffunction>


	<cffunction name="validatesConfirmationOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# is reserved">
		<cfargument name="on" type="string" required="no" default="save">
		
		<cfset "variables.validations_on_#arguments.on#.validates_confirmation_of.#arguments.field#.message" = arguments.message>
	
	</cffunction>


	<cffunction name="validatesExclusionOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# is reserved">
		<cfargument name="in" type="string" required="yes">
		<cfargument name="allow_nil" type="boolean" required="no" default="false">
		
		<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>
	
		<cfset "variables.validations_on_save.validates_exclusion_of.#arguments.field#.message" = arguments.message>
		<cfset "variables.validations_on_save.validates_exclusion_of.#arguments.field#.allow_nil" = arguments.allow_nil>
		<cfset "variables.validations_on_save.validates_exclusion_of.#arguments.field#.in" = arguments.in>
	
	</cffunction>

	
	<cffunction name="validatesFormatOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# is invalid">
		<cfargument name="allow_nil" type="boolean" required="no" default="false">
		<cfargument name="with" type="string" required="yes">
		<cfargument name="on" type="string" required="no" default="save">
		
		<cfset "variables.validations_on_#arguments.on#.validates_format_of.#arguments.field#.message" = arguments.message>
		<cfset "variables.validations_on_#arguments.on#.validates_format_of.#arguments.field#.allow_nil" = arguments.allow_nil>
		<cfset "variables.validations_on_#arguments.on#.validates_format_of.#arguments.field#.with" = arguments.with>
	
	</cffunction>
	
	
	<cffunction name="validatesInclusionOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# is not included in the list">
		<cfargument name="in" type="string" required="yes">
		<cfargument name="allow_nil" type="boolean" required="no" default="false">
	
		<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>
	
		<cfset "variables.validations_on_save.validates_inclusion_of.#arguments.field#.message" = arguments.message>
		<cfset "variables.validations_on_save.validates_inclusion_of.#arguments.field#.allow_nil" = arguments.allow_nil>
		<cfset "variables.validations_on_save.validates_inclusion_of.#arguments.field#.in" = arguments.in>
	
	</cffunction>
	
	
	<cffunction name="validatesLengthOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# is the wrong length">
		<cfargument name="allow_nil" type="boolean" required="no" default="false">
		<cfargument name="exactly" type="numeric" required="no" default=0>
		<cfargument name="maximum" type="numeric" required="no" default=0>
		<cfargument name="minimum" type="numeric" required="no" default=0>
		<cfargument name="within" type="string" required="no" default="">
		<cfargument name="on" type="string" required="no" default="save">
	
		<cfif arguments.within IS NOT "">
			<cfset arguments.within = listToArray(replace(arguments.within, ", ", ",", "all"))>		
		</cfif>
	
		<cfset "variables.validations_on_#arguments.on#.validates_length_of.#arguments.field#.message" = arguments.message>
		<cfset "variables.validations_on_#arguments.on#.validates_length_of.#arguments.field#.allow_nil" = arguments.allow_nil>
		<cfset "variables.validations_on_#arguments.on#.validates_length_of.#arguments.field#.exactly" = arguments.exactly>
		<cfset "variables.validations_on_#arguments.on#.validates_length_of.#arguments.field#.maximum" = arguments.maximum>
		<cfset "variables.validations_on_#arguments.on#.validates_length_of.#arguments.field#.minimum" = arguments.minimum>
		<cfset "variables.validations_on_#arguments.on#.validates_length_of.#arguments.field#.within" = arguments.within>
	
	</cffunction>


	<cffunction name="validatesNumericalityOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# is not a number">
		<cfargument name="allow_nil" type="boolean" required="no" default="false">
		<cfargument name="only_integer" type="boolean" required="false" default="false">
		<cfargument name="on" type="string" required="no" default="save">
	
		<cfset "variables.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.message" = arguments.message>
		<cfset "variables.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.allow_nil" = arguments.allow_nil>
		<cfset "variables.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.only_integer" = arguments.only_integer>
	
	</cffunction>


	<cffunction name="validatesPresenceOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# can't be empty">
		<cfargument name="on" type="string" required="no" default="save">
	
		<cfset "variables.validations_on_#arguments.on#.validates_presence_of.#arguments.field#.message" = arguments.message>
	
	</cffunction>
	
	
	<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="message" type="string" required="no" default="#arguments.field# has already been taken">
		<cfargument name="scope" type="string" required="no" default="">
	
		<cfset arguments.scope = replace(arguments.scope, ", ", ",", "all")>
	
		<cfset "variables.validations_on_save.validates_uniqueness_of.#arguments.field#.message" = arguments.message>
		<cfset "variables.validations_on_save.validates_uniqueness_of.#arguments.field#.scope" = arguments.scope>
	
	</cffunction>

	
	<cffunction name="validate" returntype="void" access="public" output="false">
		<cfset runValidation(variables.validations_on_save)>
	</cffunction>
	
	
	<cffunction name="validateOnCreate" returntype="void" access="public" output="false">
		<cfset runValidation(variables.validations_on_create)>
	</cffunction>
	
	
	<cffunction name="validateOnUpdate" returntype="void" access="public" output="false">
		<cfset runValidation(variables.validations_on_update)>
	</cffunction>


	<cffunction name="runValidation" returntype="void" access="private" output="false">
		<cfargument name="validations" type="struct" required="yes">

		<cfset var settings = "">
		<cfset var type = "">
		<cfset var field = "">
		<cfset var find_query = "">
		<cfset var i = "">
		<cfset var pos = 0>
		<cfset var virtual_confirm_field = "">
		
		<cfloop collection="#arguments.validations#" item="type">
			<cfloop collection="#arguments.validations[type]#" item="field">
				<cfset settings = arguments.validations[type][field]>
				<cfswitch expression="#type#">
					<cfcase value="validates_confirmation_of">
						<cfset virtual_confirm_field = "#field#_confirmation">
						<cfif structKeyExists(this, virtual_confirm_field)>
							<cfif this[field] IS NOT this[virtual_confirm_field]>
								<cfset addError(virtual_confirm_field, settings.message)>
							</cfif>							
						</cfif>
					</cfcase>
					<cfcase value="validates_exclusion_of">
						<cfif NOT settings.allow_nil AND (NOT structKeyExists(this, field) OR this[field] IS "")>
							<cfset addError(field, settings.message)>
						<cfelse>
							<cfif structKeyExists(this, field) AND this[field] IS NOT "">
								<cfif listFindNoCase(settings.in, this[field]) IS NOT 0>
									<cfset addError(field, settings.message)>
								</cfif>							
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="validates_format_of">
						<cfif NOT settings.allow_nil AND (NOT structKeyExists(this, field) OR this[field] IS "")>
							<cfset addError(field, settings.message)>
						<cfelse>
							<cfif structKeyExists(this, field) AND this[field] IS NOT "">
								<cfif NOT REFindNoCase(settings.with, this[field])>
									<cfset addError(field, settings.message)>
								</cfif>							
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="validates_inclusion_of">
						<cfif NOT settings.allow_nil AND (NOT structKeyExists(this, field) OR this[field] IS "")>
							<cfset addError(field, settings.message)>
						<cfelse>
							<cfif structKeyExists(this, field) AND this[field] IS NOT "">
								<cfif listFindNoCase(settings.in, this[field]) IS 0>
									<cfset addError(field, settings.message)>
								</cfif>							
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="validates_length_of">
						<cfif NOT settings.allow_nil AND (NOT structKeyExists(this, field) OR this[field] IS "")>
							<cfset addError(field, settings.message)>
						<cfelse>
							<cfif structKeyExists(this, field) AND this[field] IS NOT "">
								<cfif settings.maximum IS NOT 0>
									<cfif len(this[field]) GT settings.maximum>
										<cfset addError(field, settings.message)>
									</cfif>
								<cfelseif settings.minimum IS NOT 0>
									<cfif len(this[field]) LT settings.minimum>
										<cfset addError(field, settings.message)>
									</cfif>
								<cfelseif settings.exactly IS NOT 0>
									<cfif len(this[field]) IS NOT settings.exactly>
										<cfset addError(field, settings.message)>
									</cfif>
								<cfelseif isArray(settings.within) AND arrayLen(settings.within) IS NOT 0>
									<cfif len(this[field]) LT settings.within[1] OR len(this[field]) GT settings.within[2]>
										<cfset addError(field, settings.message)>
									</cfif>
								</cfif>							
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="validates_numericality_of">
						<cfif NOT settings.allow_nil AND (NOT structKeyExists(this, field) OR this[field] IS "")>
							<cfset addError(field, settings.message)>
						<cfelse>
							<cfif structKeyExists(this, field) AND this[field] IS NOT "">
								<cfif NOT isNumeric(this[field])>
									<cfset addError(field, settings.message)>
								<cfelseif settings.only_integer AND round(this[field]) IS NOT this[field]>
									<cfset addError(field, settings.message)>
								</cfif>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="validates_presence_of">
						<cfif NOT structKeyExists(this, field) OR this[field] IS "">
							<cfset addError(field, settings.message)>
						</cfif>
					</cfcase>
					<cfcase value="validates_uniqueness_of">
						<cfquery name="find_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
							SELECT #variables.primary_key#, #field#
							FROM #variables.table_name#
							WHERE #field# = '#this[field]#'
							<cfif settings.scope IS NOT "">
								AND 
								<cfset pos = 0>
								<cfloop list="#settings.scope#" index="i">
									<cfset pos = pos + 1>
									#i# = '#this[i]#'
									<cfif listLen(settings.scope) GT pos>
										AND 
									</cfif>
								</cfloop>
							</cfif>
						</cfquery>
						<cfif (NOT structKeyExists(this, variables.primary_key) AND find_query.recordcount GT 0) OR (structKeyExists(this, variables.primary_key) AND find_query.recordcount GT 0 AND find_query[variables.primary_key][1] IS NOT this[variables.primary_key])>
							<cfset addError(field, settings.message)>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfloop>
		</cfloop>
		
	</cffunction>

</cfcomponent>
