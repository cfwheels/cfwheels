<cfcomponent extends="wheelsMapping.Test">
	
	<cffunction name="setup">
		<cfset loc.params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", loc.params)>
	</cffunction>
	
	<cffunction name="test_specfying_positions_overwrite_false">
		<cfset loc.controller.contentFor(testing="A")>
		<cfset loc.controller.contentFor(testing="B")>
		<cfset loc.controller.contentFor(testing="C", position="first")>
		<cfset loc.controller.contentFor(testing="D", position="2")>
		<cfset loc.r = loc.controller.includeContent("testing")>
		<cfset loc.e = "C#chr(10)#D#chr(10)#A#chr(10)#B">
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_specfying_positions_overwrite_true">
		<cfset loc.controller.contentFor(testing="A")>
		<cfset loc.controller.contentFor(testing="B")>
		<cfset loc.controller.contentFor(testing="C", position="first", overwrite="true")>
		<cfset loc.controller.contentFor(testing="D", position="2", overwrite="true")>
		<cfset loc.r = loc.controller.includeContent("testing")>
		<cfset loc.e = "C#chr(10)#D">
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_overwrite_all">
		<cfset loc.controller.contentFor(testing="A")>
		<cfset loc.controller.contentFor(testing="B")>
		<cfset loc.controller.contentFor(testing="C", overwrite="all")>
		<cfset loc.r = loc.controller.includeContent("testing")>
		<cfset loc.e = "C">
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_specify_position_outside_of_size_should_not_error">
		<cfset loc.controller.contentFor(testing="A")>
		<cfset loc.controller.contentFor(testing="B")>
		<cfset loc.controller.contentFor(testing="C")>
		<cfset loc.controller.contentFor(testing="D", position="6")>
		<cfset loc.r = loc.controller.includeContent("testing")>
		<cfset loc.e = ["A","B","C","D"]>
		<cfset loc.e = ArrayToList(loc.e, chr(10))>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.controller.contentFor(testing="D", position="-5")>
		<cfset loc.r = loc.controller.includeContent("testing")>
		<cfset loc.e = ["D","A","B","C","D"]>
		<cfset loc.e = ArrayToList(loc.e, chr(10))>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
</cfcomponent>