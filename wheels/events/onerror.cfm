<cffunction name="onError" output="true">
	<cfargument name="exception">
	<cfargument name="eventname">
	<cfset var loc = {}>
	<cflock scope="application" type="readonly" timeout="30">
		<cfif application.settings.sendEmailOnError>
			<cfmail to="#application.settings.errorEmailAddress#" from="#application.settings.errorEmailAddress#" subject="Error" type="html">
				<cfinclude template="onerror/cfmlerror.cfm">
			</cfmail>
		</cfif>
		<cfif application.settings.showErrorInformation>
			<cfif NOT StructKeyExists(arguments.exception, "cause")>
				<cfset arguments.exception.cause = arguments.exception>
			</cfif>
			<cfif Left(arguments.exception.cause.type, 6) IS "Wheels">
				<cfinclude template="../styles/header.cfm">
				<cfinclude template="onerror/wheelserror.cfm">
				<cfinclude template="../styles/footer.cfm">
			<cfelse>
				<cfthrow object="#arguments.exception#">
			</cfif>
		<cfelse>
			<cfinclude template="../../#application.wheels.eventPath#/onerror.cfm">
		</cfif>
	</cflock>
</cffunction>
