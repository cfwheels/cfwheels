<cffunction name="addError" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfargument name="message" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.error.field = arguments.field>
	<cfset local.error.message = arguments.message>

	<cfif NOT structKeyExists(variables, "errors")>
		<cfset variables.errors = arrayNew(1)>
	</cfif>

	<cfset arrayAppend(variables.errors, local.error)>

	<cfreturn true>
</cffunction>


<cffunction name="addErrorToBase" returntype="any" access="public" output="false">
	<cfargument name="message" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.error.field = "">
	<cfset local.error.message = arguments.message>

	<cfif NOT structKeyExists(variables, "errors")>
		<cfset variables.errors = arrayNew(1)>
	</cfif>

	<cfset arrayAppend(variables.errors, local.error)>

	<cfreturn true>
</cffunction>


<cffunction name="valid" returntype="any" access="public" output="false">
	<cfif FL_isNew()>
		<cfset FL_validateOnCreate()>
	<cfelse>
		<cfset FL_validateOnUpdate()>
	</cfif>
	<cfset FL_validate()>
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
	<cfset var local = structNew()>

	<cfset local.all_error_messages = arrayNew(1)>

	<cfif structKeyExists(variables, "errors")>
		<cfloop from="1" to="#arrayLen(variables.errors)#" index="local.i">
			<cfif variables.errors[local.i].field IS arguments.field>
				<cfset arrayAppend(local.all_error_messages, variables.errors[local.i].message)>
			</cfif>
		</cfloop>
	</cfif>

	<cfif NOT structKeyExists(variables, "errors") OR arrayLen(local.all_error_messages) IS 0>
		<cfreturn false>
	<cfelse>
		<cfreturn local.all_error_messages>
	</cfif>
</cffunction>


<cffunction name="errorsOnBase" returntype="any" access="public" output="false">
	<cfset var local = structNew()>
	<cfset local.output = errorsOn(field="")>
	<cfreturn local.output>
</cffunction>


<cffunction name="allErrors" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfset local.all_error_messages = arrayNew(1)>

	<cfif structKeyExists(variables, "errors")>
		<cfloop from="1" to="#arrayLen(variables.errors)#" index="local.i">
			<cfset arrayAppend(local.all_error_messages, variables.errors[local.i].message)>
		</cfloop>
	</cfif>

	<cfif NOT structKeyExists(variables, "errors") OR arrayLen(local.all_error_messages) IS 0>
		<cfreturn false>
	<cfelse>
		<cfreturn local.all_error_messages>
	</cfif>
</cffunction>


<cffunction name="validatesConfirmationOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is reserved">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset "variables.class.validations_on_#arguments.on#.validates_confirmation_of.#arguments.field#.message" = arguments.message>
</cffunction>


<cffunction name="validatesExclusionOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is reserved">
	<cfargument name="in" type="any" required="yes">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>
	<cfset "variables.class.validations_on_save.validates_exclusion_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.class.validations_on_save.validates_exclusion_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.class.validations_on_save.validates_exclusion_of.#arguments.field#.in" = arguments.in>
</cffunction>


<cffunction name="validatesFormatOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is invalid">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfargument name="with" type="any" required="yes">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset "variables.class.validations_on_#arguments.on#.validates_format_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.class.validations_on_#arguments.on#.validates_format_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.class.validations_on_#arguments.on#.validates_format_of.#arguments.field#.with" = arguments.with>
</cffunction>


<cffunction name="validatesInclusionOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is not included in the list">
	<cfargument name="in" type="any" required="yes">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfset arguments.in = replace(arguments.in, ", ", ",", "all")>
	<cfset "variables.class.validations_on_save.validates_inclusion_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.class.validations_on_save.validates_inclusion_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.class.validations_on_save.validates_inclusion_of.#arguments.field#.in" = arguments.in>
</cffunction>


<cffunction name="validatesLengthOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is the wrong length">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfargument name="exactly" type="any" required="no" default=0>
	<cfargument name="maximum" type="any" required="no" default=0>
	<cfargument name="minimum" type="any" required="no" default=0>
	<cfargument name="within" type="any" required="no" default="">
	<cfargument name="on" type="any" required="no" default="save">
	<cfif len(arguments.within) IS NOT 0>
		<cfset arguments.within = listToArray(replace(arguments.within, ", ", ",", "all"))>
	</cfif>
	<cfset "variables.class.validations_on_#arguments.on#.validates_length_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.class.validations_on_#arguments.on#.validates_length_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.class.validations_on_#arguments.on#.validates_length_of.#arguments.field#.exactly" = arguments.exactly>
	<cfset "variables.class.validations_on_#arguments.on#.validates_length_of.#arguments.field#.maximum" = arguments.maximum>
	<cfset "variables.class.validations_on_#arguments.on#.validates_length_of.#arguments.field#.minimum" = arguments.minimum>
	<cfset "variables.class.validations_on_#arguments.on#.validates_length_of.#arguments.field#.within" = arguments.within>
</cffunction>


<cffunction name="validatesNumericalityOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# is not a number">
	<cfargument name="allow_nil" type="any" required="no" default="false">
	<cfargument name="only_integer" type="any" required="false" default="false">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset "variables.class.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.class.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.allow_nil" = arguments.allow_nil>
	<cfset "variables.class.validations_on_#arguments.on#.validates_numericality_of.#arguments.field#.only_integer" = arguments.only_integer>
</cffunction>


<cffunction name="validatesPresenceOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# can't be empty">
	<cfargument name="on" type="any" required="no" default="save">
	<cfset "variables.class.validations_on_#arguments.on#.validates_presence_of.#arguments.field#.message" = arguments.message>
</cffunction>


<cffunction name="validatesUniquenessOf" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="message" type="any" required="no" default="#arguments.field# has already been taken">
	<cfargument name="scope" type="any" required="no" default="">
	<cfset arguments.scope = replace(arguments.scope, ", ", ",", "all")>
	<cfset "variables.class.validations_on_save.validates_uniqueness_of.#arguments.field#.message" = arguments.message>
	<cfset "variables.class.validations_on_save.validates_uniqueness_of.#arguments.field#.scope" = arguments.scope>
</cffunction>


<cffunction name="FL_validate" returntype="any" access="public" output="false">
	<cfset var local = structNew()>
	<cfif structKeyExists(variables, "validate")>
		<cfset local.result = validate()>
	</cfif>
	<cfif NOT isDefined("local.result") OR (isBoolean(local.result) AND local.result)>
		<cfif structKeyExists(variables.class, "validations_on_save")>
			<cfset FL_runValidation(variables.class.validations_on_save)>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="FL_validateOnCreate" returntype="any" access="public" output="false">
	<cfset var local = structNew()>
	<cfif structKeyExists(variables, "validateOnCreate")>
		<cfset local.result = validateOnCreate()>
	</cfif>
	<cfif NOT isDefined("local.result") OR (isBoolean(local.result) AND local.result)>
		<cfif structKeyExists(variables.class, "validations_on_create")>
			<cfset FL_runValidation(variables.class.validations_on_create)>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="FL_validateOnUpdate" returntype="any" access="public" output="false">
	<cfset var local = structNew()>
	<cfif structKeyExists(variables, "validateOnUpdate")>
		<cfset local.result = validateOnUpdate()>
	</cfif>
	<cfif NOT isDefined("local.result") OR (isBoolean(local.result) AND local.result)>
		<cfif structKeyExists(variables.class, "validations_on_update")>
			<cfset FL_runValidation(variables.class.validations_on_update)>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="FL_runValidation" returntype="any" access="private" output="false">
	<cfargument name="validations" type="any" required="true">
	<cfset var local = structNew()>

	<cfloop collection="#arguments.validations#" item="local.type">
		<cfloop collection="#arguments.validations[local.type]#" item="local.field">
			<cfset local.settings = arguments.validations[local.type][local.field]>
			<cfswitch expression="#local.type#">
				<cfcase value="validates_confirmation_of">
					<cfset local.virtual_confirm_field = "#local.field#_confirmation">
					<cfif structKeyExists(this, local.virtual_confirm_field)>
						<cfif this[local.field] IS NOT this[local.virtual_confirm_field]>
							<cfset addError(local.virtual_confirm_field, local.settings.message)>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validates_exclusion_of">
					<cfif NOT local.settings.allow_nil AND (NOT structKeyExists(this, local.field) OR len(this[local.field]) IS 0)>
						<cfset addError(local.field, local.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, local.field) AND len(this[local.field]) IS NOT 0>
							<cfif listFindNoCase(local.settings.in, this[local.field]) IS NOT 0>
								<cfset addError(local.field, local.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validates_format_of">
					<cfif NOT local.settings.allow_nil AND (NOT structKeyExists(this, local.field) OR len(this[local.field]) IS 0)>
						<cfset addError(local.field, local.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, local.field) AND len(this[local.field]) IS NOT 0>
							<cfif NOT REFindNoCase(local.settings.with, this[local.field])>
								<cfset addError(local.field, local.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validates_inclusion_of">
					<cfif NOT local.settings.allow_nil AND (NOT structKeyExists(this, local.field) OR len(this[local.field]) IS 0)>
						<cfset addError(local.field, local.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, local.field) AND len(this[local.field]) IS NOT 0>
							<cfif listFindNoCase(local.settings.in, this[local.field]) IS 0>
								<cfset addError(local.field, local.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validates_length_of">
					<cfif NOT local.settings.allow_nil AND (NOT structKeyExists(this, local.field) OR len(this[local.field]) IS 0)>
						<cfset addError(local.field, local.settings.message)>
					<cfelse>
						<cfif structKeyExists(this, local.field) AND len(this[local.field]) IS NOT 0>
							<cfif local.settings.maximum IS NOT 0>
								<cfif len(this[local.field]) GT local.settings.maximum>
									<cfset addError(local.field, local.settings.message)>
								</cfif>
							<cfelseif local.settings.minimum IS NOT 0>
								<cfif len(this[local.field]) LT local.settings.minimum>
									<cfset addError(local.field, local.settings.message)>
								</cfif>
							<cfelseif local.settings.exactly IS NOT 0>
								<cfif len(this[local.field]) IS NOT local.settings.exactly>
									<cfset addError(local.field, local.settings.message)>
								</cfif>
							<cfelseif isArray(local.settings.within) AND arrayLen(local.settings.within) IS NOT 0>
								<cfif len(this[local.field]) LT local.settings.within[1] OR len(this[local.field]) GT local.settings.within[2]>
									<cfset addError(local.field, local.settings.message)>
								</cfif>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validates_numericality_of">
					<cfif NOT local.settings.allow_nil AND (NOT structKeyExists(this, local.field) OR len(this[local.field]) IS 0)>
						<cfset addError(field, settings.message)>
					<cfelse>
						<cfif structKeyExists(this, local.field) AND len(this[local.field]) IS NOT 0>
							<cfif NOT isNumeric(this[local.field])>
								<cfset addError(local.field, local.settings.message)>
							<cfelseif local.settings.only_integer AND round(this[local.field]) IS NOT this[local.field]>
								<cfset addError(local.field, local.settings.message)>
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="validates_presence_of">
					<cfif NOT structKeyExists(this, local.field) OR len(this[local.field]) IS 0>
						<cfset addError(local.field, local.settings.message)>
					</cfif>
				</cfcase>
				<cfcase value="validates_uniqueness_of">
						<cfquery name="local.query" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
						SELECT #variables.class.primary_key#, #local.field#
						FROM #variables.class.table_name#
						WHERE #local.field# = <cfqueryparam cfsqltype="#variables.class.columns[local.field].cfsqltype#" value="#this[local.field]#">
						<cfif structKeyExists(variables.class.columns, "deleted_at")>
							AND #variables.class.table_name#.deleted_at IS NULL
						</cfif>
						<cfif len(local.settings.scope) IS NOT 0>
							AND
							<cfset local.pos = 0>
							<cfloop list="#local.settings.scope#" index="local.i">
								<cfset local.pos = local.pos + 1>
								#local.i# = <cfqueryparam cfsqltype="#variables.class.columns[local.field].cfsqltype#" value="#this[local.i]#">
								<cfif listLen(local.settings.scope) GT local.pos>
									AND
								</cfif>
							</cfloop>
						</cfif>
					</cfquery>
					<cfif (NOT structKeyExists(this, variables.class.primary_key) AND local.query.recordcount GT 0) OR (structKeyExists(this, variables.class.primary_key) AND local.query.recordcount GT 0 AND local.query[variables.class.primary_key][1] IS NOT this[variables.class.primary_key])>
						<cfset addError(local.field, local.settings.message)>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfloop>
	</cfloop>

</cffunction>
