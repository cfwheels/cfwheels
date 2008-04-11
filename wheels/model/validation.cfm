<cffunction name="addError" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfargument name="message" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.error.field = arguments.field>
	<cfset locals.error.message = arguments.message>

	<cfif NOT structKeyExists(variables, "errors")>
		<cfset variables.errors = arrayNew(1)>
	</cfif>

	<cfset arrayAppend(variables.errors, locals.error)>

	<cfreturn true>
</cffunction>


<cffunction name="addErrorToBase" returntype="any" access="public" output="false">
	<cfargument name="message" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.error.field = "">
	<cfset locals.error.message = arguments.message>

	<cfif NOT structKeyExists(variables, "errors")>
		<cfset variables.errors = arrayNew(1)>
	</cfif>

	<cfset arrayAppend(variables.errors, locals.error)>

	<cfreturn true>
</cffunction>


<cffunction name="valid" returntype="any" access="public" output="false">
	<cfif _isNew()>
		<cfset _validateOnCreate()>
	<cfelse>
		<cfset _validateOnUpdate()>
	</cfif>
	<cfset _validate()>
	<cfreturn hasNoErrors()>
</cffunction>


<cffunction name="hasNoErrors" returntype="any" access="public" output="false">
	<cfif NOT structKeyExists(variables, "errors") OR arrayLen(variables.errors) IS 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="hasErrors" returntype="any" access="public" output="false">
	<cfif NOT structKeyExists(variables, "errors") OR arrayLen(variables.errors) IS 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>


<cffunction name="clearErrors" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables, "errors")>
		<cfset arrayClear(variables.errors)>
	</cfif>
	<cfreturn true>
</cffunction>


<cffunction name="errorCount" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables, "errors")>
		<cfreturn arrayLen(variables.errors)>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>


<cffunction name="errorsOn" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.allErrorMessages = arrayNew(1)>

	<cfif structKeyExists(variables, "errors")>
		<cfloop from="1" to="#arrayLen(variables.errors)#" index="locals.i">
			<cfif variables.errors[locals.i].field IS arguments.field>
				<cfset arrayAppend(locals.allErrorMessages, variables.errors[locals.i].message)>
			</cfif>
		</cfloop>
	</cfif>

	<cfif NOT structKeyExists(variables, "errors") OR arrayLen(locals.allErrorMessages) IS 0>
		<cfreturn false>
	<cfelse>
		<cfreturn locals.allErrorMessages>
	</cfif>
</cffunction>


<cffunction name="errorsOnBase" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>
	<cfset locals.result = errorsOn(field="")>
	<cfreturn locals.result>
</cffunction>


<cffunction name="allErrors" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>

	<cfset locals.allErrorMessages = arrayNew(1)>

	<cfif structKeyExists(variables, "errors")>
		<cfloop from="1" to="#arrayLen(variables.errors)#" index="locals.i">
			<cfset arrayAppend(locals.allErrorMessages, variables.errors[locals.i].message)>
		</cfloop>
	</cfif>

	<cfif NOT structKeyExists(variables, "errors") OR arrayLen(locals.allErrorMessages) IS 0>
		<cfreturn false>
	<cfelse>
		<cfreturn locals.allErrorMessages>
	</cfif>
</cffunction>


<cffunction name="validatesConfirmationOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset var locals = structNew()>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesConfirmationOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOn#arguments.on#.validatesConfirmationOf.#trim(locals.i)#.message" = locals.message>
	</cfloop>
</cffunction>


<cffunction name="validatesExclusionOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="in" type="any" required="yes">
	<cfargument name="allowBlank" type="any" required="no" default="false">
	<cfset var locals = structNew()>
	<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesExclusionOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOnSave.validatesExclusionOf.#trim(locals.i)#.message" = locals.message>
		<cfset "variables.class.validationsOnSave.validatesExclusionOf.#trim(locals.i)#.allowBlank" = arguments.allowBlank>
		<cfset "variables.class.validationsOnSave.validatesExclusionOf.#trim(locals.i)#.in" = arguments.in>
	</cfloop>
</cffunction>


<cffunction name="validatesFormatOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="allowBlank" type="any" required="no" default="false">
	<cfargument name="with" type="any" required="yes">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset var locals = structNew()>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesFormatOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOn#arguments.on#.validatesFormatOf.#trim(locals.i)#.message" = locals.message>
		<cfset "variables.class.validationsOn#arguments.on#.validatesFormatOf.#trim(locals.i)#.allowBlank" = arguments.allowBlank>
		<cfset "variables.class.validationsOn#arguments.on#.validatesFormatOf.#trim(locals.i)#.with" = arguments.with>
	</cfloop>
</cffunction>


<cffunction name="validatesInclusionOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="in" type="any" required="yes">
	<cfargument name="allowBlank" type="any" required="no" default="false">
	<cfset var locals = structNew()>
	<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesInclusionOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOnsave.validatesInclusionOf.#trim(locals.i)#.message" = locals.message>
		<cfset "variables.class.validationsOnsave.validatesInclusionOf.#trim(locals.i)#.allowBlank" = arguments.allowBlank>
		<cfset "variables.class.validationsOnsave.validatesInclusionOf.#trim(locals.i)#.in" = arguments.in>
	</cfloop>
</cffunction>


<cffunction name="validatesLengthOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="allowBlank" type="any" required="no" default="false">
	<cfargument name="exactly" type="any" required="no" default=0>
	<cfargument name="maximum" type="any" required="no" default=0>
	<cfargument name="minimum" type="any" required="no" default=0>
	<cfargument name="within" type="any" required="no" default="">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset var locals = structNew()>
	<cfif len(arguments.within) IS NOT 0>
		<cfset arguments.within = listToArray(replace(arguments.within, ", ", ",", "all"))>
	</cfif>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesLengthOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOn#arguments.on#.validatesLengthOf.#trim(locals.i)#.message" = locals.message>
		<cfset "variables.class.validationsOn#arguments.on#.validatesLengthOf.#trim(locals.i)#.allowBlank" = arguments.allowBlank>
		<cfset "variables.class.validationsOn#arguments.on#.validatesLengthOf.#trim(locals.i)#.exactly" = arguments.exactly>
		<cfset "variables.class.validationsOn#arguments.on#.validatesLengthOf.#trim(locals.i)#.maximum" = arguments.maximum>
		<cfset "variables.class.validationsOn#arguments.on#.validatesLengthOf.#trim(locals.i)#.minimum" = arguments.minimum>
		<cfset "variables.class.validationsOn#arguments.on#.validatesLengthOf.#trim(locals.i)#.within" = arguments.within>
	</cfloop>
</cffunction>


<cffunction name="validatesNumericalityOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="allowBlank" type="any" required="no" default="false">
	<cfargument name="onlyInteger" type="any" required="false" default="false">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset var locals = structNew()>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesNumericalityOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOn#arguments.on#.validatesNumericalityOf.#trim(locals.i)#.message" = locals.message>
		<cfset "variables.class.validationsOn#arguments.on#.validatesNumericalityOf.#trim(locals.i)#.allowBlank" = arguments.allowBlank>
		<cfset "variables.class.validationsOn#arguments.on#.validatesNumericalityOf.#trim(locals.i)#.onlyInteger" = arguments.onlyInteger>
	</cfloop>
</cffunction>


<cffunction name="validatesPresenceOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset var locals = structNew()>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesPresenceOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOn#arguments.on#.validatesPresenceOf.#trim(locals.i)#.message" = locals.message>
	</cfloop>
</cffunction>


<cffunction name="validatesUniquenessOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="">
	<cfargument name="scope" type="any" required="no" default="">
	<cfset var locals = structNew()>
	<cfset arguments.scope = replace(arguments.scope, ", ", ",", "all")>
	<cfloop list="#arguments.field#" index="locals.i">
		<cfif arguments.message IS NOT "">
			<cfset locals.message = arguments.message>
		<cfelse>
			<cfset locals.message = application.settings.validatesUniquenessOf.message>
		</cfif>
		<cfset locals.message = replace(locals.message, "[fieldName]", locals.i)>
		<cfset "variables.class.validationsOnsave.validatesUniquenessOf.#trim(locals.i)#.message" = locals.message>
		<cfset "variables.class.validationsOnsave.validatesUniquenessOf.#trim(locals.i)#.scope" = arguments.scope>
	</cfloop>
</cffunction>


<cffunction name="_validate" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>
	<cfif structKeyExists(variables, "validate")>
		<cfset locals.result = validate()>
	</cfif>
	<cfif NOT isDefined("locals.result") OR (isBoolean(locals.result) AND locals.result)>
		<cfif structKeyExists(variables.class, "validationsOnSave")>
			<cfset _runValidation(variables.class.validationsOnSave)>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="_validateOnCreate" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>
	<cfif structKeyExists(variables, "validateOnCreate")>
		<cfset locals.result = validateOnCreate()>
	</cfif>
	<cfif NOT isDefined("locals.result") OR (isBoolean(locals.result) AND locals.result)>
		<cfif structKeyExists(variables.class, "validationsOnCreate")>
			<cfset _runValidation(variables.class.validationsOnCreate)>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="_validateOnUpdate" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>
	<cfif structKeyExists(variables, "validateOnUpdate")>
		<cfset locals.result = validateOnUpdate()>
	</cfif>
	<cfif NOT isDefined("locals.result") OR (isBoolean(locals.result) AND locals.result)>
		<cfif structKeyExists(variables.class, "validationsOnUpdate")>
			<cfset _runValidation(variables.class.validationsOnUpdate)>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="_runValidation" returntype="any" access="private" output="false">
	<cfargument name="validations" type="any" required="true">
	<cfset var locals = structNew()>

	<cfloop collection="#arguments.validations#" item="locals.type">
		<cfloop collection="#arguments.validations[locals.type]#" item="locals.field">
			<cfset locals.settings = arguments.validations[locals.type][locals.field]>
			<cfswitch expression="#locals.type#">
				<cfcase value="validatesConfirmationOf">
					<cfset locals.virtualConfirmField = "#locals.field#Confirmation">
					<cfif structKeyExists(this, locals.virtualConfirmField)>
						<cfif this[locals.field] IS NOT this[locals.virtualConfirmField]>
							<cfset addError(locals.virtualConfirmField, locals.settings.message)>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validatesExclusionOf">
					<cfif NOT locals.settings.allowBlank AND (NOT structKeyExists(this, locals.field) OR len(this[locals.field]) IS 0)>
						<cfset addError(locals.field, locals.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, locals.field) AND len(this[locals.field]) IS NOT 0>
							<cfif listFindNoCase(locals.settings.in, this[locals.field]) IS NOT 0>
								<cfset addError(locals.field, locals.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validatesFormatOf">
					<cfif NOT locals.settings.allowBlank AND (NOT structKeyExists(this, locals.field) OR len(this[locals.field]) IS 0)>
						<cfset addError(locals.field, locals.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, locals.field) AND len(this[locals.field]) IS NOT 0>
							<cfif NOT REFindNoCase(locals.settings.with, this[locals.field])>
								<cfset addError(locals.field, locals.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validatesInclusionOf">
					<cfif NOT locals.settings.allowBlank AND (NOT structKeyExists(this, locals.field) OR len(this[locals.field]) IS 0)>
						<cfset addError(locals.field, locals.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, locals.field) AND len(this[locals.field]) IS NOT 0>
							<cfif listFindNoCase(locals.settings.in, this[locals.field]) IS 0>
								<cfset addError(locals.field, locals.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validatesLengthOf">
					<cfif NOT locals.settings.allowBlank AND (NOT structKeyExists(this, locals.field) OR len(this[locals.field]) IS 0)>
						<cfset addError(locals.field, locals.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, locals.field) AND len(this[locals.field]) IS NOT 0>
							<cfif locals.settings.maximum IS NOT 0>
								<cfif len(this[locals.field]) GT locals.settings.maximum>
									<cfset addError(locals.field, locals.settings.message)>
								</cfif>
							<cfelseif locals.settings.minimum IS NOT 0>
								<cfif len(this[locals.field]) LT locals.settings.minimum>
									<cfset addError(locals.field, locals.settings.message)>
								</cfif>
							<cfelseif locals.settings.exactly IS NOT 0>
								<cfif len(this[locals.field]) IS NOT locals.settings.exactly>
									<cfset addError(locals.field, locals.settings.message)>
								</cfif>
							<cfelseif isArray(locals.settings.within) AND arrayLen(locals.settings.within) IS NOT 0>
								<cfif len(this[locals.field]) LT locals.settings.within[1] OR len(this[locals.field]) GT locals.settings.within[2]>
									<cfset addError(locals.field, locals.settings.message)>
								</cfif>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validatesNumericalityOf">
					<cfif NOT locals.settings.allowBlank AND (NOT structKeyExists(this, locals.field) OR len(this[locals.field]) IS 0)>
						<cfset addError(field, settings.message)>
					<cfelse>
						<cfif structKeyExists(this, locals.field) AND len(this[locals.field]) IS NOT 0>
							<cfif NOT isNumeric(this[locals.field])>
								<cfset addError(locals.field, locals.settings.message)>
							<cfelseif locals.settings.onlyInteger AND round(this[locals.field]) IS NOT this[locals.field]>
								<cfset addError(locals.field, locals.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validatesPresenceOf">
					<cfif NOT structKeyExists(this, locals.field) OR len(this[locals.field]) IS 0>
						<cfset addError(locals.field, locals.settings.message)>
					</cfif>
				</cfcase>
				<cfcase value="validatesUniquenessOf">
					<cfquery name="locals.query" datasource="#variables.class.database.read.datasource#" username="#variables.class.database.read.username#" password="#variables.class.database.read.password#">
					SELECT #variables.class.primaryKey#, #locals.field#
					FROM #variables.class.tableName#
					WHERE #locals.field# = <cfqueryparam cfsqltype="#variables.class.fields[locals.field].cfsqltype#" value="#this[locals.field]#">
					<cfif structKeyExists(variables.class.fields, "deletedAt") OR structKeyExists(variables.class.fields, "deletedOn")>
						<cfif structKeyExists(variables.class.fields, "deletedAt")>
							<cfset locals.softDeleteField = "deletedAt">
						<cfelseif structKeyExists(variables.class.fields, "deletedOn")>
							<cfset locals.softDeleteField = "deletedOn">
						</cfif>
						AND #variables.class.tableName#.#locals.softDeleteField# IS NULL
					</cfif>
					<cfif len(locals.settings.scope) IS NOT 0>
						AND
						<cfset locals.pos = 0>
						<cfloop list="#locals.settings.scope#" index="locals.i">
							<cfset locals.pos = locals.pos + 1>
							#locals.i# = <cfqueryparam cfsqltype="#variables.class.fields[locals.field].cfsqltype#" value="#this[locals.i]#">
							<cfif listLen(locals.settings.scope) GT locals.pos>
								AND
							</cfif>
						</cfloop>
					</cfif>
					</cfquery>
					<cfif (NOT structKeyExists(this, variables.class.primaryKey) AND locals.query.recordCount GT 0) OR (structKeyExists(this, variables.class.primaryKey) AND locals.query.recordCount GT 0 AND locals.query[variables.class.primaryKey][1] IS NOT this[variables.class.primaryKey])>
						<cfset addError(locals.field, locals.settings.message)>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfloop>
	</cfloop>

</cffunction>