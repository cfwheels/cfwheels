component extends="Base" {
	/*
	* @onUpdate.hint how you want the constraint to act on update. possible values include `none`, `null`, or `cascade` which can also be set to `true`.
	*/
	public ForeignKeyDefinition function init(
		required any adapter,
		required string table,
		required string referenceTable,
		required string column,
		required string referenceColumn,
		string onUpdate="",
		string onDelete=""
	){
		local.args = "adapter,table,referenceTable,column,referenceColumn,onUpdate,onDelete";
		local.iEnd = ListLen(local.args);
		for (local.i=1; local.i <= local.iEnd; local.i++) {
			local.argumentName = ListGetAt(local.args,local.i);
			if(StructKeyExists(arguments,local.argumentName)) {
				this[local.argumentName] = arguments[local.argumentName];
			}
		}
		this.name = "FK_#LCase(this.table)#_#LCase(this.referenceTable)#";
		return this;
	}

	public string function toSQL() {
		local.args = "name,table,referenceTable,column,referenceColumn,onUpdate,onDelete";
		local.iEnd = ListLen(local.args);
		local.adapterArgs = {};
		for (local.i=1; local.i <= local.iEnd; local.i++) {
			local.argumentName = ListGetAt(local.args, local.i);
			local.adapterArgs[local.argumentName] = this[local.argumentName];
		}
		return this.adapter.foreignKeySQL(argumentcollection=local.adapterArgs);
	}

	public string function toForeignKeySQL(){
		local.sql = "CONSTRAINT " & this.name;
		local.sql = addForeignKeyOptions(local.sql);
		return local.sql;
	}

	public string function addForeignKeyOptions(required string sql){
		var loc = {};
		loc.options = {};
		loc.optionalArguments = "referenceTable,referenceColumn,column";
		loc.iEnd = ListLen(loc.optionalArguments);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
			loc.argumentName = ListGetAt(loc.optionalArguments,loc.i);
			if(StructKeyExists(this,loc.argumentName)) {
				loc.options[loc.argumentName] = this[loc.argumentName];
			}
		}
		arguments.sql = this.adapter.addForeignKeyOptions(sql=arguments.sql,options=loc.options);
		return arguments.sql;
	}
}
