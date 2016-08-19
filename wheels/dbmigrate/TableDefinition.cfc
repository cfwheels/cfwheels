<cfcomponent extends="Base">

	<cffunction name="init" returntype="any" access="public">
		<cfargument name="adapter" type="any" required="yes" hint="database adapter">
		<cfargument name="name" type="string" required="yes" hint="table name in pluralized form">
		<cfargument name="force" type="boolean" required="no" default="true" hint="whether or not to drop table of same name before creating new one">
		<cfargument name="id" type="boolean" required="no" default="true" hint="if false, defines a table with no primary key">
		<cfargument name="primaryKey" type="string" required="no" default="id" hint="overrides default primary key">
		<cfscript>
			var loc = {};
			loc.args = "adapter,name,force";

			this.primaryKeys = ArrayNew(1);
			this.foreignKeys = ArrayNew(1);
			this.columns = ArrayNew(1);

			loc.iEnd = ListLen(loc.args);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				loc.argumentName = ListGetAt(loc.args,loc.i);
				if(StructKeyExists(arguments,loc.argumentName)) {
					this[loc.argumentName] = arguments[loc.argumentName];
				}
			}

			if(arguments.id && Len(arguments.primaryKey)) {
				this.primaryKey(name=arguments.primaryKey, autoIncrement=true);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>


	<cffunction name="primaryKey" returntype="any" access="public" hint="adds a primary key definition to the table. this method also allows for multiple primary keys.">
		<cfargument name="name" type="string" required="yes" hint="primary key column name">
		<cfargument name="type" type="string" required="false" default="integer" hint="type for the primary key column">
		<cfargument name="autoIncrement" type="boolean" required="no" default="false">
		<cfargument name="limit" type="numeric" required="no" hint="character or integer size">
		<cfargument name="precision" type="numeric" required="no" hint="number of digits the column can hold">
		<cfargument name="scale" type="numeric" required="no" hint="number of digits that can be placed to the right of the decimal point (must be less than or equal to precision)">
		<cfargument name="references" type="string" required="no" hint="table this primary key should reference as a foreign key">
		<cfargument name="onUpdate" type="string" required="false" default="" hint="how you want the constraint to act on update. possible values include `none`, `null`, or `cascade` which can also be set to `true`.">
		<cfargument name="onDelete" type="string" required="false" default="" hint="how you want the constraint to act on delete. possible values include `none`, `null`, or `cascade` which can also be set to `true`.">

		<cfscript>
			var loc = {};
			arguments.null = false;
			arguments.adapter = this.adapter;

			// don't allow multiple autoIncrement primarykeys
			if (ArrayLen(this.primaryKeys) && arguments.autoIncrement)
				$throw(message="You cannot have multiple auto increment primary keys.");

			loc.column = CreateObject("component", "ColumnDefinition").init(argumentCollection=arguments);
			ArrayAppend(this.primaryKeys, loc.column);

			if(StructKeyExists(arguments, "references"))
			{
				loc.referenceTable = pluralize(arguments.references);
				loc.foreignKey = CreateObject("component","ForeignKeyDefinition").init(adapter=this.adapter,table=this.name,referenceTable=loc.referenceTable,column=arguments.name,referenceColumn="id",onUpdate=arguments.onUpdate,onDelete=arguments.onDelete);
				ArrayAppend(this.foreignKeys,loc.foreignKey);
			}
    </cfscript>
		<cfreturn this>
    </cffunction>

	<cffunction name="column" returntype="any" access="public" hint="adds a column to table definition">
		<cfargument name="columnName" type="string" required="yes" hint="column name">
		<cfargument name="columnType" type="string" required="yes" hint="column type">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfargument name="limit" type="any" required="no" hint="character or integer size">
		<cfargument name="precision" type="numeric" required="no" hint="number of digits the column can hold">
		<cfargument name="scale" type="numeric" required="no" hint="number of digits that can be placed to the right of the decimal point (must be less than or equal to precision)">
		<cfscript>
			var loc = {};
			arguments.adapter = this.adapter;
			arguments.name = arguments.columnName;
			arguments.type = arguments.columnType;
			loc.column = CreateObject("component","ColumnDefinition").init(argumentCollection=arguments);
			ArrayAppend(this.columns,loc.column);
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="bigInteger" returntype="any" access="public" hint="adds integer columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="limit" type="numeric" required="no" hint="integer size">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "biginteger";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="binary" returntype="any" access="public" hint="adds binary columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "binary";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="boolean" returntype="any" access="public" hint="adds boolean columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "boolean";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="date" returntype="any" access="public" hint="adds date columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "date";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="datetime" returntype="any" access="public" hint="adds datetime columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "datetime";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="decimal" returntype="any" access="public" hint="adds decimal columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfargument name="precision" type="numeric" required="no" hint="number of digits the column can hold">
		<cfargument name="scale" type="numeric" required="no" hint="number of digits that can be placed to the right of the decimal point (must be less than or equal to precision)">
		<cfscript>
			var loc = {};
			arguments.columnType = "decimal";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="float" returntype="any" access="public" hint="adds float columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" default="" hint="default value">
		<cfargument name="null" type="boolean" required="no" default="true" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "float";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="integer" returntype="any" access="public" hint="adds integer columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="limit" type="numeric" required="no" hint="integer size">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "integer";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="string" returntype="any" access="public" hint="adds string columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="limit" type="any" required="no" hint="character limit">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "string";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="char" returntype="any" access="public" hint="adds char columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="limit" type="any" required="no" hint="character limit">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "char";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="text" returntype="any" access="public" hint="adds text columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "text";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="uniqueidentifier" returntype="any" access="public" hint="adds UUID columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value" default="newid()">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "uniqueidentifier";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="time" returntype="any" access="public" hint="adds time columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfscript>
			var loc = {};
			arguments.columnType = "time";
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="timestamp" returntype="any" access="public" hint="adds timestamp columns to table definition">
		<cfargument name="columnNames" type="string" required="yes" hint="one or more column names, comma delimited">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" hint="whether nulls are allowed">
		<cfargument name="columnType" type="string" required="false" default="datetime" />
		<cfscript>
			var loc = {};
			loc.iEnd = ListLen(arguments.columnNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				arguments.columnName = ListGetAt(arguments.columnNames,loc.i);
				column(argumentCollection=arguments);
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="timestamps" returntype="any" access="public" hint="adds CFWheels convention automatic timestamp and soft delete columns to table definition">
		<cfscript>
		timestamp(columnNames="createdat,updatedat,deletedat",null=true);
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="references" returntype="any" access="public" hint="adds integer reference columns to table definition and creates foreign key constraints">
		<cfargument name="referenceNames" type="string" required="yes" hint="one or more reference names (singular of referenced tables), comma delimited. eg. referenceNames=page will create a column pageId that references table:pages, column:id">
		<cfargument name="default" type="string" required="no" hint="default value">
		<cfargument name="null" type="boolean" required="no" default="false" hint="whether nulls are allowed">
		<cfargument name="polymorphic" type="boolean" required="no" default="false" hint="whether or not to create an Id/Type pair of columns for a polymorphic relationship">
		<cfargument name="foreignKey" type="boolean" required="no" default="true" hint="whether or not to create a foreign key constraint">
		<cfargument name="onUpdate" type="string" required="false" default="" hint="how you want the constraint to act on update. possible values include `none`, `null`, or `cascade` which can also be set to `true`.">
		<cfargument name="onDelete" type="string" required="false" default="" hint="how you want the constraint to act on delete. possible values include `none`, `null`, or `cascade` which can also be set to `true`.">
		<cfscript>
			var loc = {};
			loc.iEnd = ListLen(arguments.referenceNames);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				loc.referenceName = ListGetAt(arguments.referenceNames,loc.i);

				// get all possible arguments for the column
				loc.columnArgs = {};
				for (loc.arg in ListToArray("columnType,default,null,limit,precision,scale"))
					if (StructKeyExists(arguments, loc.arg))
						loc.columnArgs[loc.arg] = arguments[loc.arg];

				// default the column to an integer if not provided
				if (!StructKeyExists(loc.columnArgs, "columnType"))
					loc.columnArgs.columnType = "integer";

				column(columnName = loc.referenceName & "id", argumentCollection=loc.columnArgs);

				if(arguments.polymorphic)
					column(columnName=loc.referenceName & "type",columnType="string");

				if(arguments.foreignKey && !arguments.polymorphic) {
					loc.referenceTable = pluralize(loc.referenceName);
					loc.foreignKey = CreateObject("component","ForeignKeyDefinition").init(adapter=this.adapter,table=this.name,referenceTable=loc.referenceTable,column="#loc.referenceName#id",referenceColumn="id",onUpdate=arguments.onUpdate,onDelete=arguments.onDelete);
					ArrayAppend(this.foreignKeys,loc.foreignKey);
				}
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="create" returntype="void" access="public" hint="creates the table in the database">
		<cfscript>
			if(this.force) {
				$execute(this.adapter.dropTable(this.name));
				announce("Dropped table #LCase(this.name)#");
			}
			$execute(this.adapter.createTable(name=this.name, primaryKeys=this.primaryKeys, columns=this.columns, foreignKeys=this.foreignKeys));
			announce("Created table #LCase(this.name)#");
			loc.iEnd = ArrayLen(this.foreignKeys);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				announce("--> added foreign key #this.foreignKeys[loc.i].name#");
			}
		</cfscript>
	</cffunction>

	<cffunction name="change" returntype="void" access="public" hint="alters existing table in the database">
		<cfargument name="addColumns" type="boolean" required="false" default="false" hint="if true, attempt to add new columns, else check whether column exists to determine whether to add or update">
		<cfscript>
			var loc = {};
			loc.existingColumns = $getColumns(this.name);
			loc.iEnd = ArrayLen(this.columns);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				if(arguments.addColumns || !ListFindNoCase(loc.existingColumns,this.columns[loc.i].name)) {
					$execute(this.adapter.addColumnToTable(name=this.name,column=this.columns[loc.i]));
					announce("Added column #this.columns[loc.i].name# to table #this.name#");
				} else {
					$execute(this.adapter.changeColumnInTable(name=this.name,column=this.columns[loc.i]));
					announce("Changed column #this.columns[loc.i].name# in table #this.name#");
				}
			}
			loc.iEnd = ArrayLen(this.foreignKeys);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				$execute(this.adapter.addForeignKeyToTable(name=this.name,foreignKey=this.foreignKeys[loc.i]));
				announce("Added foreign key #this.foreignKeys[loc.i].name# to table #this.name#");
			}
		</cfscript>
	</cffunction>

</cfcomponent>