# setPagination()

## Description
Allows you to set a pagination handle for a custom query so you can perform pagination on it in your view with `paginationLinks()`.

## Function Syntax
	setPagination( totalRecords, [ currentPage, perPage, handle ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>totalRecords</td>
			<td>numeric</td>
			<td>true</td>
			<td></td>
			<td>Total count of records that should be represented by the paginated links.</td>
		</tr>
		
		<tr>
			<td>currentPage</td>
			<td>numeric</td>
			<td>false</td>
			<td>1</td>
			<td>Page number that should be represented by the data being fetched and the paginated links.</td>
		</tr>
		
		<tr>
			<td>perPage</td>
			<td>numeric</td>
			<td>false</td>
			<td>25</td>
			<td>Number of records that should be represented on each page of data.</td>
		</tr>
		
		<tr>
			<td>handle</td>
			<td>string</td>
			<td>false</td>
			<td>query</td>
			<td>Name of handle to reference in @paginationLinks.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!---
			Note that there are two ways to do pagination yourself using
			a custom query.

			1) Do a query that grabs everything that matches and then use
			the `cfouput` or `cfloop` tag to page through the results.

			2) Use your database to make 2 queries. The first query
			basically does a count of the total number of records that match
			the criteria and the second query actually selects the page of
			records for retrieval.

			In the example below, we will show how to write a custom query
			using both of these methods. Note that the syntax where your
			database performs the pagination will differ depending on the
			database engine you are using. Plese consult your database
			engine's documentation for the correct syntax.

			also note that the view code will differ depending on the method
			used.
		--->

		<!---
			First method: Handle the pagination through your CFML engine
		--->

		<!--- Model code --->
		<!--- In your model (ie. User.cfc), create a custom method for your custom query --->
		<cffunction name="myCustomQuery">
			<cfargument name="page" type="numeric">
			<cfargument name="perPage" type="numeric" required="false" default="25">

			<cfquery name="local.customQuery" datasource="#get('dataSourceName')#">
				SELECT * FROM users
			</cfquery>

			<cfset setPagination(totalRecords=local.customQuery.RecordCount, currentPage=arguments.page, perPage=arguments.perPage, handle="myCustomQueryHandle")>
			<cfreturn customQuery>
		</cffunction>

		<!--- Controller code --->
		<cffunction name="list">
			<cfparam name="params.page" default="1">
			<cfparam name="params.perPage" default="25">

			<cfset allUsers = model("user").myCustomQuery(page=params.page, perPage=params.perPage)>
			<!---
				Because we're going to let `cfoutput`/`cfloop` handle the pagination,
				we're going to need to get some addition information about the
				pagination.
			 --->
			<cfset paginationData = pagination("myCustomQueryHandle")>
		</cffunction>

		<!--- View code (using `cfloop`) --->
		<!--- Use the information from `paginationData` to page through the records --->
		<cfoutput>
		<ul>
		    <cfloop query="allUsers" startrow="#paginationData.startrow#" endrow="#paginationData.endrow#">
		        <li>#allUsers.firstName# #allUsers.lastName#</li>
		    </cfloop>
		</ul>
		#paginationLinks(handle="myCustomQueryHandle")#
		</cfoutput>

		<!--- View code (using `cfoutput`) --->
		<!--- Use the information from `paginationData` to page through the records --->
		<ul>
		    <cfoutput query="allUsers" startrow="#paginationData.startrow#" maxrows="#paginationData.maxrows#">
		        <li>#allUsers.firstName# #allUsers.lastName#</li>
		    </cfoutput>
		</ul>
		<cfoutput>#paginationLinks(handle="myCustomQueryHandle")#</cfoutput>


		<!---
			Second method: Handle the pagination through the database
		--->

		<!--- Model code --->
		<!--- In your model (ie. `User.cfc`), create a custom method for your custom query --->
		<cffunction name="myCustomQuery">
			<cfargument name="page" type="numeric">
			<cfargument name="perPage" type="numeric" required="false" default="25">

			<cfquery name="local.customQueryCount" datasource="#get('dataSouceName')#">
				SELECT COUNT(*) AS theCount FROM users
			</cfquery>

			<cfquery name="local.customQuery" datasource="#get('dataSourceName')#">
				SELECT * FROM users
				LIMIT #arguments.page# OFFSET #arguments.perPage#
			</cfquery>

			<!--- Notice the we use the value from the first query for `totalRecords`  --->
			<cfset setPagination(totalRecords=local.customQueryCount.theCount, currentPage=arguments.page, perPage=arguments.perPage, handle="myCustomQueryHandle")>
			<!--- We return the second query --->
			<cfreturn customQuery>
		</cffunction>

		<!--- Controller code --->
		<cffunction name="list">
			<cfparam name="params.page" default="1">
			<cfparam name="params.perPage" default="25">
			<cfset allUsers = model("user").myCustomQuery(page=params.page, perPage=params.perPage)>
		</cffunction>

		<!--- View code (using `cfloop`) --->
		<cfoutput>
		<ul>
		    <cfloop query="allUsers">
		        <li>#allUsers.firstName# #allUsers.lastName#</li>
		    </cfloop>
		</ul>
		#paginationLinks(handle="myCustomQueryHandle")#
		</cfoutput>

		<!--- View code (using `cfoutput`) --->
		<ul>
		    <cfoutput query="allUsers">
		        <li>#allUsers.firstName# #allUsers.lastName#</li>
		    </cfoutput>
		</ul>
		<cfoutput>#paginationLinks(handle="myCustomQueryHandle")#</cfoutput>
