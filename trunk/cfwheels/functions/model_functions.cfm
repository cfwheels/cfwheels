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
	WHERE table_name = '#variables.table_name#' AND
	<cfif application.database.type IS "mysql5">
		table_schema = '#application.database.name#'
	<cfelseif application.database.type IS "sqlserver">
		table_catalog = '#application.database.name#'	
	</cfif>
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


<cffunction name="getCFSQLType" returntype="any" access="private" output="false">
	<cfargument name="db_sql_type" type="any" required="yes">	
	<cfset var result = "">
	<cfinclude template="includes/db_#application.database.type#.cfm">
	<cfreturn result>
</cffunction>


<cffunction name="getCFDataType" returntype="any" access="private" output="false">
	<cfargument name="db_sql_type" type="any" required="yes">	
	<cfset var result = "">
	<cfinclude template="includes/cf_#application.database.type#.cfm">
	<cfreturn result>
</cffunction>


<cffunction name="setTableName" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="yes">
	<cfset variables.table_name = arguments.name>
</cffunction>


<cffunction name="setPrimaryKey" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="yes">
	<cfset variables.primary_key = arguments.name>
</cffunction>


<cffunction name="getModelName" returntype="any" access="public" output="false">
	
	<cfreturn variables.model_name>
</cffunction>


<cffunction name="getTableName" returntype="any" access="public" output="false">
	
	<cfreturn variables.table_name>
</cffunction>


<cffunction name="getPrimaryKey" returntype="any" access="public" output="false">
	
	<cfreturn variables.primary_key>
</cffunction>


<cffunction name="getColumnList" returntype="any" access="public" output="false">
	
	<cfreturn variables.column_list>
</cffunction>


<cffunction name="getColumnInfo" returntype="any" access="public" output="false">
	
	<cfreturn variables.column_info>
</cffunction>


<cffunction name="new" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="false" default="#structNew()#">

	<cfset var i = "">

	<cfloop collection="#arguments#" item="i">
		<cfif i IS NOT "attributes">
			<cfset arguments.attributes[i] = arguments[i]>
		</cfif>
	</cfloop>
	
	<cfreturn newObject(arguments.attributes)>
</cffunction>


<cffunction name="create" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="false" default="#structNew()#">

	<cfset var new_object = "">

	<cfset new_object = new(argumentCollection=arguments)>
	<cfset new_object.save()>
	
	<cfreturn new_object>
</cffunction>


<cffunction name="getObject" returntype="any" access="private" output="false">
	<cfargument name="model_name" type="any" required="yes">

	<cfset var local = structNew()>

	<cfif application.settings.environment IS "production">
		<!--- Find a vacant object in pool (lock code so that another thread can not get the same object before it has been set to 'is_taken') --->
		<cflock name="pool_lock_for_#arguments.model_name#" type="exclusive" timeout="5">
			<cfset local.vacant_objects = structFindValue(application.wheels.pools[arguments.model_name], "is_vacant", "one")>
			<cfif arrayLen(local.vacant_objects) IS NOT 0>
				<!--- Create a reference to the object in the pool and reset all instance specific data in the object so it can be re-used --->
				<cfset local.UUID = listFirst(local.vacant_objects[1].path, ".")>
				<cfset local.new_object = application.wheels.pools[arguments.model_name][local.UUID].object>
				<cfset local.new_object.reset()>
			<cfelse>
				<!--- Create a new object since no vacant ones were found in the pool --->
				<cfset local.UUID = createUUID()>
				<cfset local.new_object = createObject("component", "app.models.#arguments.model_name#").initObject()>
				<cfset application.wheels.pools[arguments.model_name][local.UUID] = structNew()>
				<cfset application.wheels.pools[arguments.model_name][local.UUID].object = local.new_object>
			</cfif>
			<!--- Set object to taken and add object's UUID to a list in the request scope so it can be set to vacant again on request end --->
			<cfset application.wheels.pools[arguments.model_name][local.UUID].status = "is_taken">
			<cfset request.wheels.taken_objects = listAppend(request.wheels.taken_objects, local.UUID)>
		</cflock>
	<cfelse>
		<cfset local.new_object = createObject("component", "app.models.#arguments.model_name#").initObject()>
	</cfif>

	<cfreturn local.new_object>
</cffunction>


<cffunction name="reset" returntype="any" access="public" output="false">
	<cfset var i = 0>
	
	<cfloop list="#variables.column_list#" index="i">
		<cfset structDelete(this, i)>
		<cfset structDelete(this, "#i#_confirmation")>
	</cfloop>
	<cfset this.errors = arrayNew(1)>
	<cfset this.query = "">
	<cfset this.paginator = "">
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
				<cfset new_object[replaceNoCase(i, (variables.model_name & "_"), "")] = arguments.value_collection[i][1]>
			</cfloop>
		</cfif>
	<cfelseif isStruct(arguments.value_collection)>
		<cfset new_object.query = queryNew(structKeyList(arguments.value_collection))>
		<cfset queryAddRow(new_object.query, 1)>
		<cfloop collection="#arguments.value_collection#" item="i">
			<cfset querySetCell(new_object.query, i, arguments.value_collection[i])>
		</cfloop>
		<cfset new_object.recordfound = true>
		<cfset new_object.recordcount = 1>
		<cfloop collection="#arguments.value_collection#" item="i">
			<cfset new_object[i] = arguments.value_collection[i]>
		</cfloop>
	</cfif>

	<cfreturn new_object>
</cffunction>


<cffunction name="save" returntype="any" access="public" output="false">

	<cfset clearErrors()>
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


<cffunction name="isNewRecord" returntype="any" access="public" output="false">
	<cfif structKeyExists(this, variables.primary_key) AND this[variables.primary_key] GT 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>


<cffunction name="insertRecord" returntype="any" access="private" output="false">
	<cfset var insert_columns = "">
	<cfset var insert_query = "">
	<cfset var get_id_query = "">
	<cfset var pos = 0>
	<cfset var i = "">

	<cfif listFindNoCase(variables.column_list, "created_at") IS NOT 0>
		<cfset this.created_at = createODBCDateTime(now())>
	</cfif>
	
	<cfif listFindNoCase(variables.column_list, "created_on")>
		<cfset this.created_on = createODBCDate(now())>
	</cfif>

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
		@@IDENTITY AS last_id
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


<cffunction name="updateRecord" returntype="any" access="private" output="false">
	<cfset var update_columns = "">
	<cfset var update_query = "">
	<cfset var get_id_query = "">
	<cfset var pos = 0>
	<cfset var i = "">

	<cfif listFindNoCase(variables.column_list, "updated_at") IS NOT 0>
		<cfset this.updated_at = createODBCDateTime(now())>
	</cfif>
	
	<cfif listFindNoCase(variables.column_list, "updated_on")>
		<cfset this.updated_on = createODBCDate(now())>
	</cfif>

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


<cffunction name="expireCache" returntype="any" access="public" output="false">
	
	<cfset "application.wheels.caches.#variables.model_name#" = "smart_cache_id_#dateFormat(now(), 'yyyymmdd')#_#timeFormat(now(), 'HHmmss')#_#randRange(1000,9999)#">
</cffunction>


<cffunction name="findByID" returntype="any" access="public" output="false">
	<cfargument name="id" type="any" required="yes">
	<cfargument name="select" type="any" required="no" default="">
	<cfargument name="joins" type="any" required="no" default="">
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
	<cfargument name="where" type="any" required="no" default="">
	<cfargument name="order" type="any" required="no" default="">
	<cfargument name="select" type="any" required="no" default="">
	<cfargument name="joins" type="any" required="no" default="">
	<cfargument name="cache" type="any" required="no" default="">

	<cfset var local = structNew()>
	
	<cfset local.find_all_arguments = duplicate(arguments)>
	<cfset structInsert(local.find_all_arguments, "limit", 1)>
	<cfset local.return_object = findAll(argumentCollection=local.find_all_arguments)>

	<cfreturn local.return_object>
</cffunction>


<cffunction name="findAll" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="no" default="">
	<cfargument name="order" type="any" required="no" default="">
	<cfargument name="select" type="any" required="no" default="">
	<cfargument name="joins" type="any" required="no" default="">
	<cfargument name="distinct" type="any" required="no" default="false">
	<cfargument name="limit" type="any" required="no" default=0>
	<cfargument name="cache" type="any" required="no" default="">
	<cfargument name="page" type="any" required="no" default=0>
	<cfargument name="per_page" type="any" required="no" default=10>

	<cfset var local = structNew()>

	<cfset local.select_clause = createSelectClause(argumentCollection=duplicate(arguments))>
	<cfset local.from_clause = createfromClause(argumentCollection=duplicate(arguments))>
	<cfset local.order_clause = createOrderClause(argumentCollection=duplicate(arguments))>
	<cfset local.where_clause = createWhereClause(argumentCollection=duplicate(arguments))>
	
	<cfif arguments.page IS NOT 0>
		<!--- return a paginator struct and override where clause --->
		<cfset local.pagination_arguments = duplicate(arguments)>
		<cfset local.pagination_arguments.from_clause = local.from_clause>
		<cfset local.pagination_arguments.where_clause = local.where_clause>
		<cfset local.pagination_arguments.order_clause = local.order_clause>
		<cfset local.pagination = pagination(argumentCollection=local.pagination_arguments)>
		<cfset local.paginator = local.pagination.paginator>
		<cfset local.where_clause = local.pagination.where_clause>
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
	
	<cfset local.current_cache = application.wheels.caches[variables.model_name]>
	
	<cfquery name="local.#local.current_cache#" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#" cachedwithin="#local.cached_within#">
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
	</cfquery>

	<cfset local.new_object = newObject(local[local.current_cache])>

	<cfif arguments.page IS NOT 0>
		<cfset local.new_object.paginator = local.paginator>
	</cfif>

	<cfreturn local.new_object>
</cffunction>


<cffunction name="pagination" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfset local.pagination.paginator.current_page = arguments.page>

	<!--- remove everything from the FROM clause unless it's referenced in the WHERE or ORDER BY clause --->
	<cfset local.from_clause = "">
	<cfset local.pos = 0>
	<cfloop list="#replaceNoCase(arguments.from_clause, ' LEFT OUTER JOIN ', chr(7), 'all')#" index="local.i" delimiters="#chr(7)#">
		<cfset local.pos = local.pos + 1>
		<cfif local.pos IS 1 OR arguments.where_clause Contains (spanExcluding(local.i, " ") & ".") OR arguments.order_clause Contains (spanExcluding(local.i, " ") & ".")>
			<cfset local.from_clause = listAppend(local.from_clause, local.i, chr(7))>
		</cfif>
	</cfloop>
	<cfset local.from_clause = replaceNoCase(local.from_clause, chr(7), ' LEFT OUTER JOIN ', 'all')>

	<cfquery name="local.count_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
	SELECT COUNT(
	<cfif local.from_clause Contains " ">
		DISTINCT
	</cfif>
	#variables.table_name#.#variables.primary_key#) AS total
	FROM #local.from_clause#
	<cfif arguments.where_clause IS NOT "">
		WHERE #preserveSingleQuotes(arguments.where_clause)#
	</cfif>
	</cfquery>

	<cfset local.pagination.paginator.total_records = local.count_query.total>
	<cfset local.pagination.paginator.total_pages = ceiling(local.pagination.paginator.total_records/arguments.per_page)>

	<cfset local.offset = (arguments.page * arguments.per_page) - (arguments.per_page)>
	<cfset local.limit = arguments.per_page>
	<cfif (local.limit + local.offset) GT local.pagination.paginator.total_records>
		<cfset local.limit = local.pagination.paginator.total_records - local.offset>
	</cfif>

	<!--- Create select clauses which contains the primary key and the order by clause (need this when using DISTINCT and for SQL Server sub queries), with and without full table name qualification --->
	<cfset local.select_clause_with_tables = variables.table_name & "." & variables.primary_key>
	<cfif variables.primary_key IS NOT "id">
		<cfset local.select_clause_with_tables = local.select_clause_with_tables & " AS id">
	</cfif>
	<cfif arguments.order_clause IS NOT "#variables.table_name#.#variables.primary_key# ASC">
		<cfset local.select_clause_with_tables = local.select_clause_with_tables &  "," & replaceList(arguments.order_clause, " ASC, DESC", ",")>
	</cfif>

	<cfset local.select_clause_without_tables = variables.primary_key>
	<cfif arguments.order_clause IS NOT "#variables.table_name#.#variables.primary_key# ASC">
		<cfset local.select_clause_without_tables = local.select_clause_without_tables &  "," & replaceList(reReplaceNoCase(arguments.order_clause, "[^,]*\.", "", "all"), " ASC, DESC", ",")>
	</cfif>

	<cfquery name="local.ids_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
	<cfif application.database.type IS "mysql5">
		SELECT
		<cfif local.from_clause Contains " ">
			DISTINCT
		</cfif>
		#local.select_clause_with_tables#
		FROM #local.from_clause#
		<cfif arguments.where_clause IS NOT "">
			WHERE #preserveSingleQuotes(arguments.where_clause)#
		</cfif>
		ORDER BY #arguments.order_clause#
		<cfif local.limit IS NOT 0>
			LIMIT #local.limit#
		</cfif>
		<cfif local.offset IS NOT 0>
			OFFSET #local.offset#
		</cfif>
	<cfelseif application.database.type IS "sqlserver">
		SELECT #local.select_clause_without_tables#
		FROM (
			SELECT TOP #local.limit# #local.select_clause_without_tables#
			FROM (
				SELECT 
				<cfif local.from_clause Contains " ">
					DISTINCT
				</cfif>
				TOP #(local.limit + local.offset)# #local.select_clause_with_tables#
				FROM #local.from_clause#
				<cfif arguments.where_clause IS NOT "">
					WHERE #preserveSingleQuotes(arguments.where_clause)#
				</cfif>
				ORDER BY #arguments.order_clause#<cfif listContainsNoCase(arguments.order_clause, "#variables.table_name#.#variables.primary_key# ") IS 0>, #variables.table_name#.#variables.primary_key# ASC</cfif>) as x
			ORDER BY #replaceNoCase(replaceNoCase(replaceNoCase(reReplaceNoCase(arguments.order_clause, "[^,]*\.", "", "all"), "DESC", chr(7), "all"), "ASC", "DESC", "all"), chr(7), "ASC", "all")#<cfif listContainsNoCase(reReplaceNoCase(arguments.order_clause, "[^,]*\.", "", "all"), "#variables.primary_key# ") IS 0>, #variables.primary_key# DESC</cfif>) as y
		ORDER BY #reReplaceNoCase(arguments.order_clause, "[^,]*\.", "", "all")#<cfif listContainsNoCase(reReplaceNoCase(arguments.order_clause, "[^,]*\.", "", "all"), "#variables.primary_key# ") IS 0>, #variables.primary_key# ASC</cfif>
	</cfif>
	</cfquery>

	<cfif local.ids_query.recordcount IS NOT 0>
		<cfset local.ids = valueList(local.ids_query.id)>
		<cfset local.pagination.where_clause = "#variables.table_name#.#variables.primary_key# IN (#local.ids#)">
	<cfelse>
		<cfset local.pagination.where_clause = arguments.where_clause>
	</cfif>

	<cfreturn local.pagination>
</cffunction>


<cffunction name="createSelectClause" returntype="any" access="private" output="false">

	<cfset var local = structNew()>
	
	<cfset local.select_clause = "">
	
	<cfif structKeyExists(arguments, "select") AND arguments.select IS NOT "">
		<!--- Loop through the fields the developer supplied, prepend table name and "AS" where necessary --->
		<cfloop list="#arguments.select#" index="local.i">
			<cfif local.i Does Not Contain "." AND local.i Does Not Contain " AS ">
				<cfset local.select_clause = listAppend(local.select_clause, "#variables.table_name#.#trim(local.i)# AS #variables.model_name#_#trim(local.i)#")>
			<cfelseif local.i Contains "." AND local.i Does Not Contain " AS ">
				<cfset local.select_clause = listAppend(local.select_clause, "#trim(local.i)# AS #variables.model_name#_#trim(listLast(local.i,"."))#")>
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


<cffunction name="createFromClause" returntype="any" access="private" output="false">

	<cfset var local = structNew()>
	
	<cfset local.from_clause = variables.table_name>
	<cfif structKeyExists(arguments, "joins") AND arguments.joins IS NOT "">
		<cfset local.from_clause = local.from_clause & " " & arguments.joins>	
	</cfif>

	<cfreturn local.from_clause>
</cffunction>


<cffunction name="createWhereClause" returntype="any" access="private" output="false">

	<cfset var local = structNew()>
	
	<cfif structKeyExists(arguments, "where") AND arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS 0>
		<cfset local.where_clause = arguments.where>
	<cfelseif structKeyExists(arguments, "where") AND arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
		<cfset local.where_clause = "#arguments.where# AND #variables.table_name#.deleted_at IS NULL">
	<cfelseif listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
		<cfset local.where_clause = "#variables.table_name#.deleted_at IS NULL">
	<cfelse>
		<cfset local.where_clause = "">
	</cfif>

	<cfreturn local.where_clause>
</cffunction>


<cffunction name="createOrderClause" returntype="any" access="private" output="false">

	<cfset var local = structNew()>
	
	<cfset local.order_clause = "">
	
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


<cffunction name="update" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="no" default="#structNew()#">

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


<cffunction name="destroy" returntype="any" access="public" output="false">

	<cfset var local = structNew()>

	<cfif isDefined("beforeDestroy") AND NOT beforeDestroy()>
		<cfreturn false>
	</cfif>

	<cfquery name="local.check_deleted" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
	SELECT #variables.primary_key#
	FROM #variables.table_name#
	WHERE #variables.primary_key# = #this[variables.primary_key]#
	</cfquery>

	<cfif local.check_deleted.recordcount IS NOT 0>
		<cfif listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			<cfquery name="local.delete_record" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			UPDATE #variables.table_name#
			SET deleted_at = #createODBCDateTime(now())#
			WHERE #variables.primary_key# = #this[variables.primary_key]#
			</cfquery>
		<cfelse>
			<cfquery name="local.delete_record" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
			DELETE
			FROM #variables.table_name#
			WHERE #variables.primary_key# = #this[variables.primary_key]#
			</cfquery>
		</cfif>
	</cfif>

	<cfif isDefined("afterDestroy") AND NOT afterDestroy()>
		<cfreturn false>
	</cfif>

	<cfreturn local.check_deleted.recordcount>
</cffunction>


<cffunction name="addError" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="yes">
	
	<cfset var local = structNew()>

	<cfset local.error.field = arguments.field>
	<cfset local.error.message = arguments.message>
	
	<cfset arrayAppend(this.errors, local.error)>
	
	<cfreturn true>
</cffunction>


<cffunction name="valid" returntype="any" access="public" output="false">
	<cfif isNewRecord()>
		<cfset validateOnCreate()>
	<cfelse>
		<cfset validateOnUpdate()>		
	</cfif>
	<cfset validate()>
	<cfreturn errorsIsEmpty()>
</cffunction>


<cffunction name="errorsIsEmpty" returntype="any" access="public" output="false">
	<cfif arrayLen(this.errors) GT 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>		
</cffunction>


<cffunction name="clearErrors" returntype="any" access="public" output="false">
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
	<cfargument name="field" type="any" required="yes">

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


<cffunction name="validatesConfirmationOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is reserved">
	<cfargument name="on" type="any" required="no" default="save">
	
	<cfset "variables.validations_on_#arguments.on#.validates_confirmation_of.#arguments.field#.message" = arguments.message>

</cffunction>


<cffunction name="validatesExclusionOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is reserved">
	<cfargument name="in" type="any" required="yes">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	
	<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>

	<cfset "variables.validations_on_save.validates_exclusion_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.validations_on_save.validates_exclusion_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.validations_on_save.validates_exclusion_of.#arguments.field#.in" = arguments.in>

</cffunction>


<cffunction name="validatesFormatOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is invalid">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfargument name="with" type="any" required="yes">
	<cfargument name="on" type="any" required="no" default="save">
	
	<cfset "variables.validations_on_#arguments.on#.validates_format_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.validations_on_#arguments.on#.validates_format_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.validations_on_#arguments.on#.validates_format_of.#arguments.field#.with" = arguments.with>

</cffunction>


<cffunction name="validatesInclusionOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is not included in the list">
	<cfargument name="in" type="any" required="yes">
	<cfargument name="allow_nil" type="any" required="no" default="false">

	<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>

	<cfset "variables.validations_on_save.validates_inclusion_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.validations_on_save.validates_inclusion_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.validations_on_save.validates_inclusion_of.#arguments.field#.in" = arguments.in>

</cffunction>


<cffunction name="validatesLengthOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is the wrong length">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfargument name="exactly" type="any" required="no" default=0>
	<cfargument name="maximum" type="any" required="no" default=0>
	<cfargument name="minimum" type="any" required="no" default=0>
	<cfargument name="within" type="any" required="no" default="">
	<cfargument name="on" type="any" required="no" default="save">

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


<cffunction name="validatesNumericalityOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is not a number">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfargument name="only_integer" type="any" required="false" default="false">
	<cfargument name="on" type="any" required="no" default="save">

	<cfset "variables.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.only_integer" = arguments.only_integer>

</cffunction>


<cffunction name="validatesPresenceOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# can't be empty">
	<cfargument name="on" type="any" required="no" default="save">

	<cfset "variables.validations_on_#arguments.on#.validates_presence_of.#arguments.field#.message" = arguments.message>

</cffunction>


<cffunction name="validatesUniquenessOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# has already been taken">
	<cfargument name="scope" type="any" required="no" default="">

	<cfset arguments.scope = replace(arguments.scope, ", ", ",", "all")>

	<cfset "variables.validations_on_save.validates_uniqueness_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.validations_on_save.validates_uniqueness_of.#arguments.field#.scope" = arguments.scope>

</cffunction>


<cffunction name="validate" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables, "validations_on_save")>
		<cfset runValidation(variables.validations_on_save)>
	</cfif>
</cffunction>


<cffunction name="validateOnCreate" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables, "validations_on_create")>
		<cfset runValidation(variables.validations_on_create)>
	</cfif>
</cffunction>


<cffunction name="validateOnUpdate" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables, "validations_on_update")>
		<cfset runValidation(variables.validations_on_update)>
	</cfif>
</cffunction>


<cffunction name="runValidation" returntype="any" access="private" output="false">
	<cfargument name="validations" type="any" required="yes">

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


<cffunction name="sum" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="where" type="any" required="no" default="">
	<cfargument name="distinct" type="any" required="no" default="false">

	<cfset var sum_query = "">
	<cfset var from_clause = "">

	<cfset from_clause = createFromClause(argumentCollection=arguments)>

	<cfquery name="sum_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT SUM(<cfif arguments.distinct>DISTINCT </cfif>#arguments.field#) AS total
		FROM #from_clause#
		<cfif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS 0>
			WHERE #preserveSingleQuotes(arguments.where)#
		<cfelseif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #preserveSingleQuotes(arguments.where)# AND #variables.table_name#.deleted_at IS NULL
		<cfelseif arguments.where IS "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #variables.table_name#.deleted_at IS NULL
		</cfif>
	</cfquery>

	<cfreturn sum_query.total>
</cffunction>


<cffunction name="minimum" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="where" type="any" required="no" default="">

	<cfset var minimum_query = "">
	<cfset var from_clause = "">

	<cfset from_clause = createFromClause(argumentCollection=arguments)>

	<cfquery name="minimum_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT MIN(#arguments.field#) AS minimum
		FROM #from_clause#
		<cfif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS 0>
			WHERE #preserveSingleQuotes(arguments.where)#
		<cfelseif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #preserveSingleQuotes(arguments.where)# AND #variables.table_name#.deleted_at IS NULL
		<cfelseif arguments.where IS "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #variables.table_name#.deleted_at IS NULL
		</cfif>
	</cfquery>

	<cfreturn minimum_query.minimum>
</cffunction>


<cffunction name="maximum" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="where" type="any" required="no" default="">

	<cfset var maximum_query = "">
	<cfset var from_clause = "">

	<cfset from_clause = createFromClause(argumentCollection=arguments)>

	<cfquery name="maximum_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT MAX(#arguments.field#) AS maximum
		FROM #from_clause#
		<cfif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS 0>
			WHERE #preserveSingleQuotes(arguments.where)#
		<cfelseif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #preserveSingleQuotes(arguments.where)# AND #variables.table_name#.deleted_at IS NULL
		<cfelseif arguments.where IS "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #variables.table_name#.deleted_at IS NULL
		</cfif>
	</cfquery>

	<cfreturn maximum_query.maximum>
</cffunction>


<cffunction name="average" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="where" type="any" required="no" default="">
	<cfargument name="distinct" type="any" required="no" default="false">

	<cfset var average_query = "">
	<cfset var from_clause = "">
	<cfset var result = 0>

	<cfset from_clause = createFromClause(argumentCollection=arguments)>

	<cfquery name="average_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT AVG(<cfif arguments.distinct>DISTINCT </cfif>#arguments.field#) AS average
		FROM #from_clause#
		<cfif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS 0>
			WHERE #preserveSingleQuotes(arguments.where)#
		<cfelseif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #preserveSingleQuotes(arguments.where)# AND #variables.table_name#.deleted_at IS NULL
		<cfelseif arguments.where IS "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #variables.table_name#.deleted_at IS NULL
		</cfif>
	</cfquery>
	
	<cfif average_query.average IS NOT "">
		<cfset result = average_query.average>
	</cfif>

	<cfreturn result>
</cffunction>


<cffunction name="count" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="no" default="">
	<cfargument name="joins" type="any" required="no" default="">
	<cfargument name="select" type="any" required="no" default="">
	<cfargument name="distinct" type="any" required="no" default="false">

	<cfset var local = structNew()>

	<cfif arguments.select IS "">
		<cfset arguments.select = "#variables.table_name#.#variables.primary_key#">
	</cfif>

	<cfset local.from_clause = createFromClause(argumentCollection=arguments)>

	<cfquery name="local.count_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.source#">
		SELECT COUNT(<cfif arguments.distinct>DISTINCT </cfif>#arguments.select#) AS total
		FROM #local.from_clause#
		<cfif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS 0>
			WHERE #preserveSingleQuotes(arguments.where)#
		<cfelseif arguments.where IS NOT "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #preserveSingleQuotes(arguments.where)# AND #variables.table_name#.deleted_at IS NULL
		<cfelseif arguments.where IS "" AND listFindNoCase(variables.column_list, "deleted_at") IS NOT 0>
			WHERE #variables.table_name#.deleted_at IS NULL
		</cfif>
	</cfquery>

	<cfreturn local.count_query.total>
</cffunction>