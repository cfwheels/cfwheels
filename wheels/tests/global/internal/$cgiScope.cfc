<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.cgi_scope = {}>
		<cfset loc.cgi_scope.path_info = "/users/list/index.cfm">
		<cfset loc.cgi_scope.http_x_rewrite_url = "/users/list/http_x_rewrite_url/index.cfm?controller=wheels&action=wheels&view=test">
		<cfset loc.cgi_scope.http_x_original_url = "/users/list/http_x_original_url/index.cfm?controller=wheels&action=wheels&view=test">
		<cfset loc.cgi_scope.request_uri = "/users/list/request_uri/index.cfm?controller=wheels&action=wheels&view=test">
		<cfset loc.cgi_scope.redirect_url = "/users/list/redirect_url/index.cfm?controller=wheels&action=wheels&view=test">
	</cffunction>

	<cffunction name="test_path_info_not_blank">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/users/list"')>
	</cffunction>
	
	<cffunction name="test_path_info_blank">
		<cfset loc.cgi_scope.path_info = "">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/users/list/http_x_rewrite_url"')>
		<cfset loc.cgi_scope.http_x_rewrite_url = "">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/users/list/http_x_original_url"')>
		<cfset loc.cgi_scope.http_x_original_url = "">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/users/list/request_uri"')>
		<cfset loc.cgi_scope.request_uri = "">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset debug('loc.cgi')>
		<cfset assert('loc.cgi.path_info eq "/users/list/redirect_url"')>
	</cffunction>
	
	<cffunction name="test_path_info_should_remove_trailing_slash">
		<cfset loc.cgi_scope.path_info = "">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/users/list/http_x_rewrite_url"')>
	</cffunction>
	
	<cffunction name="test_path_info_should_not_be_blank_when_just_root_index">
		<cfset loc.cgi_scope.path_info = "/index.cfm">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/"')>
	</cffunction>

</cfcomponent>