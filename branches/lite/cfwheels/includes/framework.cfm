<!--- Functions that support the framework --->

<cffunction name="isMethod" returntype="boolean">
	<cfargument name="component" type="any" required="true" />
	<cfargument name="name" type="string" required="true" />
	
	<cfset var funct = structFind(getMetaData(arguments.component), 'functions')>
	<cfset var i = 1>
	
	<cfif isArray(funct) and arrayLen(funct)>
		<cfloop from="1" to="#arrayLen( funct )#" index="i">
			<cfif funct[i].name IS arguments.name>
				<cfreturn true />
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn false />
</cffunction>

<cfset application.core.isMethod = isMethod>

<!---
<cffunction name="pluralize" access="public" output="false" returntype="string" hint="Accepts a word and returns the pluralized version">
	<cfargument name="text" type="string" required="yes">
	
	<cfset var output = arguments.text>
	<cfset var firstLetter = left(output,1)>
	
	<cfloop index="i" from="1" to="#ArrayLen(application.wheels.pluralizationRules)#">
		<cfif REFindNoCase(application.wheels.pluralizationRules[i][1], arguments.text)>
			<cfset output = REReplaceNoCase(arguments.text, application.wheels.pluralizationRules[i][1], application.wheels.pluralizationRules[i][2])>
			<cfset output = firstLetter & right(output,len(output)-1)>
			<cfbreak> 
		</cfif>
	</cfloop>
	
	<cfreturn output>
</cffunction>

<cfset application.core.pluralize = pluralize>

<cffunction name="singularize" access="public" output="false" returntype="string" hint="Accepts a word and returns the singularized version">
	<cfargument name="text" type="string" required="yes">

	<cfset var output = arguments.text>
	<cfset var firstLetter = left(output,1)>
	
	<cfloop index="i" from="1" to="#ArrayLen(application.wheels.singularizationRules)#">
		<cfif REFindNoCase(application.wheels.singularizationRules[i][1], arguments.text)>
			<cfset output = REReplaceNoCase(arguments.text, application.wheels.singularizationRules[i][1], application.wheels.singularizationRules[i][2])>
			<cfset output = firstLetter & right(output,len(output)-1)>
			<cfbreak> 
		</cfif>
	</cfloop>
	
	<cfreturn output>
</cffunction>

<cfset application.core.singularize = singularize>

<cffunction name="getBaseModel" access="public" output="false" returntype="string" hint="Returns the name of the model given a full model path">
	<cfargument name="modelPath" type="string" required="yes">
	
	<cfreturn listLast(modelPath,".")>
	
</cffunction>

<cfset application.core.getBaseModel = getBaseModel>

<cffunction name="baseifyModel" access="public" output="false" returntype="any" hint="Returns a model object">
	<cfargument name="modelName" type="string" required="yes" hint="The name of the model to return">
	
	<cfreturn reReplace(arguments.modelName,"(.*)(\.)(.*)","\1._\3")>
</cffunction>

<cfset application.core.baseifyModel = baseifyModel>

<cffunction name="tableNameFromModel" access="public" output="false" returntype="string" hint="Returns the table name from a model name">
	<cfargument name="modelName" type="string" required="true">
	
	<cfif reFindNoCase("^_.*?_set$", arguments.modelName)>
		<cfset arguments.modelName = reReplace(arguments.modelName, "_(.*?)_set$", "\1")>
	</cfif>
	
	<cfreturn application.core.pluralize(arguments.modelName)>
</cffunction>

<cfset application.core.tableNameFromModel = tableNameFromModel>

<cffunction name="tableNameFromForeignKey" access="public" output="false" returntype="string" hint="Returns the table name from a model name">
	<cfargument name="foreignKey" type="string" required="true">
	
	<cfset var tempName = replace(arguments.foreignKey, "_id", "")>
	
	<cfreturn application.core.pluralize(tempName)>
</cffunction>

<cfset application.core.tableNameFromForeignKey = tableNameFromForeignKey>

<cffunction name="foreignKeyFromTableName" access="public" output="false" returntype="string" hint="Returns the table name from a model name">
	<cfargument name="tableName" type="string" required="true">
	
	<cfreturn application.core.singularize(arguments.tableName) & "_id">
</cffunction>

<cfset application.core.foreignKeyFromTableName = foreignKeyFromTableName>


<cffunction name="joinTableName" access="public" output="false" returntype="any" hint="Returns the name of the join table based on two received table names">
	<cfargument name="primaryTable" type="string" required="yes" hint="The name of the first table">
	<cfargument name="secondaryTable" type="string" required="yes" hint="The name of the second table">
	
	<cfset var tableList = arguments.primaryTable & "," & arguments.secondaryTable>
	<cfset tableList = listSort(tableList,"textnocase","asc")>
	<cfset tableList = replace(tableList,",","_","all")>
	
	<cfreturn tableList>
</cffunction>

<cfset application.core.joinTableName = joinTableName>
--->

<cffunction name="componentPathToWebPath" access="public" output="false" returntype="any" hint="Takes a component path and turns it into a web path">
	<cfargument name="componentPath" type="string" required="yes" hint="The name of the model to return">
	
	<cfset var webPath = "/" & replace(arguments.componentPath,".","/","all")>
	<cfreturn webPath>
</cffunction>

<cfset application.core.componentPathToWebPath = componentPathToWebPath>

<cffunction name="componentPathToFilePath" access="public" output="false" returntype="any" hint="Takes a component path and turns it into a file path">
	<cfargument name="componentPath" type="string" required="yes" hint="The name of the model to return">
	
	<cfset var filePath = "/" & replace(arguments.componentPath,".","/","all")>
	<cfreturn filePath>
</cffunction>

<cfset application.core.componentPathToFilePath = componentPathToFilePath>

<cffunction name="webPathToComponentPath" access="public" output="false" returntype="any" hint="Takes a web path and turns it into a component path">
	<cfargument name="webPath" type="string" required="yes" hint="The name of the model to return">
	
	<cfset var componentPath = replace(arguments.webPath,"/",".","all")>
	<cfif left(componentPath,1) IS ".">
		<cfset componentPath = right(componentPath,len(componentPath)-1)>
	</cfif>
	<cfreturn componentPath>
</cffunction>

<cfset application.core.webPathToComponentPath = webPathToComponentPath>

<cffunction name="filePathToComponentPath" access="public" output="false" returntype="any" hint="Takes a file path and turns it into a component path">
	<cfargument name="filePath" type="string" required="yes" hint="The name of the model to return">
	
	<cfset var componentPath = replace(arguments.filePath,"/",".","all")>
	<cfif left(componentPath,1) IS ".">
		<cfset componentPath = right(componentPath,len(componentPath)-1)>
	</cfif>
	<cfreturn componentPath>
</cffunction>

<cfset application.core.filePathToComponentPath = filePathToComponentPath>

<cffunction name="webPathToFilePath" access="public" output="false" returntype="any" hint="Takes a web path and turns it into a file path">
	<cfargument name="webPath" type="string" required="yes" hint="The name of the model to return">
	
	<!--- <cfreturn replace(arguments.webPath,"/","\","all")> --->
	<cfreturn arguments.webPath>
</cffunction>

<cfset application.core.webPathToFilePath = webPathToFilePath>

<cffunction name="filePathToWebPath" access="public" output="false" returntype="any" hint="Takes a file path and turns it into a web path">
	<cfargument name="filePath" type="string" required="yes" hint="The name of the model to return">
	
	<!--- <cfreturn replace(arguments.filePath,"\","/","all")> --->
	<cfreturn arguments.filePath>
</cffunction>

<cfset application.core.filePathToWebPath = filePathToWebPath>

<cffunction name="fixQuotedValueList" access="public" returntype="string" output="false" hint="Removes the quotes from a quoted value list">
	<cfargument name="quotedValueList" type="string" required="true" hint="The quoted value list to work on">

	<cfreturn reReplace(arguments.quotedValueList, "'(.*?)'", "\1", "all")>
</cffunction>

<cfset application.core.fixQuotedValueList = fixQuotedValueList>

<cffunction name="queryColumnValuesToList" access="public" returntype="string" output="false" hint="Takes a query and returns a column's values as a list">
	<cfargument name="query" required="true" type="query" hint="The query to work on">
	<cfargument name="column" required="true" type="string" hint="The column to return values for">
	
	<cfset var list = "">
	
	<cfloop query="arguments.query">
		<cfset list = listAppend(list,arguments.query[column][currentRow])>
	</cfloop>
	
	<cfreturn list>
	
</cffunction>

<cfset application.core.queryColumnValuesToList = queryColumnValuesToList>