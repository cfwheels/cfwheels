<cffunction name="paginationHasPrevious" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginatedQuery">
	<cfif request.wheels[arguments.handle].currentPage GT 1>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="paginationHasNext" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginatedQuery">
	<cfif request.wheels[arguments.handle].currentPage LT request.wheels[arguments.handle].totalPages>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="paginationTotalPages" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginatedQuery">
	<cfreturn request.wheels[arguments.handle].totalPages>
</cffunction>

<cffunction name="paginationTotalRecords" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginatedQuery">
	<cfreturn request.wheels[arguments.handle].totalRecords>
</cffunction>

<cffunction name="paginationCurrentPage" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginatedQuery">
	<cfreturn request.wheels[arguments.handle].currentPage>
</cffunction>

<cffunction name="paginationLinks" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginatedQuery">
	<cfargument name="name" type="any" required="false" default="page">
	<cfargument name="windowSize" type="any" required="false" default=2>
	<cfargument name="alwaysShowAnchors" type="any" required="false" default="true">
	<cfargument name="linkToCurrentPage" type="any" required="false" default="false">
	<cfargument name="prependToLink" type="any" required="false" default="">
	<cfargument name="appendToLink" type="any" required="false" default="">
	<cfargument name="classForCurrent" type="any" required="false" default="">
	<cfargument name="params" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfset local.current_page = request.wheels[arguments.handle].currentPage>
	<cfset local.total_pages = request.wheels[arguments.handle].totalPages>
	<cfset local.link_to_arguments.action = variables.params.action>
	<cfif StructKeyExists(variables.params, "id")>
		<cfset local.link_to_arguments.id = variables.params.id>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif arguments.alwaysShowAnchors>
				<cfif (local.current_page - arguments.windowSize) GT 1>
					<cfset local.link_to_arguments.params = "#arguments.name#=1">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = 1>
					#linkTo(argumentCollection=local.link_to_arguments)# ...
				</cfif>
			</cfif>
			<cfloop from="1" to="#local.total_pages#" index="local.i">
				<cfif (local.i GTE (local.current_page - arguments.windowSize) AND local.i LTE local.current_page) OR (local.i LTE (local.current_page + arguments.windowSize) AND local.i GTE local.current_page)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.i#">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = local.i>
					<cfif len(arguments.classForCurrent) IS NOT 0 AND local.current_page IS local.i>
						<cfset local.link_to_arguments.attributes = "class=#arguments.classForCurrent#">
					<cfelse>
						<cfset local.link_to_arguments.attributes = "">
					</cfif>
					<cfif len(arguments.prependToLink) IS NOT 0>#arguments.prependToLink#</cfif><cfif local.current_page IS NOT local.i OR arguments.linkToCurrentPage>#linkTo(argumentCollection=local.link_to_arguments)#<cfelse><cfif len(arguments.classForCurrent) IS NOT 0><span class="#arguments.classForCurrent#">#local.i#</span><cfelse>#local.i#</cfif></cfif><cfif len(arguments.appendToLink) IS NOT 0>#arguments.appendToLink#</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.alwaysShowAnchors>
				<cfif local.total_pages GT (local.current_page + arguments.windowSize)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.total_pages#">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = local.total_pages>
				... #linkTo(argumentCollection=local.link_to_arguments)#
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn _trimHTML(local.output)>
</cffunction>
