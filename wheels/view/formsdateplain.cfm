<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function dateSelectTags(
		required string name,
		string selected="",
		string order,
		string separator,
		numeric startYear,
		numeric endYear,
		string monthDisplay,
		string monthNames,
		string monthAbbreviations,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		boolean combine,
		date $now=Now()
	) {
		$args(name="dateSelectTags", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "dateSelectTag";
		return $dateOrTimeSelect(argumentCollection=arguments);
	}

	public string function timeSelectTags(
		required string name,
		string selected="",
		string order,
		string separator,
		numeric minuteStep,
		numeric secondStep,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		boolean combine,
		boolean twelveHour
	) {
		$args(name="timeSelectTags", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "timeSelectTag";
		return $dateOrTimeSelect(argumentCollection=arguments);
	}

	public string function dateTimeSelectTags(
		required string name,
		string selected="",
		string dateOrder,
		string dateSeparator,
		numeric startYear,
		numeric endYear,
		string monthDisplay,
		string monthNames,
		string monthAbbreviations,
		string timeOrder,
		string timeSeparator,
		numeric minuteStep,
		numeric secondStep,
		string separator,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		boolean combine,
		boolean twelveHour
	) {
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
		return loc.rv;
	}

	public string function yearSelectTag(
		required string name,
		string selected="",
		numeric startYear,
		numeric endYear,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		date $now=now()
	) {
		$args(name="yearSelectTag", args=arguments);
		if (IsNumeric(arguments.selected))
		{
			arguments.selected = $dateForSelectTags("year", arguments.selected, arguments.$now);
		}
		arguments.order = "year";
		return dateSelectTags(argumentCollection=arguments);
	}

	public string function monthSelectTag(
		required string name,
		string selected="",
		string monthDisplay,
		string monthNames,
		string monthAbbreviations,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		date $now=now()
	) {
		var loc = {};
		$args(name="monthSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && IsValid("range", arguments.selected, 0, 12))
		{
			arguments.selected = $dateForSelectTags("month", arguments.selected, arguments.$now);
		}
		arguments.order = "month";
		return dateSelectTags(argumentCollection=arguments);
	}

	public string function daySelectTag(
		required string name,
		string selected="",
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		date $now=now()
	) {
		$args(name="daySelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && IsValid("range", arguments.selected, 0, 31))
		{
			arguments.selected = $dateForSelectTags("day", arguments.selected, arguments.$now);
		}
		arguments.order = "day";
		return dateSelectTags(argumentCollection=arguments)
	}

	public string function hourSelectTag(
		required string name,
		string selected="",
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		boolean twelveHour,
		date $now=now()
	) {
		$args(name="hourSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60)
		{
			arguments.selected = createTime(arguments.selected, Minute(arguments.$now), Second(arguments.$now));
		}
		arguments.order = "hour";
		return timeSelectTags(argumentCollection=arguments);
	}

	public string function minuteSelectTag(
		required string name,
		string selected="",
		numeric minuteStep,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		date $now=now()
	) {
		$args(name="minuteSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60)
		{
			arguments.selected = createTime(Hour(arguments.$now), arguments.selected, Second(arguments.$now));
		}
		arguments.order = "minute";
		return timeSelectTags(argumentCollection=arguments);
	}

	public string function secondSelectTag(
		required string name,
		string selected="",
		numeric secondStep,
		any includeBlank,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		date $now=now()
	) {
		$args(name="secondSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) && arguments.selected >= 0 && arguments.selected < 60)
		{
			arguments.selected = createTime(Hour(arguments.$now), Minute(arguments.$now), arguments.selected);
		}
		arguments.order = "second";
		return timeSelectTags(argumentCollection=arguments);
	}

	/**
	* PRIVATE FUNCTIONS
	*/

	public date function $dateForSelectTags(
		required string part,
		required numeric value,
		required date $now
	) {
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
		return loc.rv;
	}
</cfscript>
