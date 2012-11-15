<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_equals">
		<cfset assert('$advancedVersioning("= 1.2.1", "1.2.1")')>
		<cfset assert('$advancedVersioning("= 1.2", "1.2")')>
		<cfset assert('!$advancedVersioning("= 1.2", "1.2.5")')>
		<cfset assert('!$advancedVersioning("= 0.0.2", "0.0.1")')>
		<cfset assert('$advancedVersioning("= 1.2", "1.2.0")')>
		<cfset assert('$advancedVersioning("= 1.2.0", "1.2")')>
	</cffunction>

 	<cffunction name="test_not_equals">
		<cfset assert('!$advancedVersioning("!= 1.2.1", "1.2.1")')>
		<cfset assert('!$advancedVersioning("!= 1.2", "1.2")')>
		<cfset assert('$advancedVersioning("!= 1.2", "1.2.5")')>
		<cfset assert('$advancedVersioning("!= 0.0.2", "0.0.1")')>
		<cfset assert('!$advancedVersioning("!= 1.2", "1.2.0")')>
		<cfset assert('!$advancedVersioning("!= 1.2.0", "1.2")')>
	</cffunction>

	<cffunction name="test_greater_than">
 		<cfset assert('!$advancedVersioning("> 1.2.1", "1.2.1")')>
		<cfset assert('!$advancedVersioning("> 1.2", "1.2")')>
		<cfset assert('$advancedVersioning("> 1.2", "1.2.5")')>
		<cfset assert('!$advancedVersioning("> 0.0.2", "0.0.1")')>
		<cfset assert('$advancedVersioning("> 0.0.2", "0.0.3")')>
		<cfset assert('!$advancedVersioning("> 1.2.5", "1.2")')>
		<cfset assert('$advancedVersioning(">= 1.2.5", "1.3")')>
		<cfset assert('!$advancedVersioning(">= 1.3", "1.2.5")')>
	</cffunction>

	<cffunction name="test_greater_than_or_equals_to">
		<cfset assert('$advancedVersioning(">= 1.2.1", "1.2.1")')>
		<cfset assert('$advancedVersioning(">= 1.2", "1.2")')>
		<cfset assert('$advancedVersioning(">= 1.2", "1.2.5")')>
		<cfset assert('!$advancedVersioning(">= 0.0.2", "0.0.1")')>
		<cfset assert('$advancedVersioning(">= 0.0.2", "0.0.3")')>
		<cfset assert('!$advancedVersioning(">= 1.2.5", "1.2")')>
		<cfset assert('$advancedVersioning(">= 1.2.5", "1.3")')>
		<cfset assert('!$advancedVersioning(">= 1.3", "1.2.5")')>
	</cffunction>
	
	<cffunction name="test_less_than">
		<cfset assert('!$advancedVersioning("< 1.2.1", "1.2.1")')>
		<cfset assert('!$advancedVersioning("< 1.2", "1.2")')>
		<cfset assert('!$advancedVersioning("< 1.2", "1.2.5")')>
		<cfset assert('$advancedVersioning("< 0.0.2", "0.0.1")')>
		<cfset assert('!$advancedVersioning("< 0.0.2", "0.0.3")')>
		<cfset assert('$advancedVersioning("< 1.2.5", "1.2")')>
		<cfset assert('!$advancedVersioning("<= 1.2.5", "1.3")')>
		<cfset assert('$advancedVersioning("<= 1.3", "1.2.5")')>
	</cffunction>

	<cffunction name="test_less_than_or_equals_to">
		<cfset assert('$advancedVersioning("<= 1.2.1", "1.2.1")')>
		<cfset assert('$advancedVersioning("<= 1.2", "1.2")')>
		<cfset assert('!$advancedVersioning("<= 1.2", "1.2.5")')>
		<cfset assert('$advancedVersioning("<= 0.0.2", "0.0.1")')>
		<cfset assert('!$advancedVersioning("<= 0.0.2", "0.0.3")')>
		<cfset assert('$advancedVersioning("<= 1.2.5", "1.2")')>
		<cfset assert('!$advancedVersioning("<= 1.2.5", "1.3")')>
		<cfset assert('$advancedVersioning("<= 1.3", "1.2.5")')>
	</cffunction>
	
	<cffunction name="test_approximate_greater_than">
		<cfset assert('$advancedVersioning("~> 1.2.1", "1.2.1")')>
		<cfset assert('$advancedVersioning("~> 1.2", "1.2")')>
		<cfset assert('$advancedVersioning("~> 1.2", "1.2.5")')>
		<cfset assert('!$advancedVersioning("~> 0.0.2", "0.0.1")')>
		<cfset assert('$advancedVersioning("~> 0.0.2", "0.0.3")')>
		<cfset assert('!$advancedVersioning("~> 1.2.5", "1.2")')>
		<cfset assert('$advancedVersioning(">= 1.2.5", "1.3")')>
		<cfset assert('!$advancedVersioning(">= 1.3", "1.2.5")')>
	</cffunction>

</cfcomponent>