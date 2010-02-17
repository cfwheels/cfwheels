<cfcomponent extends="Base" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn super.init(argumentCollection=arguments)>
	</cffunction>
	<cfinclude template="mysql/functions.cfm">
	<cfinclude template="../../plugins/injection.cfm">
</cfcomponent>