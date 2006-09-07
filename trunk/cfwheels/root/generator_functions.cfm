<cfset variables.defaults = structNew()>
<cfset variables.defaults.layout_content = "<cgset contentForLayout(request.params)>">


<cffunction name="generate" access="remote" hint="Orchestrates other generator actions">
	<cfargument name="type" type="string" required="true" hint="The type of thing to generate (controller, model, scaffold)">
	<cfargument name="controller_name" type="string" required="false" hint="Name of the controller to create">
	<cfargument name="action_name" type="string" required="false" hint="Name of the action(s) to create">
	<cfargument name="model_name" type="string" required="false" hint="Name of the model to create">
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="controller">
			<cfset returnString = makeController(arguments.controller_name, arguments.action_name)>
		</cfcase>
		<cfcase value="model">
			<cfset returnString = makeModel(arguments.model_name)>
		</cfcase>
		<cfcase value="scaffold">
			<!--- Refresh the database parameters and model hashes --->
			<cfinclude template="#application.pathTo.config#/database.cfm">
			<cfset structClear(application.wheels.models)>
			<cfset returnString = makeScaffold(arguments.controller_name,arguments.model_name)>
		</cfcase>
		<cfcase value="skeleton">
			<cfset returnString = makeSkeleton()>
		</cfcase>
		<cfdefaultcase>
			<cfthrow type="cfwheels.generator.invalid_type" message="Invalid type" detail="This isn't a type that the generator can create">
		</cfdefaultcase>
	</cfswitch>
	
	<cfoutput>#returnString#</cfoutput>
	
</cffunction>


<cffunction name="makeController" access="private" returntype="string" output="false" hint="Generates a controller">
	<cfargument name="controller_name" type="string" required="false" hint="Name of the controller to create">
	<cfargument name="action_name" type="string" required="false" hint="Name of the action(s) to create">
	
	<cfset var returnString = "">
	<cfset var actionsCode = "">
	
	
	
	<!--- Create actions --->
	<cfloop list="#arguments.action_name#" index="action">
		<cfset actionsCode = actionsCode & generateActionCode(action,"")>
	</cfloop>
	
	
	
	
	<!--- Create controller --->
	<cfset newController = generateControllerCode(controller_name,actionsCode)>
	<cfset fileDir = expandPath(application.filePathTo.controllers)>
	<cfset fileName = arguments.controller_name & "_controller.cfc">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newController)>

	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>
	
	
	<!--- Create layout --->
	<cfsavecontent variable="layoutContent">
		<cfoutput>
<!-- HTML that you want on every page that's output by this controller -->

<!-- Your layout must contain this call to display the code in your view -->
<cgset contentForLayout()>
			</cfoutput>
	</cfsavecontent>
	
	<cfset newLayout = generateLayoutCode(controller_name,layoutContent)>
	<cfset fileDir = expandPath("#application.pathTo.layouts#")>
	<cfset fileName = arguments.controller_name & "_layout.cfm">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newLayout)>
	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>
	
	
	
	
	<!--- Create helper --->
	<cfset newHelper = generateHelperCode(controller_name)>
	<cfset fileDir = expandPath("#application.pathTo.helpers#")>
	<cfset fileName = arguments.controller_name & "_helper.cfm">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newHelper)>
	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>
	
	
	
	
	<!--- Create views --->
	<cfloop list="#arguments.action_name#" index="action">
		
		<cfsavecontent variable="viewContent">
			<cfoutput>
<h1>#action#</h1>
<p>You can find me in <code>/app/views/#controller_name#/#action#.cfm</code></p>
			</cfoutput>
		</cfsaveContent>
		
		<cfset newView = generateViewCode(controller_name,trim(action),viewContent)>
		<cfset fileDir = expandPath("#application.pathTo.views#") & "/" & arguments.controller_name>
		<cfset fileName = trim(action) & ".cfm">
		<cfset fileResult = application.core.saveFile(fileDir,fileName,newView)>
		<cfif fileResult>
			<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
		<cfelse>
			<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
		</cfif>
	</cfloop>
	
	
	<cfreturn returnString>
	
</cffunction>


<cffunction name="makeModel" access="private" returntype="string" output="false" hint="Generates a controller">
	<cfargument name="model_name" type="string" required="false" hint="Name of the model to create">
	
	<cfset var returnString = "">
	
	<!--- Create user-modifiable model --->
	<cfset newModel = generateUserModelCode(arguments.model_name)>
	<cfset fileDir = expandPath(application.filePathTo.models)>
	<cfset fileName = arguments.model_name & ".cfc">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newModel)>
	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>

	<!--- Create system model --->
	<cfset newModel = generateSystemModelCode(arguments.model_name)>
	<cfset fileDir = expandPath(application.filePathTo.generatedModels)>
	<cfset fileName = "_" & arguments.model_name & ".cfc">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newModel)>
	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>
			
	<cfreturn returnString>
	
</cffunction>


<cffunction name="makeScaffold" access="private" returntype="string" output="false" hint="Generates a controller">
	<cfargument name="controller_name" type="string" required="true" hint="Name of the controller to create">
	<cfargument name="model_name" type="string" required="true" hint="Name of the controller to create">

	<cfset var returnString = "">
	<cfset var action_name = "index,list,show,new,edit,update,create,destroy">
	<cfset var views = "_form,list,show,new,edit">
	<cfset var actionsCode = "">
	<cfset var modelName = arguments.model_name>
	<cfset var pluralModelName = application.core.pluralize(modelName)>
	
	<!--- Create the model and then instantiate it so that we can use it's field structure --->
	<cftry>
		<cfset makeModel(modelName)>
		<cfset theModel = application.core.model(modelName).findAll()>
		
		<cfcatch type="any">
			<cfif cfcatch.message CONTAINS "Data source datasource_name could not be found">
				<cfthrow type="cfwheels.database.datasource_name" message="You need to set up your database config file (<code>/config/database.cfm</code>) before trying to build a scaffold" detail="Please enter the proper connection details for your database in the <code>/config/database.cfm</code> file">
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
	</cftry>

	<!--- Loop over the list of columns in the model to get all the data for each --->
	
	<!--- Generate actions --->
	<cfloop list="#action_name#" index="action">
		<cfsavecontent variable="thisCode">
			<cfoutput>
				<cfswitch expression="#action#">
					<cfcase value="index">
		<cgset list()>
		<cgset render("list")>
					</cfcase>
					<cfcase value="list">
		<cgset #pluralModelName# = model("#modelName#").findAll()>
					</cfcase>
					<cfcase value="show">
		<cgset #modelName# = model("#modelName#").findByID(request.params.id)>
					</cfcase>
					<cfcase value="new">
		<cgset #modelName# = model("#modelName#").new()>
					</cfcase>
					<cfcase value="edit">
		<cgset #modelName# = model("#modelName#").findByID(request.params.id)>
					</cfcase>
					<cfcase value="update">
		<cgset #modelName# = model("#modelName#").findByID(request.params.id)>
		<cgif #modelName#.updateAttributes(request.params.#modelName#)>
			<cgset request.flash.notice = "#modelName# was successfully updated">
			<cgset redirectTo(action="show", id=#modelName#.id)>
		<cgelse>
			<cgset render(action="edit")>
		</cgif>
					</cfcase>
					<cfcase value="create">
		<cgset #modelName# = model("#modelName#").new(request.params.#modelName#)>
		<cgif #modelName#.save()>
			<cgset request.flash.notice = "#modelName# was successfully created">
			<cgset redirectTo(action="list")>
		<cgelse>
			<cgset render(action="new")>
		</cgif>
					</cfcase>
					<cfcase value="destroy">
		<cgset #modelName# = model("#modelName#").findByID(request.params.id)>
		<cgset #modelName#.destroy()>
		<cgset redirectTo(action="index")>
					</cfcase>
				</cfswitch>
			</cfoutput>
		</cfsavecontent>
		
		<cfset actionsCode = actionsCode & generateActionCode(action,thisCode)>
	</cfloop>


	<!------------------------->
	<!--- Create controller --->
	<!------------------------->
	<cfset newController = generateControllerCode(controller_name,actionsCode)>
	<cfset fileDir = expandPath(application.filePathTo.controllers)>
	<cfset fileName = arguments.controller_name & "_controller.cfc">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newController)>

	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>
	
	
	
	<!------------------------->
	<!--- Create layout     --->
	<!------------------------->
	<cfsavecontent variable="layoutContent">
		<cfoutput>
<html>
<head>
	<cgoutput>
		<title>##request.params.controller##: ##request.params.action##</title>
		<link rel="stylesheet" href="/stylesheets/scaffold.css" type="text/css" media="all" />
	</cgoutput>
</head>

<body id="scaffold">

	<cgif isDefined('request.flash.notice')>
		<cgoutput><p style="color: green">##request.flash.notice##</p></cgoutput>
	</cgif>

	<cgset contentForLayout()>

</body>
</html>
		</cfoutput>
	</cfsavecontent>
	
	<cfset newLayout = generateLayoutCode(controller_name,layoutContent)>
	<cfset fileDir = expandPath("#application.pathTo.layouts#")>
	<cfset fileName = arguments.controller_name & "_layout.cfm">
	<cfset fileResult = application.core.saveFile(fileDir,fileName,newLayout)>
	<cfif fileResult>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
	<cfelse>
		<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
	</cfif>
	

		
	<!------------------------->
	<!--- Create views      --->
	<!------------------------->
	<cfloop list="#views#" index="view">
		
		<cfsavecontent variable="viewContent">
			<cfoutput>
				<cfswitch expression="#view#">
					
					
					<!--- Code for _form.cfm --->
					
					
					<cfcase value="_form">
						<cfset columnList = listDeleteAt(theModel.columnList, listFind(theModel.columnList,"id"))>
						<cfset fields = theModel.getFieldData()>
<cgoutput>
						<cfloop list="#columnList#" index="column">
							<cfset label = replace(application.core.capitalize(column), "_", " ", "all")>
							<cfswitch expression="#fields[column]['cfSqlType']#">
								<cfcase value="cf_sql_bigint,cf_sql_bit,cf_sql_char,cf_sql_decimal,cf_sql_double,cf_sql_float,cf_sql_integer,cf_sql_money,cf_sql_numeric,cf_sql_real,cf_sql_smallint,cf_sql_tinyint,cf_sql_varchar">
	##textField(model="#modelName#", field="#column#", label="#label#")##
								</cfcase>
								<cfcase value="cf_sql_blob,cf_sql_clob,cf_sql_longvarchar">
	##textArea(model="#modelName#", field="#column#", label="#label#")##
								</cfcase>
								<cfcase value="cf_sql_timestamp">
	##dateTimeSelect(model="#modelName#", field="#column#", label="#label#")##
								</cfcase>
								<cfcase value="cf_sql_date">
	##dateSelect(model="#modelName#", field="#column#", label="#label#")##
								</cfcase>
								<cfcase value="cf_sql_time">
	##timeSelect(model="#modelName#", field="#column#", label="#label#")##
								</cfcase>
							</cfswitch>
						</cfloop>
</cgoutput>
					</cfcase>
					
					
					<!--- Code for list.cfm --->
					
					
					<cfcase value="list">
<h1>Listing #pluralModelName#</h1>
<cgset theColumnList = listDeleteAt(#pluralModelName#.columnList, listFind(#pluralModelName#.columnList,"id"))>
<cgoutput>
	<table cellspacing="0">
		<tr>
			<cgloop list="##theColumnList##" index="column">
				<cgset header = replace(core.capitalize(column),"_"," ","all")>
				<th>##header##</th>
			</cgloop>
			<th>&nbsp;</th>
		</tr>
		<cgloop query="#pluralModelName#.query">
			<tr>
				<cgloop list="##theColumnList##" index="column">
					<td>###pluralModelName#.query[column][currentRow]##&nbsp;</td>
				</cgloop>
				<td>
					##linkTo(name="Show", action="show", id=id)##
					##linkTo(name="Edit", action="edit", id=id)##
					##linkTo(name="Destroy", action="destroy", id=id)##
				</td>
			</tr>
		</cgloop>
	</table>
	<p>##linkTo(name="New #modelName#", action="new")##</p>
</cgoutput>
					</cfcase>
					
					
					<!--- Code for show.cfm --->
					
					
					<cfcase value="show">
<cgoutput>
						<cfloop list="#columnList#" index="column">
							<cfset label = replace(application.core.capitalize(column), "_", " ", "all")>
	<p><strong>#label#:</strong> ###modelName#.#column###</p>
						</cfloop>
	<p>##linkTo(name="Edit", action="edit", id=request.params.id)## | ##linkTo(name="Back", action="index")##</p>
</cgoutput>
					</cfcase>
					
					
					<!--- Code for new.cfm --->
					
					
					<cfcase value="new">
<h1>New #modelName#</h1>
<cgoutput>
	<cgif errorMessagesFor(#modelName#) IS NOT "">
		##errorMessagesFor(#modelName#)##
	</cgif>
	##startFormTag(action="create", method="post")##
		##render(partial="form")##
		##submitTag(value="Create")##
	##endFormTag()##
	<p>##linkTo(name="Back", action="index")##</p>
</cgoutput>
					</cfcase>
					
					
					<!--- Code for edit.cfm --->
					
					
					<cfcase value="edit">
<h1>Editing #modelName#</h1>
<cgoutput>
	<cgif errorMessagesFor(#modelName#) IS NOT "">
		##errorMessagesFor(#modelName#)##
	</cgif>
	##startFormTag(action="update", id=request.params.id, method="post")##
		##render(partial="form")##
		##submitTag(value="Update")##
	##endFormTag()##
	<p>##linkTo(name="Show", action="show", id=request.params.id)## | ##linkTo(name="Back", action="index")##</p>
</cgoutput>
					</cfcase>
				</cfswitch>
			</cfoutput>
		</cfsavecontent>
		
		<cfset newView = generateViewCode(controller_name,view,viewContent)>
		<cfset fileDir = expandPath("#application.pathTo.views#") & "/" & arguments.controller_name>
		<cfset fileName = view & ".cfm">
		<cfset fileResult = application.core.saveFile(fileDir,fileName,newView)>
		<cfif fileResult>
			<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>created</strong><br />">
		<cfelse>
			<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>already exists, overwrote!</strong><br />">
		</cfif>
	</cfloop>
	
	
	<cfreturn returnString>
	
</cffunction>


<cffunction name="generateControllerCode" access="private" returntype="string" output="false" hint="Generates a controller">
	<cfargument name="controller_name" type="string" required="true" hint="Name of the controller to create">
	<cfargument name="actionsCode" type="string" required="true" hint="Name of the action(s) to create inside the controller">
	
	<cfsavecontent variable="output">
		<cfoutput>
<cgcomponent name="#left(ucase(arguments.controller_name),1)##right(lcase(arguments.controller_name),len(arguments.controller_name)-1)# controller" extends="cfwheels.controllers._controller">

#arguments.actionsCode#

</cgcomponent>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn application.core.cleanup(output)>
	
</cffunction>


<cffunction name="generateActionCode" access="private" returntype="string" output="false" hint="Generates a controller">
	<cfargument name="action_name" type="string" required="true" hint="Name of the action(s) to create inside the controller">
	<cfargument name="content" type="string" required="true" hint="The code to put inside the action">
	
	<cfsavecontent variable="output">
		<cfoutput>

	<cgfunction name="#arguments.action_name#" access="public">
		
		#trim(arguments.content)#
		
	</cgfunction>

		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
	
</cffunction>


<cffunction name="generateUserModelCode" access="private" returntype="string" output="false" hint="Generates a model">
	<cfargument name="model_name" type="string" required="true" hint="Name of the model to create">

	<cfsavecontent variable="output">
		<cfoutput>
<cgcomponent displayname="#arguments.model_name#" extends="#application.componentPathTo.generatedModels#._#arguments.model_name#">

	<cgfunction name="init" access="public">
		<!-- Read the documentation for which types of relationships you can specify here -->
	</cgfunction>
	
</cgcomponent>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn application.core.cleanup(output)>
	
</cffunction>


<cffunction name="generateSystemModelCode" access="private" returntype="string" output="false" hint="Generates a model">
	<cfargument name="model_name" type="string" required="true" hint="Name of the model to create">

	<cfsavecontent variable="output">
		<cfoutput>
<cgcomponent displayname="_#arguments.model_name#" extends="cfwheels.models._model">						
	<!-- This model is auto-generated by Wheels, you should not modify it manually -->
</cgcomponent>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn application.core.cleanup(output)>
	
</cffunction>


<cffunction name="generateScaffoldCode" access="private" returntype="string" output="false" hint="Generates a scaffold">
	<cfargument name="controller_name" type="string" required="true">
	<cfargument name="model_name" type="string" required="true">
	
	
	<cfsavecontent variable="output">
		
	</cfsavecontent>
	
	<cfreturn output>
	
</cffunction>


<cffunction name="generateViewCode" access="private" returntype="string" output="false" hint="Generates a view">
	<cfargument name="controller_name" type="string" required="true" hint="Name of the generator these views belong to">
	<cfargument name="action_name" type="string" required="true" hint="Name(s) of the view files to create">
	<cfargument name="content" type="string" required="true" hint="The code to put in the view">
	
	<cfsavecontent variable="output">
		<cfoutput>
#trim(arguments.content)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn application.core.cleanup(output)>
	
</cffunction>


<cffunction name="generateHelperCode" access="private" returntype="string" output="false" hint="Generates a helper">
	<cfargument name="controller_name" type="string" required="true" hint="Name of the controller this helper belongs to">
	
	<cfsavecontent variable="output">
		<cfoutput>
<!-- Insert code or functions that you want available to every action in your #arguments.controller_name# controller -->
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn application.core.cleanup(output)>
	
</cffunction>


<cffunction name="generateLayoutCode" access="private" returntype="string" output="false" hint="Generates a layout">
	<cfargument name="controller_name" type="string" required="true" hint="Name of the layout this controller belongs to">
	<cfargument name="content" type="string" required="true" hint="Name of the layout this controller belongs to">
	
	<cfsavecontent variable="output">
		<cfoutput>
#arguments.content#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn application.core.cleanup(output)>
	
</cffunction>

<!---
<cffunction name="update" access="remote" returntype="string" output="true" hint="Updates the CFWheels application.core files">
	
	<cfset var meta = xmlParse(getMeta())>
	<cfset var coreFiles = arrayNew(1)>
	<cfset var remoteMd5 = "">
	<cfset var localMd5 = "">
	<cfset var remoteFile = "">
	<cfset var fileDir = "">
	<cfset var fileName = "">
	<cfset var fileResult = "">
	<cfset var returnString = "">
	
	<!--- Connect to the web service --->
	<cfobject name="remoteService" webservice="http://www.cfwheels.com/updater/update.cfc?wsdl">
			
	<!--- Get to the application.core files --->
	<cfset coreFiles = meta.cfwheels.application.core.xmlChildren>
	
	<cfloop from="1" to="#arrayLen(coreFiles)#" index="i">
		<cfif isDefined('coreFiles[i].xmlAttributes.action') AND coreFiles[i].xmlAttributes.name IS "delete">
			<!--- Delete the file if action="delete" in the XML file --->
			<cfif listLen(coreFiles[i].xmlAttributes.name, "/") GT 1>
				<cfset fileDir = application.absolutePathTo.cfwheels & replace(listDeleteAt(coreFiles[i].xmlAttributes.name, listLen(coreFiles[i].xmlAttributes.name,"/"), "/"),"/","\","all")>
			<cfelse>
				<cfset fileDir = application.absolutePathTo.cfwheels>
			</cfif>
			<cfset fileName = listLast(coreFiles[i].xmlAttributes.name, "/")>
			<cfset delFile(fileDir,fileName)>
		<cfelse>
			<!--- Get the file and find out if we need to update the local copy --->
			<cfset remoteMd5 = getRemoteMd5(coreFiles[i].xmlAttributes.name)>
			<cfset localMd5 = getLocalMd5(coreFiles[i].xmlAttributes.name)>
			<!--- Check to see if the file has been updated --->
			<cfif remoteMd5 IS NOT localMd5>
				<!--- Get the remote file --->
				<cfset remoteFile = getRemoteFile(coreFiles[i].xmlAttributes.name)>
				<!--- If this file is in a subdirectory, figure out what it is and add it to the path --->
				<cfif listLen(coreFiles[i].xmlAttributes.name, "/") GT 1>
					<cfset fileDir = application.absolutePathTo.cfwheels & replace(listDeleteAt(coreFiles[i].xmlAttributes.name, listLen(coreFiles[i].xmlAttributes.name,"/"), "/"),"/","\","all")>
				<cfelse>
					<cfset fileDir = application.absolutePathTo.cfwheels>
				</cfif>
				<!--- Get the filename --->
				<cfset fileName = listLast(coreFiles[i].xmlAttributes.name, "/")>
				<!--- Write the file to the filesystem --->
				<cfset fileResult = application.core.saveFile(fileDir,fileName,remoteFile)>
				<!--- Prepare results for the log --->
				<cfif fileResult>
					<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong>updated</strong><br />">
				<cfelse>
					<cfset returnString = returnString & application.core.filePathToWebPath(fileDir) & "/" & fileName & " <strong style='color:##990000;'>error!</strong><br />">
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- If no files have been updated, let the user know --->
	<cfif returnString IS "">
		<cfset returnString = "Nothing to update, all files are the most current versions!">
	</cfif>
	
	<cfoutput>#returnString#</cfoutput>
	
</cffunction>


<cffunction name="getMeta" access="private" returntype="string" output="false" hint="Gets the metadata XML file from CFWheels.com">
	
	<cfhttp url="http://www.cfwheels.com/updater/meta.xml" method="get">
	
	<cfreturn cfhttp.fileContent>
	
</cffunction>
--->

<cffunction name="getRemoteMd5" access="private" returntype="string" output="false" hint="Gets a hash of the remote the file">
	<cfargument name="file" type="string" required="true" hint="The file to get">
	
	<cfreturn remoteService.getMd5(arguments.file)>
</cffunction>


<cffunction name="getLocalMd5" access="private" returntype="string" output="false" hint="Gets an MD5 has of the local version of a file">
	<cfargument name="file" type="string" required="true" hint="The file to get">
	
	<cfset var localMd5 = "">
	<cfset var fileHash = "">
	<cfset var filePath = "#application.absolutePathTo.cfwheels##replace(arguments.file,"/","\","all")#">
	
	<cfif fileExists(filePath)>
		<cffile action="read" file="#filePath#" variable="fileContents">
		<cfset fileHash = hash(fileContents)>
	</cfif>
	
	<cfreturn fileHash>
</cffunction>


<cffunction name="getRemoteFile" access="private" returntype="string" output="false" hint="Gets the remote file from CFWheels.com">
	<cfargument name="file" type="string" required="true" hint="The file to get">

	<cfreturn remoteService.getFile(arguments.file)>
</cffunction>
