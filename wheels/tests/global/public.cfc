<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_set_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_get_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_URLFor_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_obfuscateParam_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_deobfuscateParam_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_addRoute_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_model_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_pluginName_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_capitalize_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_humanize_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_singularize_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_pluralize_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
</cfcomponent>