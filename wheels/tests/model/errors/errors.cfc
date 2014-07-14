<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.user = model("user").findOne()>
		<cfset loc.user.addErrorToBase(message="base error1")>
		<cfset loc.user.addErrorToBase(message="base name error1", name="base_errors")>
		<cfset loc.user.addErrorToBase(message="base name error2", name="base_errors")>
		<cfset loc.user.addError(property="firstname", message="firstname error1")>
		<cfset loc.user.addError(property="firstname", message="firstname error2")>
		<cfset loc.user.addError(property="firstname", message="firstname name error1", name="firstname_errors")>
		<cfset loc.user.addError(property="firstname", message="firstname name error2", name="firstname_errors")>
		<cfset loc.user.addError(property="firstname", message="firstname name error3", name="firstname_errors")>
		<cfset loc.user.addError(property="lastname", message="lastname error1")>
		<cfset loc.user.addError(property="lastname", message="lastname error2")>
		<cfset loc.user.addError(property="lastname", message="lastname error3")>
		<cfset loc.user.addError(property="lastname", message="lastname name error1", name="lastname_errors")>
		<cfset loc.user.addError(property="lastname", message="lastname name error2", name="lastname_errors")>
	</cffunction>

	<cffunction name="test_error_information_for_lastname_property_no_name_provided">
		<cfset loc.r = loc.user.hasErrors(property="lastname")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.errorCount(property="lastname")>
		<cfset assert('loc.r eq 3')>
		<cfset loc.user.clearErrors(property="lastname")>
		<cfset loc.r = loc.user.errorCount(property="lastname")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="lastname")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_lastname_property_name_provided">
		<cfset loc.r = loc.user.hasErrors(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.errorCount(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq 2')>
		<cfset loc.user.clearErrors(property="lastname", name="lastname_errors")>
		<cfset loc.r = loc.user.errorCount(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="lastname")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_firstname_property_no_name_provided">
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.errorCount(property="firstname")>
		<cfset assert('loc.r eq 2')>
		<cfset loc.user.clearErrors(property="firstname")>
		<cfset loc.r = loc.user.errorCount(property="firstname")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_firstname_property_name_provided">
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.errorCount(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq 3')>
		<cfset loc.user.clearErrors(property="firstname", name="firstname_errors")>
		<cfset loc.r = loc.user.errorCount(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_base_no_name_provided">
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.errorCount()>
		<cfset assert('loc.r eq 13')>
		<cfset loc.user.clearErrors()>
		<cfset loc.r = loc.user.errorCount()>
		<cfset assert('loc.r eq 0')>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="lastname")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq false')>
	</cffunction>

	<cffunction name="test_error_information_for_base_name_provided">
		<cfset loc.r = loc.user.hasErrors(name="base_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.errorCount(name="base_errors")>
		<cfset assert('loc.r eq 2')>
		<cfset loc.user.clearErrors(name="base_errors")>
		<cfset debug('loc.user.allErrors()', false)>
		<cfset loc.r = loc.user.errorCount(name="base_errors")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.r = loc.user.hasErrors(name="base_errors")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.hasErrors(property="lastname")>
		<cfset assert('loc.r eq true')>
 		<cfset loc.r = loc.user.hasErrors(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_incorrect_property">
		<cfset loc.r = loc.user.hasErrors(property="firstnamex")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.errorCount(property="firstnamex")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.user.clearErrors(property="firstnamex")>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_incorrect_name_on_property">
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errorsx")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.errorCount(property="firstname", name="firstname_errorsx")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.user.clearErrors(property="firstname", name="firstname_errorsx")>
		<cfset loc.r = loc.user.hasErrors()>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq true')>
	</cffunction>

	<cffunction name="test_error_information_for_incorrect_name_on_base">
		<cfset loc.r = loc.user.hasErrors(name="base_errorsx")>
		<cfset assert('loc.r eq false')>
		<cfset loc.r = loc.user.errorCount(name="base_errorsx")>
		<cfset assert('loc.r eq 0')>
		<cfset loc.user.clearErrors(name="base_errorsx")>
		<cfset loc.r = loc.user.hasErrors(name="base_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="lastname")>
		<cfset assert('loc.r eq true')>
 		<cfset loc.r = loc.user.hasErrors(property="lastname", name="lastname_errors")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname")>
		<cfset assert('loc.r eq true')>
		<cfset loc.r = loc.user.hasErrors(property="firstname", name="firstname_errors")>
		<cfset assert('loc.r eq true')>
	</cffunction>

</cfcomponent>