<cfscript>

/**
 * Internal function.
 * Called from get().
 */
public any function $get(required string name, string functionName="") {
	local.appKey = $appKey();
	if (Len(arguments.functionName)) {
		local.rv = application[local.appKey].functions[arguments.functionName][arguments.name];
	} else {
		local.rv = application[local.appKey][arguments.name];
	}
	return local.rv;
}

/**
 * Internal function.
 * Called from set().
 */
public void function $set() {
	local.appKey = $appKey();
	if (ArrayLen(arguments) > 1) {
		for (local.key in arguments) {
			if (local.key != "functionName") {
				local.iEnd = ListLen(arguments.functionName);
				for (local.i = 1; local.i <= local.iEnd; local.i++) {
					application[local.appKey].functions[Trim(ListGetAt(arguments.functionName, local.i))][local.key] = arguments[local.key];
				}
			}
		}
	} else {
		application[local.appKey][StructKeyList(arguments)] = arguments[1];
	}
}

/**
 * Capitalizes all words in the text to create a nicer looking title.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @string String to capitalize.
 */
public string function capitalize(required string text) {
	local.rv = arguments.text;
	if (Len(local.rv)) {
		local.rv = UCase(Left(local.rv, 1)) & Mid(local.rv, 2, Len(local.rv)-1);
	}
	return local.rv;
}

/**
 * Returns readable text by capitalizing and converting camel casing to multiple words.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @text Text to humanize.
 * @except A list of strings (space separated) to replace within the output.
 *
 */
public string function humanize(required string text, string except="") {
	// add a space before every capitalized word
	local.rv = REReplace(arguments.text, "([[:upper:]])", " \1", "all");

	// fix abbreviations so they form a word again (example: aURLVariable)
	local.rv = REReplace(local.rv, "([[:upper:]]) ([[:upper:]])(?:\s|\b)", "\1\2", "all");

	if (Len(arguments.except)) {
		local.iEnd = ListLen(arguments.except, " ");
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(arguments.except, local.i);
			local.rv = ReReplaceNoCase(local.rv, "#local.item#(?:\b)", "#local.item#", "all");
		}
	}

	// support multiple word input by stripping out all double spaces created
	local.rv = Replace(local.rv, "  ", " ", "all");

	// capitalize the first letter and trim final result (which removes the leading space that happens if the string starts with an upper case character)
	local.rv = Trim(capitalize(local.rv));
	return local.rv;
}

/**
 * Returns the plural form of the passed in word. Can also pluralize a word based on a value passed to the `count` argument. CFWheels stores a list of words that are the same in both singular and plural form (e.g. "equipment", "information") and words that don't follow the regular pluralization rules (e.g. "child" / "children", "foot" / "feet"). Use `get("uncountables")` / `set("uncountables", newList)` and `get("irregulars")` / `set("irregulars", newList)` to modify them to suit your needs.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @word The word to pluralize.
 * @count Pluralization will occur when this value is not 1.
 * @returnCount Will return count prepended to the pluralization when true and count is not -1.
 */
public string function pluralize(required string word, numeric count="-1", boolean returnCount="true") {
	return $singularizeOrPluralize(
		count=arguments.count,
		returnCount=arguments.returnCount,
		text=arguments.word,
		which="pluralize"
	);
}

/**
 * Returns the singular form of the passed in word.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @string String to singularize.
 */
public string function singularize(required string word) {
		return $singularizeOrPluralize(text=arguments.word, which="singularize");
}

/**
 * Converts camelCase strings to lowercase strings with hyphens as word delimiters instead. Example: myVariable becomes my-variable.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @string The string to hyphenize.
 */
public string function hyphenize(required string string) {
	local.rv = REReplace(arguments.string, "([A-Z][a-z])", "-\l\1", "all");
	local.rv = REReplace(local.rv, "([a-z])([A-Z])", "\1-\l\2", "all");
	local.rv = REReplace(local.rv, "^-", "", "one");
	local.rv = LCase(local.rv);
	return local.rv;
}

/**
 * Capitalizes all words in the text to create a nicer looking title.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @word The text to turn into a title.
 */
public string function titleize(required string word) {
	local.rv = "";
	local.iEnd = ListLen(arguments.word, " ");
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.rv = ListAppend(local.rv, capitalize(ListGetAt(arguments.word, local.i, " ")), " ");
	}
	return local.rv;
}

</cfscript>
