<cffunction name="isGet" returntype="any" access="public" output="false">
	<cfif CGI.request_method IS "get">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="isPost" returntype="any" access="public" output="false">
	<cfif CGI.request_method IS "post">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="isAjax" returntype="any" access="public" output="false">
	<cfif CGI.HTTP_x_requested_with IS "XMLHTTPRequest">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="sendFile" returntype="any" access="public" output="false">
	<cfargument name="path" required="true">
	<cfargument name="filename" required="false" default="">
	<cfargument name="type" required="false" default="">
	<cfargument name="disposition" required="false" default="attachment">
	<cfset var local = structNew()>

	<cfset local.file_directory = expandPath(application.settings.paths.files)>

	<cfif arguments.path Contains ".">
		<cfset local.path = arguments.path>
	<cfelse>
		<cfdirectory action="list" directory="#local.file_directory#" name="local.match" filter="#arguments.path#.*">
		<cfset local.path = arguments.path & "." & listLast(local.match.name, ".")>
	</cfif>

	<cfset local.filename = listLast(local.path, "/")>

	<cfset local.extension = listLast(local.path, ".")>
	<cfif local.extension IS "txt">
		<cfset local.type = "text/plain">
	<cfelseif local.extension IS "gif">
		<cfset local.type = "image/gif">
	<cfelseif local.extension IS "jpg">
		<cfset local.type = "image/jpg">
	<cfelseif local.extension IS "png">
		<cfset local.type = "image/png">
	<cfelseif local.extension IS "wav">
		<cfset local.type = "audio/wav">
	<cfelseif local.extension IS "mp3">
		<cfset local.type = "audio/mpeg3">
	<cfelseif local.extension IS "pdf">
		<cfset local.type = "application/pdf">
	<cfelseif local.extension IS "zip">
		<cfset local.type = "application/zip">
	<cfelseif local.extension IS "ppt">
		<cfset local.type = "application/powerpoint">
	<cfelseif local.extension IS "doc">
		<cfset local.type = "application/word">
	<cfelseif local.extension IS "xls">
		<cfset local.type = "application/excel">
	<cfelse>
		<cfset local.type = "application/octet-stream">
	</cfif>

	<cfset local.file = "#local.file_directory#/#local.path#">

	<cfheader name="content-disposition" value="#arguments.disposition#; filename=#local.filename#">
	<cfcontent type="#local.type#" file="#local.file#">

	<cfreturn true>
</cffunction>


<cffunction name="getControllerClassData" returntype="any" access="public" output="false">
	<cfreturn variables.class>
</cffunction>