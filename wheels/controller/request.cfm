<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="isSecure" returntype="boolean" access="public" output="false">
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

<cffunction name="isAjax" returntype="boolean" access="public" output="false">
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

<cffunction name="isGet" returntype="boolean" access="public" output="false">
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

<cffunction name="isPost" returntype="boolean" access="public" output="false">
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

<cffunction name="pagination" returntype="struct" access="public" output="false">
	<cfargument name="handle" type="string" required="false" default="query">
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