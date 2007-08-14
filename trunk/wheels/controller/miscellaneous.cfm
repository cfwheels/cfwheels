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