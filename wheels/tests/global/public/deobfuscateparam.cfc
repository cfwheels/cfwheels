<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset results = {}>
	</cffunction>

	<cffunction name="test_deobfuscate_eb77359232">
		<cfset results.param = deobfuscateParam("eb77359232")>
		<cfset assert("results.param IS '999999999'")>
	</cffunction>

	<cffunction name="test_deobfuscate_9b1c6">
		<cfset results.param = deobfuscateParam("9b1c6")>
		<cfset assert("results.param IS 1")>
	</cffunction>

	<cffunction name="test_deobfuscate_ac10a">
		<cfset results.param = deobfuscateParam("ac10a")>
		<cfset assert("results.param IS 99")>
	</cffunction>

	<cffunction name="test_deobfuscate_b226582">
		<cfset results.param = deobfuscateParam("b226582")>
		<cfset assert("results.param IS 15765")>
	</cffunction>

	<cffunction name="test_deobfuscate_c06d44215">
		<cfset results.param = deobfuscateParam("c06d44215")>
		<cfset assert("results.param IS 69247541")>
	</cffunction>

	<cffunction name="test_becca2515_should_not_deobfuscate">
		<cfset results.param = deobfuscateParam("becca2515")>
		<cfset assert("results.param IS 'becca2515'")>
	</cffunction>

	<cffunction name="test_a15ba9_should_not_deobfuscate">
		<cfset results.param = deobfuscateParam("a15ba9")>
		<cfset assert("results.param IS 'a15ba9'")>
	</cffunction>

	<cffunction name="test_1111111111_should_not_deobfuscate">
		<cfset results.param = deobfuscateParam("1111111111")>
		<cfset assert("results.param IS '1111111111'")>
	</cffunction>

</cfcomponent>