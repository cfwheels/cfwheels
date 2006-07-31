<cfcomponent displayname="Code Generator" hint="Generates model code">
	
	<cfset variables.generatedCode = arrayNew(1)>
	<cfset variables.model = "">
	
	<cffunction name="init" access="public" output="false" hint="Updates the model schema of the database if needed">
		<cfargument name="model" type="any" required="true" hint="The model that this code is generating for">
		
		<cfset var tableSchema = "">
		<cfset var insertData = "">
		<cfset var hashableData = "">
		<cfset var tableHash = "">
		<cfset var fileName = "">
		<cfset var fileHash = "">
		<cfset var theHash = "">
		<cfset var relationships = structNew()>
		<cfset var validations = structNew()>
		<cfset var finders = structNew()>
		<cfset var modelFile = "">
		<cfset var thisRelationship = "">
		<cfset var thisValidation = "">
		<cfset var initFind = structNew()>
		<cfset var finderFieldsStart = "">
		<cfset var finderFieldsEnd = "">
		<cfset var finderFields = "">
		
		<cfset variables.model = arguments.model>
		
		<cfif application.database.type IS "mysql5">
			<!--- For MySQL 5 get the database schema from the information_schema table (this probably won't be as clean for other databases) --->
			<cfquery name="tableSchema" datasource="#application.database.name#" username="#application.database.user#" password="#application.database.pass#">
				SELECT COLUMN_NAME as name,
					CASE
						WHEN COLUMN_KEY = 'PRI' THEN 'true'
						ELSE 'false'
					END AS primaryKey,
					CASE
						WHEN EXTRA = 'auto_increment' THEN 'true'
						ELSE 'false'
					END AS identity,
					CASE
						WHEN IS_NULLABLE = 'Yes' THEN 'true'
						ELSE 'false'
					END as nullable,
					DATA_TYPE AS dbDataType,
					CASE
						WHEN CHARACTER_MAXIMUM_LENGTH IS NULL THEN 0
						ELSE CHARACTER_MAXIMUM_LENGTH
					END AS length,
					COLUMN_DEFAULT as 'default'
				FROM information_schema.COLUMNS
				WHERE TABLE_SCHEMA = Database() AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#variables.model._tableName#" />
			</cfquery>
		<cfelseif application.database.type IS "sqlserver">
			<cfquery name="tableSchema" datasource="#application.database.name#" username="#application.database.user#" password="#application.database.pass#">
				SELECT INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME as name,
				CASE
					WHEN INFORMATION_SCHEMA.TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'Primary Key' THEN 'true'
					ELSE 'false'
				END AS primaryKey,
				COLUMNPROPERTY(OBJECT_ID(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME), INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME, 'IsIdentity') AS [identity],
				CASE
					WHEN INFORMATION_SCHEMA.COLUMNS.IS_NULLABLE = 'Yes' THEN 'true'
					ELSE 'false'
				END as nullable,
				INFORMATION_SCHEMA.COLUMNS.DATA_TYPE AS dbDataType,
				CASE
					WHEN INFORMATION_SCHEMA.COLUMNS.CHARACTER_MAXIMUM_LENGTH IS NULL THEN 0
					ELSE INFORMATION_SCHEMA.COLUMNS.CHARACTER_MAXIMUM_LENGTH
				END AS length,
				INFORMATION_SCHEMA.COLUMNS.COLUMN_DEFAULT as 'default'
				FROM INFORMATION_SCHEMA.COLUMNS LEFT OUTER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE ON INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = INFORMATION_SCHEMA.KEY_COLUMN_USAGE.COLUMN_NAME AND INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = INFORMATION_SCHEMA.KEY_COLUMN_USAGE.TABLE_NAME LEFT OUTER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS ON INFORMATION_SCHEMA.KEY_COLUMN_USAGE.CONSTRAINT_NAME = INFORMATION_SCHEMA.TABLE_CONSTRAINTS.CONSTRAINT_NAME AND INFORMATION_SCHEMA.KEY_COLUMN_USAGE.TABLE_NAME = INFORMATION_SCHEMA.TABLE_CONSTRAINTS.TABLE_NAME
				WHERE INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#variables.model._tableName#" />
			</cfquery>
		</cfif>
		
		<!--- Build a big list out of all the fields and properties in the table --->
		<cfloop query="tableSchema">
			<cfset insertData = name & "," & primaryKey & "," & identity & "," & nullable & "," & dbDataType & "," & length & "," & default>
			<cfset hashableData = listAppend(hashableData, insertData)>
		</cfloop>
		
		<!--- Create hash of the table data --->
		<cfset tableHash = hash(hashableData)>
		<!--- Get user's model file --->
		<cfset fileName = expandPath("#application.filePathTo.models#/#variables.model._modelName#.cfc")>
		<cffile action="read" file="#fileName#" variable="modelFile">
		<!--- Create hash of user's model file --->
		<cfset fileHash = hash(modelFile)>
		<!--- Create one mega hash --->
		<cfset theHash = tableHash & fileHash>

		<!--- If the schema has never been hashed, or the hashes don't match, generate new code --->
		<cfif NOT isDefined('application.wheels.models.#variables.model._modelName#') OR evaluate("application.wheels.models.#variables.model._modelName#.hash") IS NOT theHash>
			
			<!--- Convert the table schema into a new query object that the models can use --->
			<cfset tableSchema = organizeTableSchema(tableSchema)>
			
			<!--- Trim model file to just the important parts we care about --->
			<cfset initFind = reFindNoCase('<cffunction name="init".*?>(.*?)</cffunction>',modelFile,1,true)>
			
			<!--- Check to see if there's even an "init" function in the model. If not, skip this other stuff --->
			<cfif arrayLen(initFind.pos) GT 1>
				<cfset modelFile = mid(modelFile,initFind.pos[2],initFind.len[2])>
				
				<!--- Get the relationships, validations and dynamic finder fields defined by the user --->
				<cfset settings = readInit(modelFile, "setTableName", "name")>
				<cfset relationships = readInit(modelFile, "hasMany,belongsTo,hasOne,hasAndBelongsToMany", "name,modelName,tableName,foreignKey,joinTableName,associationForeignKey,order,conditions")>
				<cfset validations = readInit(modelFile, "validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf", "field,message,allowNil,in,with,exactly,maximum,minimum,within,scope,onlyInteger,on")>
				<cfif reFind("dynamicFinders.*=.*false.*>", modelFile) IS 0>
					<cfif findNoCase("dynamicFinders", modelFile) IS 0>
						<cfset finderFields = "">
					<cfelse>
						<cfset finderFieldsStart = findNoCase("<cfset dynamicFinders", modelFile)>
						<cfset finderFieldsEnd = findNoCase(">", modelFile, finderFieldsStart)>
						<cfset finderFields = mid(modelFile, finderFieldsStart+21, (finderFieldsEnd-finderFieldsStart)-21)>
						<cfset finderFields = replace(replace(replace(replace(finderFields, "true", "", "ALL"), """", "", "ALL"), "=", "", "ALL"), " ", "", "ALL")>
					</cfif>
					<cfset finders = getFinders(tableSchema, finderFields)>
				</cfif>

				<!--- Generate the code --->
				<cfset generateCode(settings, relationships, validations, finders)>
				
				<!--- Put all the code together and create the files --->
				<cfset assembleCode(tableSchema, variables.generatedCode)>
				
				<!--- Save the new mega hash --->
				<cfset "application.wheels.models.#variables.model._modelName#.hash" = theHash>
				<!--- Let the model() function know to reload the component to get the new definition --->
				<cfset variables.model._reload = true>
			</cfif>
		</cfif>

	</cffunction>
	
	
	<cffunction name="readInit" access="private" returntype="struct" output="false" hint="">
		<cfargument name="modelFile" type="string" required="true">
		<cfargument name="initNames" type="string" required="true">
		<cfargument name="initArguments" type="string" required="true">
		
		<cfset var startPos = 1>
		<cfset var found = true>
		<cfset var temp = "">
		<cfset var valArray = arrayNew(1)>
		<cfset var result = structNew()>
				
		<cfloop list="#initNames#" index="name">
			<cfset "result.#name#" = structNew()>
			<cfloop list="#initArguments#" index="arg">
				<cfset "result.#name#.#arg#s" = arrayNew(1)>
			</cfloop>
		</cfloop>

		<cfloop list="#initNames#" index="name">
			<cfset startPos = "1">
			<cfset found = true>
			<cfloop condition="found IS true">
				<cfset temp = reFindNoCase('<cfset #name#\((.*?)\)>', arguments.modelFile, startPos, true)>
				<cfif arrayLen(temp.pos) IS 2>
					<cfset startPos = temp.pos[2] + 1>
					<cfset temp = mid(arguments.modelFile, temp.pos[2], temp.len[2])>
					<cfloop list="#initArguments#" index="arg">
						<cfset temp = replaceNoCase(temp, ",#arg#=", "#chr(7)##arg#=", "all")>
						<cfset temp = replaceNoCase(temp, ", #arg#=", "#chr(7)##arg#=", "all")>
						<cfset temp = replaceNoCase(temp, "#arg#=""", "#arg#=", "all")>
						<cfset temp = replaceNoCase(temp, """#chr(7)##arg#", "#chr(7)##arg#", "all")>
						<cfset temp = replaceNoCase(temp, '","', '#chr(7)#', "one")>
						<cfset temp = replaceNoCase(temp, '", "', '#chr(7)#', "one")>
						<cfset temp = replaceNoCase(temp, '" ,"', '#chr(7)#', "one")>
						<cfset temp = replaceNoCase(temp, '" , "', '#chr(7)#', "one")>
					</cfloop>
					<cfif right(temp, 1) IS '"'>
						<cfset temp = left(temp, len(temp)- 1)>
					</cfif>
					<cfif left(temp, 1) IS '"'>
						<cfset temp = right(temp, len(temp)- 1)>
					</cfif>
					<cfif temp Contains "=">
						<!--- Named arguments passed in --->
						<cfloop list="#temp#" delimiters="#chr(7)#" index="arg">
							<cfset valArray = ListToArray(arg, "=")>
							<cfset Evaluate("arrayAppend(result[""#name#""].#valArray[1]#s, ""#valArray[2]#"")")>
						</cfloop>
						<cfloop list="#initArguments#" index="arg">
							<cfif reFindNoCase('#chr(7)##arg#=|^#arg#=', temp) IS 0>
								<cfset Evaluate("arrayAppend(result[""#name#""].#arg#s, """")")>
							</cfif>
						</cfloop>
					<cfelseif temp Contains chr(7)>
						<!--- Two unnamed passed in --->
						<cfset firstArg = #SpanExcluding(temp, chr(7))#>
						<cfset secondArg = #Replace(Replace(temp, (firstArg&chr(7)), ""), chr(7), ",", "ALL")#>
						<cfset Evaluate("arrayAppend(result[""#name#""].#listGetAt(initArguments, 1)#s, ""#firstArg#"")")>
						<cfset Evaluate("arrayAppend(result[""#name#""].#listGetAt(initArguments, 2)#s, ""#secondArg#"")")>
						<cfloop list="#initArguments#" index="arg">
							<cfif arg IS NOT listGetAt(initArguments, 1) AND arg IS NOT listGetAt(initArguments, 2)>
								<cfset Evaluate("arrayAppend(result[""#name#""].#arg#s, """")")>
							</cfif>
						</cfloop>
					<cfelse>
						<!--- One unnamed passed in --->
						<cfset Evaluate("arrayAppend(result[""#name#""].#listGetAt(initArguments, 1)#s, ""#temp#"")")>					
						<cfloop list="#initArguments#" index="arg">
							<cfif arg IS NOT listGetAt(initArguments, 1)>
								<cfset Evaluate("arrayAppend(result[""#name#""].#arg#s, """")")>
							</cfif>
						</cfloop>
					</cfif>
				<cfelse>
					<cfset found = false>
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn result>

	</cffunction>

	
	<cffunction name="getFinders" access="private" returntype="struct" output="false" hint="">
		<cfargument name="tableSchema" type="query" required="true" hint="Table layout" />
		<cfargument name="fields" type="string" required="true" hint="Fields to create finders for" />

		<cfset var finders = structNew()>
		<cfset var outerNameOrig = "">
		<cfset var outerName = "">
		<cfset var innerNameOrig = "">
		<cfset var innerName = "">
		<cfset var temp = "">

		<cfloop query="tableSchema">
			<cfset outerNameOrig = name>
			<cfset outerName = "">			
			<cfloop list="#name#" delimiters="_" index="i">
				<cfset outerName = outerName & uCase(left(i,1)) & lCase(right(i,len(i)-1))>			
			</cfloop>			
			<cfset temp = arrayNew(1)>
			<cfset temp[1] = outerNameOrig>
			<cfif arguments.fields IS "" OR listFindNoCase(arguments.fields, outerNameOrig) IS NOT 0>
				<cfset "finders.findAllBy#outerName#.fields" = temp>
				<cfset "finders.findOneBy#outerName#.fields" = temp>
			</cfif>
			<cfloop query="tableSchema">
				<cfset innerNameOrig = name>
				<cfset innerName = "">			
				<cfloop list="#name#" delimiters="_" index="j">
					<cfset innerName = innerName & uCase(left(j,1)) & lCase(right(j,len(j)-1))>			
				</cfloop>			
				<cfset temp[2] = innerNameOrig>
				<cfif innerName IS NOT outerName AND Asc(Left(outerName, 1)) LT Asc(Left(innerName, 1))>
					<cfif arguments.fields IS "" OR (listFindNoCase(arguments.fields, outerNameOrig) IS NOT 0 AND listFindNoCase(arguments.fields, innerNameOrig) IS NOT 0)>
						<cfset "finders.findAllBy#outerName#And#innerName#.fields" = temp>
						<cfset "finders.findOneBy#outerName#And#innerName#.fields" = temp>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn finders>
	
	</cffunction>


	<cffunction name="generateCode" access="private" returntype="void" output="false" hint="Calls all of the proper methods to generate the code for the model">
		<cfargument name="settings" type="struct" required="true" hint="" />
		<cfargument name="relationships" type="struct" required="true" hint="" />
		<cfargument name="validations" type="struct" required="true" hint="" />
		<cfargument name="finders" type="struct" required="true" hint="" />
		
		<cfset var valMethod = "">

		<!--- For each setting run the appropriate code generator method --->
		<cfloop collection="#arguments.settings#" item="key">
			<cfset thisSetting = arguments.settings[key]>
			<cfif NOT arrayIsEmpty(thisSetting.names)>
				<cfloop from="1" to="#arrayLen(thisSetting.names)#" index="i">
					<cfset valMethod = "#key#(">
					<cfloop list="#arrayToList(structKeyArray(thisSetting))#" index="j">
						<cfif #evaluate("thisSetting.#j#[#i#]")# IS NOT "">
							<cfif isNumeric(thisSetting[j][i])>
								<cfset valMethod = valMethod & "#left(j, len(j)-1)#=#thisSetting[j][i]#,">
							<cfelse>
								<cfset valMethod = valMethod & "#left(j, len(j)-1)#=""#thisSetting[j][i]#"",">
							</cfif>
						</cfif>
					</cfloop>
					<cfif right(valMethod, 1) IS ",">				
						<cfset valMethod = left(valMethod, Len(valMethod)-1)>
					</cfif>
					<cfset valMethod = valMethod & ")">
					<cfset evaluate(valMethod)>
				</cfloop>
			</cfif>
		</cfloop>

		<!--- For each relationship run the appropriate code generator method --->
		<cfloop collection="#arguments.relationships#" item="key">
			<cfset thisRelationship = arguments.relationships[key]>
			<cfif NOT arrayIsEmpty(thisRelationship.names)>
				<cfloop from="1" to="#arrayLen(thisRelationship.names)#" index="i">
					<cfset valMethod = "#key#(">
					<cfloop list="#arrayToList(structKeyArray(thisRelationship))#" index="j">
						<cfif #evaluate("thisRelationship.#j#[#i#]")# IS NOT "">
							<cfif isNumeric(thisRelationship[j][i])>
								<cfset valMethod = valMethod & "#left(j, len(j)-1)#=#thisRelationship[j][i]#,">
							<cfelse>
								<cfset valMethod = valMethod & "#left(j, len(j)-1)#=""#thisRelationship[j][i]#"",">
							</cfif>
						</cfif>
					</cfloop>
					<cfif right(valMethod, 1) IS ",">				
						<cfset valMethod = left(valMethod, Len(valMethod)-1)>
					</cfif>
					<cfset valMethod = valMethod & ")">
					<cfset evaluate(valMethod)>
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- For each validation run the appropriate code generator method --->
		<cfloop collection="#arguments.validations#" item="key">
			<cfset thisValidation = arguments.validations[key]>
			<cfif NOT arrayIsEmpty(thisValidation.fields)>
				<cfloop from="1" to="#arrayLen(thisValidation.fields)#" index="i">
					<cfset valMethod = "#key#(">
					<cfloop list="#arrayToList(structKeyArray(thisValidation))#" index="j">
						<cfif #evaluate("thisValidation.#j#[#i#]")# IS NOT "">
							<cfif isNumeric(thisValidation[j][i])>
								<cfset valMethod = valMethod & "#left(j, len(j)-1)#=#thisValidation[j][i]#,">
							<cfelse>
								<cfset valMethod = valMethod & "#left(j, len(j)-1)#=""#thisValidation[j][i]#"",">
							</cfif>
						</cfif>
					</cfloop>
					<cfif right(valMethod, 1) IS ",">				
						<cfset valMethod = left(valMethod, Len(valMethod)-1)>
					</cfif>
					<cfset valMethod = valMethod & ")">
					<cfset evaluate(valMethod)>
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- For each finder run the code generator method --->
		<cfloop collection="#arguments.finders#" item="key">
			<cfset createFinder(name=key, fields=arguments.finders[key].fields)>
		</cfloop>
		
	</cffunction>
	
	
	<cffunction name="assembleCode" access="private" returntype="void" output="false" hint="Assembles all of the code for the model">
		<cfargument name="tableSchema" type="query" required="true" hint="Table layout" />
		<cfargument name="generatedCode" type="array" required="true" hint="The code" />
		
		<cfset var settingCode = "">
		<cfset var relationshipCode = "">
		<cfset var validationCode = "">
		<cfset var validationOnCreateCode = "">
		<cfset var validationOnUpdateCode = "">
		<cfset var finderCode = "">
		<cfset var foreignKey = "">
		
		<!--- Split up the code into table relationships and the different types of validation --->
		<cfloop from="1" to="#arrayLen(arguments.generatedCode)#" index="i">
			<cfif arguments.generatedCode[i].type IS "setting">
				<cfset settingCode = settingCode & arguments.generatedCode[i].code>
			<cfelseif arguments.generatedCode[i].type IS "relationship">
				<cfset relationshipCode = relationshipCode & arguments.generatedCode[i].code>
			<cfelseif arguments.generatedCode[i].type IS "validation">
				<cfset validationCode = validationCode & arguments.generatedCode[i].code>
			<cfelseif arguments.generatedCode[i].type IS "validationOnCreate">
				<cfset validationOnCreateCode = validationOnCreateCode & arguments.generatedCode[i].code>
			<cfelseif arguments.generatedCode[i].type IS "validationOnUpdate">
				<cfset validationOnUpdateCode = validationOnUpdateCode & arguments.generatedCode[i].code>
			<cfelseif arguments.generatedCode[i].type IS "finder">
				<cfset finderCode = finderCode & arguments.generatedCode[i].code>
			</cfif>
		</cfloop>
		
		<cfinclude template="#application.pathTo.includes#/files.cfm">

		<!--- Create the "dao" model component for single-record returns (filename similar to _modelname.cfc) --->
		<cfoutput>
			<cfsavecontent variable="code">
<cgcomponent displayname="_#variables.model._modelName#" extends="cfwheels.models._model" hint="Creates a 'dao' type of model for single-record models">
	<!-- This model is auto-generated by Wheels, you should not edit it manually -->
	
	<cgset this.fields = structNew()>
				<cfloop query="arguments.tableSchema">
	<cgset this.#name# = #default#>
	<cgset variables.fields.#name# = structNew()>
	<cgset variables.fields.#name#.primaryKey = #primaryKey#>
	<cgset variables.fields.#name#.identity = #identity#>
	<cgset variables.fields.#name#.nullable = #nullable#>
	<cgset variables.fields.#name#.dbDataType = "#dbDataType#">
	<cgset variables.fields.#name#.cfDataType = "#cfDataType#">
	<cgset variables.fields.#name#.cfSqlType = "#cfSqlType#">
	<cgset variables.fields.#name#.length = #length#>
	<cgset variables.fields.#name#.default = #default#>
				</cfloop>
				
	<cgset this.columnList = "#application.core.queryColumnValuesToList(arguments.tableSchema,"name")#">

				<cfif settingCode DOES NOT CONTAIN "this._tableName">
	<cgset this._tableName = "#application.core.tableNameFromModel(variables.model._modelName)#">
				</cfif>
				<cfloop list="#settingCode#" index="section" delimiters="#chr(7)#">
	#section#
				</cfloop>
				
				<cfloop list="#relationshipCode#" index="section" delimiters="#chr(7)#">
	#section#
				</cfloop>

				<cfloop list="#finderCode#" index="section" delimiters="#chr(7)#">
	#section#
				</cfloop>
							
	<cgfunction name="validate" access="public" output="false" returntype="void" hint="Validates the model against some rules">
		<cgset var message = "">
				<cfloop list="#validationCode#" index="section" delimiters="#chr(7)#">
		#section#
				</cfloop>
	</cgfunction>

	<cgfunction name="validateOnCreate" access="public" output="false" returntype="void" hint="Validates the model against some rules, only for new records">
		<cgset var message = "">
				<cfloop list="#validationOnCreateCode#" index="section" delimiters="#chr(7)#">
		#section#
				</cfloop>
	</cgfunction>

	<cgfunction name="validateOnUpdate" access="public" output="false" returntype="void" hint="Validates the model against some rules, only for existing records">
		<cgset var message = "">
				<cfloop list="#validationOnUpdateCode#" index="section" delimiters="#chr(7)#">
		#section#
				</cfloop>
	</cgfunction>
	
</cgcomponent>
			</cfsavecontent>
		</cfoutput>
		<!--- Set the new filename and write it --->
		<cfset fileDir = expandPath(application.filePathTo.generatedModels)>
		<cfset fileName = "_#variables.model._modelName#.cfc">
		<cfset saveFile(fileDir,fileName,cleanup(code))>

	
	</cffunction>
	
	
	<cffunction name="organizeTableSchema" access="private" output="false" hint="Takes a table schema and reorganizes it, adding some values">
		<cfargument name="tableSchema" type="query" required="true" hint="The table schema to reorganize">
		
		<cfset var newQuery = queryNew("name,primaryKey,identity,nullable,dbDataType,cfDataType,cfSqlType,length,default")>
		
		<cfloop query="arguments.tableSchema">
			<cfset queryAddRow(newQuery)>
			<cfset querySetCell(newQuery,"name",lCase(name))>
			<cfset querySetCell(newQuery,"primaryKey",primaryKey)>
			<cfset querySetCell(newQuery,"identity",identity)>
			<cfset querySetCell(newQuery,"nullable",nullable)>
			<cfset querySetCell(newQuery,"dbDataType",dbDataType)>
			<cfset querySetCell(newQuery,"cfDataType",getCfDataType(dbDataType))>
			<cfset querySetCell(newQuery,"cfSqlType",getCfSqlType(dbDataType))>
			<cfset querySetCell(newQuery,"length",length)>
			<cfset querySetCell(newQuery,"default",getDefault(default, getCfDataType(dbDataType), nullable))>
		</cfloop>
		
		<cfreturn newQuery>
	</cffunction>
	
	
	<!--- Borrowed from Doug Hughes's Reactor --->
	<cffunction name="getDefault" access="private" hint="I get a default value for a cf datatype." output="false" returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." required="yes" type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="string" />
		<cfargument name="nullable" hint="I indicate if the column is nullable." required="yes" type="boolean" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="numeric">
				<cfif IsNumeric(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.nullable>
					<cfreturn """"""/>
				<cfelse>
					<cfreturn 0 />
				</cfif>
			</cfcase>
			<cfcase value="binary">
				<cfreturn """""" />
			</cfcase>
			<cfcase value="boolean">
				<cfif IsBoolean(arguments.sqlDefaultValue)>
					<cfreturn Iif(arguments.sqlDefaultValue, DE(true), DE(false)) />
				<cfelse>
					<cfreturn false />
				</cfif>
			</cfcase>
			<cfcase value="string">
				<!--- insure that the first and last characters are "'" --->
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<!--- mssql functions must be constants.  for this reason I can convert anything quoted in single quotes safely to a string --->
					<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, "''", "'", "All") />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, """", """""", "All") />
					<cfreturn arguments.sqlDefaultValue />
				<cfelse>
					<cfreturn """""" />
				</cfif>
			</cfcase>
			<cfcase value="date">
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<cfreturn Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
				<cfelseif arguments.sqlDefaultValue IS "0000-00-00 00:00:00">
					<!--- <cfset returnValue = dateFormat(now(), 'yyyy-mm-dd') & " " & timeFormat(now(), 'HH:mm:ss')> --->
					<cfreturn """""" />
				<cfelse>
					<cfreturn """""" />
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfreturn """""" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	
	<!--- Borrowed from Doug Hughes's Reactor --->
	<cffunction name="getCfSqlType" access="private" hint="I translate the MySQL data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bit,bool,boolean">
				<cfreturn "cf_sql_bit" />
			</cfcase>
			<cfcase value="tinyint">
				<cfreturn "cf_sql_tinyint" />
			</cfcase>
			<cfcase value="smallint,year">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="mediumint,int,integer">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="bigint">
				<cfreturn "cf_sql_bigint" />
			</cfcase>
			<cfcase value="float,real">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="double,double percision">
				<cfreturn "cf_sql_double" />
			</cfcase>
			<cfcase value="decimal,dec,money,smallmoney">
				<cfreturn "cf_sql_double" />
			</cfcase>
			<cfcase value="date">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="datetime,smalldatetime">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>			
			<cfcase value="char,nchar,uniqueidentifier">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="varchar,nvarchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="tinytext,text,mediumtext,longtext,ntext">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<cfcase value="tinyblob,blob,mediumblob,longblob">
				<cfreturn "cf_sql_blob" />
			</cfcase>
			<cfcase value="binary,image">
				<cfreturn "cf_sql_binary" />
			</cfcase>
		</cfswitch>
	</cffunction>


	<!--- Borrowed from Doug Hughes's Reactor --->
	<cffunction name="getCfDataType" access="private" hint="I translate the MySQL data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bit,bool,boolean">
				<cfreturn "boolean" />
			</cfcase>
			<cfcase value="tinyint,smallint,mediumint,int,integer,bigint,float,double,double percision,decimal,dec,year,money,smallmoney,real">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="date,datetime,timestamp,smalldatetime">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="time,enum,set">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="char,varchar,tinytext,text,mediumtext,longtext,nvarchar,nchar,ntext,uniqueidentifier">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="binary,varbinary,tinyblob,blob,mediumblob,longblob,image">
				<cfreturn "binary" />
			</cfcase>			
		</cfswitch>
	</cffunction>
	
	
	<cffunction name="codeCollector" access="private" output="true" hint="Populates a struct full of generated code to save">
		<cfargument name="type" type="string" required="true" hint="The type of code this is (setting|relationship|validation)">
		<cfargument name="code" type="string" required="true" hint="The code to save">
		
		<cfset var thisCode = structNew()>
		
		<cfset thisCode.type = arguments.type>
		<cfset thisCode.code = arguments.code>
 		<cfset arrayAppend(variables.generatedCode, structCopy(thisCode))>
		
	</cffunction>
	
	
	<!------------------------------------------------>
	<!----- Code generator methods ------------------->
	<!------------------------------------------------>

	<cffunction name="setTableName" access="private" output="false" hint="Outputs some generated code for settings">
		<cfargument name="name" type="string" required="yes">

		<cfset var output = "">

		<cfsavecontent variable="output"><cfoutput>

		<cgset this._tableName = "#arguments.name#">

	#chr(7)#

		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("setting",output)>

	</cffunction>
	
	<cffunction name="hasMany" access="private" output="false" hint="Outputs some generated code for hasMany relationships">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="modelName" type="string" required="no" default="#application.core.singularize(arguments.name)#">
		<cfargument name="foreignKey" type="string" required="no" default="#variables.model._modelName#_id">
		<cfargument name="order" type="string" required="no" default="">
		<cfargument name="conditions" type="string" required="no" default="">

		<cfset var output = "">

		<cfsavecontent variable="output"><cfoutput>
			
	<cgset this._#arguments.name# = "">
			
	<cgfunction name="#arguments.name#" access="public" returntype="any">
		<cgargument name="forceReload" type="boolean" required="no" default="false">
		<cgif NOT isObject(this._#arguments.name#) OR arguments.forceReload>
			<cgset this._#arguments.name# = application.core.model("#arguments.modelName#").findAll(where="(#arguments.foreignKey#=##this.id##)<cfif arguments.conditions IS NOT ""> AND (#arguments.conditions#)</cfif>"<cfif arguments.order IS NOT "">, order="#arguments.order#"</cfif>)>
		</cgif>
		<cgreturn this._#arguments.name#>
	</cgfunction>

	<cgfunction name="set#arguments.name#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset var objArray = arrayNew(1)>
		<cgset clear#arguments.name#()>
		<cgif isArray(arguments.object)>
			<cgset objArray = arguments.object>		
		<cgelse>
			<cgset arrayAppend(objArray, arguments.object)>
		</cgif>
		<cgloop from="1" to="##arrayLen(objArray)##" index="i">
			<cgset objArray[i].updateAttribute("#arguments.foreignKey#", this.id)>
		</cgloop>	
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="add#application.core.singularize(arguments.name)#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset var objArray = arrayNew(1)>
		<cgif isArray(arguments.object)>
			<cgset objArray = arguments.object>		
		<cgelse>
			<cgset arrayAppend(objArray, arguments.object)>
		</cgif>
		<cgloop from="1" to="##arrayLen(objArray)##" index="i">
			<cgset objArray[i].updateAttribute("#arguments.foreignKey#", this.id)>
		</cgloop>	
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="delete#application.core.singularize(arguments.name)#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset var objArray = arrayNew(1)>
		<cgif isArray(arguments.object)>
			<cgset objArray = arguments.object>		
		<cgelse>
			<cgset arrayAppend(objArray, arguments.object)>
		</cgif>
		<cgloop from="1" to="##arrayLen(objArray)##" index="i">
			<cgset objArray[i].updateAttribute("#arguments.foreignKey#", "null")>
		</cgloop>	
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="clear#arguments.name#" access="public" returntype="any">
		<cgset application.core.model("#arguments.modelName#").updateAll(updates="#arguments.foreignKey# = NULL", conditions="#arguments.foreignKey# = ##this.id##")>
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="has#arguments.name#" access="public" returntype="boolean">
		<cgif #application.core.singularize(arguments.name)#Count() IS 0>
			<cgreturn true>
		<cgelse>
			<cgreturn false>
		</cgif>
	</cgfunction>

	<cgfunction name="#application.core.singularize(arguments.name)#Count" access="public" returntype="numeric">
		<cgreturn application.core.model("#arguments.modelName#").count(where="#arguments.foreignKey# = ##this.id##")>
	</cgfunction>

	<cgfunction name="find#application.core.singularize(arguments.name)#ByID" access="public" returntype="any">
		<cgargument name="id" required="yes" type="numeric">
		<cgreturn application.core.model("#arguments.modelName#").findOne(where="#arguments.foreignKey# = ##this.id## AND id=##arguments.id##")>
	</cgfunction>

	<cgfunction name="find#application.core.singularize(arguments.name)#" access="public" returntype="any">
		<cgset var AddToWhere = "#arguments.foreignKey# = ##this.id##">
		<cgif structKeyExists(arguments, "where")>
			<cgset arguments.where = AddToWhere & " AND " & arguments.where>
		<cgelse>
			<cgset arguments.where = AddToWhere>
		</cgif>
		<cgreturn application.core.model("#arguments.modelName#").findOne(argumentCollection=arguments)>
	</cgfunction>

	<cgfunction name="find#arguments.name#" access="public" returntype="any">
		<cgset var AddToWhere = "#arguments.foreignKey# = ##this.id##">
		<cgif structKeyExists(arguments, "where")>
			<cgset arguments.where = AddToWhere & " AND " & arguments.where>
		<cgelse>
			<cgset arguments.where = AddToWhere>
		</cgif>
		<cgreturn application.core.model("#arguments.modelName#").findAll(argumentCollection=arguments)>
	</cgfunction>

	<cgfunction name="build#application.core.singularize(arguments.name)#" access="public" returntype="any">
		<cgset var newArgs = structNew()>
		<cgloop collection="##arguments##" item="key">
			<cgif isStruct(arguments[key])>
				<cgset newArgs.attributes = structCopy(arguments[key])>
			<cgelse>
				<cgset newArgs[key] = arguments[key]>			
			</cgif>
		</cgloop>
		<cgset newArgs["#arguments.foreignKey#"] = this.id>
		<cgreturn application.core.model("#arguments.modelName#").new(argumentCollection=newArgs)>
	</cgfunction>

	<cgfunction name="create#application.core.singularize(arguments.name)#" access="public" returntype="any">
		<cgset var newArgs = structNew()>
		<cgloop collection="##arguments##" item="key">
			<cgif isStruct(arguments[key])>
				<cgset newArgs.attributes = structCopy(arguments[key])>
			<cgelse>
				<cgset newArgs[key] = arguments[key]>			
			</cgif>
		</cgloop>
		<cgset newArgs["#arguments.foreignKey#"] = this.id>
		<cgreturn application.core.model("#arguments.modelName#").create(argumentCollection=newArgs)>
	</cgfunction>

	<cgfunction name="#arguments.name#For" access="public" returntype="any">
		<cgargument name="foreignKey" required="yes" type="numeric">
		
		<cgreturn application.core.model("#arguments.modelName#").findAll(where="#arguments.foreignKey#=##arguments.foreignKey##")>
	</cgfunction>

	#chr(7)#

		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("relationship",output)>

	</cffunction>
	
	
	<cffunction name="belongsTo" access="private" output="false" hint="Outputs some generated code for belongsTo relationships">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="modelName" type="string" required="no" default="#arguments.name#">
		<cfargument name="foreignKey" type="string" required="no" default="#arguments.modelName#_id">

		<cfset var output = "">

		<cfsavecontent variable="output"><cfoutput>

	<cgset this._#arguments.name# = "">
			
	<cgfunction name="#arguments.name#" access="public" returntype="any">
		<cgargument name="forceReload" type="boolean" required="no" default="false">
		<cgif NOT isObject(this._#arguments.name#) OR arguments.forceReload>
			<cgset this._#arguments.name# = application.core.model("#arguments.modelName#").findByID(this.#arguments.foreignKey#)>
		</cgif>
		<cgreturn this._#arguments.name#>
	</cgfunction>

	<cgfunction name="set#arguments.name#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset updateAttribute("#arguments.foreignKey#", arguments.object.id)>
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="has#arguments.name#" access="public" returntype="boolean">
		<cgif application.core.model("#arguments.modelName#").count(where="id = ##this.#arguments.foreignKey###") IS NOT 0>
			<cgreturn true>
		<cgelse>
			<cgreturn false>
		</cgif>
	</cgfunction>

	<cgfunction name="build#arguments.name#" access="public" returntype="any">
		<cgset var newObject = "">
		<cgset newObject = application.core.model("#arguments.modelName#").new(argumentCollection=arguments)>
		<cgset this.#arguments.foreignKey# = newObject.id>
		<cgreturn newObject>
	</cgfunction>

	<cgfunction name="create#arguments.name#" access="public" returntype="any">
		<cgset var newObject = "">
		<cgset newObject = application.core.model("#arguments.modelName#").create(argumentCollection=arguments)>
		<cgset this.#arguments.foreignKey# = newObject.id>
		<cgreturn newObject>
	</cgfunction>

	<cgfunction name="#arguments.name#For" access="public" returntype="any">
		<cgargument name="foreignKey" required="yes" type="numeric">

		<cgquery name="get_foreign_key" dbtype="query">
			SELECT	#arguments.foreignKey#
			FROM	this.query
			WHERE	id = ##arguments.foreignKey##
		</cgquery>
		
		<cgreturn application.core.model("#arguments.modelName#").findByID(##get_foreign_key.#foreignKey###)>
	</cgfunction>

	#chr(7)#

		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("relationship",output)>
		
	</cffunction>
	
	
	<cffunction name="hasAndBelongsToMany" access="private" output="false" hint="Outputs some generated code for hasAndBelongsToMany relationships">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="modelName" type="string" required="no" default="#application.core.singularize(arguments.name)#">
		<cfargument name="foreignKey" type="string" required="no" default="#variables.model._modelName#_id">
		<cfargument name="associationForeignKey" type="string" required="no" default="#arguments.modelName#_id">
		<cfargument name="joinTable" type="string" required="no" default="#application.core.joinTableName(variables.model._tableName, arguments.name)#">
		<cfargument name="order" type="string" required="no" default="">

		<cfset var output = "">

		<cfsavecontent variable="output"><cfoutput>

	<cgset this._#arguments.name# = "">
			
	<cgfunction name="#arguments.name#" access="public" returntype="any">
		<cgargument name="forceReload" type="boolean" required="no" default="false">
		<cgif NOT isObject(this._#arguments.name#) OR arguments.forceReload>
			<cgset this._#arguments.name# = application.core.model("#arguments.modelName#").findAll(where="#arguments.joinTable#.#arguments.foreignKey# = ##this.id##", joins="INNER JOIN #arguments.joinTable# ON #arguments.name#.id = #arguments.joinTable#.#arguments.associationForeignKey#"<cfif arguments.order IS NOT "">, order="#arguments.order#"</cfif>)>
		</cgif>
		<cgreturn this._#arguments.name#>
	</cgfunction>

	<cgfunction name="set#arguments.name#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset var objArray = arrayNew(1)>
		<cgset clear#arguments.name#()>
		<cgif isArray(arguments.object)>
			<cgset objArray = arguments.object>		
		<cgelse>
			<cgset arrayAppend(objArray, arguments.object)>
		</cgif>
		<cgloop from="1" to="##arrayLen(objArray)##" index="i">
			<cgset executeSQL("INSERT INTO #arguments.joinTable# (#arguments.foreignKey#, #arguments.associationForeignKey#) VALUES (##this.id##, ##objArray[i].id##)")>
		</cgloop>	
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="add#application.core.singularize(arguments.modelName)#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset var objArray = arrayNew(1)>
		<cgif isArray(arguments.object)>
			<cgset objArray = arguments.object>		
		<cgelse>
			<cgset arrayAppend(objArray, arguments.object)>
		</cgif>
		<cgloop from="1" to="##arrayLen(objArray)##" index="i">
			<cgset executeSQL("INSERT INTO #arguments.joinTable# (#arguments.foreignKey#, #arguments.associationForeignKey#) VALUES (##this.id##, ##objArray[i].id##)")>
		</cgloop>	
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="delete#application.core.singularize(arguments.modelName)#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset var objArray = arrayNew(1)>
		<cgif isArray(arguments.object)>
			<cgset objArray = arguments.object>		
		<cgelse>
			<cgset arrayAppend(objArray, arguments.object)>
		</cgif>
		<cgloop from="1" to="##arrayLen(objArray)##" index="i">
			<cgset executeSQL("DELETE FROM #arguments.joinTable# WHERE #arguments.associationForeignKey# = ##objArray[i].id##")>
		</cgloop>	
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="clear#arguments.name#" access="public" returntype="any">
			<cgset executeSQL("DELETE FROM #arguments.joinTable# WHERE #arguments.foreignKey# = ##this.id##")>
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="has#arguments.name#" access="public" returntype="boolean">
		<cgif #application.core.singularize(arguments.modelName)#Count() IS 0>
			<cgreturn true>
		<cgelse>
			<cgreturn false>
		</cgif>
	</cgfunction>

	<cgfunction name="#application.core.singularize(arguments.modelName)#Count" access="public" returntype="numeric">
		<cgreturn countBySQL("SELECT COUNT(*) FROM #arguments.joinTable# WHERE #arguments.foreignKey# = ##this.id##")>
	</cgfunction>

	<cgfunction name="find#application.core.singularize(arguments.name)#ByID" access="public" returntype="any">
		<cgargument name="id" required="yes" type="numeric">
		<cgreturn application.core.model("#arguments.modelName#").findOne(where="#arguments.joinTable#.#arguments.foreignKey# = ##this.id## AND #arguments.joinTable#.#arguments.associationForeignKey#=##arguments.id##", joins="INNER JOIN #arguments.joinTable# ON #arguments.name#.id = #arguments.joinTable#.#arguments.associationForeignKey#")>
	</cgfunction>

	<cgfunction name="#arguments.name#For" access="public" returntype="any">
		<cgargument name="foreignKey" required="yes" type="numeric">
		<cgreturn application.core.model("#arguments.modelName#").findAll(where="#arguments.joinTable#.#arguments.foreignKey# = ##arguments.foreignKey##", joins="INNER JOIN #arguments.joinTable# ON #arguments.name#.id = #arguments.joinTable#.#arguments.associationForeignKey#"<cfif arguments.order IS NOT "">, order="#arguments.order#"</cfif>)>
	</cgfunction>

	#chr(7)#

		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("relationship",output)>
		
	</cffunction>
	
	
	<cffunction name="hasOne" access="private" output="false" hint="Outputs some generated code for hasOne relationships">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="modelName" type="string" required="no" default="#arguments.name#">
		<cfargument name="foreignKey" type="string" required="no" default="#application.core.singularize(variables.model._tableName)#_id">
		<cfargument name="order" type="string" required="no" default="">
		<cfargument name="conditions" type="string" required="no" default="">

		<cfset var output = "">

		<cfsavecontent variable="output"><cfoutput>

	<cgset this._#arguments.name# = "">
			
	<cgfunction name="#arguments.name#" access="public" returntype="any">
		<cgargument name="forceReload" type="boolean" required="no" default="false">
		<cgif NOT isObject(this._#arguments.name#) OR arguments.forceReload>
			<cgset this._#arguments.name# = application.core.model("#arguments.modelName#").findOne(where="(#arguments.foreignKey#=##this.id##)<cfif arguments.conditions IS NOT ""> AND (#arguments.conditions#)</cfif>"<cfif arguments.order IS NOT "">, order="#arguments.order#"</cfif>)>
		</cgif>
		<cgreturn this._#arguments.name#>
	</cgfunction>

	<cgfunction name="set#arguments.name#" access="public" returntype="any">
		<cgargument name="object" type="any" required="yes">
		<cgset arguments.object.updateAttribute("#arguments.foreignKey#", this.id)>
		<cgreturn #arguments.name#(forceReload=true)>
	</cgfunction>

	<cgfunction name="has#arguments.name#" access="public" returntype="boolean">
		<cgif application.core.model("#arguments.modelName#").count(where="#arguments.foreignKey# = ##this.id##") IS NOT 0>
			<cgreturn true>
		<cgelse>
			<cgreturn false>
		</cgif>
	</cgfunction>

	<cgfunction name="build#arguments.name#" access="public" returntype="any">
		<cgset var newArgs = structNew()>
		<cgloop collection="##arguments##" item="key">
			<cgif isStruct(arguments[key])>
				<cgset newArgs.attributes = structCopy(arguments[key])>
			<cgelse>
				<cgset newArgs[key] = arguments[key]>			
			</cgif>
		</cgloop>
		<cgset newArgs["#arguments.foreignKey#"] = this.id>
		<cgreturn application.core.model("#arguments.modelName#").new(argumentCollection=newArgs)>
	</cgfunction>

	<cgfunction name="create#arguments.name#" access="public" returntype="any">
		<cgset var newArgs = structNew()>
		<cgloop collection="##arguments##" item="key">
			<cgif isStruct(arguments[key])>
				<cgset newArgs.attributes = structCopy(arguments[key])>
			<cgelse>
				<cgset newArgs[key] = arguments[key]>			
			</cgif>
		</cgloop>
		<cgset newArgs["#arguments.foreignKey#"] = this.id>
		<cgreturn application.core.model("#arguments.modelName#").create(argumentCollection=newArgs)>
	</cgfunction>

	<cgfunction name="#arguments.name#For" access="public" returntype="any">
		<cgargument name="foreignKey" required="yes" type="numeric">
		
		<cgreturn application.core.model("#arguments.modelName#").findOne(where="#arguments.foreignKey#=##arguments.foreignKey##")>
	</cgfunction>

	#chr(7)#

		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("relationship",output)>
		
	</cffunction>


	<cffunction name="validatesPresenceOf" access="private" output="false" hint="[DOCS] Validates that the specified attributes are not blank">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="on" required="no" default="save" type="string" hint="Specifies when this validation is active (default is 'save', other options are 'create' and 'update')">
		
		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		[DOCS:COMMENTS END]
		--->

		<cfset var output = "">
		<cfset var codeBlock = "">
		
		<cfsavecontent variable="output"><cfoutput>
		<cgif this.#field# IS "">
			<cfif arguments.message IS "">
				<cgset message = "#field# can't be empty">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfif arguments.on IS "save">
			<cfset codeBlock = "validation">
		<cfelseif arguments.on IS "create">
			<cfset codeBlock = "validationOnCreate">
		<cfelseif arguments.on IS "update">
			<cfset codeBlock = "validationOnUpdate">
		</cfif>
		
		<cfset codeCollector(codeBlock,output)>
		
	</cffunction>
	
	
	<cffunction name="validatesNumericalityOf" access="private" output="false" hint="[DOCS] Validates whether the value of the specified attribute is numeric">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="allowNil" required="no" default="false" type="boolean" hint="When true validation is skipped if the attribute is blank">
		<cfargument name="onlyInteger" required="false" default="false" type="boolean" hint="Specifies whether the value has to be an integer">
		<cfargument name="on" required="no" default="save" type="string" hint="Specifies when this validation is active (default is 'save', other options are 'create' and 'update')">

		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		You can use unnamed arguments when supplying the field and/or message but if you supply more arguments they have to be named.
		[DOCS:COMMENTS END]
		--->
		
		<cfset var output = "">
		<cfset var codeBlock = "">
		
		<cfsavecontent variable="output"><cfoutput>
		<cgif <cfif arguments.allowNil IS true>(this.#field# IS NOT "") AND </cfif>(NOT isNumeric(this.#field#))<cfif arguments.onlyInteger IS true> OR (isNumeric(this.#field#) AND Round(this.#field#) IS NOT this.#field#)</cfif>>
			<cfif arguments.message IS "">
				<cgset message = "#field# is not a number">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfif arguments.on IS "save">
			<cfset codeBlock = "validation">
		<cfelseif arguments.on IS "create">
			<cfset codeBlock = "validationOnCreate">
		<cfelseif arguments.on IS "update">
			<cfset codeBlock = "validationOnUpdate">
		</cfif>
		
		<cfset codeCollector(codeBlock,output)>
		
	</cffunction>
	
	
	<cffunction name="validatesFormatOf" access="private" output="false" hint="[DOCS] Validates whether the value of the specified attribute is of the correct form by matching it against the regular expression provided">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="allowNil" required="no" default="false" type="boolean" hint="When true validation is skipped if the attribute is blank">
		<cfargument name="with" required="yes" type="string" hint="The regular expression used to validate the format with">
		<cfargument name="on" required="no" default="save" type="string" hint="Specifies when this validation is active (default is 'save', other options are 'create' and 'update')">
		
		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		Always use named arguments for this validation function.
		[DOCS:COMMENTS END]

		[DOCS:EXAMPLE 1 START]
		Screen name must consist of only letters, numbers, dashes and underscores:
		<cfset validatesFormatOf(field="screen_name", with="^[0-9A-Za-z_-]*$")>
		[DOCS:EXAMPLE 1 END]
		--->

		<cfset var output = "">
		<cfset var codeBlock = "">

		<cfsavecontent variable="output"><cfoutput>
		<cgif <cfif arguments.allowNil IS true>this.#field# IS NOT "" AND </cfif>NOT REFindNoCase("#arguments.with#", this.#arguments.field#)>
			<cfif arguments.message IS "">
				<cgset message = "#field# is invalid">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfif arguments.on IS "save">
			<cfset codeBlock = "validation">
		<cfelseif arguments.on IS "create">
			<cfset codeBlock = "validationOnCreate">
		<cfelseif arguments.on IS "update">
			<cfset codeBlock = "validationOnUpdate">
		</cfif>
		
		<cfset codeCollector(codeBlock,output)>
		
	</cffunction>
	

	<cffunction name="validatesInclusionOf" access="private" output="false" hint="[DOCS] Validates that the value of the specified attribute is not in the supplied list of values">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="in" required="yes" type="string" hint="The value or list of values to check against">
		<cfargument name="allowNil" required="no" default="false" type="boolean" hint="When true validation is skipped if the attribute is blank">
		
		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		Always use named arguments for this validation function.
		[DOCS:COMMENTS END]
		--->

		<cfset var output = "">
		<cfset arguments.in = Replace(arguments.in, ", ", ",", "ALL")>
		
		<cfsavecontent variable="output"><cfoutput>
		<cgif <cfif arguments.allowNil IS true>(this.#field# IS NOT "") AND </cfif>(<cfset pos = 0><cfloop list="#arguments.in#" index="i"><cfset pos = pos + 1>this.#arguments.field# IS NOT "#i#"<cfif ListLen(arguments.in) GT pos> AND </cfif></cfloop>)>
			<cfif arguments.message IS "">
				<cgset message = "#field# is not included in the list">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("validation",output)>
		
	</cffunction>


	<cffunction name="validatesExclusionOf" access="private" output="false" hint="[DOCS] Validates that the value of the specified attribute is not in the supplied list of values">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="in" required="yes" type="string" hint="The value or list of values to check against">
		<cfargument name="allowNil" required="no" default="false" type="boolean" hint="When true validation is skipped if the attribute is blank">
		
		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		Always use named arguments for this validation function.
		[DOCS:COMMENTS END]
		--->

		<cfset var output = "">
		<cfset arguments.in = Replace(arguments.in, ", ", ",", "ALL")>
		
		<cfsavecontent variable="output"><cfoutput>
		<cgif <cfif arguments.allowNil IS true>(this.#field# IS NOT "") AND </cfif>(<cfset pos = 0><cfloop list="#arguments.in#" index="i"><cfset pos = pos + 1>this.#arguments.field# IS "#i#"<cfif ListLen(arguments.in) GT pos> OR </cfif></cfloop>)>
			<cfif arguments.message IS "">
				<cgset message = "#field# is reserved">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("validation",output)>
		
	</cffunction>


	<cffunction name="validatesLengthOf" access="private" output="false" hint="[DOCS] Validates that the specified attribute matches the length restrictions supplied. Only one option can be used at a time">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="allowNil" required="no" default="false" type="boolean" hint="When true validation is skipped if the attribute is blank">
		<cfargument name="exactly" required="no" default="0" type="numeric" hint="The exact size of the attribute">
		<cfargument name="maximum" required="no" default="0" type="numeric" hint="The maximum size of the attribute">
		<cfargument name="minimum" required="no" default="0" type="numeric" hint="The minimum size of the attribute">
		<cfargument name="within" required="no" default="" type="string" hint="A range, supplied as two numbers in a list (for example: '5,9'), specifying the minimum and maximum size of the attribute">
		<cfargument name="on" required="no" default="save" type="string" hint="Specifies when this validation is active (default is 'save', other options are 'create' and 'update')">
		
		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		Always use named arguments for this validation function.
		[DOCS:COMMENTS END]

		[DOCS:EXAMPLE 1 START]
		Length of the book title has to be less than 255 characters:
		<cfset validatesLengthOf(field="book_title", maximum=255)>
		[DOCS:EXAMPLE 1 END]
		
		[DOCS:EXAMPLE 2 START]
		Specifies the allowed range for the length of the password with a custom error message:
		<cfset validatesLengthOf(field="password", within="6,20", message="Your password must be between 6 and 20 characters")>
		[DOCS:EXAMPLE 2 END]

		[DOCS:EXAMPLE 3 START]
		Description has to be at least 50 characters if it exists (blank descriptions are allowed):
		<cfset validatesLengthOf(field="description", minimum="50", allowNil=true)>
		[DOCS:EXAMPLE 3 END]
		
		[DOCS:EXAMPLE 4 START]
		The state code has to be exactly 2 characters:
		<cfset validatesLengthOf(field="state_code", exactly="2")>
		[DOCS:EXAMPLE 4 END]
		--->
		
		<cfset var output = "">
		<cfset var codeBlock = "">
		<cfset var withinArray = "">
		<cfset arguments.within = Replace(arguments.within, ", ", ",", "ALL")>

		<cfif arguments.within IS NOT "">
			<cfset withinArray = ListToArray(arguments.within)>		
		</cfif>
		
		<cfsavecontent variable="output"><cfoutput>
		<cgif <cfif arguments.allowNil IS true>(this.#field# IS NOT "") AND </cfif>(<cfif arguments.maximum IS NOT 0>Len(this.#field#) GT #arguments.maximum#<cfelseif arguments.minimum IS NOT 0>Len(this.#field#) LT #arguments.minimum#<cfelseif arguments.exactly IS NOT 0>Len(this.#field#) IS NOT #arguments.exactly#<cfelseif arguments.within IS NOT "">Len(this.#field#) LT #withinArray[1]# OR Len(this.#field#) GT #withinArray[2]#</cfif>)>
			<cfif arguments.message IS "">
				<cgset message = "#field# is the wrong length">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfif arguments.on IS "save">
			<cfset codeBlock = "validation">
		<cfelseif arguments.on IS "create">
			<cfset codeBlock = "validationOnCreate">
		<cfelseif arguments.on IS "update">
			<cfset codeBlock = "validationOnUpdate">
		</cfif>
		
		<cfset codeCollector(codeBlock,output)>
		
	</cffunction>

	
	<cffunction name="validatesUniquenessOf" access="private" output="false" hint="[DOCS] Validates whether the value of the specified attributes are unique">
		<cfargument name="field" required="yes" type="string" hint="The name of the attribute to check">
		<cfargument name="message" required="no" default="" type="string" hint="The error message to use when validation fails.">
		<cfargument name="scope" required="no" default="" type="string" hint="One or more columns (in a list) by which to limit the scope of the uniquness constraint">
		
		<!---
		[DOCS:COMMENTS START]
		Validations should be placed in the 'init' function of your model.
		You can use unnamed arguments when supplying the field and/or message but if you supply more arguments they have to be named.
		[DOCS:COMMENTS END]

		[DOCS:EXAMPLE 1 START]
		Checks to make sure the chosen username does not already exist in the database before inserting or updating:
		<cfset validatesUniquenessOf("username")>
		[DOCS:EXAMPLE 1 END]
		
		[DOCS:EXAMPLE 2 START]
		Makes sure that a person can never book two times per day (meaning the person can not have two records with the same day_of_week number in the database table):
		<cfset validatesUniquenessOf(field="person_id", scope="day_of_week", message="You can not book more than one time per day")>
		[DOCS:EXAMPLE 2 END]
		--->

		<cfset var output = "">
		<cfset var thisScope = "">
		<cfset var pos = "">
		<cfset arguments.scope = Replace(arguments.scope, ", ", ",", "ALL")>
		
		<cfsavecontent variable="output"><cfoutput>
		<cgquery name="findQuery" username="##application.database.user##" password="##application.database.pass##" datasource="##application.database.name##">
			SELECT	id, #arguments.field#
			FROM	#variables.model._tableName#
			<cgif isNumeric(this.#arguments.field#)>
				WHERE	#arguments.field# = ##this.#arguments.field###
			<cgelse>
				WHERE	#arguments.field# = '##this.#arguments.field###'
			</cgif>
			<cfif arguments.scope IS NOT "">
				AND 
				<cfset pos = 0>
				<cfloop list="#arguments.scope#" index="thisScope">
					<cfset pos = pos + 1>
					#thisScope# = 
					<cgif isNumeric(this.#thisScope#)>
						##this.#thisScope###
					<cgelse>
						'##this.#thisScope###'
					</cgif>
					<cfif ListLen(arguments.scope) GT pos>
						AND 
					</cfif>
				</cfloop>
			</cfif>
		</cgquery>
		<cgif findQuery.recordCount GTE 1 AND findQuery.id IS NOT this.id>
			<cfif arguments.message IS "">
				<cgset message = "#field# has already been taken">
			<cfelse>
				<cgset message = "#arguments.message#">
			</cfif>
			<cgset addError("#field#", message)>
		</cgif>
		#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("validation",output)>
		
	</cffunction>


	<cffunction name="createFinder" access="private" output="false" hint="Generates code for a dynamic finder">
		<cfargument name="name" required="yes" type="string" hint="name for this finder">
		<cfargument name="fields" required="yes" type="array" hint="Array with two fields in alphabetical order">

		<cfset var output = "">

		<cfsavecontent variable="output"><cfoutput>
	<cgfunction name="#arguments.name#" access="public" returntype="any">
		<cgargument name="values" type="string" required="yes">
		<cgargument name="order" type="string" required="no" default="">
		<cgargument name="select" type="string" required="no" default="">
			<cfif left(arguments.name, 7) IS "findAll">
		<cgargument name="include" type="string" required="no" default="">
		<cgargument name="limit" type="numeric" required="no" default=0>
		<cgargument name="offset" type="numeric" required="no" default=0>
		<cgargument name="paginate" type="boolean" required="no" default="false">
		<cgargument name="page" type="numeric" required="no" default=0>
		<cgargument name="perPage" type="numeric" required="no" default=10>
			</cfif>

		<cgset var findArguments = structNew()>
		<cgset var valueOne = "">
		<cgset var valueTwo = "">

		<cgif arguments.order IS NOT "">
			<cgset findArguments.order = arguments.order>
		</cgif>
		<cgif arguments.select IS NOT "">
			<cgset findArguments.select = arguments.select>
		</cgif>
			<cfif left(arguments.name, 7) IS "findAll">
		<cgif arguments.include IS NOT "">
			<cgset findArguments.include = arguments.include>
		</cgif>
		<cgif arguments.limit IS NOT 0>
			<cgset findArguments.limit = arguments.limit>
		</cgif>
		<cgif arguments.offset IS NOT 0>
			<cgset findArguments.offset = arguments.offset>
		</cgif>
		<cgif arguments.paginate>
			<cgset findArguments.paginate = arguments.paginate>
		</cgif>
		<cgif arguments.page IS NOT 0>
			<cgset findArguments.page = arguments.page>
		</cgif>
		<cgif arguments.perPage IS NOT 10>
			<cgset findArguments.perPage = arguments.perPage>
		</cgif>
			</cfif>
	
		<cgset arguments.values = replace(arguments.values, ", ", ",", "all")>
		<cgset valueOne = spanexcluding(arguments.values, ",")>
		<cgset valueTwo = replace(arguments.values, valueOne & ",", "", "one")>

		<cgif variables.fields["#arguments.fields[1]#"].CfDataType IS "numeric">
			<cgif valueOne IS NOT "">
				<cgset findArguments.where = "#arguments.fields[1]# = ##valueOne##">
			<cgelse>
				<cgset findArguments.where = "#arguments.fields[1]# IS NULL">
			</cgif>
		<cgelse>
			<cgif valueOne IS NOT "">
				<cgset findArguments.where = "#arguments.fields[1]# = '##valueOne##'">
			<cgelse>
				<cgset findArguments.where = "(#arguments.fields[1]# = '' OR #arguments.fields[1]# IS NULL)">
			</cgif>
		</cgif>
			<cfif arrayLen(arguments.fields) GT 1>
		<cgif variables.fields["#arguments.fields[2]#"].CfDataType IS "numeric">
			<cgif valueTwo IS NOT "">
				<cgset findArguments.where = findArguments.where & " AND #arguments.fields[2]# = ##valueTwo##">
			<cgelse>
				<cgset findArguments.where = findArguments.where & " AND #arguments.fields[2]# IS NULL">
			</cgif>
		<cgelse>
			<cgif valueTwo IS NOT "">
				<cgset findArguments.where = findArguments.where & " AND #arguments.fields[2]# = '##valueTwo##'">
			<cgelse>
				<cgset findArguments.where = findArguments.where & " AND (#arguments.fields[2]# = '' OR #arguments.fields[2]# IS NULL)">
			</cgif>
		</cgif>
			</cfif>		
		<cgreturn #left(arguments.name, 7)#(argumentCollection=findArguments)>
	</cgfunction>
	#chr(7)#
		</cfoutput></cfsavecontent>
		
		<cfset codeCollector("finder",output)>
		
	</cffunction>
	
	
</cfcomponent>
