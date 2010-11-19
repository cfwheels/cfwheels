<cffunction name="dateSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls (month, day, and year) based on a `name` and `value`."
	examples=
	'
		<!--- This "Tag" version of function accepts `name` and `selected` instead of binding to a model object --->
		<cfoutput>
			##dateSelectTags(name="dateStart", selected=params.dateStart)##
		</cfoutput>
		
		<!--- Show fields for month and year only --->
		<cfoutput>
			##dateSelectTags(name="expiration", selected=params.expiration, order="month,year")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textFieldTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="order" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="separator" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="startYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="monthDisplay" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="combine" type="boolean" required="false" hint="See documentation for @dateSelect.">
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

<cffunction name="timeSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for hour, minute, and second based on `name`."
	examples=
	'
		<!--- This "Tag" version of function accepts `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##timeSelectTags(name="timeOfMeeting" selected=params.timeOfMeeting)##
		</cfoutput>
		
		<!--- Show fields for `hour` and `minute` only --->
		<cfoutput>
			##timeSelectTags(name="timeOfMeeting", selected=params.timeOfMeeting, order="hour,minute")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="order" type="string" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="separator" type="string" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="combine" type="boolean" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="twelveHour" type="boolean" required="false" default="false" hint="See documentation for @timeSelect.">
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

<cffunction name="dateTimeSelectTags" returntype="string" access="public" output="false" hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on a `name`."
	examples=
	'
		<!--- This "Tag" version of the function accepts a `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##dateTimeSelectTags(name="dateTimeStart", selected=params.dateTimeStart)##
		</cfoutput>
		
		<!--- Show fields for month, day, hour, and minute --->
		<cfoutput>
			##dateTimeSelectTags(name="dateTimeStart", selected=params.dateTimeStart, dateOrder="month,day", timeOrder="hour,minute")##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="dateOrder" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="dateSeparator" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="startYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="monthDisplay" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="timeOrder" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="timeSeparator" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="minuteStep" type="numeric" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="separator" type="string" required="false" hint="See documentation for @dateTimeSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="combine" type="boolean" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="twelveHour" type="boolean" required="false" default="false" hint="See documentation for @timeSelect.">
	<cfscript>
		var loc = {};
		$args(name="dateTimeSelectTags", args=arguments);
		loc.returnValue = "";
		loc.separator = arguments.separator;
		loc.label = arguments.label;

		// create date portion
		arguments.order = arguments.dateOrder;
		arguments.separator = arguments.dateSeparator;
		// when a list of 6 elements has been passed in as labels we assume the first 3 are meant to be placed on the date related tags
		if (ListLen(loc.label) == 6)
			arguments.label = ListGetAt(loc.label, 1) & "," & ListGetAt(loc.label, 2) & "," & ListGetAt(loc.label, 3);
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & dateSelect(argumentCollection=arguments);
		else
			loc.returnValue = loc.returnValue & dateSelectTags(argumentCollection=arguments);

		// separate date and time with a string ("-" by default)
		loc.returnValue = loc.returnValue & loc.separator;

		// create time portion
		arguments.order = arguments.timeOrder;
		arguments.separator = arguments.timeSeparator;
		// when a list of 6 elements has been passed in as labels we assume the last 3 are meant to be placed on the time related tags
		if (ListLen(loc.label) == 6)
			arguments.label = ListGetAt(loc.label, 4) & "," & ListGetAt(loc.label, 5) & "," & ListGetAt(loc.label, 6);
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & timeSelect(argumentCollection=arguments);
		else
			loc.returnValue = loc.returnValue & timeSelectTags(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="yearSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control for a range of years based on the supplied `name`."
	examples=
	'
		<!--- View code --->
		<cfoutput>
		    ##yearSelectTag(name="yearOfBirthday", selected=params.yearOfBirthday)##
		</cfoutput>
		
		<!--- Only allow selection of year to be for the past 50 years, minimum being 18 years ago --->
		<cfset fiftyYearsAgo = Now() - 50>
		<cfset eighteenYearsAgo = Now() - 18>
		<cfoutput>
			##yearSelectTag(name="yearOfBirthday", selected=params.yearOfBirthday, startYear=fiftyYearsAgo, endYear=eighteenYearsAgo)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The year that should be selected initially.">
	<cfargument name="startYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="endYear" type="numeric" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="yearSelectTag", args=arguments);
		if (IsNumeric(arguments.selected))
			arguments.selected = createDate(arguments.selected, Month(Now()), Day(Now()));
		arguments.order = "year";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="monthSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control for the months of the year based on the supplied `name`."
	examples=
	'
		<!--- This "Tag" version of the function accepts a `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##monthSelectTag(name="monthOfBirthday", selected=params.monthOfBirthday)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The month that should be selected initially.">
	<cfargument name="monthDisplay" type="string" required="false" hint="See documentation for @dateSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="monthSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gt 0 and arguments.selected lte 12)
			arguments.selected = createDate(Year(Now()), arguments.selected, Day(Now()));
		arguments.order = "month";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="daySelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control for the days of the week based on the supplied `name`."
	examples=
	'
		<!--- This "Tag" version of the function accepts a `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##daySelectTag(name="dayOfWeek", selected=params.dayOfWeek)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The day that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="daySelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gt 0 and arguments.selected lte 31)
			arguments.selected = createDate(Year(Now()), Month(Now()), arguments.selected);
		arguments.order = "day";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="hourSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing one select form control for the hours of the day based on the supplied `name`."
	examples=
	'
		<!--- This "Tag" version of the function accepts a `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##hourSelectTag(name="hourOfMeeting", selected=params.hourOfMeeting)##
		</cfoutput>
		
		<!--- Show 12 hours instead of 24 --->
		<cfoutput>
			##hourSelectTag(name="hourOfMeeting", selected=params.hourOfMeeting, twelveHour=true)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The hour that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="twelveHour" type="boolean" required="false" default="false" hint="See documentation for @timeSelect.">
	<cfscript>
		$args(name="hourSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(arguments.selected, Minute(Now()), Second(Now()));
		arguments.order = "hour";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="minuteSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing one select form control for the minutes of an hour based on the supplied `name`."
	examples=
	'
		<!--- This "Tag" version of the function accepts a `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##minuteSelectTag(name="minuteOfMeeting", value=params.minuteOfMeeting)##
		</cfoutput>
		
		<!--- Only show 15-minute intervals --->
		<cfoutput>
			##minuteSelectTag(name="minuteOfMeeting", value=params.minuteOfMeeting, minuteStep=15)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The minute that should be selected initially.">
	<cfargument name="minuteStep" type="numeric" required="false" hint="See documentation for @timeSelect.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="minuteSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(Hour(Now()), arguments.selected, Second(Now()));
		arguments.order = "minute";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="secondSelectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing one select form control for the seconds of a minute based on the supplied `name`."
	examples=
	'
		<!--- This "Tag" version of the function accepts a `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    ##secondSelectTag(name="secondsToLaunch", selected=params.secondsToLaunch)##
		</cfoutput>
	'
	categories="view-helper,forms-plain" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="The second that should be selected initially.">
	<cfargument name="includeBlank" type="any" required="false" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		$args(name="secondSelectTag", args=arguments);
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(Hour(Now()), Minute(Now()), arguments.selected);
		arguments.order = "second";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>