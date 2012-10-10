<!--- string helpers --->

<cffunction name="capitalize" returntype="string" access="public" output="false" hint="Returns the text with the first character converted to uppercase."
	examples=
	'
		<!--- Capitalize a sentence, will result in "Wheels is a framework" --->
		##capitalize("wheels is a framework")##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="humanize,pluralize,singularize">
	<cfargument name="text" type="string" required="true" hint="Text to capitalize.">
	<cfif !Len(arguments.text)>
		<cfreturn arguments.text />
	</cfif>
	<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
</cffunction>

<cffunction name="humanize" returntype="string" access="public" output="false" hint="Returns readable text by capitalizing and converting camel casing to multiple words."
	examples=
	'
		<!--- Humanize a string, will result in "Wheels Is A Framework" --->
		##humanize("wheelsIsAFramework")##

		<!--- Humanize a string, force wheels to replace "Cfml" with "CFML" --->
		##humanize("wheelsIsACFMLFramework", "CFML")##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="capitalize,pluralize,singularize">
	<cfargument name="text" type="string" required="true" hint="Text to humanize.">
	<cfargument name="except" type="string" required="false" default="" hint="a list of strings (space separated) to replace within the output.">
	<cfscript>
		var loc = {};
		loc.returnValue = REReplace(arguments.text, "([[:upper:]])", " \1", "all"); // adds a space before every capitalized word
		loc.returnValue = REReplace(loc.returnValue, "([[:upper:]]) ([[:upper:]])(?:\s|\b)", "\1\2", "all"); // fixes abbreviations so they form a word again (example: aURLVariable)
		if (Len(arguments.except))
		{
			loc.iEnd = ListLen(arguments.except, " ");
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				loc.a = ListGetAt(arguments.except, loc.i);
				loc.returnValue = ReReplaceNoCase(loc.returnValue, "#loc.a#(?:\b)", "#loc.a#", "all");
			}
		}
		loc.returnValue = Trim(capitalize(loc.returnValue)); // capitalize the first letter and trim final result (which removes the leading space that happens if the string starts with an upper case character)
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="pluralize" returntype="string" access="public" output="false" hint="Returns the plural form of the passed in word. Can also pluralize a word based on a value passed to the `count` argument."
	examples=
	'
		<!--- Pluralize a word, will result in "people" --->
		##pluralize("person")##

		<!--- Pluralize based on the count passed in --->
		Your search returned ##pluralize(word="person", count=users.RecordCount)##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="capitalize,humanize,singularize">
	<cfargument name="word" type="string" required="true" hint="The word to pluralize.">
	<cfargument name="count" type="numeric" required="false" default="-1" hint="Pluralization will occur when this value is not `1`.">
	<cfargument name="returnCount" type="boolean" required="false" default="true" hint="Will return `count` prepended to the pluralization when `true` and `count` is not `-1`.">
	<cfreturn $singularizeOrPluralizeWithCount(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>

<cffunction name="singularize" returntype="string" access="public" output="false" hint="Returns the singular form of the passed in word."
	examples=
	'
		<!--- Singularize a word, will result in "language" --->
		##singularize("languages")##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="capitalize,humanize,pluralize">
	<cfargument name="word" type="string" required="true" hint="String to singularize.">
	<cfreturn $singularizeOrPluralizeWithCount(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="toXHTML" returntype="string" access="public" output="false" hint="Returns an XHTML-compliant string."
	examples=
	'
		<!--- Outputs `productId=5&amp;categoryId=12&amp;returningCustomer=1` --->
		<cfoutput>
			##toXHTML("productId=5&categoryId=12&returningCustomer=1")##
		</cfoutput>
	'
	categories="global,string" chapters="" functions="">
	<cfargument name="text" type="string" required="true" hint="String to make XHTML-compliant.">
	<cfset arguments.text = Replace(arguments.text, "&", "&amp;", "all")>
	<cfreturn arguments.text>
</cffunction>

<cffunction name="mimeTypes" returntype="string" access="public" output="false" hint="Returns an associated MIME type based on a file extension."
	examples=
	'
		<!--- Get the internally-stored MIME type for `xls` --->
		<cfset mimeType = mimeTypes("xls")>

		<!--- Get the internally-stored MIME type for a dynamic value. Fall back to a MIME type of `text/plain` if it''s not found --->
		<cfset mimeType = mimeTypes(extension=params.type, fallback="text/plain")>
	'
	categories="global,miscellaneous" chapters="" functions="">
	<cfargument name="extension" required="true" type="string" hint="The extension to get the MIME type for.">
	<cfargument name="fallback" required="false" type="string" default="application/octet-stream" hint="the fallback MIME type to return.">
	<cfif StructKeyExists(application.wheels.mimetypes, arguments.extension)>
		<cfset arguments.fallback = application.wheels.mimetypes[arguments.extension]>
	</cfif>
	<cfreturn arguments.fallback>
</cffunction>

<cffunction name="hyphenize" returntype="string" access="public" output="false" hint="Converts camelCase strings to lowercase strings with hyphens as word delimiters instead. Example: `myVariable` becomes `my-variable`."
	examples=
	'
		<!--- Outputs "my-blog-post" --->
		<cfoutput>
			##hyphenize("myBlogPost")##
		</cfoutput>
	'
	categories="global,string" chapters="" functions="">
	<cfargument name="string" type="string" required="true" hint="The string to hyphenize.">
	<cfset arguments.string = REReplace(arguments.string, "([A-Z][a-z])", "-\l\1", "all")>
	<cfset arguments.string = REReplace(arguments.string, "([a-z])([A-Z])", "\1-\l\2", "all")>
	<cfset arguments.string = REReplace(arguments.string, "^-", "", "one")>
	<cfreturn LCase(arguments.string)>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$singularizeOrPluralizeWithCount" returntype="string" access="public" output="false" hint="Decides if we need to convert the word based on the count value passed in and then adds the count to the string.">
	<cfargument name="text" type="string" required="true" hint="@pluralize.">
	<cfargument name="count" type="numeric" required="false" default="-1" hint="@pluralize.">
	<cfargument name="returnCount" type="boolean" required="false" default="true" hint="@pluralize.">
	<cfargument name="which" type="string" required="true" hint="Should be either `singularize` or `pluralize`.">
	<cfscript>
		var loc = {};
		loc.returnValue = $args(name="$singularizeOrPluralizeWithCount", args=arguments);
		if (!StructKeyExists(loc, "returnValue"))
		{
			// run conversion unless count is passed in and its value means conversion is unnecessary
			if (arguments.which == "pluralize" && arguments.count == 1)
				loc.returnValue = arguments.text;
			else
				loc.returnValue = $singularizeOrPluralize(text=arguments.text, which=arguments.which);
	
			// return the count number in the string (e.g. "5 sites" instead of just "sites")
			if (arguments.returnCount && arguments.count != -1)
				loc.returnValue = LSNumberFormat(arguments.count) & " " & loc.returnValue;
		}
		return loc.returnValue;
	</cfscript>
</cffunction>

<cffunction name="$singularizeOrPluralize" returntype="string" access="public" output="false" hint="Converts a word to singular or plural form.">
	<cfargument name="text" type="string" required="true" hint="@pluralize.">
	<cfargument name="which" type="string" required="true" hint="@$singularizeOrPluralizeWithCount.">
	<cfscript>
		var loc = {};
		loc.returnValue = $args(name="$singularizeOrPluralize", args=arguments);
		if (!StructKeyExists(loc, "returnValue"))
		{
			// default to returning the same string when nothing can be converted
			loc.returnValue = arguments.text;
			
			// keep track of the success of any rule matches
			loc.ruleMatched = false;
			
			// only pluralize/singularize the last part of a camelCased variable (e.g. in "websiteStatusUpdate" we only change the "update" part)
			// also set a variable with the unchanged part of the string (to be prepended before returning final result)
			if (REFind("[A-Z]", arguments.text))
			{
				loc.upperCasePos = REFind("[A-Z]", Reverse(arguments.text));
				loc.prepend = Mid(arguments.text, 1, Len(arguments.text)-loc.upperCasePos);
				arguments.text = Reverse(Mid(Reverse(arguments.text), 1, loc.upperCasePos));
			}

			loc.uncountables = "advice,air,blood,deer,equipment,fish,food,furniture,garbage,graffiti,grass,homework,housework,information,knowledge,luggage,mathematics,meat,milk,money,music,pollution,research,rice,sand,series,sheep,soap,software,species,sugar,traffic,transportation,travel,trash,water,feedback";
			loc.irregulars = "child,children,foot,feet,man,men,move,moves,person,people,sex,sexes,tooth,teeth,woman,women";
			if (ListFindNoCase(loc.uncountables, arguments.text))
			{
				// this word is the same in both plural and singular so it can just be returned as is
				loc.returnValue = arguments.text;
				
				// note that we successfully matched a rule
				loc.ruleMatched = true;
			}
			else if (ListFindNoCase(loc.irregulars, arguments.text))
			{
				// this word cannot be converted in a standard way so we return a preset value as specifed in the list above
				loc.pos = ListFindNoCase(loc.irregulars, arguments.text);
				if (arguments.which == "singularize" && loc.pos MOD 2 == 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos-1);
				else if (arguments.which == "pluralize" && loc.pos MOD 2 != 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos+1);
				else
					loc.returnValue = arguments.text;
				
				// note that we successfully matched a rule
				loc.ruleMatched = true;
			}
			else
			{
				// this word can probably be converted to plural/singular using standard rules so we'll do that
				// we'll start by setting the rules and create an array from them
				if (arguments.which == "pluralize")
					loc.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status)$,\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
				else if (arguments.which == "singularize")
					loc.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,(.*)?ss$,\1ss,s$,#Chr(7)#";
				loc.rules = ArrayNew(2);
				loc.count = 1;
				loc.iEnd = ListLen(loc.ruleList);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i=loc.i+2)
				{
					loc.rules[loc.count][1] = ListGetAt(loc.ruleList, loc.i);
					loc.rules[loc.count][2] = ListGetAt(loc.ruleList, loc.i+1);
					loc.count = loc.count + 1;
				}
				
				// loop through the rules looking for a match and perform the regex replace when we find one
				loc.iEnd = ArrayLen(loc.rules);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					if (REFindNoCase(loc.rules[loc.i][1], arguments.text))
					{
						loc.returnValue = REReplaceNoCase(arguments.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
						loc.ruleMatched = true;
						break;
					}
				}

				// set back to blank string since we worked around the fact that we can't have blank values in lists above by using Chr(7) instead
				loc.returnValue = Replace(loc.returnValue, Chr(7), "", "all");
			}
	
			// if this is a camel cased string we need to prepend the unchanged part to the result
			if (StructKeyExists(loc, "prepend") && loc.ruleMatched)
				loc.returnValue = loc.prepend & loc.returnValue;
		}
		return loc.returnValue;
	</cfscript>
</cffunction>