<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset results = {}>
	</cffunction>

	<cffunction name="test_obfuscate_999999999">
		<cfset results.param = obfuscateParam("999999999")>
		<cfset assert("results.param IS 'eb77359232'")>
	</cffunction>

	<cffunction name="test_obfuscate_0162823571">
		<cfset results.param = obfuscateParam("0162823571")>
		<cfset assert("results.param IS '0162823571'")>
	</cffunction>

	<cffunction name="test_obfuscate_1">
		<cfset results.param = obfuscateParam("1")>
		<cfset assert("results.param IS '9b1c6'")>
	</cffunction>

	<cffunction name="test_obfuscate_99">
		<cfset results.param = obfuscateParam("99")>
		<cfset assert("results.param IS 'ac10a'")>
	</cffunction>

	<cffunction name="test_obfuscate_15765">
		<cfset results.param = obfuscateParam("15765")>
		<cfset assert("results.param IS 'b226582'")>
	</cffunction>

	<cffunction name="test_obfuscate_69247541">
		<cfset results.param = obfuscateParam("69247541")>
		<cfset assert("results.param IS 'c06d44215'")>
	</cffunction>

	<cffunction name="test_obfuscate_0413">
		<cfset results.param = obfuscateParam("0413")>
		<cfset assert("results.param IS '0413'")>
	</cffunction>

	<cffunction name="test_per_should_not_obfuscate">
		<cfset results.param = obfuscateParam("per")>
		<cfset assert("results.param IS 'per'")>
	</cffunction>

	<cffunction name="test_1111111111_should_not_obfuscate">
		<cfset results.param = obfuscateParam("1111111111")>
		<cfset assert("results.param IS '1111111111'")>
	</cffunction>

</cfcomponent>