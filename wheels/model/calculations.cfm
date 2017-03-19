<cfscript>

/**
* Calculates the average value for a given property. Uses the SQL function AVG. If no records can be found to perform the calculation on you can use the ifNull argument to decide what should be returned.
*
* [section: Model Class]
* [category: Statistics Functions]
*
* @property Name of the property to calculate the average for.
* @where See documentation for [doc:findAll].
* @include See documentation for [doc:findAll].
* @distinct When true, AVG will be performed only on each unique instance of a value, regardless of how many times the value occurs.
* @parameterize See documentation for [doc:findAll].
* @ifNull The value returned if no records are found. Common usage is to set this to 0 to make sure a numeric value is always returned instead of a blank string.
* @includeSoftDeletes See documentation for [doc:findAll].
* @group See documentation for [doc:findAll].
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
	if (StructKeyExists(arguments, "group")) {
		local.rv = $calculate(argumentCollection=arguments);
	} else {
		if (ListFindNoCase("cf_sql_integer,cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint", variables.wheels.class.properties[arguments.property].type)) {
			// this is an integer column so we get all the values from the database and do the calculation in ColdFusion since we can't run a query to get the average value without type casting it
			local.values = findAll(select=arguments.property, where=arguments.where, include=arguments.include, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes);
			local.values = ListToArray(Evaluate("ValueList(local.values.#arguments.property#)"));
			local.rv = arguments.ifNull;
			if (!ArrayIsEmpty(local.values)) {
				if (arguments.distinct) {
					local.tempValues = {};
					local.iEnd = ArrayLen(local.values);
					for (local.i = 1; local.i <= local.iEnd; local.i++) {
						StructInsert(local.tempValues, local.values[local.i], local.values[local.i], true);
					}
					local.values = ListToArray(StructKeyList(local.tempValues));
				}
				local.rv = ArrayAvg(local.values);
			}
		} else {
			// if the column's type is a float or similar we can run an AVG type query since it will always return a value of the same type as the column
			local.rv = $calculate(argumentCollection=arguments);

			// we convert the result to a string so that it is the same as what would happen if you calculate an average in ColdFusion code (like we do for integers in this function for example)
			local.rv = JavaCast("string", local.rv);
		}
	}
	return local.rv;
}

/**
* Returns the number of rows that match the arguments (or all rows if no arguments are passed in). Uses the SQL function COUNT. If no records can be found to perform the calculation on, 0 is returned.
*
* [section: Model Class]
* [category: Statistics Functions]
*
* @where This argument maps to the WHERE clause of the query. The following operators are supported: =, !=, <>, <, <=, >, >=, LIKE, NOT LIKE, IN, NOT IN, IS NULL, IS NOT NULL, AND, and OR (note that the key words need to be written in upper case). You can also use parentheses to group statements. You do not need to specify the table name(s); CFWheels will do that for you. Instead of using the where argument, you can create cleaner code by making use of a concept called Dynamic Finders.
* @include Associations that should be included in the query using INNER or LEFT OUTER joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. department,addresses,emails). You can build more complex include strings by using parentheses when the association is set on an included model, like album(artist(genre)), for example. These complex include strings only work when returnAs is set to query though.
* @reload Set to true to force CFWheels to query the database even though an identical query may have been run in the same request. (The default in CFWheels is to get the second query from the request-level cache.)
* @parameterize Set to true to use cfqueryparam on all columns, or pass in a list of property names to use cfqueryparam on those only.
* @includeSoftDeletes You can set this argument to true to include soft-deleted records in the results.
* @group Maps to the GROUP BY clause of the query. You do not need to specify the table name(s); CFWheels will do that for you.
*/
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
	if (Len(arguments.include)) {
		arguments.distinct = true;
	} else {
		arguments.distinct = false;
	}
	local.rv = $calculate(argumentCollection=arguments);
	if (!StructKeyExists(arguments, "group") && !IsNumeric(local.rv)) {
		local.rv = 0;
	}
	return local.rv;
}

/**
* Calculates the maximum value for a given property. Uses the SQL function MAX. If no records can be found to perform the calculation on you can use the ifNull argument to decide what should be returned.
*
* [section: Model Class]
* [category: Statistics Functions]
*
* @property Name of the property to get the highest value for (must be a property of a numeric data type).
* @where See documentation for [doc:findAll].
* @include See documentation for [doc:findAll].
* @parameterizeSee documentation for [doc:findAll].
* @ifNull See documentation for [doc:average].
* @includeSoftDeletes boolean false false See documentation for [doc:findAll].
* @group See documentation for [doc:findAll].
*/
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
	return $calculate(argumentCollection=arguments);
}

/**
* Calculates the minimum value for a given property. Uses the SQL function MIN. If no records can be found to perform the calculation on you can use the ifNull argument to decide what should be returned.
*
* [section: Model Class]
* [category: Statistics Functions]
*
* @property Name of the property to get the lowest value for (must be a property of a numeric data type).
* @where See documentation for [doc:findAll].
* @include See documentation for [doc:findAll].
* @parameterize See documentation for [doc:findAll].
* @ifNull See documentation for [doc:average].
* @includeSoftDeletes See documentation for [doc:findAll].
* @group See documentation for [doc:findAll].
*/
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
	return $calculate(argumentCollection=arguments);
}

/**
* Calculates the sum of values for a given property. Uses the SQL function SUM. If no records can be found to perform the calculation on you can use the ifNull argument to decide what should be returned.
*
* [section: Model Class]
* [category: Statistics Functions]
*
* @property Name of the property to get the sum for (must be a property of a numeric data type).
* @where This argument maps to the WHERE clause of the query. The following operators are supported: =, !=, <>, <, <=, >, >=, LIKE, NOT LIKE, IN, NOT IN, IS NULL, IS NOT NULL, AND, and OR (note that the key words need to be written in upper case). You can also use parentheses to group statements. You do not need to specify the table name(s); CFWheels will do that for you. Instead of using the where argument, you can create cleaner code by making use of a concept called Dynamic Finders.
* @include Associations that should be included in the query using INNER or LEFT OUTER joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. department,addresses,emails). You can build more complex include strings by using parentheses when the association is set on an included model, like album(artist(genre)), for example. These complex include strings only work when returnAs is set to query though.
* @distinct When true, SUM returns the sum of unique values only.
* @parameterize any false true Set to true to use cfqueryparam on all columns, or pass in a list of property names to use cfqueryparam on those only.
* @ifNull The value returned if no records are found. Common usage is to set this to 0 to make sure a numeric value is always returned instead of a blank string.
* @includeSoftDeletes You can set this argument to true to include soft-deleted records in the results.
* @group Maps to the GROUP BY clause of the query. You do not need to specify the table name(s); CFWheels will do that for you.
*/
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
	return $calculate(argumentCollection=arguments);
}

/**
* Internal Function
**/
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
	if (arguments.distinct) {
		arguments.select &= "DISTINCT ";
	}

	// create a list of columns for the `SELECT` clause either from regular properties on the model or calculated ones
	local.properties = "";
	local.iEnd = ListLen(arguments.property);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = Trim(ListGetAt(arguments.property, local.i));
		if (ListFindNoCase(variables.wheels.class.propertyList, local.item)) {
			local.properties = ListAppend(local.properties, tableName() & "." & variables.wheels.class.properties[local.item].column);
		} else if (ListFindNoCase(variables.wheels.class.calculatedPropertyList, local.item)) {
			local.properties = ListAppend(local.properties, variables.wheels.class.calculatedProperties[local.item].sql);
		}
	}
	arguments.select &= local.properties;

	// alias the result with `AS`, this means that Wheels will not try and change the string (which is why we have to add the table name above since it won't be done automatically)
	local.alias = LCase(arguments.type);
	local.alias = Replace(Replace(Replace(local.alias, "avg", "average"), "min", "minimum"), "max", "maximum");
	if (arguments.type != "count") {
		local.alias = arguments.property & local.alias;
	}
	arguments.select &= ") AS " & local.alias;

	if (StructKeyExists(arguments, "group")) {
		arguments.select = ListAppend(arguments.select, $createSQLFieldList(clause="select", list=arguments.group, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes, returnAs="query"));
	}

	// call `findAll` with `select`, `where`, `group`, `parameterize` and `include` but delete all other arguments
	StructDelete(arguments, "type");
	StructDelete(arguments, "property");
	StructDelete(arguments, "distinct");

	// since we don't return any records for calculation methods we want to skip the callbacks
	arguments.callbacks = false;

	local.rv = findAll(argumentCollection=arguments);
	if (!StructKeyExists(arguments, "group")) {
		// when not grouping by something we just return the value itself
		local.rv = local.rv[local.alias];
		if (!Len(local.rv) && Len(arguments.ifNull)) {
			local.rv = arguments.ifNull;
		}
	}
	return local.rv;
}

</cfscript>
