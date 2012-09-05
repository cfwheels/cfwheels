<cfcomponent output="false">


	<cffunction name="init">
		<cfargument name="wheelsAPIChapterDirectory" type="string" required="true" hint="the full path to the wheels api directory in the documentation root. Is used to generate chapters and function references.">
		<cfargument name="data" type="struct" required="true">
		<cfset variables.wheelsAPIChapterDirectory = ListChangeDelims(arguments.wheelsAPIChapterDirectory, "/", "\")>
		<cfset variables.data = arguments.data>
		<cfset variables.chapters = {}>
		<cfset variables.functionNames = "">
		<cfset variables.chaptersNames = "">
		<cfset variables.needsDocumentation = []>
		<cfset $sortFunctionDocumentation()>
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="build">
		<cfset $resetDocumentationDirectory()>
		<cfset $createChapterPage()>
		<cfset $createSubChapterPages()>
		<cfset $createFunctionListPage()>
		<cfset $createFunctionPages()>
	</cffunction>
	
	
	<cffunction name="$resetDocumentationDirectory" access="private" output="false" hint="generates all the function references in markdown format">
		<cfset var loc = {}>
		<!--- delete the previous documentation --->
		<cfif DirectoryExists(variables.wheelsAPIChapterDirectory)>
			<cfdirectory action="delete" recurse="true" directory="#variables.wheelsAPIChapterDirectory#">
		</cfif>
		
		<!--- create the documentation directory --->
		<cfdirectory action="create" recurse="true" directory="#variables.wheelsAPIChapterDirectory#">

	</cffunction>
	
	
	<cffunction name="$sortFunctionDocumentation" access="private" output="false">
		<cfset var loc = {}>
		
		<!--- get a list of all the function names --->		
		<cfset variables.functionNames = ListSort(StructKeyList(variables.data), "textNoCase")>
		
		<!--- will hold all the chapters --->
		<cfset variables.chapters = {}>
		
		<cfloop list="#variables.functionNames#" index="loc.functionName">
			<cfset loc.main = "uncategorized">
			<cfset loc._function = variables.data[loc.functionName]>
			<cfset loc.categories = loc._function.categories>
			<cfif !ArrayIsEmpty(loc.categories)>
				<cfset loc.main = loc.categories[1]>
			</cfif>
			<cfif !StructKeyExists(variables.chapters, loc.main)>
				<cfset variables.chapters[loc.main] = {}>
			</cfif>
			<cfset loc.sub = "uncategorized">
			<cfif ArrayLen(loc.categories) gt 1>
				<cfset loc.sub = loc.categories[2]>
			</cfif>
			<cfif !StructKeyExists(variables.chapters[loc.main], loc.sub)>
				<cfset variables.chapters[loc.main][loc.sub] = []>
			</cfif>
			<cfset ArrayAppend(variables.chapters[loc.main][loc.sub], loc.functionName)>
		</cfloop>
		
		<!--- put the chapters in alphabetical order --->
		<cfset variables.chaptersNames = ListSort(StructKeyList(variables.chapters), "textnocase")>
	</cffunction>
	
	
	<cffunction name="$createChapterPage" access="private" output="false">
		<cfset var loc = {}>
		
		<cfset loc.counter = 1>
		<cfoutput>
<cfsavecontent variable="loc.markdown">
## Functions By Category
<cfloop list="#variables.chaptersNames#" index="loc.chapter"><cfset loc.chapter = "#$capitalize(loc.chapter)# Functions">
#loc.counter#. [#loc.chapter#](#loc.chapter#.md)<cfset loc.counter ++></cfloop>
</cfsavecontent>
		</cfoutput>
		
		<cffile action="write" file="#variables.wheelsAPIChapterDirectory#/Functions By Category.md" output="#trim(loc.markdown)#">
	</cffunction>
	
	
	<cffunction name="$createSubChapterPages" access="private" output="false">
		<cfset var loc = {}>
		
		<cfoutput>
		<cfloop list="#variables.chaptersNames#" index="loc.chapter"><cfset loc.chapterTitle = "#$capitalize(loc.chapter)# Functions">
			<cfset loc.subChapterNames = ListSort(StructKeyList(variables.chapters[loc.chapter]), "textnocase")>
<cfsavecontent variable="loc.markdown">
## #loc.chapterTitle#
			<cfloop list="#loc.subChapterNames#" index="loc.subchapter"><cfset loc.subchapterTitle = "#$capitalize(loc.subchapter)# Functions">
#### #loc.subchapterTitle#
				<cfset loc.functionNames = variables.chapters[loc.chapter][loc.subchapter]>
				<cfloop array="#loc.functionNames#" index="loc.function"><cfset loc.functionTitle = "#loc.function#()">
* [#loc.functionTitle#](#loc.function#.md)</cfloop>
			</cfloop>
</cfsavecontent>
			<cffile action="write" file="#variables.wheelsAPIChapterDirectory#/#loc.chapterTitle#.md" output="#trim(loc.markdown)#">
		</cfloop>
		</cfoutput>
	</cffunction>
	
	
	<cffunction name="$createFunctionListPage" access="private" output="false">
		<cfset var loc = {}>
		
		<cfoutput>
<cfsavecontent variable="loc.markdown">
## All Functions A-Z
<cfloop list="#variables.functionNames#" index="loc.function"><cfset loc.functionTitle = "#loc.function#()">
* [#loc.functionTitle#](#loc.function#.md)</cfloop>
</cfsavecontent>
			<cffile action="write" file="#variables.wheelsAPIChapterDirectory#/All Functions.md" output="#trim(loc.markdown)#">
		</cfoutput>
	</cffunction>
	
	
	<cffunction name="$createFunctionPages" access="private" output="false">
		<cfset var loc = {}>
		
		<cfoutput>
		<cfloop list="#variables.chaptersNames#" index="loc.chapter">
			<cfset loc.subChapterNames = ListSort(StructKeyList(variables.chapters[loc.chapter]), "textnocase")>
			<cfloop list="#loc.subChapterNames#" index="loc.subchapter">
				<cfset loc.functionNames = variables.chapters[loc.chapter][loc.subchapter]>
				<cfloop array="#loc.functionNames#" index="loc.function"><cfset loc.functionTitle = "#loc.function#()">
				<cfset loc.data = variables.data[loc.function]>
				<cfset loc.syntax = "#loc.function#( ">
				<cfset loc.parametersRequired = []>
				<cfset loc.parametersNotRequired = []>
				<cfloop array="#loc.data.parameters#" index="loc.parameter">
					<cfif loc.parameter.required eq "true">
						<cfset ArrayAppend(loc.parametersRequired, loc.parameter.name)>
					<cfelse>
						<cfset ArrayAppend(loc.parametersNotRequired, loc.parameter.name)>
					</cfif>
				</cfloop>
				<cfif !ArrayIsEmpty(loc.parametersRequired)>
					<cfset loc.syntax &= ArrayToList(loc.parametersRequired, ', ')>
				</cfif>
				<cfif !ArrayIsEmpty(loc.parametersNotRequired)>
					<cfif !ArrayIsEmpty(loc.parametersRequired)>
						<cfset loc.syntax &= ", ">
					</cfif>
					<cfset loc.syntax &= "[ #ArrayToList(loc.parametersNotRequired, ', ')# ]" >
				</cfif>
				<cfset loc.syntax &= " )">
<cfsavecontent variable="loc.markdown">
## #loc.functionTitle#

#### Description
#loc.data.hint#

#### Function Syntax
	#loc.syntax#

<cfif !ArrayIsEmpty(loc.data.parameters)>
#### Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#loc.data.parameters#" index="loc.parameter">
		<tr>
			<td>#loc.parameter.name#</td>
			<td>#loc.parameter.type#</td>
			<td>#loc.parameter.required#</td>
			<td>#loc.parameter.default#</td>
			<td>#loc.parameter.hint#</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</cfif>

#### Examples
	#loc.data.examples#
</cfsavecontent>
				<cffile action="write" file="#variables.wheelsAPIChapterDirectory#/#loc.function#.md" output="#trim(loc.markdown)#">
				</cfloop>
			</cfloop>
		</cfloop>
		</cfoutput>
	</cffunction>
	
	
	<cffunction name="$capitalize" output="false">
		<cfargument name="str" type="string" required="true">
		<cfreturn ReReplaceNoCase(ReplaceNoCase(arguments.str, "-", " "), "\b(\w)","\u\1", "all")>
		<cfreturn trim(arguments.str)>
	</cffunction>


	<cffunction name="getNeedsDocumentation">
		<cfreturn ArrayToList(variables.needsDocumentation)>
	</cffunction>

</cfcomponent>