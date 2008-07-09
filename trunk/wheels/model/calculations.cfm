<cffunction name="sum" returntype="numeric" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="">
	<cfscript>
		arguments.type = "SUM";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="minimum" returntype="numeric" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="">
	<cfscript>
		arguments.type = "MIN";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="maximum" returntype="numeric" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="">
	<cfscript>
		arguments.type = "MAX";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="average" returntype="numeric" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="">
	<cfscript>
		arguments.type = "AVG";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="">
	<cfscript>
		arguments.property = ListFirst(variables.wheels.class.keys);
		arguments.type = "COUNT";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="$calculate" returntype="numeric" access="private" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="">
	<cfscript>
		var loc = {};
		if (!Len(arguments.distinct))
		{
			if (Len(arguments.include))
				arguments.distinct = true;
			else
				arguments.distinct = false;
		}
		arguments.select = "#arguments.type#(";
		if (arguments.distinct)
			arguments.select = arguments.select & "DISTINCT ";
		arguments.select = arguments.select & "#variables.wheels.class.tableName#.#arguments.property#) AS result";
		StructDelete(arguments, "type");
		StructDelete(arguments, "property");
		loc.query = findAll(argumentCollection=arguments);
		if (Len(loc.query.result))
			loc.returnValue = loc.query.result;
		else
			loc.returnValue = 0;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>