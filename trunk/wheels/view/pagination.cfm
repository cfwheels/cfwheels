<cffunction name="paginationHasPrevious" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfif request.wheels[arguments.handle].current_page GT 1>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="paginationHasNext" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfif request.wheels[arguments.handle].current_page LT request.wheels[arguments.handle].total_pages>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="paginationTotalPages" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfreturn request.wheels[arguments.handle].total_pages>
</cffunction>


<cffunction name="paginationTotalRecords" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfreturn request.wheels[arguments.handle].total_records>
</cffunction>


<cffunction name="paginationCurrentPage" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfreturn request.wheels[arguments.handle].current_page>
</cffunction>


<cffunction name="paginationLinks" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfargument name="name" type="any" required="false" default="page">
	<cfargument name="window_size" type="any" required="false" default=2>
	<cfargument name="always_show_anchors" type="any" required="false" default="true">
	<cfargument name="link_to_current_page" type="any" required="false" default="false">
	<cfargument name="prepend_to_link" type="any" required="false" default="">
	<cfargument name="append_to_link" type="any" required="false" default="">
	<cfargument name="class_for_current" type="any" required="false" default="">
	<cfargument name="params" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfset local.current_page = request.wheels[arguments.handle].current_page>
	<cfset local.total_pages = request.wheels[arguments.handle].total_pages>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif arguments.always_show_anchors>
				<cfif (local.current_page - arguments.window_size) GT 1>
					<cfset local.link_to_arguments.params = "#arguments.name#=1">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = 1>
					#linkTo(argumentCollection=local.link_to_arguments)# ...
				</cfif>
			</cfif>
			<cfloop from="1" to="#local.total_pages#" index="local.i">
				<cfif (local.i GTE (local.current_page - arguments.window_size) AND local.i LTE local.current_page) OR (local.i LTE (local.current_page + arguments.window_size) AND local.i GTE local.current_page)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.i#">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = local.i>
					<cfif len(arguments.class_for_current) IS NOT 0 AND local.current_page IS local.i>
						<cfset local.link_to_arguments.attributes = "class=#arguments.class_for_current#">
					<cfelse>
						<cfset local.link_to_arguments.attributes = "">
					</cfif>
					<cfif len(arguments.prepend_to_link) IS NOT 0>#arguments.prepend_to_link#</cfif><cfif local.current_page IS NOT local.i OR arguments.link_to_current_page>#linkTo(argumentCollection=local.link_to_arguments)#<cfelse><cfif len(arguments.class_for_current) IS NOT 0><span class="#arguments.class_for_current#">#local.i#</span><cfelse>#local.i#</cfif></cfif><cfif len(arguments.append_to_link) IS NOT 0>#arguments.append_to_link#</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.always_show_anchors>
				<cfif local.total_pages GT (local.current_page + arguments.window_size)>
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

	<cfreturn CFW_trimHTML(local.output)>
</cffunction>
