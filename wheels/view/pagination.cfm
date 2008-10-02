<cffunction name="paginationLinks" returntype="string" access="public" output="false" hint="View, Helper, Builds and returns a string containing links to pages based on a paginated query.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">
	<cfargument name="name" type="string" required="false" default="page" hint="The name of the param that holds the current page number">
	<cfargument name="windowSize" type="numeric" required="false" default="2" hint="The number of page links to show around the current page">
	<cfargument name="alwaysShowAnchors" type="boolean" required="false" default="true" hint="Whether or not links to the first and last page should always be displayed">
	<cfargument name="linkToCurrentPage" type="boolean" required="false" default="false" hint="Whether or not the current page should be linked to">
	<cfargument name="prependToLink" type="string" required="false" default="" hint="String to be prepended before all links">
	<cfargument name="appendToLink" type="string" required="false" default="" hint="String to be appended after all links">
	<cfargument name="classForCurrent" type="string" required="false" default="" hint="Class name for the link to the current page">
	<cfargument name="params" type="string" required="false" default="" hint="Any additional parameters that should be appended to the links">
	<cfset var loc = {}>

	<!---
		EXAMPLES:
		Controller code...
		<cfparam name="params.page" default="1">
		<cfset allAuthors = model("Author").findAll(page=params.page, perPage=25)>
		View code...
		<ul>
		  <cfoutput query="allAuthors">
		    <li>#firstName# #lastName#</li>
		  </cfoutput>
		</ul>
		<cfoutput>#paginationLinks()#</cfoutput>

		Controller code...
		<cfset allAuthors = model("Author").findAll(handle="authQuery", page=5)>
		View code...
		<ul>
		  <cfoutput>#paginationLinks(handle="authQuery", prependToLink="<li>", appendToLink="</li>")#</cfoutput>
		</ul>

		View code...
		<cfoutput>#paginationLinks(windowSize=5)#</cfoutput>

		RELATED:
		 * [GettingPaginatedData Getting Paginated Data] (chapter)
		 * [DisplayingLinksforPagination Displaying Links for Pagination] (chapter)
		 * [paginationHasPrevious paginationHasPrevious()] (function)
		 * [paginationHasNext paginationHasNext()] (function)
		 * [paginationTotalPages paginationTotalPages()] (function)
		 * [paginationTotalRecords paginationTotalRecords()] (function)
		 * [paginationCurrentPage paginationCurrentPage()] (function)
	--->

	<cfset loc.currentPage = paginationCurrentPage(arguments.handle)>
	<cfset loc.totalPages = paginationTotalPages(arguments.handle)>
	<cfset loc.linkToArguments.action = variables.params.action>
	<cfif StructKeyExists(variables.params, "key")>
		<cfset loc.linkToArguments.key = variables.params.key>
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<cfif arguments.alwaysShowAnchors>
				<cfif (loc.currentPage - arguments.windowSize) GT 1>
					<cfset loc.linkToArguments.params = "#arguments.name#=1">
					<cfif Len(arguments.params) IS NOT 0>
						<cfset loc.linkToArguments.params = loc.linkToArguments.params & "&" & arguments.params>
					</cfif>
					<cfset loc.linkToArguments.text = 1>
					#linkTo(argumentCollection=loc.linkToArguments)# ...
				</cfif>
			</cfif>
			<cfloop from="1" to="#loc.totalPages#" index="loc.i">
				<cfif (loc.i GTE (loc.currentPage - arguments.windowSize) AND loc.i LTE loc.currentPage) OR (loc.i LTE (loc.currentPage + arguments.windowSize) AND loc.i GTE loc.currentPage)>
					<cfset loc.linkToArguments.params = "#arguments.name#=#loc.i#">
					<cfif Len(arguments.params) IS NOT 0>
						<cfset loc.linkToArguments.params = loc.linkToArguments.params & "&" & arguments.params>
					</cfif>
					<cfset loc.linkToArguments.text = loc.i>
					<cfif Len(arguments.classForCurrent) IS NOT 0 AND loc.currentPage IS loc.i>
						<cfset loc.linkToArguments.attributes = "class=#arguments.classForCurrent#">
					<cfelse>
						<cfset loc.linkToArguments.attributes = "">
					</cfif>
					<cfif Len(arguments.prependToLink) IS NOT 0>#arguments.prependToLink#</cfif><cfif loc.currentPage IS NOT loc.i OR arguments.linkToCurrentPage>#linkTo(argumentCollection=loc.linkToArguments)#<cfelse><cfif Len(arguments.classForCurrent) IS NOT 0><span class="#arguments.classForCurrent#">#loc.i#</span><cfelse>#loc.i#</cfif></cfif><cfif Len(arguments.appendToLink) IS NOT 0>#arguments.appendToLink#</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.alwaysShowAnchors>
				<cfif loc.totalPages GT (loc.currentPage + arguments.windowSize)>
					<cfset loc.linkToArguments.params = "#arguments.name#=#loc.totalPages#">
					<cfif Len(arguments.params) IS NOT 0>
						<cfset loc.linkToArguments.params = loc.linkToArguments.params & "&" & arguments.params>
					</cfif>
					<cfset loc.linkToArguments.text = loc.totalPages>
				... #linkTo(argumentCollection=loc.linkToArguments)#
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="paginationHasPrevious" returntype="boolean" access="public" output="false" hint="View, Helper, Returns true if previous pages exists in the pagination.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">

	<!---
		EXAMPLES:
		<cfif paginationHasPrevious()>
		  do something...
		</cfif>

		RELATED:
		 * [GettingPaginatedData Getting Paginated Data] (chapter)
		 * [DisplayingLinksforPagination Displaying Links for Pagination] (chapter)
		 * [paginationLinks paginationLinks()] (function)
		 * [paginationHasNext paginationHasNext()] (function)
		 * [paginationTotalPages paginationTotalPages()] (function)
		 * [paginationTotalRecords paginationTotalRecords()] (function)
		 * [paginationCurrentPage paginationCurrentPage()] (function)
	--->

	<cfif request.wheels[arguments.handle].currentPage GT 1>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="paginationHasNext" returntype="boolean" access="public" output="false" hint="View, Helper, Returns true if more pages exists in the pagination.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">

	<!---
		EXAMPLES:
		<cfif paginationHasNext(handle="handleGivenInFindAllCall")>
		  do something...
		</cfif>

		RELATED:
		 * [GettingPaginatedData Getting Paginated Data] (chapter)
		 * [DisplayingLinksforPagination Displaying Links for Pagination] (chapter)
		 * [paginationLinks paginationLinks()] (function)
		 * [paginationHasPrevious paginationHasPrevious()] (function)
		 * [paginationTotalPages paginationTotalPages()] (function)
		 * [paginationTotalRecords paginationTotalRecords()] (function)
		 * [paginationCurrentPage paginationCurrentPage()] (function)
	--->

	<cfif request.wheels[arguments.handle].currentPage LT request.wheels[arguments.handle].totalPages>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="paginationTotalPages" returntype="numeric" access="public" output="false" hint="View, Helper, Returns the total number of pages in the pagination.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">

	<!---
		EXAMPLES:
		Showing page <cfoutput>#paginationCurrentPage()#</cfoutput> of <cfoutput>#paginationTotalPages()#</cfoutput> total.

		RELATED:
		 * [GettingPaginatedData Getting Paginated Data] (chapter)
		 * [DisplayingLinksforPagination Displaying Links for Pagination] (chapter)
		 * [paginationLinks paginationLinks()] (function)
		 * [paginationHasPrevious paginationHasPrevious()] (function)
		 * [paginationHasNext paginationHasNext()] (function)
		 * [paginationTotalRecords paginationTotalRecords()] (function)
		 * [paginationCurrentPage paginationCurrentPage()] (function)
	--->

	<cfreturn request.wheels[arguments.handle].totalPages>
</cffunction>

<cffunction name="paginationTotalRecords" returntype="numeric" access="public" output="false" hint="View, Helper, Returns the total number of records in the pagination.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">

	<!---
		EXAMPLES:
		<cfoutput>#paginationTotalRecords()#</cfoutput>

		RELATED:
		 * [GettingPaginatedData Getting Paginated Data] (chapter)
		 * [DisplayingLinksforPagination Displaying Links for Pagination] (chapter)
		 * [paginationLinks paginationLinks()] (function)
		 * [paginationHasPrevious paginationHasPrevious()] (function)
		 * [paginationHasNext paginationHasNext()] (function)
		 * [paginationTotalPages paginationTotalPages()] (function)
		 * [paginationCurrentPage paginationCurrentPage()] (function)
	--->

	<cfreturn request.wheels[arguments.handle].totalRecords>
</cffunction>

<cffunction name="paginationCurrentPage" returntype="numeric" access="public" output="false" hint="View, Helper, Returns the number of the page that is currently being displayed.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">

	<!---
		EXAMPLES:
		Showing page <cfoutput>#paginationCurrentPage()#</cfoutput> of <cfoutput>#paginationTotalPages()#</cfoutput> total.

		RELATED:
		 * [GettingPaginatedData Getting Paginated Data] (chapter)
		 * [DisplayingLinksforPagination Displaying Links for Pagination] (chapter)
		 * [paginationLinks paginationLinks()] (function)
		 * [paginationHasPrevious paginationHasPrevious()] (function)
		 * [paginationHasNext paginationHasNext()] (function)
		 * [paginationTotalPages paginationTotalPages()] (function)
		 * [paginationTotalRecords paginationTotalRecords()] (function)
	--->

	<cfreturn request.wheels[arguments.handle].currentPage>
</cffunction>