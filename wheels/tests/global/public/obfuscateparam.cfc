<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset results = {}>
	</cffunction>

	<cffunction name="test_obfuscate_1">
		<cfset results.param = obfuscateParam(1)>
		<cfset assert("results.param IS '9b1c6'")>
	</cffunction>

	<cffunction name="test_obfuscate_99">
		<cfset results.param = obfuscateParam(99)>
		<cfset assert("results.param IS 'ac10a'")>
	</cffunction>

	<cffunction name="test_obfuscate_15765">
		<cfset results.param = obfuscateParam(15765)>
		<cfset assert("results.param IS 'b226582'")>
	</cffunction>

	<cffunction name="test_obfuscate_69247541">
		<cfset results.param = obfuscateParam(69247541)>
		<cfset assert("results.param IS 'c06d44215'")>
	</cffunction>

	<cffunction name="test_obfuscate_0413">
		<cfset results.param = obfuscateParam(0413)>
		<cfset assert("results.param IS 'a24ef'")>
	</cffunction>

	<cffunction name="test_per_should_not_obfuscate">
		<cfset results.param = obfuscateParam('per')>
		<cfset assert("results.param IS 'per'")>
	</cffunction>

</cfcomponent>