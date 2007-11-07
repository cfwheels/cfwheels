<cffunction name="onMissingMethod" returntype="any" access="public" output="false">
	<cfargument name="missingmethodname" type="string" required="true">
	<cfargument name="missingmethodarguments" type="struct" required="true">
	<cfset var local = structNew()>

	<cfif left(arguments.missingmethodname, 9) IS "findOneBy" OR left(arguments.missingmethodname, 9) IS "findAllBy">
		<!--- dynamic finder --->
		<cfset local.finder_fields = listToArray(replaceNoCase(replaceNoCase(replace(arguments.missingmethodname, "And", "|"), "findAllBy", ""), "findOneBy", ""), "|")>
		<cfset local.first_field_name = underscore(local.finder_fields[1])>
		<cfif arrayLen(local.finder_fields) IS 2>
			<cfset local.second_field_name = underscore(local.finder_fields[2])>
		<cfelse>
			<cfset local.second_field_name = "">
		</cfif>

		<cfset local.add_to_where = "#local.first_field_name# = '#trim(listFirst(arguments.missingmethodarguments[1]))#'">
		<cfif local.second_field_name IS NOT "">
			<cfset local.add_to_where = local.add_to_where & " AND #local.second_field_name# = '#trim(listLast(arguments.missingmethodarguments[1]))#'">
		</cfif>

		<cfif structKeyExists(arguments.missingmethodarguments, "where")>
			<cfset arguments.missingmethodarguments.where = "(" & arguments.missingmethodarguments.where & ") AND (" & local.add_to_where & ")">
		<cfelse>
			<cfset arguments.missingmethodarguments.where = local.add_to_where>
		</cfif>

		<cfif left(arguments.missingmethodname, 9) IS "findOneBy">
			<cfset structDelete(arguments.missingmethodarguments, "1")>
			<cfset structDelete(arguments.missingmethodarguments, "values")>
			<cfreturn findOne(argumentCollection=arguments.missingmethodarguments)>
		<cfelseif left(arguments.missingmethodname, 9) IS "findAllBy">
			<cfset structDelete(arguments.missingmethodarguments, "1")>
			<cfset structDelete(arguments.missingmethodarguments, "values")>
			<cfreturn findAll(argumentCollection=arguments.missingmethodarguments)>
		</cfif>

	<cfelse>
		<cfloop collection="#variables.class.associations#" item="local.i">
			<cfif listFindNoCase(variables.class.associations[local.i].methods, arguments.missingmethodname) IS NOT 0>
				<!--- Set name from "posts" to "objects", for example, so we can use it in the switch below --->
				<cfset local.name = replaceNoCase(replaceNoCase(arguments.missingmethodname, pluralize(local.i), "objects"), singularize(local.i), "object")>
				<cfset local.info = variables.class.associations[local.i]>
				<cfif local.info.type IS "has_many">
					<cfset local.where = "#local.info.foreign_key# = #this[local.info.primary_key]#">
					<cfif structKeyExists(arguments.missingmethodarguments, "where")>
						<cfset local.where = "(#local.where#) AND (#arguments.missingmethodarguments.where#)">
					</cfif>
					<cfswitch expression="#local.name#">
						<cfcase value="objects">
							<cfset arguments.missingmethodarguments.where = local.where>
							<cfreturn model(local.info.associated_model_name).findAll(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="addObject">
							<cfset local.object = arguments.missingmethodarguments[listFirst(structKeyList(arguments.missingmethodarguments))]>
							<cfset local.attributes[local.info.foreign_key] = this[local.info.primary_key]>
							<cfreturn local.object.update(attributes=local.attributes)>
						</cfcase>
						<cfcase value="deleteObject">
							<cfset local.object = arguments.missingmethodarguments[listFirst(structKeyList(arguments.missingmethodarguments))]>
							<cfset local.attributes[local.info.foreign_key] = "">
							<cfreturn local.object.update(attributes=local.attributes)>
						</cfcase>
						<cfcase value="clearObjects">
							<cfset arguments.missingmethodarguments.where = local.where>
							<cfset arguments.missingmethodarguments.attributes[local.info.foreign_key] = "">
							<cfreturn model(local.info.associated_model_name).updateAll(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="newObject">
							<cfset arguments.missingmethodarguments[local.info.foreign_key] = this[local.info.primary_key]>
							<cfreturn model(local.info.associated_model_name).new(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="createObject">
							<cfset arguments.missingmethodarguments[local.info.foreign_key] = this[local.info.primary_key]>
							<cfreturn model(local.info.associated_model_name).create(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="findOneObject">
							<cfset arguments.missingmethodarguments.where = local.where>
							<cfreturn model(local.info.associated_model_name).findOne(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="findObjectByID">
							<cfset arguments.missingmethodarguments.where = "(#local.where#) AND (#local.info.primary_key# = #arguments.missingmethodarguments[listFirst(structKeyList(arguments.missingmethodarguments))]#)">
							<cfreturn model(local.info.associated_model_name).findOne(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="hasObjects">
							<cfreturn model(local.info.associated_model_name).count(where=local.where) IS NOT 0>
						</cfcase>
						<cfcase value="objectCount">
							<cfset arguments.missingmethodarguments.where = local.where>
							<cfreturn model(local.info.associated_model_name).count(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
					</cfswitch>
				<cfelseif local.info.type IS "has_one">
					<cfset local.where = "#local.info.foreign_key# = #this[local.info.primary_key]#">
					<cfif structKeyExists(arguments.missingmethodarguments, "where")>
						<cfset local.where = "(#local.where#) AND (#arguments.missingmethodarguments.where#)">
					</cfif>
					<cfswitch expression="#local.name#">
						<cfcase value="object">
							<cfset arguments.missingmethodarguments.where = local.where>
							<cfreturn model(local.info.associated_model_name).findOne(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="setObject">
							<cfset local.object = arguments.missingmethodarguments[listFirst(structKeyList(arguments.missingmethodarguments))]>
							<cfset local.attributes[local.info.foreign_key] = this[local.info.primary_key]>
							<cfreturn local.object.update(attributes=local.attributes)>
						</cfcase>
						<cfcase value="newObject">
							<cfset arguments.missingmethodarguments[local.info.foreign_key] = this[local.info.primary_key]>
							<cfreturn model(local.info.associated_model_name).new(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="createObject">
							<cfset arguments.missingmethodarguments[local.info.foreign_key] = this[local.info.primary_key]>
							<cfreturn model(local.info.associated_model_name).create(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="hasObject">
							<cfreturn model(local.info.associated_model_name).count(where=local.where) IS NOT 0>
						</cfcase>
					</cfswitch>
				<cfelseif local.info.type IS "belongs_to">
					<cfset local.where = "#local.info.primary_key# = #this[local.info.foreign_key]#">
					<cfif structKeyExists(arguments.missingmethodarguments, "where")>
						<cfset local.where = "(#local.where#) AND (#arguments.missingmethodarguments.where#)">
					</cfif>
					<cfswitch expression="#local.name#">
						<cfcase value="object">
							<cfset arguments.missingmethodarguments.where = local.where>
							<cfreturn model(local.info.associated_model_name).findOne(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="setObject">
							<cfset local.object = arguments.missingmethodarguments[listFirst(structKeyList(arguments.missingmethodarguments))]>
							<cfset local.attributes[local.info.primary_key] = this[local.info.foreign_key]>
							<cfreturn local.object.update(attributes=local.attributes)>
						</cfcase>
						<cfcase value="newObject">
							<cfset arguments.missingmethodarguments[local.info.primary_key] = this[local.info.foreign_key]>
							<cfreturn model(local.info.associated_model_name).new(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="createObject">
							<cfset arguments.missingmethodarguments[local.info.primary_key] = this[local.info.foreign_key]>
							<cfreturn model(local.info.associated_model_name).create(argumentCollection=arguments.missingmethodarguments)>
						</cfcase>
						<cfcase value="hasObject">
							<cfreturn model(local.info.associated_model_name).count(where=local.where) IS NOT 0>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<!--- if we get to here it means there is no method with this name so just throw an error instead --->
	<cfthrow type="wheels" extendedinfo="OnMissingMethod" message="Method <tt>#arguments.missingmethodname#</tt> does not exist" detail="Make sure you spelled the method name correctly.">

</cffunction>


<cffunction name="modifiedFields" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables, "modified_fields") AND len(variables.modified_fields) IS NOT 0>
		<cfset local.result = variables.modified_fields>
	<cfelse>
		<cfset local.result = "">
	</cfif>

	<cfreturn local.result>
</cffunction>


<cffunction name="fieldWasModified" returntype="any" access="public" output="false">
	<cfargument name="field_name" type="any" required="true">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables, "modified_fields") AND listFindNoCase(variables.modified_fields, arguments.field_name) IS NOT 0>
		<cfset local.result = true>
	<cfelse>
		<cfset local.result = false>
	</cfif>

	<cfreturn local.result>
</cffunction>


<cffunction name="wasModified" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfif structKeyExists(variables, "modified_fields") AND len(variables.modified_fields) IS NOT 0>
		<cfset local.result = true>
	<cfelse>
		<cfset local.result = false>
	</cfif>

	<cfreturn local.result>
</cffunction>


<cffunction name="hasVirtualField" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="sql" type="any" required="true">
	<cfargument name="cfsqltype" type="any" required="false" default="cf_sql_varchar">
	<cfset "variables.class.virtual_fields.#arguments.name#.sql" = arguments.sql>
	<cfset "variables.class.virtual_fields.#arguments.name#.cfsqltype" = arguments.cfsqltype>
</cffunction>
