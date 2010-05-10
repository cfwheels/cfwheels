<cffunction name="isSecure" returntype="boolean" access="public" output="false" hint="Returns whether wheels is communicating over a secure port."
	examples=
	'
		<cfset requestIsSecure = isSecure()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isGet,isPost,isAjax">
	<cfscript>
		var returnValue = "";
		if (request.cgi.server_port_secure == true)
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isAjax" returntype="boolean" access="public" output="false" hint="Returns whether the page was called from JavaScript or not."
	examples=
	'
		<cfset requestIsAjax = isAjax()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isGet,isPost,isSecure">
	<cfscript>
		var returnValue = "";
		if (request.cgi.http_x_requested_with == "XMLHTTPRequest")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isGet" returntype="boolean" access="public" output="false" hint="Returns whether the request was a normal (GET) request or not."
	examples=
	'
		<cfset requestIsGet = isGet()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isAjax,isPost,isSecure">
	<cfscript>
		var returnValue = "";
		if (request.cgi.request_method == "get")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="isPost" returntype="boolean" access="public" output="false" hint="Returns whether the request came from a form submission or not."
	examples=
	'
		<cfset requestIsPost = isPost()>
	'
	categories="controller-request,miscellaneous" chapters="" functions="isAjax,isGet,isSecure">
	<cfscript>
		var returnValue = "";
		if (request.cgi.request_method == "post")
			returnValue = true;
		else
			returnValue = false;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="pagination" returntype="struct" access="public" output="false" hint="Returns a struct with information about the specificed paginated query. The variables that will be returned are `currentPage`, `totalPages` and `totalRecords`."
	examples=
	'
		<cfparam name="params.page" default="1">
		<cfset allAuthors = model("author").findAll(page=params.page, perPage=25, order="lastName", handle="authorsData")>
		<cfset paginationData = pagination("authorsData")>
	'
	categories="controller-request,miscellaneous" chapters="getting-paginated-data,displaying-links-for-pagination" functions="paginationLinks,findAll">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query to return pagination information for.">
	<cfscript>
		if (application.wheels.showErrorInformation)
		{
			if (!StructKeyExists(request.wheels, arguments.handle))
			{
				$throw(type="Wheels.QueryHandleNotFound", message="Wheels couldn't find a query with the handle of `#arguments.handle#`.", extendedInfo="Make sure your `findAll` call has the `page` argument specified and matching `handle` argument if specified.");
			}
		}
	</cfscript>
	<cfreturn request.wheels[arguments.handle]>
</cffunction>