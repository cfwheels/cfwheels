<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_timeSelect_valid">
		<cfset loc.controller.timeSelect(objectName="user", property="birthday")>
	</cffunction>

	<cffunction name="test_x_timeSelectTags_valid">
		<cfset loc.controller.timeSelectTags(name="timeOfMeeting")>
	</cffunction>

	<cffunction name="test_x_hourSelectTag_valid">
		<cfset loc.controller.hourSelectTag(name="hourOfMeeting")>
	</cffunction>

	<cffunction name="test_x_minuteSelectTag_valid">
		<cfset loc.controller.minuteSelectTag(name="minuteOfMeeting")>
	</cffunction>

	<cffunction name="test_x_secondSelectTag_valid">
		<cfset loc.controller.secondSelectTag(name="secondsToLaunch")>
	</cffunction>

</cfcomponent>