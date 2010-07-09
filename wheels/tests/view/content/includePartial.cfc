<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset $$oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="test_including_partial">
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(partial="partialTemplate")#</cfoutput></cfsavecontent>
		<cfset assert("result Contains 'partial template content'")>
	</cffunction>

	<cffunction name="test_including_partial_loading_data">
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(partial="partialDataTemplate")#</cfoutput></cfsavecontent>
		<cfset assert("result IS 'Apple,Banana,Kiwi'")>
	</cffunction>
	
	<cffunction name="test_including_partial_loading_data_not_allowed_from_public_method">
		<cfset result = "">
		<cftry>
			<cfsavecontent variable="result"><cfoutput>#controller.includePartial(partial="partialDataTemplate", dataFunction="partialDataTemplatePublic")#</cfoutput></cfsavecontent>
			<cfcatch type="any">
				<cfset result = cfcatch>
			</cfcatch>
		</cftry>
		<cfset assert("!issimplevalue(result)")>
		<cfset assert("result.type eq 'expression'")>
		<cfset assert("result.element eq 'fruit'")>
		<cfset assert("result.resolvedname eq 'arguments'")>
	</cffunction>

	<cffunction name="test_including_partial_with_query">
		<cfset usersQuery = model("user").findAll(order="firstName")>
		<cfset request.partialTests.currentTotal = 0>
		<cfset request.partialTests.thirdUserName = "">
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(usersQuery)#</cfoutput></cfsavecontent>
		<cfset assert("request.partialTests.currentTotal IS 15 AND request.partialTests.thirdUserName IS 'Per'")>
	</cffunction>

	<cffunction name="test_including_partial_with_special_query_argument">
		<cfset usersQuery = model("user").findAll(order="firstName")>
		<cfset request.partialTests.currentTotal = 0>
		<cfset request.partialTests.thirdUserName = "">
		<cfset request.partialTests.noQueryArg = true>
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(partial="custom", query=usersQuery)#</cfoutput></cfsavecontent>
		<cfset assert("request.partialTests.noQueryArg IS true AND request.partialTests.currentTotal IS 15 AND request.partialTests.thirdUserName IS 'Per'")>
	</cffunction>

	<cffunction name="test_including_partial_with_normal_query_argument">
		<cfset usersQuery = model("user").findAll(order="firstName")>
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(partial="custom", customQuery=usersQuery)#</cfoutput></cfsavecontent>
		<cfset assert("Trim(result) IS 'Per'")>
	</cffunction>

	<cffunction name="test_including_partial_with_special_objects_argument">
		<cfset usersArray = model("user").findAll(order="firstName", returnAs="objects")>
		<cfset request.partialTests.currentTotal = 0>
		<cfset request.partialTests.thirdUserName = "">
		<cfset request.partialTests.thirdObjectExists = false>
		<cfset request.partialTests.noObjectsArg = true>
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(partial="custom", objects=usersArray)#</cfoutput></cfsavecontent>
		<cfset assert("request.partialTests.thirdObjectExists IS true AND request.partialTests.noObjectsArg IS true AND request.partialTests.currentTotal IS 15 AND request.partialTests.thirdUserName IS 'Per'")>
	</cffunction>

	<cffunction name="test_including_partial_with_object">
		<cfset userObject = model("user").findOne(order="firstName")>
		<cfset request.wheelsTests.objectTestsPassed = false>
		<cfsavecontent variable="result"><cfoutput>#controller.includePartial(userObject)#</cfoutput></cfsavecontent>
		<cfset assert("request.wheelsTests.objectTestsPassed IS true AND Trim(result) IS 'Chris'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = $$oldViewPath>
	</cffunction>

</cfcomponent>