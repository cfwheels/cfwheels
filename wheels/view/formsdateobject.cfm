<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="dateSelect" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="order" type="string" required="false">
	<cfargument name="separator" type="string" required="false">
	<cfargument name="startYear" type="numeric" required="false">
	<cfargument name="endYear" type="numeric" required="false">
	<cfargument name="monthDisplay" type="string" required="false">
	<cfargument name="monthNames" type="string" required="false">
	<cfargument name="monthAbbreviations" type="string" required="false">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfargument name="combine" type="boolean" required="false">
	<cfscript>
		$args(name="dateSelect", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		arguments.$functionName = "dateSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelect" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="order" type="string" required="false">
	<cfargument name="separator" type="string" required="false">
	<cfargument name="minuteStep" type="numeric" required="false">
	<cfargument name="secondStep" type="numeric" required="false">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfargument name="combine" type="boolean" required="false">
	<cfargument name="twelveHour" type="boolean" required="false">
	<cfscript>
		$args(name="timeSelect", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		arguments.$functionName = "timeSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelect" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="dateOrder" type="string" required="false">
	<cfargument name="dateSeparator" type="string" required="false">
	<cfargument name="startYear" type="numeric" required="false">
	<cfargument name="endYear" type="numeric" required="false">
	<cfargument name="monthDisplay" type="string" required="false">
	<cfargument name="monthNames" type="string" required="false">
	<cfargument name="monthAbbreviations" type="string" required="false">
	<cfargument name="timeOrder" type="string" required="false">
	<cfargument name="timeSeparator" type="string" required="false">
	<cfargument name="minuteStep" type="numeric" required="false">
	<cfargument name="secondStep" type="numeric" required="false">
	<cfargument name="separator" type="string" required="false">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfargument name="combine" type="boolean" required="false">
	<cfargument name="twelveHour" type="boolean" required="false">
	<cfscript>
		$args(name="dateTimeSelect", reserved="name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.$functionName = "dateTimeSelect";
	</cfscript>
	<cfreturn dateTimeSelectTags(argumentCollection=arguments)>
</cffunction>