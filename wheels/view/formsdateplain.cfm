<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="dateSelectTags" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
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
	<cfargument name="combine" type="boolean" required="false">
	<cfargument name="$now" type="date" required="false" default="#Now()#">
	<cfscript>
		$args(name="dateSelectTags", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "dateSelectTag";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelectTags" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
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
	<cfargument name="combine" type="boolean" required="false">
	<cfargument name="twelveHour" type="boolean" required="false">
	<cfscript>
		$args(name="timeSelectTags", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "timeSelectTag";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelectTags" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
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
	<cfargument name="combine" type="boolean" required="false">
	<cfargument name="twelveHour" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="dateTimeSelectTags", args=arguments);
		loc.rv = "";
		loc.separator = arguments.separator;
		loc.label = arguments.label;

		// create date portion
		arguments.order = arguments.dateOrder;
		arguments.separator = arguments.dateSeparator;
		// when a list of 6 elements has been passed in as labels we assume the first 3 are meant to be placed on the date related tags
		if (ListLen(loc.label) == 6)
		{
			arguments.label = ListGetAt(loc.label, 1) & "," & ListGetAt(loc.label, 2) & "," & ListGetAt(loc.label, 3);
		}
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
		{
			loc.rv &= dateSelect(argumentCollection=arguments);
		}
		else
		{
			loc.rv &= dateSelectTags(argumentCollection=arguments);
		}

		// separate date and time with a string ("-" by default)
		loc.rv &= loc.separator;

		// create time portion
		arguments.order = arguments.timeOrder;
		arguments.separator = arguments.timeSeparator;
		// when a list of 6 elements has been passed in as labels we assume the last 3 are meant to be placed on the time related tags
		if (ListLen(loc.label) == 6)
		{
			arguments.label = ListGetAt(loc.label, 4) & "," & ListGetAt(loc.label, 5) & "," & ListGetAt(loc.label, 6);
		}
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
		{
			loc.rv &= timeSelect(argumentCollection=arguments);
		}
		else
		{
			loc.rv &= timeSelectTags(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="yearSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
	<cfargument name="startYear" type="numeric" required="false">
	<cfargument name="endYear" type="numeric" required="false">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="$now" type="date" required="false" default="#now()#">
	<cfscript>
		$args(name="yearSelectTag", args=arguments);
		if (IsNumeric(arguments.selected))
		{
			arguments.selected = $dateForSelectTags("year", arguments.selected, arguments.$now);
		}
		arguments.order = "year";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="monthSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
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
	<cfargument name="$now" type="date" required="false" default="#now()#">
	<cfscript>
		var loc = {};
		$args(name="monthSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && IsValid("range", arguments.selected, 0, 12))
		{
			arguments.selected = $dateForSelectTags("month", arguments.selected, arguments.$now);
		}
		arguments.order = "month";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="daySelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="$now" type="date" required="false" default="#now()#">
	<cfscript>
		$args(name="daySelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && IsValid("range", arguments.selected, 0, 31))
		{
			arguments.selected = $dateForSelectTags("day", arguments.selected, arguments.$now);
		}
		arguments.order = "day";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="hourSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="twelveHour" type="boolean" required="false">
	<cfargument name="$now" type="date" required="false" default="#now()#">
	<cfscript>
		$args(name="hourSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60)
		{
			arguments.selected = createTime(arguments.selected, Minute(arguments.$now), Second(arguments.$now));
		}
		arguments.order = "hour";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="minuteSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
	<cfargument name="minuteStep" type="numeric" required="false">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="$now" type="date" required="false" default="#now()#">
	<cfscript>
		$args(name="minuteSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60)
		{
			arguments.selected = createTime(Hour(arguments.$now), arguments.selected, Second(arguments.$now));
		}
		arguments.order = "minute";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="secondSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="selected" type="string" required="false" default="">
	<cfargument name="secondStep" type="numeric" required="false">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="$now" type="date" required="false" default="#now()#">
	<cfscript>
		$args(name="secondSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60)
		{
			arguments.selected = createTime(Hour(arguments.$now), Minute(arguments.$now), arguments.selected);
		}
		arguments.order = "second";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$dateForSelectTags" returntype="date" access="public" output="false">
	<cfargument name="part" type="string" required="true">
	<cfargument name="value" type="numeric" required="true">
	<cfargument name="$now" type="date" required="true">
	<cfscript>
		var loc = {};
		loc.year = Year(arguments.$now);
		loc.month = Month(arguments.$now);
		loc.day = Day(arguments.$now);
		loc.rv = arguments.$now;
		switch (arguments.part)
		{
			case "year":
				loc.year = arguments.value;
				break;
			case "month":
				loc.month = arguments.value;
				break;
			case "day":
				loc.day = arguments.value;
				break;
		}

		// handle february
		if (loc.month == 2 && ((!IsLeapYear(loc.year) && loc.day > 29) || (IsLeapYear(loc.year) && loc.day > 28)))
		{
			if (IsLeapYear(loc.year))
			{
				loc.day = 29;
			}
			else
			{
				loc.day = 28;
			}
		}

		try
		{
			loc.rv = CreateDate(loc.year, loc.month, loc.day);
		}
		catch (any e)
		{
			loc.rv = arguments.$now;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>