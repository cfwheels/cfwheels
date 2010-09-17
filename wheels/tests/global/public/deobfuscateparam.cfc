<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset results = {}>
	</cffunction>

	<cffunction name="test_deobfuscate_9b1c6">
		<cfset results.param = deobfuscateParam('9b1c6')>
		<cfset assert("results.param IS 1")>
	</cffunction>

	<cffunction name="test_deobfuscate_ac10a">
		<cfset results.param = deobfuscateParam('ac10a')>
		<cfset assert("results.param IS 99")>
	</cffunction>

	<cffunction name="test_deobfuscate_b226582">
		<cfset results.param = deobfuscateParam('b226582')>
		<cfset assert("results.param IS 15765")>
	</cffunction>

	<cffunction name="test_deobfuscate_c06d44215">
		<cfset results.param = deobfuscateParam('c06d44215')>
		<cfset assert("results.param IS 69247541")>
	</cffunction>

	<cffunction name="test_deobfuscate_a24ef">
		<cfset results.param = deobfuscateParam('a24ef')>
		<cfset assert("results.param IS 413")>
	</cffunction>

	<cffunction name="test_becca2515_should_not_deobfuscate">
		<cfset results.param = deobfuscateParam('becca2515')>
		<cfset assert("results.param IS 'becca2515'")>
	</cffunction>

	<cffunction name="test_a15ba9_should_not_deobfuscate">
		<cfset results.param = deobfuscateParam('a15ba9')>
		<cfset assert("results.param IS 'a15ba9'")>
	</cffunction>

</cfcomponent>