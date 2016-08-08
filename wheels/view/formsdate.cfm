<cfscript>
	/**
	* PRIVATE FUNCTIONS
	*/

	public string function $yearSelectTag(required numeric startYear, required numeric endYear) {
		if (Structkeyexists(arguments, "value") && Val(arguments.value))
		{
			if (arguments.value < arguments.startYear && arguments.endYear > arguments.startYear)
			{
				arguments.startYear = arguments.value;
			}
			else if (arguments.value < arguments.endYear && arguments.endYear < arguments.startYear)
			{
				arguments.endYear = arguments.value;
			}
		}
		arguments.$loopFrom = arguments.startYear;
		arguments.$loopTo = arguments.endYear;
		arguments.$type = "year";
		arguments.$step = 1;
		StructDelete(arguments, "startYear");
		StructDelete(arguments, "endYear");
		return $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments);
	}

	public string function $monthSelectTag(
		required string monthDisplay,
		required string monthNames,
		required string monthAbbreviations
	) {
		arguments.$loopFrom = 1;
		arguments.$loopTo = 12;
		arguments.$type = "month";
		arguments.$step = 1;
		if (arguments.monthDisplay == "names")
		{
			arguments.$optionNames = arguments.monthNames;
		}
		else if (arguments.monthDisplay == "abbreviations")
		{
			arguments.$optionNames = arguments.monthAbbreviations;
		}
		StructDelete(arguments, "monthDisplay");
		StructDelete(arguments, "monthNames");
		StructDelete(arguments, "monthAbbreviations");
		return $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments);
	}

	public string function $daySelectTag() {
		arguments.$loopFrom = 1;
		arguments.$loopTo = 31;
		arguments.$type = "day";
		arguments.$step = 1;
		return $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments);
	}

	public string function $hourSelectTag() {
		arguments.$loopFrom = 0;
		arguments.$loopTo = 23;
		arguments.$type = "hour";
		arguments.$step = 1;
		if (arguments.twelveHour)
		{
			arguments.$loopFrom = 1;
			arguments.$loopTo = 12;
		}
		return $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments);
	}

	public string function $minuteSelectTag(required numeric minuteStep) {
		arguments.$loopFrom = 0;
		arguments.$loopTo = 59;
		arguments.$type = "minute";
		arguments.$step = arguments.minuteStep;
		StructDelete(arguments, "minuteStep");
		return $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments);
	}

	public any function $secondSelectTag(required numeric secondStep) {
		arguments.$loopFrom = 0;
		arguments.$loopTo = 59;
		arguments.$type = "second";
		arguments.$step = arguments.secondStep;
		StructDelete(arguments, "secondStep");
		return $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments);
	}

	public string function $dateOrTimeSelect(
		required any objectName,
		required string property,
		required string $functionName,
		boolean combine=true,
		boolean twelveHour=false
	) {
		var loc = {};
		loc.combine = arguments.combine;
		StructDelete(arguments, "combine");
		loc.name = $tagName(arguments.objectName, arguments.property);
		arguments.$id = $tagId(arguments.objectName, arguments.property);

		// in order to support 12-hour format, we have to enforce some rules
		// if arguments.twelveHour is true, then order MUST contain ampm
		// if the order contains ampm, then arguments.twelveHour MUST be true
		if (ListFindNoCase(arguments.order, "hour") && arguments.twelveHour && !ListFindNoCase(arguments.order, "ampm"))
		{
			arguments.twelveHour = true;
			if (!ListFindNoCase(arguments.order, "ampm"))
			{
				arguments.order = ListAppend(arguments.order, "ampm");
			}
		}

		loc.value = $formValue(argumentCollection=arguments);
		loc.rv = "";
		loc.firstDone = false;
		loc.iEnd = ListLen(arguments.order);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.order, loc.i);
			loc.marker = "($" & loc.item & ")";
			if (!loc.combine)
			{
				loc.name = $tagName(arguments.objectName, "#arguments.property#-#loc.item#");
				loc.marker = "";
			}
			arguments.name = loc.name & loc.marker;
			arguments.value = loc.value;
			if (IsDate(loc.value))
			{
				if (arguments.twelveHour && ListFind("hour,ampm", loc.item))
				{
					if (loc.item == "hour")
					{
						arguments.value = TimeFormat(loc.value, 'h');
					}
					else if (loc.item == "ampm")
					{
						arguments.value = TimeFormat(loc.value, 'tt');
					}
				}
				else
				{
					arguments.value = Evaluate("#loc.item#(loc.value)");
				}
			}
			if (loc.firstDone)
			{
				loc.rv &= arguments.separator;
			}
			loc.rv &= Evaluate("$#loc.item#SelectTag(argumentCollection=arguments)");
			loc.firstDone = true;
		}
		return loc.rv;
	}

	public string function $yearMonthHourMinuteSecondSelectTag(
		required string name,
		required string value,
		required any includeBlank,
		required string label,
		required string labelPlacement,
		required string prepend,
		required string append,
		required string prependToLabel,
		required string appendToLabel,
		string errorElement="",
		string errorClass="",
		required string $type,
		required numeric $loopFrom,
		required numeric $loopTo,
		required string $id,
		required numeric $step,
		string $optionNames="",
		boolean twelveHour=false,
		date $now=now()
	) {
		var loc = {};
		loc.optionContent = "";

		// only set the default value if the value is blank and includeBlank is false
		if (!Len(arguments.value) && (IsBoolean(arguments.includeBlank) && !arguments.includeBlank))
		{
			if (arguments.twelveHour && arguments.$type IS "hour")
			{
				arguments.value = TimeFormat(arguments.$now, 'h');
			}
			else
			{
				arguments.value = Evaluate("#arguments.$type#(arguments.$now)");
			}
		}

		if (StructKeyExists(arguments, "order") && ListLen(arguments.order) > 1)
		{
			if (ListLen(arguments.includeBlank) > 1)
			{
				arguments.includeBlank = ListGetAt(arguments.includeBlank, ListFindNoCase(arguments.order, arguments.$type));
			}
			if (ListLen(arguments.label) > 1)
			{
				arguments.label = ListGetAt(arguments.label, ListFindNoCase(arguments.order, arguments.$type));
			}
			if (StructKeyExists(arguments, "labelClass") && ListLen(arguments.labelClass) > 1)
			{
				arguments.labelClass = ListGetAt(arguments.labelClass, ListFindNoCase(arguments.order, arguments.$type));
			}
		}
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = arguments.$id & "-" & arguments.$type;
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		loc.content = "";
		if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
		{
			loc.args = {};
			loc.args.value = "";
			if (!Len(arguments.value))
			{
				loc.args.selected = "selected";
			}
			if (!IsBoolean(arguments.includeBlank))
			{
				loc.optionContent = arguments.includeBlank;
			}
			loc.content &= $element(name="option", content=loc.optionContent, attributes=loc.args);
		}
		if (arguments.$loopFrom < arguments.$loopTo)
		{
			for (loc.i=arguments.$loopFrom; loc.i <= arguments.$loopTo; loc.i=loc.i+arguments.$step)
			{
				loc.args = Duplicate(arguments);
				loc.args.counter = loc.i;
				loc.args.optionContent = loc.optionContent;
				loc.content &= $yearMonthHourMinuteSecondSelectTagContent(argumentCollection=loc.args);
			}
		}
		else
		{
			for (loc.i=arguments.$loopFrom; loc.i >= arguments.$loopTo; loc.i=loc.i-arguments.$step)
			{
				loc.args = Duplicate(arguments);
				loc.args.counter = loc.i;
				loc.args.optionContent = loc.optionContent;
				loc.content &= $yearMonthHourMinuteSecondSelectTagContent(argumentCollection=loc.args);
			}
		}
		loc.rv = loc.before & $element(name="select", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,value,includeBlank,order,separator,startYear,endYear,monthDisplay,monthNames,monthAbbreviations,dateSeparator,dateOrder,timeSeparator,timeOrder,minuteStep,secondStep,association,position,twelveHour", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
		return loc.rv;
	}

	public string function $yearMonthHourMinuteSecondSelectTagContent() {
		var loc = {};
		loc.args = {};
		loc.args.value = arguments.counter;
		if (arguments.value == arguments.counter)
		{
			loc.args.selected = "selected";
		}
		if (Len(arguments.$optionNames))
		{
			arguments.optionContent = ListGetAt(arguments.$optionNames, arguments.counter);
		}
		else
		{
			arguments.optionContent = arguments.counter;
		}
		if (arguments.$type == "minute" || arguments.$type == "second")
		{
			arguments.optionContent = NumberFormat(arguments.optionContent, "09");
		}
		loc.rv = $element(name="option", content=arguments.optionContent, attributes=loc.args);
		return loc.rv;
	}

	public string function $ampmSelectTag(
		required string name,
		required string value,
		required string $id,
		date $now=now()
	) {
		var loc = {};
		loc.options = "AM,PM";
		loc.optionContent = "";
		if (!Len(arguments.value))
		{
			arguments.value = TimeFormat(arguments.$now, "tt");
		}
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = arguments.$id & "-ampm";
		}
		loc.content = "";
		loc.iEnd = ListLen(loc.options);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.option = ListGetAt(loc.options, loc.i);
			loc.args = {};
			loc.args.value = loc.option;
			if (arguments.value == loc.option)
			{
				loc.args.selected = "selected";
			}
			loc.content &= $element(name="option", content=loc.option, attributes=loc.args);
		}
		loc.rv = $element(name="select", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,value,includeBlank,order,separator,startYear,endYear,monthDisplay,monthNames,monthAbbreviations,dateSeparator,dateOrder,timeSeparator,timeOrder,minuteStep,secondStep,association,position,twelveHour", skipStartingWith="label", content=loc.content, attributes=arguments);
		return loc.rv;
	}
</cfscript>
