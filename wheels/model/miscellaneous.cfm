<cffunction name="onMissingMethod" returntype="any" access="public" output="false">
	<cfargument name="missingMethodName" type="any" required="true">
	<cfargument name="missingMethodArguments" type="any" required="true">
	<cfset var locals = structNew()>

	<cfif left(arguments.missingMethodName, 9) IS "findOneBy" OR left(arguments.missingMethodName, 9) IS "findAllBy">
		<!--- dynamic finder --->
		<cfset locals.finderFields = listToArray(replaceNoCase(replaceNoCase(replace(arguments.missingMethodName, "And", "|"), "findAllBy", ""), "findOneBy", ""), "|")>
		<cfset locals.firstFieldName = locals.finderFields[1]>
		<cfif arrayLen(locals.finderFields) IS 2>
			<cfset locals.secondFieldName = locals.finderFields[2]>
		<cfelse>
			<cfset locals.secondFieldName = "">
		</cfif>

		<cfset locals.addToWhere = "#locals.firstFieldName# = '#trim(listFirst(arguments.missingMethodArguments[1]))#'">
		<cfif locals.secondFieldName IS NOT "">
			<cfset locals.addToWhere = locals.addToWhere & " AND #locals.secondFieldName# = '#trim(listLast(arguments.missingMethodArguments[1]))#'">
		</cfif>

		<cfif structKeyExists(arguments.missingMethodArguments, "where")>
			<cfset arguments.missingMethodArguments.where = "(" & arguments.missingMethodArguments.where & ") AND (" & locals.addToWhere & ")">
		<cfelse>
			<cfset arguments.missingMethodArguments.where = locals.addToWhere>
		</cfif>

		<cfif left(arguments.missingMethodName, 9) IS "findOneBy">
			<cfset structDelete(arguments.missingMethodArguments, "1")>
			<cfset structDelete(arguments.missingMethodArguments, "values")>
			<cfreturn findOne(argumentCollection=arguments.missingMethodArguments)>
		<cfelseif left(arguments.missingMethodName, 9) IS "findAllBy">
			<cfset structDelete(arguments.missingMethodArguments, "1")>
			<cfset structDelete(arguments.missingMethodArguments, "values")>
			<cfreturn findAll(argumentCollection=arguments.missingMethodArguments)>
		</cfif>

	<cfelse>
		<cfloop collection="#variables.class.associations#" item="locals.i">
			<cfif listFindNoCase(variables.class.associations[locals.i].methods, arguments.missingMethodName) IS NOT 0>
				<!--- Set name from "posts" to "objects", for example, so we can use it in the switch below --->
				<cfset locals.name = replaceNoCase(replaceNoCase(arguments.missingMethodName, _pluralize(locals.i), "objects"), _singularize(locals.i), "object")>
				<cfset locals.info = variables.class.associations[locals.i]>
				<cfif locals.info.type IS "hasMany">
					<cfset locals.where = "#locals.info.foreignKey# = #this[locals.info.primaryKey]#">
					<cfif structKeyExists(arguments.missingMethodArguments, "where")>
						<cfset locals.where = "(#locals.where#) AND (#arguments.missingMethodArguments.where#)">
					</cfif>
					<cfswitch expression="#locals.name#">
						<cfcase value="objects">
							<cfset arguments.missingMethodArguments.where = locals.where>
							<cfreturn model(locals.info.associatedModelName).findAll(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="addObject">
							<cfset locals.object = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))]>
							<cfset locals.attributes[locals.info.foreignKey] = this[locals.info.primaryKey]>
							<cfreturn locals.object.update(attributes=locals.attributes)>
						</cfcase>
						<cfcase value="deleteObject">
							<cfset locals.object = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))]>
							<cfset locals.attributes[locals.info.foreignKey] = "">
							<cfreturn locals.object.update(attributes=locals.attributes)>
						</cfcase>
						<cfcase value="clearObjects">
							<cfset arguments.missingMethodArguments.where = locals.where>
							<cfset arguments.missingMethodArguments.attributes[locals.info.foreignKey] = "">
							<cfreturn model(locals.info.associatedModelName).updateAll(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="newObject">
							<cfset arguments.missingMethodArguments[locals.info.foreignKey] = this[locals.info.primaryKey]>
							<cfreturn model(locals.info.associatedModelName).new(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="createObject">
							<cfset arguments.missingMethodArguments[locals.info.foreignKey] = this[locals.info.primaryKey]>
							<cfreturn model(locals.info.associatedModelName).create(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="findOneObject">
							<cfset arguments.missingMethodArguments.where = locals.where>
							<cfreturn model(locals.info.associatedModelName).findOne(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="findObjectById">
							<cfset arguments.missingMethodArguments.where = "(#locals.where#) AND (#locals.info.primaryKey# = #arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))]#)">
							<cfreturn model(locals.info.associatedModelName).findOne(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="hasObjects">
							<cfreturn model(locals.info.associatedModelName).count(where=locals.where) IS NOT 0>
						</cfcase>
						<cfcase value="objectCount">
							<cfset arguments.missingMethodArguments.where = locals.where>
							<cfreturn model(locals.info.associatedModelName).count(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
					</cfswitch>
				<cfelseif locals.info.type IS "hasOne">
					<cfset locals.where = "#locals.info.foreignKey# = #this[locals.info.primaryKey]#">
					<cfif structKeyExists(arguments.missingMethodArguments, "where")>
						<cfset locals.where = "(#locals.where#) AND (#arguments.missingMethodArguments.where#)">
					</cfif>
					<cfswitch expression="#locals.name#">
						<cfcase value="object">
							<cfset arguments.missingMethodArguments.where = locals.where>
							<cfreturn model(locals.info.associatedModelName).findOne(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="setObject">
							<cfset locals.object = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))]>
							<cfset locals.attributes[locals.info.foreignKey] = this[locals.info.primaryKey]>
							<cfreturn locals.object.update(attributes=locals.attributes)>
						</cfcase>
						<cfcase value="newObject">
							<cfset arguments.missingMethodArguments[locals.info.foreignKey] = this[locals.info.primaryKey]>
							<cfreturn model(locals.info.associatedModelName).new(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="createObject">
							<cfset arguments.missingMethodArguments[locals.info.foreignKey] = this[locals.info.primaryKey]>
							<cfreturn model(locals.info.associatedModelName).create(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="hasObject">
							<cfreturn model(locals.info.associatedModelName).count(where=locals.where) IS NOT 0>
						</cfcase>
					</cfswitch>
				<cfelseif locals.info.type IS "belongsTo">
					<cfset locals.where = "#locals.info.primaryKey# = #this[locals.info.foreignKey]#">
					<cfif structKeyExists(arguments.missingMethodArguments, "where")>
						<cfset locals.where = "(#locals.where#) AND (#arguments.missingMethodArguments.where#)">
					</cfif>
					<cfswitch expression="#locals.name#">
						<cfcase value="object">
							<cfset arguments.missingMethodArguments.where = locals.where>
							<cfreturn model(locals.info.associatedModelName).findOne(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="setObject">
							<cfset locals.object = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))]>
							<cfset locals.attributes[locals.info.primaryKey] = this[locals.info.foreignKey]>
							<cfreturn locals.object.update(attributes=locals.attributes)>
						</cfcase>
						<cfcase value="newObject">
							<cfset arguments.missingMethodArguments[locals.info.primaryKey] = this[locals.info.foreignKey]>
							<cfreturn model(locals.info.associatedModelName).new(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="createObject">
							<cfset arguments.missingMethodArguments[locals.info.primaryKey] = this[locals.info.foreignKey]>
							<cfreturn model(locals.info.associatedModelName).create(argumentCollection=arguments.missingMethodArguments)>
						</cfcase>
						<cfcase value="hasObject">
							<cfreturn model(locals.info.associatedModelName).count(where=locals.where) IS NOT 0>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<!--- if we get to here it means there is no method with this name so just throw an error instead --->
	<cfthrow type="wheels" extendedinfo="OnMissingMethod" message="Method <tt>#arguments.missingMethodName#</tt> does not exist" detail="Make sure you spelled the method name correctly.">

</cffunction>


<cffunction name="modifiedFields" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>

	<cfif structKeyExists(variables, "modifiedFields") AND len(variables.modifiedFields) IS NOT 0>
		<cfset locals.result = variables.modifiedFields>
	<cfelse>
		<cfset locals.result = "">
	</cfif>

	<cfreturn locals.result>
</cffunction>


<cffunction name="fieldWasModified" returntype="any" access="public" output="false">
	<cfargument name="fieldName" type="any" required="true">
	<cfset var locals = structNew()>

	<cfif structKeyExists(variables, "modifiedFields") AND listFindNoCase(variables.modifiedFields, arguments.fieldName) IS NOT 0>
		<cfset locals.result = true>
	<cfelse>
		<cfset locals.result = false>
	</cfif>

	<cfreturn locals.result>
</cffunction>


<cffunction name="wasModified" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>

	<cfif structKeyExists(variables, "modifiedFields") AND len(variables.modifiedFields) IS NOT 0>
		<cfset locals.result = true>
	<cfelse>
		<cfset locals.result = false>
	</cfif>

	<cfreturn locals.result>
</cffunction>


<cffunction name="hasComposedField" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="sql" type="any" required="true">
	<cfargument name="cfsqltype" type="any" required="false" default="cf_sql_varchar">
	<cfset variables.class.composedFields[arguments.name] = structNew()>
	<cfset variables.class.composedFields[arguments.name].sql = arguments.sql>
	<cfset variables.class.composedFields[arguments.name].cfsqltype = arguments.cfsqltype>
</cffunction>
