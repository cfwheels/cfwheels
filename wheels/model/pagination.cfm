<cffunction name="setPagination" access="public" output="false" returntype="void" hint="Allows you to set a pagination handle for a custom query so you can perform pagination on it in your view with `paginationLinks()`."
	examples=
	'
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
			engine''s documentation for the correct syntax.

			Also note that the view code will differ depending on the method
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

			<cfquery name="local.customQuery" datasource="##get(''dataSourceName'')##">
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
				Because we''re going to let `cfoutput`/`cfloop` handle the pagination,
				we''re going to need to get some addition information about the
				pagination.
			 --->
			<cfset paginationData = pagination("myCustomQueryHandle")>
		</cffunction>

		<!--- View code (using `cfloop`) --->
		<!--- Use the information from `paginationData` to page through the records --->
		<cfoutput>
		<ul>
		    <cfloop query="allUsers" statrow="##paginationData.startrow##" endrow="##paginationData.endrow##">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfloop>
		</ul>
		##paginationLinks(handle="myCustomQueryHandle")##
		</cfoutput>

		<!--- View code (using `cfoutput`) --->
		<!--- Use the information from `paginationData` to page through the records --->
		<ul>
		    <cfoutput query="allUsers" statrow="##paginationData.startrow##" maxrows="##paginationData.maxrows##">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfoutput>
		</ul>
		<cfoutput>##paginationLinks(handle="myCustomQueryHandle")##</cfoutput>


		<!---
			Second method: Handle the pagination through the database
		--->

		<!--- Model code --->
		<!--- In your model (ie. `User.cfc`), create a custom method for your custom query --->
		<cffunction name="myCustomQuery">
			<cfargument name="page" type="numeric">
			<cfargument name="perPage" type="numeric" required="false" default="25">

			<cfquery name="local.customQueryCount" datasource="##get(''dataSouceName'')##">
				SELECT COUNT(*) AS theCount FROM users
			</cfquery>

			<cfquery name="local.customQuery" datasource="##get(''dataSourceName'')##">
				SELECT * FROM users
				LIMIT ##arguments.page## OFFSET ##arguments.perPage##
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
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfloop>
		</ul>
		##paginationLinks(handle="myCustomQueryHandle")##
		</cfoutput>

		<!--- View code (using `cfoutput`) --->
		<ul>
		    <cfoutput query="allUsers">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfoutput>
		</ul>
		<cfoutput>##paginationLinks(handle="myCustomQueryHandle")##</cfoutput>
	'
	categories="model-class,miscellaneous" chapters="getting-paginated-data" functions="findAll,paginationLinks">
	<cfargument name="totalRecords" type="numeric" required="true" hint="Total count of records that should be represented by the paginated links.">
	<cfargument name="currentPage" type="numeric" required="false" default="1" hint="Page number that should be represented by the data being fetched and the paginated links.">
	<cfargument name="perPage" type="numeric" required="false" default="25" hint="Number of records that should be represented on each page of data.">
	<cfargument name="handle" type="string" required="false" default="query" hint="Name of handle to reference in @paginationLinks.">
	<cfscript>
		var loc = {};

		// all numeric values must be integers
		arguments.totalRecords = fix(arguments.totalRecords);
		arguments.currentPage = fix(arguments.currentPage);
		arguments.perPage = fix(arguments.perPage);

		// totalRecords cannot be negative
		if (arguments.totalRecords lt 0)
		{
			arguments.totalRecords = 0;
		}

		// perPage less then zero
		if (arguments.perPage lte 0)
		{
			arguments.perPage = 25;
		}

		// calculate the total pages the query will have
		arguments.totalPages = Ceiling(arguments.totalRecords/arguments.perPage);

		// currentPage shouldn't be less then 1 or greater then the number of pages
		if (arguments.currentPage gte arguments.totalPages)
		{
			arguments.currentPage = arguments.totalPages;
		}
		if (arguments.currentPage lt 1)
		{
			arguments.currentPage = 1;
		}

		// as a convinence for cfquery and cfloop when doing oldschool type pagination
		// startrow for cfquery and cfloop
		arguments.startRow = (arguments.currentPage * arguments.perPage) - arguments.perPage + 1;

		// maxrows for cfquery
		arguments.maxRows = arguments.perPage;

		// endrow for cfloop
		arguments.endRow = arguments.startRow + arguments.perPage;

		// endRow shouldn't be greater then the totalRecords or less than startRow
		if (arguments.endRow gte arguments.totalRecords)
		{
			arguments.endRow = arguments.totalRecords;
		}
		if (arguments.endRow lt arguments.startRow)
		{
			arguments.endRow = arguments.startRow;
		}

		loc.args = duplicate(arguments);
		structDelete(loc.args, "handle", false);
		request.wheels[arguments.handle] = loc.args;
	</cfscript>
</cffunction>