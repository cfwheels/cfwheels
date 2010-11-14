<cffunction name="$tokenizeSql" returntype="any" output="false" access="public">
	<cfargument name="sql" type="string" required="true" />
	<cfscript>
		var loc = {};
		loc.result = [];
		loc.sql = REReplace(Trim(arguments.sql), "([[:space:]]*,)", ",", "all"); // remove all spaces in front of commas
		loc.part = $matchSqlPart(string=loc.sql);
		
		while (Len(loc.part))
		{
			if (loc.part == "'")
			{
				loc.part = $singleQuoteString(loc.sql);
				ArrayAppend(loc.result, loc.part);
			}
			else if (loc.part == "`")
			{
				loc.part = $backQuoteString(loc.sql);
				ArrayAppend(loc.result, loc.part);
			}
			else if (loc.part == '"')
			{
				loc.part = $doubleQuoteString(loc.sql);
				ArrayAppend(loc.result, loc.part);
			}
			else
			{
				ArrayAppend(loc.result, loc.part);
			}
		
			loc.rightLen = Len(loc.sql) - Len(loc.part);
			if (loc.rightLen gt 0)
				loc.sql = Trim(Right(loc.sql, loc.rightLen));
			else
				loc.sql = "";
				
			loc.part = $matchSqlPart(string=loc.sql);
			
			if (!Len(loc.part))
				ArrayAppend(loc.result, loc.sql);
		}
	</cfscript>
	<cfreturn loc.result />
</cffunction>

<cffunction name="$matchSqlPart" output="false" access="public" returntype="string">
	<cfargument name="string" type="string" required="true" />
	<cfscript>
		var tokenArray = [];
		
		tokenArray = REMatch("^(#variables.wheels.class.RESQLToken#)", arguments.string);
		if (ArrayLen(tokenArray)) return tokenArray[1];
		
		tokenArray = REMatch("^(#variables.wheels.class.RESQLToken#)(#variables.wheels.class.RESQLTerminal#)", arguments.string);
		if (ArrayLen(tokenArray)) return tokenArray[1];
		
		tokenArray = REMatch("^(#variables.wheels.class.RESQLToken#).", arguments.string);
		if (ArrayLen(tokenArray)) return tokenArray[1];
		
		tokenArray = REMatch("^([a-zA-Z0-9\-_\.]+?)(#variables.wheels.class.RESQLTerminal#)", arguments.string);
		if (ArrayLen(tokenArray)) return tokenArray[1];
	</cfscript>
	<cfreturn "" />
</cffunction>

<cffunction name="$singleQuoteString" output="false" access="public" returntype="string">
	<cfargument name="string" type="string" required="true" />
	<cfset var matches = REMatch("^'(.*?([']{2}|(\\'))?)+'.", arguments.string) />
	<cfreturn matches[1] />
</cffunction>

<cffunction name="$backQuoteString" output="false" access="public" returntype="string">
	<cfargument name="string" type="string" required="true" />
	<cfset var matches = REMatch("^(`.*?`)\.?(`.*?`)?.", arguments.string) />
	<cfreturn matches[1] />
</cffunction>

<cffunction name="$doubleQuoteString" output="false" access="public" returntype="string">
	<cfargument name="string" type="string" required="true" />
	<cfset var matches = REMatch("^""(.*?)"".", arguments.string) />
	<cfreturn matches[1] />
</cffunction>
