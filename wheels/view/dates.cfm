<cfscript>

/**
 * Pass in two dates to this method, and it will return a string describing the difference between them.
 *
 * [section: View Helpers]
 * [category: Date Functions]
 *
 * @fromTime date Yes Date to compare from..
 * @toTime date Yes , Date to compare to.
 * @includeSeconds boolean No false Whether or not to include the number of seconds in the returned string.
 */
public string function distanceOfTimeInWords(required date fromTime, required date toTime, boolean includeSeconds) {
	$args(name="distanceOfTimeInWords", args=arguments);
	local.minuteDiff = DateDiff("n", arguments.fromTime, arguments.toTime);
	local.secondDiff = DateDiff("s", arguments.fromTime, arguments.toTime);
	local.hours = 0;
	local.days = 0;
	local.rv = "";
	if (local.minuteDiff <= 1) {
		if (local.secondDiff < 60) {
			local.rv = "less than a minute";
		} else {
			local.rv = "1 minute";
		}
		if (arguments.includeSeconds) {
			if (local.secondDiff < 5) {
				local.rv = "less than 5 seconds";
			} else if (local.secondDiff < 10) {
				local.rv = "less than 10 seconds";
			} else if (local.secondDiff < 20) {
				local.rv = "less than 20 seconds";
			} else if (local.secondDiff < 40) {
				local.rv = "half a minute";
			}
		}
	} else if (local.minuteDiff < 45) {
		local.rv = local.minuteDiff & " minutes";
	} else if (local.minuteDiff < 90) {
		local.rv = "about 1 hour";
	} else if (local.minuteDiff < 1440) {
		local.hours = Ceiling(local.minuteDiff / 60);
		local.rv = "about " & local.hours & " hours";
	} else if (local.minuteDiff < 2880) {
		local.rv = "1 day";
	} else if (local.minuteDiff < 43200) {
		local.days = Int(local.minuteDiff/1440);
		local.rv = local.days & " days";
	} else if (local.minuteDiff < 86400) {
		local.rv = "about 1 month";
	} else if (local.minuteDiff < 525600) {
		local.months = Int(local.minuteDiff / 43200);
		local.rv = local.months & " months";
	} else if (local.minuteDiff < 657000) {
		local.rv = "about 1 year";
	} else if (local.minuteDiff < 919800) {
		local.rv = "over 1 year";
	} else if (local.minuteDiff < 1051200) {
		local.rv = "almost 2 years";
	} else if (local.minuteDiff >= 1051200) {
		local.years = Int(local.minuteDiff / 525600);
		local.rv = "over " & local.years & " years";
	}
	return local.rv;
}

/**
 * Returns a string describing the approximate time difference between the date passed in and the current date.
 *
 * [section: View Helpers]
 * [category: Date Functions]
 *
 * @fromTime date Yes Date to compare from..
 * @includeSeconds boolean No false Whether or not to include the number of seconds in the returned string.
 * @toTime date No [runtime expression] Date to compare to.
 */
public any function timeAgoInWords(required date fromTime, boolean includeSeconds, date toTime=Now()) {
	$args(name="timeAgoInWords", args=arguments);
	return distanceOfTimeInWords(argumentCollection=arguments);
}

/**
 * Returns a string describing the approximate time difference between the current date and the date passed in.
 *
 * [section: View Helpers]
 * [category: Date Functions]
 *
 * @toTime date Yes Date to compare to.
 * @includeSeconds boolean No false Whether or not to include the number of seconds in the returned string.
 * @fromTime date No [runtime expression] Date to compare from.
 */
public string function timeUntilInWords(required date toTime, boolean includeSeconds, date fromTime=Now()) {
	$args(name="timeUntilInWords", args=arguments);
	return distanceOfTimeInWords(argumentCollection=arguments);
}

</cfscript>
