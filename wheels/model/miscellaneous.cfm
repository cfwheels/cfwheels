<cfscript>
	/*
	* PUBLIC MODEL INITIALIZATION METHODS
	*/

	public void function dataSource(
		required string datasource,
		string username="",
		string password=""
	) {
		variables.wheels.class.datasource = arguments.datasource;
		variables.wheels.class.username = arguments.username;
		variables.wheels.class.password = arguments.password;
	}

	public void function table(required any name) {
		variables.wheels.class.tableName = arguments.name;
	}

	public void function setTableNamePrefix(required string prefix) {
		variables.wheels.class.tableNamePrefix =  arguments.prefix;
	}

	public void function setPrimaryKey(required string property) {
		local.iEnd = ListLen(arguments.property);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.item = ListGetAt(arguments.property, local.i);
			if (!ListFindNoCase(variables.wheels.class.keys, local.item))
			{
				variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, local.item);
			}
		}
	}

	public void function setPrimaryKeys(required string property) {
		setPrimaryKey(argumentCollection=arguments);
	}

	/*
	* PUBLIC MODEL CLASS METHODS
	*/

	public boolean function exists(
		any key,
		string where,
		boolean reload,
		any parameterize,
		boolean includeSoftDeletes
	) {
		$args(name="exists", args=arguments);
		if (get("showErrorInformation") && StructKeyExists(arguments, "key") && StructKeyExists(arguments, "where"))
		{
				$throw(type="Wheels.IncorrectArguments", message="You cannot pass in both `key` and `where`.");
		}
		arguments.select = primaryKey();
		arguments.returnAs = "query";
		arguments.callbacks = false;
		if (StructKeyExists(arguments, "key"))
		{
			local.rv = findByKey(argumentCollection=arguments).recordCount;
		}
		else
		{
			local.rv = findOne(argumentCollection=arguments).recordCount;
		}
		return local.rv;
	}

	public string function columnNames() {
		return variables.wheels.class.columnList;
	}

	public string function primaryKey(numeric position=0) {
		if (arguments.position > 0)
		{
			local.rv = ListGetAt(variables.wheels.class.keys, arguments.position);
		}
		else
		{
			local.rv = variables.wheels.class.keys;
		}
		return local.rv;
	}

	public string function primaryKeys(numeric position=0) {
		return primaryKey(argumentCollection=arguments);
	}

	public string function tableName() {
		return variables.wheels.class.tableName;
	}

	public string function getTableNamePrefix() {
		return variables.wheels.class.tableNamePrefix;
	}

	public string function isClass() {
		return !isInstance(argumentCollection=arguments);
	}

	/*
	* PUBLIC MODEL OBJECT METHODS
	*/

	public boolean function isNew() {
		if (!StructKeyExists(variables, "$persistedProperties")){
			// no values have been saved to the database so this object is new
			local.rv = true;
		} else {
			local.rv = false;
		}
		return local.rv;
	}

	public boolean function compareTo(required component object) {
		return Compare(this.$objectId(), arguments.object.$objectId()) IS 0;
	}

	public boolean function isInstance() {
		return StructKeyExists(variables.wheels, "instance");
	}

	/*
	* PRIVATE METHODS
	*/

	public string function $objectId() {
		return variables.wheels.tickCountId;
	}

	public struct function $buildQueryParamValues(required string property) {
		local.rv = {};
		local.rv.value = this[arguments.property];
		local.rv.type = variables.wheels.class.properties[arguments.property].type;
		local.rv.dataType = variables.wheels.class.properties[arguments.property].dataType;
		local.rv.scale = variables.wheels.class.properties[arguments.property].scale;
		local.rv.null = (!Len(this[arguments.property]) && variables.wheels.class.properties[arguments.property].nullable);
		return local.rv;
	}

	public void function $keyLengthCheck(required any key) {
		// throw error if the number of keys passed in is not the same as the number of keys defined for the model
		if (ListLen(primaryKeys()) != ListLen(arguments.key))
		{
			$throw(type="Wheels.InvalidArgumentValue", message="The `key` argument contains an invalid value.", extendedInfo="The `key` argument contains a list, however this table doesn't have a composite key. A list of values is allowed for the `key` argument, but this only applies in the case when the table contains a composite key.");
		}
	}

	public void function $timestampProperty(required string property) {
		this[arguments.property] = Now();
	}
</cfscript>