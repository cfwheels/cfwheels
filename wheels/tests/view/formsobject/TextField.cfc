<cfcomponent extends="wheelsMapping.Test">

	<cfset pkg.controller = controller("controllerWithModelErrors")>

	<cffunction name="setup">
		<cfset result = "">
	</cffunction>

	<cffunction name="testDefaultErrorElement">
		<cfset result = pkg.controller.textField(objectName="user", property="firstName")>
		<cfset assert("result Contains 'span class=""fieldWithErrors""'")>
	</cffunction>

	<cffunction name="testCustomErrorElement">
		<cfset result = pkg.controller.textField(errorElement="div", objectName="user", property="firstName")>
		<cfset assert("result Contains 'div class=""fieldWithErrors""'")>
	</cffunction>

	<cffunction name="testDefaultClassOnError">
		<cfset result = pkg.controller.textField(objectName="user", property="firstName")>
		<cfset assert("result Contains 'span class=""fieldWithErrors""'")>
	</cffunction>

	<cffunction name="testCustomClassOnError">
		<cfset result = pkg.controller.textField(errorClass="customClass", objectName="user", property="firstName")>
		<cfset assert("result Contains 'span class=""customClass""'")>
	</cffunction>
	
</cfcomponent>