<cffunction name="average" returntype="numeric" access="public" output="false"
	hint="Calculates the average value for a given property. Uses the SQL function `AVG`."
	examples=
	'
		<!--- Get the average salary for all employees --->
		<cfset avgSalary = model("employee").average("salary")>
	'
	categories="model-class" chapters="column-statistics" functions="count,maximum,minimum,sum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to calculate the average for.">
	<cfargument name="where" type="string" required="false" default="" hint="An SQL fragment such as `lastName LIKE 'A%'` for example.">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that need to be included in the query.">
	<cfargument name="distinct" type="boolean" required="false" default="#application.wheels.functions.average.distinct#" hint="When `true`, `AVG` will be performed only on each unique instance of a value, regardless of how many times the value occurs.">
	<cfscript>
		arguments.type = "AVG";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false"
	hint="Returns the number of rows that match the arguments (or all rows if no arguments are passed in). Uses the SQL function `COUNT`."
	examples=
	'
		<!--- Count how many authors there are in the table --->
		<cfset authorCount = model("author").count()>

		<!--- Count how many authors whose last name starts with "A" there are --->
		<cfset authorOnACount = model("author").count(where="lastName LIKE ''A%''")>

		<!--- Count how many authors that have written books starting on "A" --->
		<cfset authorWithBooksOnACount = model("author").count(include="books", where="title LIKE ''A%''")>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call like this --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset amount = aPost.commentCount()>
	'
	categories="model-class" chapters="column-statistics,associations" functions="average,belongsTo,hasMany,hasOne,maximum,minimum,sum">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfscript>
		if (Len(arguments.include))
		{
			arguments.distinct = true;
			arguments.property = variables.wheels.class.keys;
		}
		else
		{
			arguments.distinct = false;
			arguments.property = "*";
		}
		arguments.type = "COUNT";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="maximum" returntype="numeric" access="public" output="false"
	hint="Calculates the maximum value for a given property. Uses the SQL function `MAX`."
	examples=
	'
		<!--- Get the amount of the highest salary for all employees --->
		<cfset highestSalary = model("employee").maximum("salary")>
	'
	categories="model-class" chapters="column-statistics" functions="average,count,minimum,sum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the highest value for (has to be a property of a numeric data type).">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfscript>
		arguments.type = "MAX";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="minimum" returntype="numeric" access="public" output="false"
	hint="Calculates the minimum value for a given property. Uses the SQL function `MIN`."
	examples=
	'
		<!--- Get the amount of the lowest salary for all employees --->
		<cfset lowestSalary = model("employee").minimum("salary")>
	'
	categories="model-class" chapters="column-statistics" functions="average,count,maximum,sum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the lowest value for (has to be a property of a numeric data type).">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfscript>
		arguments.type = "MIN";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="sum" returntype="numeric" access="public" output="false"
	hint="Calculates the sum of values for a given property. Uses the SQL function `SUM`."
	examples=
	'
		<!--- Get the sum of all salaries --->
		<cfset allSalaries = model("employee").sum(property="salary")>

		<!--- Get the sum of all salaries for employees in Australia --->
		<cfset allAustralianSalaries = model("employee").sum(property="salary", include="country", where="name=''Australia''")>
	'
	categories="model-class" chapters="column-statistics" functions="average,count,maximum,minimum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the sum for (has to be a property of a numeric data type).">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="distinct" type="boolean" required="false" default="#application.wheels.functions.sum.distinct#" hint="When `true`, `SUM` returns the sum of unique values only.">
	<cfscript>
		arguments.type = "SUM";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="$calculate" returntype="numeric" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		arguments.select = "#arguments.type#(";
		if (arguments.distinct)
			arguments.select = arguments.select & "DISTINCT ";
		if (arguments.property == "*")
		{
			arguments.select = arguments.select & arguments.property;
		}
		else
		{
			loc.properties = "";
			loc.iEnd = ListLen(arguments.property);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = Trim(ListGetAt(arguments.property, loc.i));
				if (ListFindNoCase(variables.wheels.class.propertyList, loc.iItem))
					loc.properties = ListAppend(loc.properties, variables.wheels.class.tableName & "." & variables.wheels.class.properties[loc.iItem].column);
				else if (ListFindNoCase(variables.wheels.class.calculatedPropertyList, loc.iItem))
					loc.properties = ListAppend(loc.properties, variables.wheels.class.calculatedProperties[loc.iItem].sql);
			}
			arguments.select = arguments.select & loc.properties;
		}
		arguments.select = arguments.select & ") AS result";
		StructDelete(arguments, "type");
		StructDelete(arguments, "property");
		StructDelete(arguments, "distinct");
		loc.query = findAll(argumentCollection=arguments);
		if (Len(loc.query.result))
			loc.returnValue = loc.query.result;
		else
			loc.returnValue = 0;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>