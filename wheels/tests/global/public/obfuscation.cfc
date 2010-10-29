<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_1">
		<cfset assert_obfuscation(1)>
	</cffunction>

	<cffunction name="test_99">
		<cfset assert_obfuscation(99)>
	</cffunction>

	<cffunction name="test_15765">
		<cfset assert_obfuscation(15765)>
	</cffunction>

	<cffunction name="test_69247541">
		<cfset assert_obfuscation(69247541)>
	</cffunction>

	<cffunction name="test_0413">
		<cfset assert_obfuscation(0413)>
	</cffunction>
	
	<cffunction name="test_400">
		<cfset assert_obfuscation(400)>
	</cffunction>

	<cffunction name="test_per">
		<cfset assert_obfuscation("per")>
	</cffunction>
	
	<cffunction name="test_becca2515">
		<cfset assert_obfuscation("becca2515")>
	</cffunction>
	
	<cffunction name="test_a15ba9">
		<cfset assert_obfuscation("a15ba9")>
	</cffunction>
	
	<cffunction name="assert_obfuscation">
		<cfargument name="o" type="any" required="true">
		<cfset loc.args = arguments>
		<cfset loc.o = obfuscateParam(loc.args.o)>
		<cfset loc.d = deobfuscateParam(loc.o)>
		<cfset assert('loc.d eq loc.args.o')>
	</cffunction>

</cfcomponent>