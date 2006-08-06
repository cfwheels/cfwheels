<cfcomponent displayname="_model" hint="The base model that all other models extend">
	
	<cfset this._initialized = false>
	<cfset this._reload = false>
	<cfset this._modelName = "">
	<cfset this._tableName = "">
	<cfset this._primaryKey = "id">
	<cfset this.query = "">
	<cfset this._errors = arrayNew(1)>
	<cfset this.recordFound = true>
	<cfset this.recordCount = 0>
	<cfset this.currentRow = 0>


	<!--- Function for saving data (called when inserting or updating records) --->


	<cffunction name="save" returntype="boolean" access="public" output="false" hint="[DOCS] Creates a new record or updates an existing one with values matching those of the object attributes">

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


	<!--- Functions for creating data --->


	<cffunction name="new" returntype="any" access="public" output="false" hint="[DOCS] Create a new instance of this model">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#" hint="The values used to populate the new model instance">

		<cfloop collection="#arguments#" item="key">
			<cfif key IS NOT "attributes">
				<cfset arguments.attributes[key] = arguments[key]>
			</cfif>
		</cfloop>

		<cfif NOT structIsEmpty(arguments.attributes)>
			<cfloop collection="#arguments.attributes#" item="key">
				<cfset setValue(key, arguments.attributes[key])>
			</cfloop>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="create" returntype="any" access="public" output="false" hint="[DOCS] Creates an object, instantly saves it as a record (if the validation permits it), and returns it">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#" hint="The values used to populate the new model instance">
		
		<cfloop collection="#arguments#" item="key">
			<cfif key IS NOT "attributes">
				<cfset arguments.attributes[key] = arguments[key]>
			</cfif>
		</cfloop>

		<cfset new(arguments.attributes)>
		<cfset save()>

		<cfreturn this>
	</cffunction>


	<!--- Functions for reading data --->


	<cffunction name="findByID" access="public" returntype="any" output="false" hint="[DOCS] Returns a single row or multiple rows from the database">
		<cfargument name="id" required="yes" type="any" hint="The ID(s) of the record(s) to return (one ID or multiple IDs in a list or array)">

		<!---
		[DOCS:COMMENTS START]
		If the row (or any of the rows when passing in multiple IDs) is not found an exception of type RecordNotFound is thrown.
		[DOCS:COMMENTS END]

		[DOCS:EXAMPLE 1 START]
		Return the user with id 33:
		<cfset aUser = model("user").findByID(33)>
		[DOCS:EXAMPLE 1 END]
		
		[DOCS:EXAMPLE 2 START]
		Use a list to return users 1, 6 and 7:
		<cfset someUsers = model("user").findByID("1,6,7")>
		[DOCS:EXAMPLE 2 END]
		
		[DOCS:EXAMPLE 3 START]
		Use an array to return users 43, 99 and 110:
		<cfset userArray = arrayNew(1)>
		<cfset userArray[1] = 43>
		<cfset userArray[2] = 99>
		<cfset userArray[3] = 110>
		<cfset someUsers = model("user").findByID(userArray)>
		[DOCS:EXAMPLE 3 END]
		--->

		<cfset var findByIDQuery = "">
	
		<cfif isArray(arguments.id)>
			<cfset arguments.id = arrayToList(arguments.id)>
		<cfelseif arguments.id Contains ",">
			<cfset arguments.id = replace(arguments.id, ", ", ",", "all")>
		</cfif>
		
		<cfquery name="findByIDQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT *
			FROM #this._tableName#
			<cfif arguments.id Contains ",">
				WHERE id IN (<cfqueryparam cfsqltype="#variables.fields.id.cfSqlType#" value="#arguments.id#" list="yes">)
			<cfelse>
				WHERE id = <cfqueryparam cfsqltype="#variables.fields.id.cfSqlType#" value="#arguments.id#">
			</cfif>
		</cfquery>

		<cfif findByIDQuery.recordCount IS NOT listLen(arguments.id)>
			<cfthrow type="wheels.recordNotFound" message="RecordNotFound: A record with an id of #arguments.id# was not found in the `#this._tableName#` table" detail="You were looking in the database for a record with id=#arguments.id# but none exists.">
		<cfelse>
			<cfif arguments.id Contains ",">
				<cfreturn initGateway(findByIDQuery)>
			<cfelse>
				<cfreturn initDAO(findByIDQuery)>
			</cfif>
		</cfif>
		
	</cffunction>


	<cffunction name="findAll" access="public" returntype="any" output="false" hint="[DOCS] Returns multiple rows from the database">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">
		<cfargument name="order" type="string" required="no" default="" hint="The SQL fragment to be used in the ORDER BY clause of the query">
		<cfargument name="select" type="string" required="no" default="" hint="The SQL fragment to be used in the SELECT clause of the query">
		<cfargument name="include" type="string" required="no" default="" hint="List of other model(s) to include in query using a left outer join">
		<cfargument name="joins" type="string" required="no" default="" hint="An SQL fragment for additional joins">
		<cfargument name="limit" type="numeric" required="no" default=0 hint="An integer determining the limit on the number of rows that should be returned">
		<cfargument name="offset" type="numeric" required="no" default=0 hint="An integer determining the offset from where the rows should be fetched">
		<cfargument name="paginate" type="boolean" required="no" default="false" hint="Whether or not results should be paginated">
		<cfargument name="page" type="numeric" required="no" default=0 hint="The page to retrieve records for when using pagination">
		<cfargument name="perPage" type="numeric" required="no" default=10 hint="Number of records to retrieve per page when using pagination">

		<!---
		[DOCS:COMMENTS START]
		If no rows are found the query property will be empty and the 'recordFound' property is set to false.
		[DOCS:COMMENTS END]

		[DOCS:EXAMPLE 1 START]
		Return all users in the users table:
		<cfset allUsers = model("user").findAll()>
		[DOCS:EXAMPLE 1 END]
		
		[DOCS:EXAMPLE 2 START]
		Return 10 administrators ordered by last name:
		<cfset admins = model("user").findAll(where="admin=1", order="last_name", limit=10)>
		[DOCS:EXAMPLE 2 END]

		[DOCS:EXAMPLE 3 START]
		Paginate all users with 10 on each page and return the 2nd page (users 11-20):
		<cfset users = model("user").findAll(order="last_name", paginate=true, page=2, perPage=10)>
		[DOCS:EXAMPLE 3 END]

		[DOCS:EXAMPLE 4 START]
		Paginate all users and return the page that corresponds to the request.params.page variable (when you don't supply "page" and "perPage" the function defaults to 10 for each page and to look at the request.params.page variable to get the requested page number:
		<cfset users = model("user").findAll(order="last_name", paginate=true)>
		[DOCS:EXAMPLE 4 END]
		--->

		<cfset var findAllQuery = "">
		<cfset var selectColumns = "">
		<cfset var fromTables = "">
		<cfset var orderByColumns = "">
		<cfset var orderByColumnsForPagination = "">

		<cfif arguments.select IS "">
			<cfset selectColumns = getSelectColumns(argumentCollection=arguments)>
		<cfelse>
			<cfset selectColumns = arguments.select>		
		</cfif>
		<cfset fromTables = getfromTables(argumentCollection=arguments)>
		<cfset orderByColumns = getOrderByColumns(argumentCollection=arguments)>
	
		<cfif arguments.paginate>
			<cfset selectColumnsForPagination = getselectColumnsForPagination(selectColumns=selectColumns)>
			<cfset orderByColumnsForPagination = getOrderByColumnsForPagination(orderByColumns=orderByColumns)>
			<cfif isDefined("request.params.page") AND arguments.page IS 0>
				<cfset this._paginatorCurrentPage = request.params.page>			
			<cfelseif arguments.page IS NOT 0>
				<cfset this._paginatorCurrentPage = arguments.page>			
			<cfelse>
				<cfset this._paginatorCurrentPage = 1>
			</cfif>
			<cfset this._paginatorTotalRecords = this.count(argumentCollection=arguments)>
			<cfset this._paginatorTotalPages = ceiling(this._paginatorTotalRecords/arguments.perPage)>
			<cfset arguments.offset = (this._paginatorCurrentPage * arguments.perPage) - (arguments.perPage)>
			<cfset arguments.limit = arguments.perPage>
			<cfif (arguments.limit + arguments.offset) GT this._paginatorTotalRecords>
				<cfset arguments.limit = this._paginatorTotalRecords - arguments.offset>
			</cfif>
		</cfif>
	
		<cfquery name="findAllQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			<cfif application.database.type IS "sqlserver" AND arguments.paginate>
				<!--- need a special query here since offset is not supported by SQL server --->
				SELECT #selectColumnsForPagination#
				FROM (
					SELECT TOP #arguments.limit# #selectColumnsForPagination#
					FROM (
						SELECT TOP #(arguments.limit + arguments.offset)# #selectColumns#
						FROM #fromTables#
						<cfif arguments.where IS NOT "">
							WHERE #preserveSingleQuotes(arguments.where)#
						</cfif>
						ORDER BY #orderByColumns#<cfif listContainsNoCase(orderByColumns, "#this._tableName#.id ") IS 0>, #this._tableName#.id ASC</cfif>) as x
					ORDER BY #replaceNoCase(replaceNoCase(replaceNoCase(orderByColumnsForPagination, "DESC", chr(7), "all"), "ASC", "DESC", "all"), chr(7), "ASC", "all")#<cfif listContainsNoCase(orderByColumnsForPagination, "id ") IS 0>, id DESC</cfif>) as y
				ORDER BY #orderByColumnsForPagination#<cfif listContainsNoCase(orderByColumnsForPagination, "id ") IS 0>, id ASC</cfif>
			<cfelse>
				SELECT
				<cfif application.database.type IS "sqlserver" AND arguments.limit IS NOT 0>
					TOP #arguments.limit#
				</cfif>
				#selectColumns#
				FROM #fromTables#
				<cfif arguments.where IS NOT "">
					WHERE #preserveSingleQuotes(arguments.where)#
				</cfif>
				ORDER BY #orderByColumns#
				<cfif application.database.type IS NOT "sqlserver" AND arguments.limit IS NOT 0>
					LIMIT #arguments.limit#
				</cfif>
				<cfif application.database.type IS NOT "sqlserver" AND arguments.offset IS NOT 0>
					OFFSET #arguments.offset#
				</cfif>
			</cfif>
		</cfquery>
		
		<cfif findAllQuery.recordCount IS 0>
			<cfset this.recordFound = false>
		</cfif>
		
		<cfreturn initGateway(findAllQuery)>		

	</cffunction>


	<cffunction name="findOne" access="public" returntype="any" output="false" hint="[DOCS] Returns a single row from the database">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">
		<cfargument name="order" type="string" required="no" default="" hint="The SQL fragment to be used in the ORDER BY clause of the query">
		<cfargument name="select" type="string" required="no" default="" hint="The SQL fragment to be used in the SELECT clause of the query">
		<cfargument name="include" type="string" required="no" default="" hint="List of other model(s) to include in query using a left outer join">
		<cfargument name="joins" type="string" required="no" default="" hint="An SQL fragment for additional joins">

		<!---
		[DOCS:COMMENTS START]
		If no row is found the query property will be empty and the 'recordFound' property is set to false.
		[DOCS:COMMENTS END]

		[DOCS:EXAMPLE 1 START]
		Return the user that was last online:
		<cfset aUser = model("user").findOne(order="last_online_time DESC")>
		[DOCS:EXAMPLE 1 END]
		--->

		<cfset var findOneQuery = "">
		<cfset var selectColumns = "">
		<cfset var fromTables = "">
		<cfset var orderByColumns = "">

		<cfif arguments.select IS "">
			<cfset selectColumns = getSelectColumns(argumentCollection=arguments)>
		<cfelse>
			<cfset selectColumns = arguments.select>		
		</cfif>
		<cfset fromTables = getfromTables(argumentCollection=arguments)>
		<cfset orderByColumns = getOrderByColumns(argumentCollection=arguments)>

		<cfquery name="findOneQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#" maxrows="1">
			SELECT #selectColumns#
			FROM #fromTables#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
			ORDER BY #orderByColumns#
		</cfquery>
		
		<cfif findOneQuery.recordCount IS 0>
			<cfset this.recordFound = false>
			<cfreturn this>
		<cfelse>
			<cfreturn initDAO(findOneQuery)>
		</cfif>

	</cffunction>


	<cffunction name="findAllBySQL" access="public" returntype="any" output="false" hint="[DOCS] Returns multiple rows from the database">
		<cfargument name="sql" required="yes" type="string" hint="The complete SQL statement">

		<!---
		[DOCS:COMMENTS START]
		This allows you to take full control by passing in a complete SQL statement.
		If no rows are found the query property will be empty and the 'recordFound' property is set to false.
		[DOCS:COMMENTS END]
		--->

		<cfset var findAllBySQLQuery = "">

		<cfquery name="findAllBySQLQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			#preserveSingleQuotes(arguments.sql)#
		</cfquery>
		
		<cfif findAllBySQLQuery.recordCount IS 0>
			<cfset this.recordFound = false>
		</cfif>
		
		<cfreturn initGateway(findAllBySQLQuery)>
		
	</cffunction>


	<cffunction name="findOneBySQL" access="public" returntype="any" output="false" hint="[DOCS] Returns a single row from the database">
		<cfargument name="sql" required="yes" type="string" hint="The complete SQL statement">

		<!---
		[DOCS:COMMENTS START]
		This allows you to take full control by passing in a complete SQL statement.
		If no row is found the query property will be empty and the 'recordFound' property is set to false.
		[DOCS:COMMENTS END]
		--->
		
		<cfset var findOneBySQLQuery = "">

		<cfquery name="findOneBySQLQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#" maxrows="1">
			#preserveSingleQuotes(arguments.sql)#
		</cfquery>
		
		<cfif findOneBySQLQuery.recordCount IS 0>
			<cfset this.recordFound = false>
			<cfreturn this>
		<cfelse>
			<cfreturn initDAO(findOneBySQLQuery)>
		</cfif>
		
	</cffunction>


	<!--- Functions for updating data --->
	
	
	<cffunction name="updateAttribute" returntype="boolean" access="public" output="false" hint="[DOCS] Updates a single attribute and saves the record">
		<cfargument name="name" type="string" required="no" default="" hint="The attribute to update">
		<cfargument name="value" type="string" required="no" default="" hint="The value to set on the attribute">

		<cfif structCount(arguments) IS 2>
			<cfset setValue(arguments.name, arguments.value)>
		<cfelse>
			<cfloop collection="#arguments#" item="key">
				<cfif key IS NOT "name" AND key IS NOT "value">
					<cfset setValue(key, arguments[key])>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn save()>
	</cffunction>
	
	
	<cffunction name="updateAttributes" returntype="boolean" access="public" output="false" hint="[DOCS] Updates all the attributes from the supplied struct and saves the record">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#" hint="The attributes to update">

		<cfloop collection="#arguments#" item="key">
			<cfif key IS NOT "attributes">
				<cfset setValue(arguments.attributes[key], arguments[key])>
			</cfif>
		</cfloop>

		<cfif NOT structIsEmpty(arguments.attributes)>
			<cfloop collection="#arguments.attributes#" item="key">
				<cfset setValue(key, arguments.attributes[key])>
			</cfloop>
		</cfif>

		<cfreturn save()>
	</cffunction>


	<cffunction name="update" returntype="any" access="public" output="false" hint="[DOCS] Finds the record from the passed id, instantly saves it with the passed attributes (if the validation permits it), and returns it">
		<cfargument name="id" type="numeric" required="true" hint="The record to find and update">
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#" hint="The attributes to update">
		
		<cfset findByID(arguments.id)>
		<cfloop collection="#arguments#" item="key">
			<cfif key IS NOT "id" AND key IS NOT "attributes">
				<cfset arguments.attributes[key] = arguments[key]>
			</cfif>
		</cfloop>
		<cfset updateAttributes(arguments.attributes)>
		<cfset save()>
		
		<cfreturn this>
	</cffunction>


	<cffunction name="updateAll" returntype="numeric" access="public" output="false" hint="[DOCS] Updates all records with the SET-part of an SQL update statement and returns an integer with the number of rows updated">
		<cfargument name="updates" type="string" required="true" hint="The SQL fragment to be used in the SET clause of the query">
		<cfargument name="conditions" type="string" required="false" default="" hint="The SQL fragment to be used in the WHERE clause of the query">
		
		<!--- Extra safety added --->
		<cfif structCount(arguments) GT 1>
			<cfloop list="#structKeyList(arguments)#" index="arg">
				<cfif arg IS NOT "updates" AND arg IS NOT "conditions">
					<cfthrow type="wheels.disallowedArgument" message="disallowedArgument: '#arg#'" detail="You tried passing in the argument '#arg#'. The only allowed arguments for this function are: 'updates', 'conditions'.">
				</cfif>
			</cfloop>	
		</cfif>

		<cfquery name="checkUpdated" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT *
			FROM #this._tableName#
			<cfif arguments.conditions IS NOT "">
				WHERE #preserveSingleQuotes(arguments.conditions)#
			</cfif>
		</cfquery>
		<cfif checkUpdated.recordCount IS NOT 0>
			<cfquery name="updateRecord" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
				UPDATE #this._tableName#
				SET #preserveSingleQuotes(arguments.updates)#
				<cfif arguments.conditions IS NOT "">
					WHERE #preserveSingleQuotes(arguments.conditions)#
				</cfif>
			</cfquery>
		</cfif>
		
		<cfreturn checkUpdated.recordCount>
	</cffunction>


	<cffunction name="toggle" returntype="boolean" access="public" output="false" hint="[DOCS] Turns an attribute that's currently true into false and vice versa">
		<cfargument name="attribute" type="string" required="yes" hint="The attribute to toggle">

		<cfreturn doToggle(argumentCollection=arguments)>
	</cffunction>


	<cffunction name="toggleAndSave" returntype="boolean" access="public" output="false" hint="[DOCS] Turns an attribute that's currently true into false and vice versa and saves the record afterwards">
		<cfargument name="attribute" type="string" required="yes" hint="The attribute to toggle and save">

		<cfif doToggle(argumentCollection=arguments)>
			<cfreturn save()>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>


	<!--- Functions for deleting data --->


	<cffunction name="delete" returntype="numeric" access="public" output="false" hint="[DOCS] Deletes the record with the given id without instantiating an object first. If an array of ids is provided, all of them are deleted">
		<cfargument name="id" type="any" required="yes" hint="The id(s) to delete (one ID or multiple IDs in a list or array)">
		
		<cfset var checkDeleted = "">
		<cfset var deleteRecord = "">
	
		<cfif isArray(arguments.id)>
			<cfset arguments.id = arrayToList(arguments.id)>
		<cfelseif arguments.id Contains ",">
			<cfset arguments.id = replace(arguments.id, ", ", ",", "all")>
		</cfif>
		
		<cfquery name="checkDeleted" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT *
			FROM #this._tableName#
			WHERE id <cfif arguments.id Contains ",">IN (#arguments.id#)<cfelse>= #arguments.id#</cfif>
		</cfquery>
		
		<cfif checkDeleted.recordCount IS NOT 0>
			<cfquery name="deleteRecord" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
				DELETE
				FROM #this._tableName#
				WHERE id <cfif arguments.id Contains ",">IN (#arguments.id#)<cfelse>= #arguments.id#</cfif>
			</cfquery>
		</cfif>
		
		<cfreturn checkDeleted.recordCount>
	</cffunction>


	<cffunction name="deleteAll" returntype="numeric" access="public" output="false" hint="[DOCS] Deletes all the records that match the condition without instantiating the objects first">
		<cfargument name="conditions" type="string" required="false" default="" hint="The SQL fragment to be used in the WHERE clause of the query">

		<cfset var checkDeleted = "">
		<cfset var deleteRecord = "">

		<!--- Extra safety added --->
		<cfif structCount(arguments) GT 0>
			<cfloop list="#structKeyList(arguments)#" index="arg">
				<cfif arg IS NOT "conditions">
					<cfthrow type="wheels.disallowedArgument" message="disallowedArgument: '#arg#'" detail="You tried passing in the argument '#arg#'. The only allowed argument for this function is: 'conditions'.">
				</cfif>
			</cfloop>	
		</cfif>
		
		<cfquery name="checkDeleted" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT *
			FROM #this._tableName#
			<cfif arguments.conditions IS NOT "">
				WHERE #preserveSingleQuotes(arguments.conditions)#
			</cfif>
		</cfquery>
		<cfif checkDeleted.recordCount IS NOT 0>
			<cfquery name="deleteRecord" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
				DELETE FROM #this._tableName#
				<cfif arguments.conditions IS NOT "">
					WHERE #preserveSingleQuotes(arguments.conditions)#
				</cfif>
			</cfquery>		
		</cfif>
		
		<cfreturn checkDeleted.recordCount>
	</cffunction>
	
	
	<cffunction name="destroy" returntype="boolean" access="public" output="false" hint="[DOCS] If called on an object (no ID supplied) then delete the record in the database. If called with an ID passed then find and instantiate the object and call destroy on it. If an array of ids is provided, all of them are destroyed.">
		<cfargument name="id" type="any" required="no" default=0 hint="The id(s) to destroy (one ID or multiple IDs in a list or array)">

		<cfif isArray(arguments.id)>
			<cfset arguments.id = arrayToList(arguments.id)>
		<cfelseif arguments.id Contains ",">
			<cfset arguments.id = replace(arguments.id, ", ", ",", "all")>
		</cfif>

		<cfif arguments.id IS 0>
			<cfif NOT isDefined("beforeDestroy") OR beforeDestroy()>
				<cfset delete(this.id)>
			</cfif>
			<cfif isDefined("afterDestroy")>
				<cfset afterDestroy()>
			</cfif>
		<cfelse>
			<cfloop list="#arguments.id#" index="i">
				<cfset findByID(i)>
				<cfset destroy()>
			</cfloop>
		</cfif>

		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="destroyAll" returntype="boolean" access="public" output="false" hint="[DOCS] Destroys the objects for all the records that match the condition by instantiating each object and calling the destroy method">
		<cfargument name="conditions" type="string" required="false" default="" hint="The SQL fragment to be used in the WHERE clause of the query">

		<cfset var recordsToDestroy = "">
		
		<cfset recordsToDestroy = findAll(where="#arguments.conditions#")>
		<cfloop query="recordsToDestroy.query">
			<cfset destroy(id)>
		</cfloop>
		
		<cfreturn true>
	</cffunction>


	<!--- Functions for calculations --->


	<cffunction name="average" returntype="numeric" access="public" output="false" hint="[DOCS] Calculates the average value on a given column. Returns a float value.">
		<cfargument name="fieldName" type="string" required="yes" hint="The field name to get the average value for">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">
		<cfargument name="distinct" type="boolean" required="no" default="false" hint="Set this to true to make this a distinct calculation">

		<cfset var averageQuery = "">
		<cfset var fromTables = "">

		<cfset fromTables = getfromTables(argumentCollection=arguments)>

		<cfquery name="averageQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT AVG(<cfif arguments.distinct>DISTINCT </cfif>cast(#arguments.fieldName# as float)) AS average
			FROM #fromTables#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>

		<cfreturn averageQuery.average>
	</cffunction>


	<cffunction name="count" returntype="numeric" access="public" output="false" hint="[DOCS] Returns a count of the records in the table based on the supplied arguments">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">
		<cfargument name="select" type="string" required="no" default="" hint="The SQL fragment to be used in the SELECT clause of the query">
		<cfargument name="distinct" type="boolean" required="no" default="false" hint="Set this to true to make this a distinct calculation">

		<!---
		[DOCS:EXAMPLE 1 START]
		Count how many administrators we have in our table:
		<cfset adminCount = model("user").count(where="admin=1")>
		[DOCS:EXAMPLE 1 END]
		--->

		<cfset var countQuery = "">
		<cfset var fromTables = "">

		<cfif arguments.select IS "">
			<cfset arguments.select = "*">
		</cfif>

		<cfset fromTables = getfromTables(argumentCollection=arguments)>

		<cfquery name="countQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT COUNT(<cfif arguments.distinct>DISTINCT </cfif>#arguments.select#) AS total
			FROM #fromTables#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>

		<cfreturn countQuery.total>
	</cffunction>


	<cffunction name="countBySQL" returntype="numeric" access="public" output="false" hint="[DOCS] Returns a count of the records in a table based on the supplied SQL statement">
		<cfargument name="sql" required="yes" type="string" hint="The complete SQL statement">

		<!---
		[DOCS:EXAMPLE 1 START]
		Count how many times a customer has made a purchase:
		<cfset custPurchases = model("purchase").countBySQL("SELECT COUNT(*) FROM purchases WHERE customer_id = #custID#")>
		[DOCS:EXAMPLE 1 END]
		--->

		<cfset var countBySQLQuery = "">

		<cfquery name="countBySQLQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			#preserveSingleQuotes(arguments.sql)#
		</cfquery>

		<cfreturn countBySQLQuery[countBySQLQuery.columnList][1]>
	</cffunction>


	<cffunction name="maximum" returntype="numeric" access="public" output="false" hint="[DOCS] Calculates the maximum value on a given column">
		<cfargument name="fieldName" type="string" required="yes" hint="The field name to get the maximum value for">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">

		<cfset var maximumQuery = "">
		<cfset var fromTables = "">

		<cfset fromTables = getfromTables(argumentCollection=arguments)>

		<cfquery name="maximumQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT MAX(#arguments.fieldName#) AS maximum
			FROM #fromTables#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>

		<cfreturn maximumQuery.maximum>
	</cffunction>


	<cffunction name="minimum" returntype="numeric" access="public" output="false" hint="[DOCS] Calculates the minimum value on a given column">
		<cfargument name="fieldName" type="string" required="yes" hint="The field name to get the minimum value for">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">

		<cfset var minimumQuery = "">
		<cfset var fromTables = "">

		<cfset fromTables = getfromTables(argumentCollection=arguments)>

		<cfquery name="minimumQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT MIN(#arguments.fieldName#) AS minimum
			FROM #fromTables#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>

		<cfreturn minimumQuery.minimum>
	</cffunction>


	<cffunction name="sum" returntype="numeric" access="public" output="false" hint="[DOCS] Calculates the total sum on a given column">
		<cfargument name="fieldName" type="string" required="yes" hint="The field name to get the total sum for">
		<cfargument name="where" type="string" required="no" default="" hint="The SQL fragment to be used in the WHERE clause of the query">
		<cfargument name="distinct" type="boolean" required="no" default="false" hint="Set this to true to make this a distinct calculation">

		<cfset var sumQuery = "">
		<cfset var fromTables = "">

		<cfset fromTables = getfromTables(argumentCollection=arguments)>

		<cfquery name="sumQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT SUM(<cfif arguments.distinct>DISTINCT </cfif>#arguments.fieldName#) AS total
			FROM #fromTables#
			<cfif arguments.where IS NOT "">
				WHERE #preserveSingleQuotes(arguments.where)#
			</cfif>
		</cfquery>

		<cfreturn sumQuery.total>
	</cffunction>


	<!--- Functions related to errors --->


	<cffunction name="addError" returntype="boolean" access="public" output="false" hint="[DOCS] Adds an error message for the specified field name">
		<cfargument name="fieldName" required="yes" type="string" hint="Name of the field to add the error message for">
		<cfargument name="message" required="yes" type="string" hint="The error message">
		
		<cfset var thisError = structNew()>

		<cfset thisError.field = arguments.fieldName>
		<cfset thisError.message = arguments.message>
		
		<cfset arrayAppend(this._errors,thisError)>
		
		<cfreturn true>
	</cffunction>
	

	<cffunction name="clearErrors" returntype="boolean" access="public" output="false" hint="[DOCS] Removes all the errors that have been added">
		<cfset arrayClear(this._errors)>
		<cfreturn true>
	</cffunction>


	<cffunction name="errorsFullMessages" returntype="any" access="public" output="false" hint="[DOCS] Returns all the full error messages in an array">

		<!---
		[DOCS:COMMENTS START]
	    Returns false, if no errors are associated with the model, otherwise returns the error messages in an array.
		[DOCS:COMMENTS END]
		--->

		<cfset var allErrorMessages = arrayNew(1)>
		
		<cfloop from="1" to="#arrayLen(this._errors)#" index="i">
			<cfset arrayAppend(allErrorMessages, this._errors[i].message)>
		</cfloop>

		<cfif arrayLen(allErrorMessages) IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn allErrorMessages>
		</cfif>
	</cffunction>


	<cffunction name="errorsIsEmpty" returntype="boolean" access="public" output="false" hint="[DOCS] Returns true if no errors have been added">
		
		<cfif arrayLen(this._errors) GTE 1>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
		
	</cffunction>

	
	<cffunction name="errorsOn" returntype="any" access="public" output="false" hint="[DOCS] Returns error message(s) for the specified field">
		<cfargument name="fieldName" required="yes" type="string" hint="Name of the field to return error messages for">

		<!---
		[DOCS:COMMENTS START]
	    Returns false, if no errors are associated with the specified field name, otherwise returns the error messages in an array.
		[DOCS:COMMENTS END]
		--->

		<cfset var allErrorMessages = arrayNew(1)>
		
		<cfloop from="1" to="#arrayLen(this._errors)#" index="i">
			<cfif this._errors[i].field IS arguments.fieldName>
				<cfset arrayAppend(allErrorMessages, this._errors[i].message)>
			</cfif>
		</cfloop>

		<cfif arrayLen(allErrorMessages) IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn allErrorMessages>
		</cfif>
	</cffunction>


	<cffunction name="valid" access="public" returntype="boolean" hint="[DOCS] Runs validate and validateOnCreate or validateOnUpdate and returns true if no errors were added otherwise false.">
		<cfif isNewRecord()>
			<cfset validateOnCreate()>
		<cfelse>
			<cfset validateOnUpdate()>		
		</cfif>
		<cfset validate()>
		<cfreturn errorsIsEmpty()>
	</cffunction>
	
	
	<!--- Functions for iterating the query result set --->


	<cffunction name="hasNext" returntype="boolean" access="public" output="false" hint="">
		<cfif this.recordCount GT this.currentRow>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>


	<cffunction name="next" returntype="any" access="public" output="false" hint="">

		<cfset var columns = listToArray(this.columnList)>
		<cfset var i = 1>

		<cfset this.currentRow = this.currentRow + 1>
		
		<cfloop index="i" from="1" to="#arrayLen(columns)#">
			<cfset this[columns[i]] = this.query[columns[i]][this.currentRow]>
		</cfloop>

		<cfreturn this>
	</cffunction>

	
	<!--- Miscellaneous functions --->


	<cffunction name="exists" returntype="boolean" access="public" output="false" hint="[DOCS] Returns true if the given id represents the primary key of a record in the database, false otherwise">
		<cfargument name="id" required="yes" type="numeric" hint="id of the record to check for existence">

		<cfset var checkQuery = "">

		<cfquery name="checkQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			SELECT id
			FROM #this._tableName#
			WHERE id = #arguments.id#
		</cfquery>
		
		<cfif checkQuery.recordcount IS NOT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	
	<cffunction name="isNewRecord" returntype="boolean" access="public" output="false" hint="[DOCS] Returns true if this object hasn't been saved yet — that is, a record for the object doesn't exist yet">
		<cfif this.id IS 0>
			<cfreturn true>
		<cfelseif this.id IS NOT "">
			<cfreturn false>
		</cfif>
	</cffunction>


	<cffunction name="columns" returntype="array" access="public" output="false" hint="[DOCS] Returns an array of column names">
		
		<cfreturn listToArray(this.columnList)>
	
	</cffunction>


	<cffunction name="contentColumns" returntype="array" access="public" output="false" hint="[DOCS] Returns an array of column names where the primary id, all columns ending in '_id' or '_count' have been removed">
		
		<cfset var contentColumns = arrayNew(1)>
		
		<cfloop list="#this.columnList#" index="column">
			<cfif column IS NOT "id" AND right(column, 3) IS NOT "_id" AND right(column, 6) IS NOT "_count">
				<cfset arrayAppend(contentColumns, column)>
			</cfif>
		</cfloop>
		
		<cfreturn contentColumns>	
	</cffunction>


	<cffunction name="reload" returntype="any" access="public" output="false" hint="[DOCS] Reloads the variables for this object from the database">
		
		<cfreturn findById(this.id)>
		
	</cffunction>


	<!--- Internal functions called from other functions in this file --->
	
	
	<cffunction name="initDAO" access="private" returntype="any" output="false" hint="Initializes this as a 'DAO' model (single record returned)">
		<cfargument name="theRecord" type="query" required="yes" hint="The one-record query to turn into the model">
	
		<cfset var queryCols = listToArray(arguments.theRecord.columnList)>
		<cfset var i = 1>
		
		<!--- Loop through each column in the query --->
		<cfloop index="i" from="1" to="#arrayLen(queryCols)#">
			<!--- For each row, change the column names into struct keys and the column data into struct values --->
			<cfif arguments.theRecord[queryCols[i]][1] IS NOT "" OR variables.fields[queryCols[i]].cfDataType IS NOT "numeric">
				<cfset this[queryCols[i]] = arguments.theRecord[queryCols[i]][1]>
			</cfif>
		</cfloop>
		
		<cfset this.recordCount = 1>
		
		<cfreturn this>
	
	</cffunction>
	
	
	<cffunction name="initGateway" access="private" returntype="any" output="false" hint="Initializes this as a 'gateway' model (query results)">
		<cfargument name="theQuery" type="query" required="true" hint="The query that represents the data">
		
		<cfset this.query = arguments.theQuery>
		<cfset this.recordCount = arguments.theQuery.recordCount>
		
		<cfreturn this>
	</cffunction>


	<cffunction name="setValue" returntype="void" access="public" output="false" hint="">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="string" required="true">

		<cfif variables.fields[arguments.name].cfDataType IS "boolean" AND NOT isBoolean(arguments.value)>
			<cfif arguments.value IS "" OR arguments.value IS 0>
				<cfset this[arguments.name] = false>
			<cfelse>
				<cfset this[arguments.name] = true>
			</cfif>
		<cfelseif variables.fields[arguments.name].cfDataType IS "numeric" AND NOT isNumeric(arguments.value)>
			<cfset this[arguments.name] = 0>
		<cfelse>
			<cfset this[arguments.name] = arguments.value>
		</cfif>

	</cffunction>

	
	<cffunction name="insertRecord" access="private" output="false" returntype="boolean" hint="Inserts a new record into the database">
	
		<cfset var columnsWithoutID = listDeleteAt(this.columnList,listFind(this.columnList,"id"))>
		<cfset var columnArray = listToArray(columnsWithoutID)>
		<cfset var insertColumns = arrayNew(1)>
		<cfset var joinTable = "">
		<cfset var thisKey = "">
		<cfset var foreignKey = "">
		<cfset var insert_record = "">
		<cfset var get_id = "">
		<cfset var deleteRelationships = "">
		<cfset var createRelationships = "">
		
		<!--- Set default created_at and created_on times --->
		<cfif isDefined('this.created_at') AND this.created_at IS "">
			<cfset this.created_at = "#dateFormat(now(),'yyyy-mm-dd')# #timeFormat(now(),'HH:mm:ss')#">
		</cfif>
		
		<cfif isDefined('this.created_on') AND this.created_on IS "">
			<cfset this.created_at = dateFormat(now(),'yyyy-mm-dd')>
		</cfif>
		
		<cfif StructKeyExists(this,'lock_version')>
			<cfset this.lock_version = 0>
		</cfif>

		<!--- Loop through each column and see if there's value for it. If so, insert it into a new list of columns --->
		<cfloop from="1" to="#arrayLen(columnArray)#" index="i">
			<cfif this[columnArray[i]] IS NOT "">
				<cfset arrayAppend(insertColumns, columnArray[i])>
			</cfif>
		</cfloop>

		<!--- If there is no id then this is a new record and must be inserted into the database --->
		<cftransaction>
			<cfquery name="insert_record" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#" maxrows="1" result="sql">
				INSERT INTO	#this._tableName#(#arrayToList(insertColumns)#)
				VALUES (
					<cfloop index="i" from="1" to="#arrayLen(insertColumns)#">
							<cfqueryparam cfsqltype="#variables.fields[insertColumns[i]].cfSqlType#" value="#this[insertColumns[i]]#" null="#Iif(this[insertColumns[i]] IS "null", DE("yes"), DE("no"))#">
							<cfif i IS NOT arrayLen(insertColumns)>,</cfif>
					</cfloop> )
			</cfquery>
			<cfquery name="get_id" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#" maxrows="1">
				SELECT		*
				FROM		#this._tableName#
				ORDER BY	id desc
			</cfquery>
			<cfset this.id = get_id.id>
		</cftransaction>

		<cfreturn true>
	
	</cffunction>
	
	
	<cffunction name="updateRecord" access="private" output="false" returntype="boolean" hint="Updates an existing record in the database">

		<cfset var columnsWithoutID = listDeleteAt(this.columnList,listFind(this.columnList,"id"))>
		<cfset var columnArray = listToArray(columnsWithoutID)>
		<cfset var updateColumns = arrayNew(1)>
		<cfset var joinTable = "">
		<cfset var thisKey = "">
		<cfset var foreignKey = "">
		<cfset var insert_record = "">
		<cfset var get_id = "">
		<cfset var deleteRelationships = "">
		<cfset var createRelationships = "">
		<cfset var check_lock_version = false>
		<cfset var new_lock_version = 0>
		
		<!--- Set default created_at and created_on times --->
		<cfif isDefined('this.updated_at') AND this.updated_at IS "">
			<cfset this.updated_at = "#dateFormat(now(),'yyyy-mm-dd')# #timeFormat(now(),'HH:mm:ss')#">
		</cfif>
		
		<cfif isDefined('this.updated_on') AND this.updated_on IS "">
			<cfset this.updated_on = dateFormat(now(),'yyyy-mm-dd')>
		</cfif>
		
		<!--- check to see if we need validate the lock_version --->
		<cfif StructKeyExists(this,'lock_version')>
			<cfset check_lock_version = true>
		</cfif>

		<!--- Loop through each column and see if there's value for it. If so, insert it into a new list of columns --->
		<cfloop from="1" to="#arrayLen(columnArray)#" index="i">
			<cfif this[columnArray[i]] IS NOT "">
				<cfset arrayAppend(updateColumns,columnArray[i])>
			</cfif>
		</cfloop>
		
		<cfquery name="get_id" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#" maxrows="1">
			SELECT	*
			FROM	#this._tableName#
			WHERE	id = #this.id#
		</cfquery>
		
		<cfif get_id.recordCount IS NOT 0>

			<!--- if the lock version is not the same as the one we currently have throw an error --->
			<cfif check_lock_version>
				<cfif get_id.lock_version neq this.lock_version>
					<cfthrow type="wheels.optimisticLockingException" message="OptimisticLockingException: Lock values did not match in '#this._tableName#' table for id '#this.id#'" detail="You attempted to update the table '#this._tableName#' for id = #this.id# with a stale object">
				<cfelse>
					<cfset this.lock_version = this.lock_version + 1>
				</cfif>
			</cfif>

			<cfquery name="update_record" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#" maxrows="1">
				UPDATE	#this._tableName#
				SET	
					<cfloop index="i" from="1" to="#arrayLen(updateColumns)#">
						#updateColumns[i]# = <cfqueryparam cfsqltype="#variables.fields[updateColumns[i]].cfSqlType#" value="#this[updateColumns[i]]#" null="#Iif(this[updateColumns[i]] IS "null", DE("yes"), DE("no"))#">
						<cfif i IS NOT arrayLen(updateColumns)>,</cfif>
					</cfloop>
				WHERE	id = #this.id#
			</cfquery>
			
			<cfreturn true>

		<cfelse>

			<cfreturn false>

		</cfif>
		
	</cffunction>


	<cffunction name="getOrderByColumns" access="public" returntype="string" output="false" hint="">

		<cfset var orderByColumns = "">
		<cfset var modelObj = "">
		<cfset var added = "">
		<cfset var pos = 0>

		<cfif arguments.order IS "">
			<cfset orderByColumns = this._tableName & ".id ASC">
		<cfelse>
			<cfset pos = 0>
			<cfloop list="#arguments.order#" index="column">
				<cfset pos = pos + 1>
				<cfif column Does not Contain "ASC" AND column Does not Contain "DESC">
					<cfset column = column & " ASC">
				</cfif>
				<cfif column Does Not Contain ".">
					<cfset added = false>
					<cfif StructKeyExists(arguments, "include") AND arguments.include IS NOT "">
						<cfloop list="#arguments.include#" index="name">
							<cfset modelObj = application.core.model(trim(name))>
							<cfif listFindNoCase(modelObj.columnList, replaceNoCase(replaceNoCase(trim(column), " DESC", ""), " ASC", "")) IS NOT 0 AND listFindNoCase(this.columnList, replaceNoCase(replaceNoCase(trim(column), " DESC", ""), " ASC", "")) IS 0>
								<cfset orderByColumns = orderByColumns & modelObj._tableName & "." & trim(column)>					
								<cfset added = true>
							</cfif>
						</cfloop>
					</cfif>
					<cfif NOT added>
						<cfset orderByColumns = orderByColumns & this._tableName & "." & trim(column)>
					</cfif>
				<cfelse>
					<cfset orderByColumns = orderByColumns & trim(column)>
				</cfif>
				<cfif listLen(arguments.order) GT pos>
					<cfset orderByColumns = orderByColumns & ",">
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn orderByColumns>
	</cffunction>


	<cffunction name="getSelectColumns" access="public" returntype="string" output="false" hint="">

		<cfset var selectColumns = "">
		<cfset var modelObj = "">
		<cfset var flattendedInclude = "">
		<cfset var pos = 0>
		
		<cfset pos = 0>
		<cfloop list="#this.columnList#" index="column">
			<cfset pos = pos + 1>
			<cfset selectColumns = selectColumns & this._tableName & "." & trim(column)>			
			<cfif listLen(this.columnList) GT pos>
				<cfset selectColumns = selectColumns & ",">
			</cfif>
		</cfloop>
		<cfif StructKeyExists(arguments, "include") AND arguments.include IS NOT "">
			<cfset flattendedInclude = replace(replace(arguments.include, "(", ",", "all"), ")", "", "all")>
			<cfloop list="#flattendedInclude#" index="name">
				<cfset modelObj = application.core.model(application.core.singularize(trim(name)))>
				<cfloop list="#modelObj.columnList#" index="column">
					<cfif listContainsNoCase(selectColumns, "." & trim(column)) IS 0>
						<cfset selectColumns = selectColumns & "," & modelObj._tableName & "." & trim(column)>
					<cfelse>
						<cfif listContainsNoCase(selectColumns, "." & modelObj._modelName & "_" & trim(column)) IS 0>
							<cfset selectColumns = selectColumns & "," & modelObj._tableName & "." & trim(column) & " AS " & modelObj._modelName & "_" & trim(column)>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

		<cfreturn selectColumns>
	</cffunction>


	<cffunction name="getFromTables" access="public" returntype="string" output="false" hint="">

		<cfset var fromTables = "">
		<cfset var expandedInclude = "">
		<cfset var modelString = "">
		<cfset var innerModelList = "">
		<cfset var outerModel = "">
		<cfset var innerModel = "">
		<cfset var joinTable = "">
		<cfset var pos = 0>

		<cfif StructKeyExists(arguments, "include") AND arguments.include IS NOT "">
			<cfset expandedInclude = "#this._modelName#(#arguments.include#)">
			<cfloop condition="#expandedInclude# Contains '('">
				<cfset pos = 1>
				<cfloop condition="#reFindNoCase('\(([a-z]|,)*\)', expandedInclude, pos, true).pos[1]# GT 0">
					<cfset modelString = reFindNoCase("\(([a-z]|,)*\)", expandedInclude, pos, true)>
					<cfset outerModel = application.core.model(application.core.singularize(reverse(spanExcluding(reverse(left(expandedInclude, modelString.pos[1]-1)), ",("))))>
					<cfset innerModelList = replaceList(mid(expandedInclude, modelString.pos[1], modelString.len[1]), "(,)", ",")>
					<cfloop list="#innerModelList#" index="model">
						<cfset innerModel = application.core.model(application.core.singularize(model))>
						<cfif listFindNoCase(outerModel.columnList, "#innerModel._modelName#_id")>
							<!--- belongsTo --->
							<cfset fromTables = "LEFT OUTER JOIN #innerModel._tableName# ON #outerModel._tableName#.#innerModel._modelName#_id = #innerModel._tableName#.id" & " " & fromTables>
						<cfelseif listFindNoCase(innerModel.columnList, "#outerModel._modelName#_id")>
							<!--- hasOne, hasMany --->
							<cfset fromTables = "LEFT OUTER JOIN #innerModel._tableName# ON #outerModel._tableName#.id = #innerModel._tableName#.#outerModel._modelName#_id" & " " & fromTables>
						<cfelse>
							<!--- hasAndBelongsToMany --->
							<cfset joinTable = application.core.joinTableName(outerModel._tableName, innerModel._tableName)>
							<cfset fromTables = "LEFT OUTER JOIN #joinTable# ON #outerModel._tableName#.id = #joinTable#.#outerModel._modelName#_id LEFT OUTER JOIN #innerModel._tableName# ON #joinTable#.#outerModel._modelName#_id = #innerModel._tableName#.id" & " " & fromTables>
						</cfif>
					</cfloop>
					<cfset pos = modelString.pos[2]>
				</cfloop>
				<cfset expandedInclude = reReplaceNoCase(expandedInclude, "\(([a-z]|,)*\)", "", "all")>
			</cfloop>
			<cfset fromTables = this._tableName & " " & fromTables>
		<cfelse>
			<cfset fromTables = this._tableName>		
		</cfif>

		<cfif StructKeyExists(arguments, "joins") AND arguments.joins IS NOT "">
			<cfset fromTables = fromTables & " " & arguments.joins>
		</cfif>

		<cfreturn fromTables>
	</cffunction>


	<cffunction name="getOrderByColumnsForPagination" access="public" returntype="string" output="false" hint="">
		<cfargument name="orderByColumns" required="yes" type="string" hint="">

		<cfset var orderByColumnsForPagination = "">

		<cfloop list="#arguments.orderByColumns#" index="column">
			<cfset orderByColumnsForPagination = listAppend(orderByColumnsForPagination, reverse(spanExcluding(reverse(trim(column)), ".")))>
		</cfloop>

		<cfreturn orderByColumnsForPagination>
	</cffunction>


	<cffunction name="getSelectColumnsForPagination" access="public" returntype="string" output="false" hint="">
		<cfargument name="selectColumns" required="yes" type="string" hint="">

		<cfset var selectColumnsForPagination = "">

		<cfloop list="#arguments.selectColumns#" index="column">
			<cfset selectColumnsForPagination = listAppend(selectColumnsForPagination, reverse(spanExcluding(reverse(trim(column)), ".")))>
		</cfloop>

		<cfreturn selectColumnsForPagination>
	</cffunction>


	<cffunction name="doToggle" access="public" output="false" returntype="boolean" hint="">
		<cfargument name="attribute" type="string" required="yes" hint="The attribute to toggle">

		<cfif isBoolean(this[arguments.attribute])>
			<cfif this[arguments.attribute]>
				<cfset setValue(arguments.attribute, false)>
			<cfelse>
				<cfset setValue(arguments.attribute, true)>
			</cfif>
		<cfelse>
			<cfreturn false>
		</cfif>
	
		<cfreturn true>
	</cffunction>


	<!--- Other functions --->


	<cffunction name="initModel" access="public" output="true" hint="Sets up some initial values for the model and generates code if need be">
		
		<!--- <cfinclude template="#application.pathTo.includes#/text.cfm" /> --->
		
		<!--- Have the model keep track of it's name --->
		<cfset this._modelName = application.core.getBaseModel(getMetaData().name)>
		<!--- Have the model keep track of the table it's accessing --->
		<cfif isDefined('this.primaryKey')>
			<cfset this._primaryKey = this.primaryKey>
		</cfif>

		<cfif NOT isDefined('application.wheels.models.#this._modelName#') OR application.settings.environment IS "development">
			<!--- If the tables have never been hashed, or we're in development, run the code generator --->
			<cfset createObject("component","cfwheels.models.generator").init(this)>
		</cfif>
		
		<cfset this._initialized = true>
		
		<cfreturn this>
	</cffunction>

	
	<cffunction name="queryToStruct" access="private" returntype="array" hint="Returns an array (for each row of the query) of structures (each value in the row)">
		<cfargument name="theQuery" required="yes" type="query" hint="The query to turn into an array of structures">
		
		<cfset var queryCols = listToArray(arguments.theQuery.columnList)>
		<cfset var queryRow = structNew()>
		<cfset var thisRecord = "">
		<cfset var thisArray = arrayNew(1)>
		<cfset var i = 1>
		
		<cfloop query="arguments.theQuery">
			<!--- Loop through each column in the query --->
			<cfloop index="i" from="1" to="#arrayLen(queryCols)#">
				<!--- For each row, change the column names into struct keys and the column data into struct values --->
				<cfset queryRow[queryCols[i]] = arguments.theQuery[queryCols[i]][currentRow]>
			</cfloop>
			<cfset arrayAppend(thisArray, duplicate(queryRow))>
		</cfloop>
		
		<cfreturn thisArray>
		
	</cffunction>
	
	
	<cffunction name="asArray" access="public" returntype="array" output="true" hint="Returns an array (for each row of the query) of structures (each value in the row)">
		
		<cfset var queryStruct = queryToStruct(this.query)>
		<cfset var theModel = "">
		<cfset var theArray = arrayNew(1)>
		
		<cfloop from="1" to="#arrayLen(queryStruct)#" index="i">
			<cfset theModel = application.core.model(this._modelName).findByID(queryStruct[i].id)>
			<cfset arrayAppend(theArray, theModel)>
		</cfloop>
		
		<cfreturn theArray>
		
	</cffunction>

	
	<cffunction name="getFieldData" access="public" returntype="struct" hint="">
		
		<cfreturn variables.fields>
		
	</cffunction>
	

	<cffunction name="executeSQL" access="public" returntype="void" output="false">
		<cfargument name="sql" type="string" required="yes">
		<cfset var executeSQLQuery = "">
		<cfquery name="executeSQLQuery" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
			#preserveSingleQuotes(arguments.sql)#
		</cfquery>
	</cffunction>
	
<!---
   Copyright 2006 Rob Cameron

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
	
</cfcomponent>
