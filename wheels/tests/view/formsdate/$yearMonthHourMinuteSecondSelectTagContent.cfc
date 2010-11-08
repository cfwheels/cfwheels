<cfcomponent extends="wheelsMapping.Test">

	<cfset pkg.controller = controller("dummy")>

	<cffunction name="setup">
		<cfset result = "">
		<cfset results = {}>
	</cffunction>

	<cffunction name="testBasic">
		<cfset result = pkg.controller.$yearMonthHourMinuteSecondSelectTagContent(counter=5, value="", $optionNames="", $type="")>
		<cfset assert("result IS '<option value=""5"">5</option>'")>
	</cffunction>

	<cffunction name="testSelected">
		<cfset result = pkg.controller.$yearMonthHourMinuteSecondSelectTagContent(counter=3, value=3, $optionNames="", $type="")>
		<cfset assert("result IS '<option selected=""selected"" value=""3"">3</option>'")>
	</cffunction>

	<cffunction name="testFormatting">
		<cfset result = pkg.controller.$yearMonthHourMinuteSecondSelectTagContent(counter=1, value="", $optionNames="", $type="minute")>
		<cfset assert("result IS '<option value=""1"">01</option>'")>
		<cfset result = pkg.controller.$yearMonthHourMinuteSecondSelectTagContent(counter=59, value="", $optionNames="", $type="second")>
		<cfset assert("result IS '<option value=""59"">59</option>'")>
	</cffunction>

	<cffunction name="testOptionName">
		<cfset result = pkg.controller.$yearMonthHourMinuteSecondSelectTagContent(counter=1, value="", $optionNames="someName", $type="")>
		<cfset assert("result IS '<option value=""1"">someName</option>'")>
	</cffunction>

</cfcomponent>