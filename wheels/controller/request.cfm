<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="isSecure" returntype="boolean" access="public" output="false" hint="Returns whether CFWheels is communicating over a secure port."
	examples=
	'
		// Redirect non-secure connections to the secure version
		if (!isSecure())
		{
			redirectTo(protocol="https");
		}
	'
	categories="controller-request,miscellaneous" chapters="" functions="isGet,isPost,isAjax">
	<cfscript>
		var loc = {};
		if (request.cgi.server_port_secure == "true")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isAjax" returntype="boolean" access="public" output="false" hint="Returns whether the page was called from JavaScript or not."
	examples=
	'
		requestIsAjax = isAjax();
	'
	categories="controller-request,miscellaneous" chapters="" functions="isGet,isPost,isSecure">
	<cfscript>
		var loc = {};
		if (request.cgi.http_x_requested_with == "XMLHTTPRequest")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isGet" returntype="boolean" access="public" output="false" hint="Returns whether the request was a normal `GET` request or not."
	examples=
	'
		requestIsGet = isGet();
	'
	categories="controller-request,miscellaneous" chapters="" functions="isAjax,isPost,isSecure">
	<cfscript>
		var loc = {};
		if (request.cgi.request_method == "get")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="isPost" returntype="boolean" access="public" output="false" hint="Returns whether the request came from a form `POST` submission or not."
	examples=
	'
		requestIsPost = isPost();
	'
	categories="controller-request,miscellaneous" chapters="" functions="isAjax,isGet,isSecure">
	<cfscript>
		var loc = {};
		if (request.cgi.request_method == "post")
		{
			loc.rv = true;
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="pagination" returntype="struct" access="public" output="false" hint="Returns a struct with information about the specificed paginated query. The keys that will be included in the struct are `currentPage`, `totalPages` and `totalRecords`."
	examples=
	'
		allAuthors = model("author").findAll(page=1, perPage=25, order="lastName", handle="authorsData");
		paginationData = pagination("authorsData");
	'
	categories="controller-request,miscellaneous" chapters="getting-paginated-data,displaying-links-for-pagination" functions="paginationLinks,findAll">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query to return pagination information for.">
	<cfscript>
		var loc = {};
		if (get("showErrorInformation"))
		{
			if (!StructKeyExists(request.wheels, arguments.handle))
			{
				$throw(type="Wheels.QueryHandleNotFound", message="CFWheels couldn't find a query with the handle of `#arguments.handle#`.", extendedInfo="Make sure your `findAll` call has the `page` argument specified and matching `handle` argument if specified.");
			}
		}
		loc.rv = request.wheels[arguments.handle];
	</cfscript>
	<cfreturn loc.rv>
</cffunction>