<cffunction name="paginationLinks" returntype="string" access="public" output="false" hint="View, Helper, Builds and returns a string containing links to pages based on a paginated query.">
	<cfargument name="windowSize" type="numeric" required="false" default="2" hint="The number of page links to show around the current page">
	<cfargument name="alwaysShowAnchors" type="boolean" required="false" default="true" hint="Whether or not links to the first and last page should always be displayed">
	<cfargument name="linkToCurrentPage" type="boolean" required="false" default="false" hint="Whether or not the current page should be linked to">
	<cfargument name="prependToLink" type="string" required="false" default="" hint="String to be prepended before all links">
	<cfargument name="appendToLink" type="string" required="false" default="" hint="String to be appended after all links">
	<cfargument name="classForCurrent" type="string" required="false" default="" hint="Class name for the link to the current page">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">
	<cfargument name="name" type="string" required="false" default="page" hint="The name of the param that holds the current page number">
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
	--->

	<cfset loc.currentPage = request.wheels[arguments.handle].currentPage>
	<cfset loc.totalPages = request.wheels[arguments.handle].totalPages>
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

<cffunction name="includePartial" returntype="any" access="public" output="false" hint="View, Helper, Includes a specified file.">
	<cfargument name="name" type="any" required="true" hint="The name to the file to be included (starting with an optional path and with the underscore excluded). When only the name is supplied Wheels will look for the file in the current controller's view folder. When passing in a path it should be relative to the views folder. All partials should be saved with a leading underscore but the underscore should not be passed in to this function.">
	<cfargument name="cache" type="any" required="false" default="" hint="Number of minutes to cache the partial for.">
	<cfargument name="$type" type="any" required="false" default="include">

	<!---
		EXAMPLES:
		<cfoutput>#includePartial("login")#</cfoutput>
		-> If we're in the "Admin" controller Wheels will include the file "views/admin/_login.cfm".

		<cfoutput>#includePartial(name="shared/button", cache=15)#</cfoutput>
		-> Wheels will include the file "views/shared/_button.cfm" and cache it for 30 minutes.

		RELATED:
		 * [IncludingPartials Including Partials] (chapter)
		 * [renderPartial renderPartial()] (function)
	--->

	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="$trimHTML" returntype="string" access="public" output="false">
	<cfargument name="str" type="string" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>

<cffunction name="$getAttributes" returntype="string" access="public" output="false">
	<cfset var loc = {}>

	<cfset loc.attributes = "">
	<cfloop collection="#arguments#" item="loc.i">
		<cfif loc.i Does Not Contain "$" AND listFindNoCase(arguments.$namedArguments, loc.i) IS 0>
			<cfset loc.attributes = "#loc.attributes# #lCase(loc.i)#=""#arguments[loc.i]#""">
		</cfif>
	</cfloop>

	<cfreturn loc.attributes>
</cffunction>
