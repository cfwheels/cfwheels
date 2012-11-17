<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_equals">
		<cfset assert('semanticVersioning("= 1.2.1", "1.2.1")')>
		<cfset assert('semanticVersioning("= 1.2", "1.2")')>
		<cfset assert('!semanticVersioning("= 1.2", "1.2.5")')>
		<cfset assert('!semanticVersioning("= 0.0.2", "0.0.1")')>
		<cfset assert('semanticVersioning("= 1.2", "1.2.0")')>
		<cfset assert('semanticVersioning("= 1.2.0", "1.2")')>
		<cfset assert('semanticVersioning("= 1.2.0", "1.2-preview1")')>
		<cfset assert('!semanticVersioning("= 1.2.3", "1.2.003-preview1")')>
	</cffunction>

 	<cffunction name="test_not_equals">
		<cfset assert('!semanticVersioning("!= 1.2.1", "1.2.1")')>
		<cfset assert('!semanticVersioning("!= 1.2", "1.2")')>
		<cfset assert('semanticVersioning("!= 1.2", "1.2.5")')>
		<cfset assert('semanticVersioning("!= 0.0.2", "0.0.1")')>
		<cfset assert('!semanticVersioning("!= 1.2", "1.2.0")')>
		<cfset assert('!semanticVersioning("!= 1.2.0", "1.2")')>
		<cfset assert('!semanticVersioning("!= 1.2.0", "1.2-preview1")')>
		<cfset assert('semanticVersioning("!= 1.2.3", "1.2.003-preview1")')>
	</cffunction>

	<cffunction name="test_greater_than">
  		<cfset assert('!semanticVersioning("> 1.2.1", "1.2.1")')>
		<cfset assert('!semanticVersioning("> 1.2", "1.2")')>
		<cfset assert('semanticVersioning("> 1.2", "1.2.5")')>
		<cfset assert('!semanticVersioning("> 0.0.2", "0.0.1")')>
		<cfset assert('semanticVersioning("> 0.0.2", "0.0.3")')>
		<cfset assert('!semanticVersioning("> 1.2.5", "1.2")')>
		<cfset assert('semanticVersioning("> 1.2.5", "1.3")')>
		<cfset assert('!semanticVersioning("> 1.3", "1.2.5")')>
		<cfset assert('!semanticVersioning("> 1.2.1", "1.2-preview1")')>
		<cfset assert('semanticVersioning("> 1.2.0", "1.2.2-preview1")')>
		<cfset assert('!semanticVersioning("> 1.2.0", "1.2-preview1")')>
		<cfset assert('!semanticVersioning("> 1.2.3", "1.2.003-preview1")')>
	</cffunction>

	<cffunction name="test_greater_than_or_equal_to">
		<cfset assert('semanticVersioning(">= 1.2.1", "1.2.1")')>
		<cfset assert('semanticVersioning(">= 1.2", "1.2")')>
		<cfset assert('semanticVersioning(">= 1.2", "1.2.5")')>
		<cfset assert('!semanticVersioning(">= 0.0.2", "0.0.1")')>
		<cfset assert('semanticVersioning(">= 0.0.2", "0.0.3")')>
		<cfset assert('!semanticVersioning(">= 1.2.5", "1.2")')>
		<cfset assert('semanticVersioning(">= 1.2.5", "1.3")')>
		<cfset assert('!semanticVersioning(">= 1.3", "1.2.5")')>
		<cfset assert('!semanticVersioning(">= 1.2.1", "1.2-preview1")')>
		<cfset assert('semanticVersioning(">= 1.2.0", "1.2.2-preview1")')>
		<cfset assert('semanticVersioning(">= 1.2.0", "1.2-preview1")')>
		<cfset assert('!semanticVersioning(">= 1.2.3", "1.2.003-preview1")')>
	</cffunction>
	
	<cffunction name="test_less_than">
		<cfset assert('!semanticVersioning("< 1.2.1", "1.2.1")')>
		<cfset assert('!semanticVersioning("< 1.2", "1.2")')>
		<cfset assert('!semanticVersioning("< 1.2", "1.2.5")')>
		<cfset assert('semanticVersioning("< 0.0.2", "0.0.1")')>
		<cfset assert('!semanticVersioning("< 0.0.2", "0.0.3")')>
		<cfset assert('semanticVersioning("< 1.2.5", "1.2")')>
		<cfset assert('!semanticVersioning("< 1.2.5", "1.3")')>
		<cfset assert('semanticVersioning("< 1.3", "1.2.5")')>
		<cfset assert('semanticVersioning("< 1.2.1", "1.2-preview1")')>
		<cfset assert('!semanticVersioning("< 1.2.0", "1.2.2-preview1")')>
		<cfset assert('!semanticVersioning("< 1.2.0", "1.2-preview1")')>
		<cfset assert('semanticVersioning("< 1.2.3", "1.2.003-preview1")')>
	</cffunction>

	<cffunction name="test_less_than_or_equal_to">
		<cfset assert('semanticVersioning("<= 1.2.1", "1.2.1")')>
		<cfset assert('semanticVersioning("<= 1.2", "1.2")')>
		<cfset assert('!semanticVersioning("<= 1.2", "1.2.5")')>
		<cfset assert('semanticVersioning("<= 0.0.2", "0.0.1")')>
		<cfset assert('!semanticVersioning("<= 0.0.2", "0.0.3")')>
		<cfset assert('semanticVersioning("<= 1.2.5", "1.2")')>
		<cfset assert('!semanticVersioning("<= 1.2.5", "1.3")')>
		<cfset assert('semanticVersioning("<= 1.3", "1.2.5")')>
		<cfset assert('semanticVersioning("<= 1.2.1", "1.2-preview1")')>
		<cfset assert('!semanticVersioning("<= 1.2.0", "1.2.2-preview1")')>
		<cfset assert('semanticVersioning("<= 1.2.0", "1.2-preview1")')>
		<cfset assert('semanticVersioning("<= 1.2.3", "1.2.003-preview1")')>
	</cffunction>
	
	<cffunction name="test_approximate_greater_than">
 		<cfset assert('semanticVersioning("~> 1.2.1", "1.2.1")')>
		<cfset assert('semanticVersioning("~> 1.2", "1.2")')>
		<cfset assert('semanticVersioning("~> 1.2", "1.2.5")')>
		<cfset assert('!semanticVersioning("~> 0.0.2", "0.0.1")')>
		<cfset assert('semanticVersioning("~> 0.0.2", "0.0.3")')>
		<cfset assert('!semanticVersioning("~> 1.2.5", "1.2")')>
		<cfset assert('semanticVersioning("~> 1.2.5", "1.3")')>
		<cfset assert('!semanticVersioning("~> 1.3", "1.2.5")')>
		<cfset assert('!semanticVersioning("~> 1.2.1", "1.2-preview1")')>
		<cfset assert('semanticVersioning("~> 1.2.0", "1.2.2-preview1")')>
		<cfset assert('semanticVersioning("~> 1.2.0", "1.2-preview1")')>
		<cfset assert('!semanticVersioning("~> 1.2.3", "1.2.003-preview1")')>
	</cffunction>

</cfcomponent>