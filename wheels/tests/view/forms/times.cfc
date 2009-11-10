<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_timeSelect_valid">
		<cfset global.controller.timeSelect(objectName="user", property="birthday")>
	</cffunction>

	<cffunction name="test_x_timeSelectTags_valid">
		<cfset global.controller.timeSelectTags(name="timeOfMeeting")>
	</cffunction>

	<cffunction name="test_x_hourSelectTag_valid">
		<cfset global.controller.hourSelectTag(name="hourOfMeeting")>
	</cffunction>

	<cffunction name="test_x_minuteSelectTag_valid">
		<cfset global.controller.minuteSelectTag(name="minuteOfMeeting")>
	</cffunction>

	<cffunction name="test_x_secondSelectTag_valid">
		<cfset global.controller.secondSelectTag(name="secondsToLaunch")>
	</cffunction>

</cfcomponent>