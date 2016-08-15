<cfscript>
	/*
	* PUBLIC MODEL CLASS METHODS
	*/

	public any function average(
		required string property,
		string where="",
		string include="",
		boolean distinct,
		any parameterize,
		any ifNull,
		boolean includeSoftDeletes="false",
		string group
	) {
		$args(name="average", args=arguments);
		arguments.type = "AVG";
		if (StructKeyExists(arguments, "group"))
		{
			local.rv = $calculate(argumentCollection=arguments);
		}
		else
		{
			if (ListFindNoCase("cf_sql_integer,cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint", variables.wheels.class.properties[arguments.property].type))
			{
				// this is an integer column so we get all the values from the database and do the calculation in ColdFusion since we can't run a query to get the average value without type casting it
				local.values = findAll(select=arguments.property, where=arguments.where, include=arguments.include, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes);
				local.values = ListToArray(Evaluate("ValueList(local.values.#arguments.property#)"));
				local.rv = arguments.ifNull;
				if (!ArrayIsEmpty(local.values))
				{
					if (arguments.distinct)
					{
						local.tempValues = {};
						local.iEnd = ArrayLen(local.values);
						for (local.i=1; local.i <= local.iEnd; local.i++)
						{
							StructInsert(local.tempValues, local.values[local.i], local.values[local.i], true);
						}
						local.values = ListToArray(StructKeyList(local.tempValues));
					}
					local.rv = ArrayAvg(local.values);
				}
			}
			else
			{
				// if the column's type is a float or similar we can run an AVG type query since it will always return a value of the same type as the column
				local.rv = $calculate(argumentCollection=arguments);

				// we convert the result to a string so that it is the same as what would happen if you calculate an average in ColdFusion code (like we do for integers in this function for example)
				local.rv = JavaCast("string", local.rv);
			}
		}
		return local.rv;
	}
	public any function count(
		string where="",
		string include="",
		any parameterize,
		boolean includeSoftDeletes="false",
		string group
	) {
		$args(name="count", args=arguments);
		arguments.type = "COUNT";
		arguments.property = ListFirst(primaryKey());
		if (Len(arguments.include))
		{
			arguments.distinct = true;
		}
		else
		{
			arguments.distinct = false;
		}
		local.rv = $calculate(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "group") && !IsNumeric(local.rv))
		{
			local.rv = 0;
		}
		return local.rv;
	}

	public any function maximum(
		required string property,
		string where="",
		string include="",
		any parameterize,
		any ifNull,
		boolean includeSoftDeletes="false",
		string group
	) {
		$args(name="maximum", args=arguments);
		arguments.type = "MAX";
		local.rv = $calculate(argumentCollection=arguments);
		return local.rv;
	}

	public any function minimum(
		required string property,
		string where="",
		string include="",
		any parameterize,
		any ifNull,
		boolean includeSoftDeletes="false",
		string group
	) {
		$args(name="minimum", args=arguments);
		arguments.type = "MIN";
		local.rv = $calculate(argumentCollection=arguments);
		return local.rv;
	}

	public any function sum(
		required string property,
		string where="",
		string include="",
		boolean distinct,
		any parameterize,
		any ifNull,
		boolean includeSoftDeletes="false",
		string group
	) {
		$args(name="sum", args=arguments);
		arguments.type = "SUM";
		local.rv = $calculate(argumentCollection=arguments);
		return local.rv;
	}

	/*
	* PRIVATE METHODS
	*/
	public any function $calculate(
		required string type,
		required string property,
		required string where,
		required string include,
		required any parameterize,
		boolean distinct="false",
		any ifNull="",
		required boolean includeSoftDeletes,
		string group
	){
		// start the select string with the type (`SUM`, `COUNT` etc)
		arguments.select = "#arguments.type#(";

		// add the DISTINCT keyword if necessary (generally used for `COUNT` operations when associated tables are joined in the query, means we'll only count the unique primary keys on the current model)
		if (arguments.distinct)
		{
			arguments.select &= "DISTINCT ";
		}

		// create a list of columns for the `SELECT` clause either from regular properties on the model or calculated ones
		local.properties = "";
		local.iEnd = ListLen(arguments.property);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.item = Trim(ListGetAt(arguments.property, local.i));
			if (ListFindNoCase(variables.wheels.class.propertyList, local.item))
			{
				local.properties = ListAppend(local.properties, tableName() & "." & variables.wheels.class.properties[local.item].column);
			}
			else if (ListFindNoCase(variables.wheels.class.calculatedPropertyList, local.item))
			{
				local.properties = ListAppend(local.properties, variables.wheels.class.calculatedProperties[local.item].sql);
			}
		}
		arguments.select &= local.properties;

		// alias the result with `AS`, this means that Wheels will not try and change the string (which is why we have to add the table name above since it won't be done automatically)
		local.alias = LCase(arguments.type);
		local.alias = Replace(Replace(Replace(local.alias, "avg", "average"), "min", "minimum"), "max", "maximum");
		if (arguments.type != "count")
		{
			local.alias = arguments.property & local.alias;
		}
		arguments.select &= ") AS " & local.alias;

		if (StructKeyExists(arguments, "group"))
		{
			arguments.select = ListAppend(arguments.select, $createSQLFieldList(clause="select", list=arguments.group, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes, returnAs="query"));
		}

		// call `findAll` with `select`, `where`, `group`, `parameterize` and `include` but delete all other arguments
		StructDelete(arguments, "type");
		StructDelete(arguments, "property");
		StructDelete(arguments, "distinct");

		// since we don't return any records for calculation methods we want to skip the callbacks
		arguments.callbacks = false;

		local.rv = findAll(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "group"))
		{
			// when not grouping by something we just return the value itself
			local.rv = local.rv[local.alias];
			if (!Len(local.rv) && Len(arguments.ifNull))
			{
				local.rv = arguments.ifNull;
			}
		}
		return local.rv;
	}
</cfscript>