<cfcomponent name="Model">

	<cfinclude template="#application.pathTo.includes#/request_functions.cfm">


	<cffunction name="initModel" returntype="any" access="public" output="false">
		<cfset var get_columns_query = "">	

		<cfset variables.model_name = listLast(getMetaData(this).name, ".")>

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

		<cfreturn this>
	</cffunction>


	<cffunction name="initObject" returntype="any" access="public" output="false">

		<!--- Copy model variables --->
		<cfset variables.model_name = listLast(getMetaData(this).name, ".")>
		<cfset variables.table_name = application.wheels.models[variables.model_name].getTableName()>
		<cfset variables.primary_key = application.wheels.models[variables.model_name].getPrimaryKey()>
		<cfset variables.column_list = application.wheels.models[variables.model_name].getColumnList()>
		<cfset variables.column_info = duplicate(application.wheels.models[variables.model_name].getColumnInfo())>
		
		<!--- Create object variables --->
		<cfset this.errors = arrayNew(1)>
		<cfset this.query = "">
		<cfset this.recordcount = 0>
		<cfset this.recordfound = false>

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
	

	<cffunction name="getModelName" returntype="string" access="public" output="false">
		<cfreturn variables.model_name>
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


	<cffunction name="getObject" returntype="any" access="private" output="false">
		<cfargument name="model_name" type="string" required="yes">
	
		<cfset var new_object = "">
		<cfset var vacant_objects = "">
		<cfset var UUID = 0>

		<cfif application.settings.environment IS "production">

			<!--- Find a vacant object in pool (lock code so that another thread can not get the same object before it has been set to 'is_taken') --->
			<cflock name="pool_lock_for_#arguments.model_name#" type="exclusive" timeout="5">
				<cfset vacant_objects = structFindValue(application.wheels.pools[arguments.model_name], "is_vacant", "one")>
				<cfif arrayLen(vacant_objects) IS NOT 0>
					<cfset UUID = listFirst(vacant_objects[1].path, ".")>
					<cfset application.wheels.pools[arguments.model_name][UUID].status = "is_taken">
				</cfif>
			</cflock>
			
			<cfif UUID IS NOT 0>
				<!--- Create a reference to the object in the pool and reset all instance specific data in the object so it can be re-used --->
				<cfset new_object = application.wheels.pools[arguments.model_name][UUID].object>
				<cfset new_object.reset()>
			<cfelse>
				<!--- Create a new object since no vacant ones were found in the pool (or we're in development mode) --->
				<cfset UUID = createUUID()>
				<cfset new_object = createObject("component", "app.models.#arguments.model_name#").initObject()>
				<cfset application.wheels.pools[arguments.model_name][UUID] = structNew()>
				<cfset application.wheels.pools[arguments.model_name][UUID].status = "is_taken">
				<cfset application.wheels.pools[arguments.model_name][UUID].object = new_object>
			</cfif>
			
			<!--- Add this object's UUID to a list in the request scope so it can be set to vacant again on request end --->
			<cfset request.wheels.taken_objects = listAppend(request.wheels.taken_objects, UUID)>

		<cfelse>

			<cfset new_object = createObject("component", "app.models.#arguments.model_name#").initObject()>

		</cfif>

		<cfreturn new_object>
	</cffunction>
	

	<cffunction name="reset" returntype="void" access="public" output="false">
		<cfset var i = 0>
		
		<cfloop list="#variables.column_list#" index="i">
			<cfset structDelete(this, i)>
			<cfset structDelete(this, "#i#_confirmation")>
		</cfloop>
		<cfset this.errors = arrayNew(1)>
		<cfset this.query = "">
		<cfset this.recordcount = 0>
		<cfset this.recordfound = false>	
	</cffunction>
	

	<cffunction name="newObject" returntype="any" access="private" output="false">
		<cfargument name="value_collection" type="any" required="yes">
	
		<cfset var i = "">
		<cfset var new_object = "">
		
		<cfset new_object = getObject(variables.model_name)>

		<cfif isQuery(arguments.value_collection) AND arguments.value_collection.recordcount GT 0>
			<cfset new_object.query = arguments.value_collection>
			<cfset new_object.recordfound = true>
			<cfset new_object.recordcount = arguments.value_collection.recordcount>
			<cfif arguments.value_collection.recordcount IS 1>
				<cfloop list="#arguments.value_collection.columnlist#" index="i">
					<cfif listFindNoCase(variables.column_list, replaceNoCase(i, (variables.model_name & "_"), "")) IS NOT 0>
						<cfset new_object[replaceNoCase(i, (variables.model_name & "_"), "")] = arguments.value_collection[i][1]>
					</cfif>
				</cfloop>
			</cfif>
		<cfelseif isStruct(arguments.value_collection) AND structCount(arguments.value_collection) GT 0>
			<cfset new_object.query = queryNew(structKeyList(arguments.value_collection))>
			<cfset queryAddRow(new_object.query, 1)>
			<cfloop collection="#arguments.value_collection#" item="i">
				<cfset querySetCell(new_object.query, i, arguments.value_collection[i])>
			</cfloop>
			<cfset new_object.recordfound = true>
			<cfset new_object.recordcount = structCount(arguments.value_collection)>
			<cfif structCount(arguments.value_collection) IS 1>
				<cfloop collection="#arguments.value_collection#" item="i">
					<cfif listFindNoCase(variables.column_list, i) IS NOT 0>
						<cfset new_object[i] = arguments.value_collection[i]>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	
		<cfreturn new_object>
	</cffunction>
	
	
	<cffunction name="save" returntype="boolean" access="public" output="false">

		<cfif valid()>
			<cfif isDefined("beforeValidation") AND NOT beforeValidation()>
				<cfreturn false>
			</cfif>
			<cfif isNewRecord()>
				<cfset validateOnCreate()>
				<cfif isDefined("afterValidationOnCreate") AND NOT afterValidationOnCreate()>
					<cfreturn false>
				</cfif>
			<cfelse>
				<cfset validateOnUpdate()>		
				<cfif isDefined("afterValidationOnUpdate") AND NOT afterValidationOnUpdate()>
					<cfreturn false>
				</cfif>
			</cfif>
			<cfset validate()>
			<cfif isDefined("afterValidation") AND NOT afterValidation()>
				<cfreturn false>
			</cfif>
			<cfif isDefined("beforeSave") AND NOT beforeSave()>
				<cfreturn false>
			</cfif>
			<cfif isNewRecord()>
				<cfif isDefined("beforeCreate") AND NOT beforeCreate()>
					<cfreturn false>
				</cfif>
				<cfif NOT insertRecord()>
					<cfreturn false>
				</cfif>
				<cfset expireCache()>
				<cfif isDefined("afterCreate") AND NOT afterCreate()>
					<cfreturn false>
				</cfif>
			<cfelse>
				<cfif isDefined("beforeUpdate") AND NOT beforeUpdate()>
					<cfreturn false>
				</cfif>
				<cfif NOT updateRecord()>
					<cfreturn false>
				</cfif>
				<cfset expireCache()>
				<cfif isDefined("afterUpdate") AND NOT afterUpdate()>
					<cfreturn false>
				</cfif>
			</cfif>
			<cfif isDefined("afterSave") AND NOT afterSave()>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfreturn false>
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
			LAST_INSERT_ID() AS last_id
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
	

	<cffunction name="expireCache" returntype="void" access="public" output="false">
		<cfset "application.wheels.caches.#variables.model_name#" = "smart_cache_id_#dateFormat(now(), 'yyyymmdd')#_#timeFormat(now(), 'HHmmss')#_#randRange(1000,9999)#">
	</cffunction>


	<cffunction name="findByID" returntype="any" access="public" output="false">
		<cfargument name="id" required="yes" type="numeric">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
		<cfargument name="cache" type="any" required="no" default="">
	
		<cfset var local = structNew()>
		
		<cfset local.find_all_arguments = duplicate(arguments)>
		<cfset structInsert(local.find_all_arguments, "where", "#variables.table_name#.#variables.primary_key# = #arguments.id#")>
		<cfset structDelete(local.find_all_arguments, "id")>
		<cfset local.return_object = findAll(argumentCollection=local.find_all_arguments)>
	
		<cfif local.return_object.recordfound>
			<cfreturn local.return_object>
		<cfelse>
			<cfthrow type="cfwheels.record_not_found" message="Record Not Found: a record with an id of #arguments.id# was not found in the '#variables.table_name#' table." detail="Correct the '#variables.table_name#' table by adding a record with an id of #arguments.id# or look for a different record.">
		</cfif>
		
	</cffunction>
	
	
	<cffunction name="findOne" returntype="any" access="public" output="false">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="order" type="string" required="no" default="">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
		<cfargument name="cache" type="any" required="no" default="">
	
		<cfset var local = structNew()>
		
		<cfset local.find_all_arguments = duplicate(arguments)>
		<cfset structInsert(local.find_all_arguments, "limit", 1)>
		<cfset local.return_object = findAll(argumentCollection=local.find_all_arguments)>
	
		<cfreturn local.return_object>
	</cffunction>

	
	<cffunction name="findAll" returntype="any" access="public" output="false">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="order" type="string" required="no" default="">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
		<cfargument name="distinct" type="boolean" required="no" default="false">
		<cfargument name="limit" type="numeric" required="no" default=0>
		<cfargument name="offset" type="numeric" required="no" default=0>
		<cfargument name="cache" type="any" required="no" default="">
		<cfargument name="page" type="numeric" required="no" default=0>
		<cfargument name="per_page" type="numeric" required="no" default=10>

		<cfset var local = structNew()>

		<cfset local.select_clause = createSelectClause(argumentCollection=duplicate(arguments))>
		<cfset local.from_clause = createfromClause(argumentCollection=duplicate(arguments))>
		<cfset local.order_clause = createOrderClause(argumentCollection=duplicate(arguments))>
		
		<cfif arguments.page IS NOT 0>
			<cfset local.pagination_details = createPaginationWhereClause(argumentCollection=duplicate(arguments))>
			<cfset local.where_clause = local.pagination_details.where_clause>
			<cfset local.paginator = local.pagination_details.paginator>
		<cfelse>
			<cfset local.where_clause = createWhereClause(argumentCollection=duplicate(arguments))>
		</cfif>
		
		<cfif arguments.cache IS NOT "">
			<cfif isNumeric(arguments.cache)>
				<cfset local.cached_within = createTimeSpan(0,0,arguments.cache,0)>
			<cfelseif isBoolean(arguments.cache) AND arguments.cache>
				<cfset local.cached_within = createTimeSpan(1,0,0,0)>
			</cfif>
		<cfelse>
			<cfset local.cached_within = createTimeSpan(0,0,0,0)>
		</cfif>
		
		<cfquery name="local.#application.wheels.caches[variables.model_name]#" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#" cachedwithin="#local.cached_within#">
		SELECT
		<cfif arguments.distinct>
			DISTINCT
		</cfif>
		<cfif application.database.type IS "sqlserver" AND arguments.limit IS NOT 0>
			TOP #arguments.limit#
		</cfif>
		#local.select_clause#
		FROM #local.from_clause#
		<cfif local.where_clause IS NOT "">
			WHERE #preserveSingleQuotes(local.where_clause)#
		</cfif>
		ORDER BY #local.order_clause#
		<cfif application.database.type IS "mysql5" AND arguments.limit IS NOT 0>
			LIMIT #arguments.limit#
		</cfif>
		<cfif application.database.type IS "mysql5" AND arguments.offset IS NOT 0>
			OFFSET #arguments.offset#
		</cfif>
		</cfquery>

		<cfset local.new_object = newObject(local[application.wheels.caches[variables.model_name]])>
	
		<cfif arguments.page IS NOT 0>
			<cfset local.new_object.paginator = local.paginator>
		</cfif>

		<cfreturn local.new_object>
	</cffunction>

	<cffunction name="createPaginationWhereClause" returntype="struct" access="private" output="false">

		<cfset var local = structNew()>

		<cfset local.find_all_arguments = duplicate(arguments)>
		<cfset local.count_arguments = duplicate(arguments)>
		<cfset local.paginator.current_page = arguments.page>
		<cfset local.count_arguments.distinct = true>
		<cfset local.paginator.total_records = count(argumentCollection=local.count_arguments)>
		<cfset local.paginator.total_pages = ceiling(local.paginator.total_records/arguments.per_page)>
		<cfset local.find_all_arguments.offset = (arguments.page * arguments.per_page) - (arguments.per_page)>
		<cfset local.find_all_arguments.limit = arguments.per_page>
		<cfif (local.find_all_arguments.limit + local.find_all_arguments.offset) GT local.paginator.total_records>
			<cfset local.find_all_arguments.limit = local.paginator.total_records - local.find_all_arguments.offset>
		</cfif>
		<cfset local.find_all_arguments.distinct = true>
		<cfset local.find_all_arguments.select = "#variables.primary_key# AS id">
		<cfset local.find_all_arguments.page = 0>
		<cfset local.find_all_arguments.per_page = 10>
		<cfset local.get_ids = findAll(argumentCollection=local.find_all_arguments)>
		<cfif local.get_ids.recordfound>
			<cfset local.ids = valueList(local.get_ids.query.id)>
		</cfif>
		<cfset local.where_clause = "#variables.table_name#.#variables.primary_key# IN (#local.ids#)">

		<cfreturn local>
	</cffunction>


	<cffunction name="createSelectClause" returntype="string" access="private" output="false">
	
		<cfset var local = structNew()>
		
		<cfset local.select_clause = "">
		
		<cfif structKeyExists(arguments, "select") AND arguments.select IS NOT "">
			<!--- Loop through the fields the developer supplied, prepend table name and "AS" where necessary --->
			<cfloop list="#arguments.select#" index="local.i">
				<cfif local.i Does Not Contain "." AND local.i Does Not Contain " AS ">
					<cfset local.select_clause = listAppend(local.select_clause, "#variables.table_name#.#trim(local.i)# AS #variables.model_name#_#trim(local.i)#")>
				<cfelseif local.i Contains "." AND local.i Does Not Contain " AS ">
					<cfset local.select_clause = listAppend(local.select_clause, "#trim(local.i)# AS #variables.model_name#_#trim(local.i)#")>
				<cfelseif local.i Does Not Contain "." AND local.i Contains " AS ">
					<cfset local.select_clause = listAppend(local.select_clause, "#variables.table_name#.#trim(local.i)#")>
				<cfelseif local.i Contains "." AND local.i Contains " AS ">
					<cfset local.select_clause = listAppend(local.select_clause, "#trim(local.i)#")>
				</cfif>
			</cfloop>
		<cfelse>
			<!--- Loop through list of columns and select all of them in the query --->
			<cfloop list="#variables.column_list#" index="local.i">
				<cfset local.select_clause = listAppend(local.select_clause, "#variables.table_name#.#trim(local.i)# AS #variables.model_name#_#trim(local.i)#")>
			</cfloop>
		</cfif>
	
		<cfreturn local.select_clause>
	</cffunction>
	

	<cffunction name="createFromClause" returntype="string" access="private" output="false">
	
		<cfset var local = structNew()>
		
		<cfset local.from_clause = variables.table_name>
		<cfif structKeyExists(arguments, "joins") AND arguments.joins IS NOT "">
			<cfset local.from_clause = local.from_clause & " " & arguments.joins>	
		</cfif>
	
		<cfreturn local.from_clause>
	</cffunction>


	<cffunction name="createWhereClause" returntype="string" access="private" output="false">
	
		<cfset var local = structNew()>
		
		<cfif structKeyExists(arguments, "where") AND arguments.where IS NOT "">
			<cfset local.where_clause = arguments.where>
		<cfelse>
			<cfset local.where_clause = "">
		</cfif>

		<cfreturn local.where_clause>
	</cffunction>


	<cffunction name="createOrderClause" returntype="string" access="private" output="false">
	
		<cfset var local = structNew()>
		
		<cfset order_clause = "">
		
		<cfif structKeyExists(arguments, "order") AND arguments.order IS NOT "">
			<cfloop list="#arguments.order#" index="local.i">
				<cfif local.i Does Not Contain "ASC" AND local.i Does Not Contain "DESC">
					<cfset local.i = trim(local.i) & " ASC">
				</cfif>
				<cfif local.i Contains ".">
					<cfset local.order_clause = listAppend(local.order_clause, trim(local.i))>
				<cfelse>
					<cfset local.order_clause = listAppend(local.order_clause, "#variables.table_name#.#trim(local.i)#")>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset local.order_clause = variables.table_name & "." & variables.primary_key & " ASC">
		</cfif>
	
		<cfreturn local.order_clause>
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


	<cffunction name="addError" returntype="boolean" access="public" output="false">
		<cfargument name="field" required="yes" type="string">
		<cfargument name="message" required="yes" type="string">
		
		<cfset var this_error = structNew()>
	
		<cfset this_error.field = arguments.field>
		<cfset this_error.message = arguments.message>
		
		<cfset arrayAppend(this.errors, this_error)>
		
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="valid" access="public" returntype="boolean">
		<cfif isNewRecord()>
			<cfset validateOnCreate()>
		<cfelse>
			<cfset validateOnUpdate()>		
		</cfif>
		<cfset validate()>
		<cfreturn errorsIsEmpty()>
	</cffunction>
	
	
	<cffunction name="errorsIsEmpty" returntype="boolean" access="public" output="false">
		<cfif arrayLen(this.errors) GT 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>		
	</cffunction>
	
	
	<cffunction name="clearErrors" returntype="boolean" access="public" output="false">
		<cfset arrayClear(this.errors)>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="errorsFullMessages" returntype="any" access="public" output="false">
	
		<cfset var all_error_messages = arrayNew(1)>
		
		<cfloop from="1" to="#arrayLen(this.errors)#" index="i">
			<cfset arrayAppend(all_error_messages, this.errors[i].message)>
		</cfloop>
	
		<cfif arrayLen(all_error_messages) IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn all_error_messages>
		</cfif>
	</cffunction>
	
	
	<cffunction name="errorsOn" returntype="any" access="public" output="false">
		<cfargument name="field" required="yes" type="string">
	
		<cfset var all_error_messages = arrayNew(1)>
		
		<cfloop from="1" to="#arrayLen(this.errors)#" index="i">
			<cfif this.errors[i].field IS arguments.field>
				<cfset arrayAppend(all_error_messages, this.errors[i].message)>
			</cfif>
		</cfloop>
	
		<cfif arrayLen(all_error_messages) IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn all_error_messages>
		</cfif>
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
		<cfif structKeyExists(variables, "validations_on_save")>
			<cfset runValidation(variables.validations_on_save)>
		</cfif>
	</cffunction>
	
	
	<cffunction name="validateOnCreate" returntype="void" access="public" output="false">
		<cfif structKeyExists(variables, "validations_on_create")>
			<cfset runValidation(variables.validations_on_create)>
		</cfif>
	</cffunction>
	
	
	<cffunction name="validateOnUpdate" returntype="void" access="public" output="false">
		<cfif structKeyExists(variables, "validations_on_update")>
			<cfset runValidation(variables.validations_on_update)>
		</cfif>
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


	<cffunction name="sum" returntype="numeric" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="distinct" type="boolean" required="no" default="false">
	
		<cfset var sum_query = "">
		<cfset var from_clause = "">
	
		<cfset from_clause = createFromClause(argumentCollection=arguments)>
	
		<cfquery name="sum_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			SELECT SUM(<cfif arguments.distinct>DISTINCT </cfif>#arguments.field#) AS total
			FROM #from_clause#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>
	
		<cfreturn sum_query.total>
	</cffunction>
	

	<cffunction name="minimum" returntype="numeric" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="where" type="string" required="no" default="">
	
		<cfset var minimum_query = "">
		<cfset var from_clause = "">
	
		<cfset from_clause = createFromClause(argumentCollection=arguments)>
	
		<cfquery name="minimum_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			SELECT MIN(#arguments.field#) AS minimum
			FROM #from_clause#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>
	
		<cfreturn minimum_query.minimum>
	</cffunction>
	
	
	<cffunction name="maximum" returntype="numeric" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="where" type="string" required="no" default="">
	
		<cfset var maximum_query = "">
		<cfset var from_clause = "">
	
		<cfset from_clause = createFromClause(argumentCollection=arguments)>
	
		<cfquery name="maximum_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			SELECT MAX(#arguments.field#) AS maximum
			FROM #from_clause#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>
	
		<cfreturn maximum_query.maximum>
	</cffunction>


	<cffunction name="average" returntype="numeric" access="public" output="false">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="distinct" type="boolean" required="no" default="false">
	
		<cfset var average_query = "">
		<cfset var from_clause = "">
		<cfset var result = 0>
	
		<cfset from_clause = createFromClause(argumentCollection=arguments)>
	
		<cfquery name="average_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			SELECT AVG(<cfif arguments.distinct>DISTINCT </cfif>#arguments.field#) AS average
			FROM #from_clause#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>
		
		<cfif average_query.average IS NOT "">
			<cfset result = average_query.average>
		</cfif>
	
		<cfreturn result>
	</cffunction>
	
	
	<cffunction name="count" returntype="numeric" access="public" output="false">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="joins" type="string" required="no" default="">
		<cfargument name="select" type="string" required="no" default="">
		<cfargument name="distinct" type="boolean" required="no" default="false">
	
		<cfset var count_query = "">
		<cfset var select_clause = "">
		<cfset var from_clause = "">
		<cfset var where_clause = "">
	
		<cfif arguments.select IS "">
			<cfset arguments.select = "#variables.table_name#.#variables.primary_key#">
		</cfif>
	
		<cfset from_clause = createFromClause(argumentCollection=arguments)>
	
		<cfquery name="count_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			SELECT COUNT(<cfif arguments.distinct>DISTINCT </cfif>#arguments.select#) AS total
			FROM #from_clause#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>
	
		<cfreturn count_query.total>
	</cffunction>

</cfcomponent>
