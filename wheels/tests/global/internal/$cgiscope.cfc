<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.cgi_scope = {}>
		<cfset loc.cgi_scope.path_info = "/users/list/index.cfm">
		<cfset loc.cgi_scope.http_x_rewrite_url = "/users/list/http_x_rewrite_url/index.cfm?controller=wheels&action=wheels&view=test">
		<cfset loc.cgi_scope.http_x_original_url = "/users/list/http_x_original_url/index.cfm?controller=wheels&action=wheels&view=test">
		<cfset loc.cgi_scope.request_uri = "/users/list/request_uri/index.cfm?controller=wheels&action=wheels&view=test">
		<cfset loc.cgi_scope.redirect_url = "/users/list/redirect_url/index.cfm?controller=wheels&action=wheels&view=test">
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
		<cfset assert('loc.cgi.path_info eq "/users/list/redirect_url"')>
	</cffunction>

	<cffunction name="test_path_info_should_remove_trailing_slash">
		<cfset loc.cgi_scope.path_info = "">
		<cfset loc.cgi = $cgiScope(scope=loc.cgi_scope)>
		<cfset assert('loc.cgi.path_info eq "/users/list/http_x_rewrite_url"')>
	</cffunction>

	<cffunction name="test_path_info_non_ascii">
		<cfscript>
			loc.e = {script_name="/index.cfm", path_info="/wheels/wheels/%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81", unencoded_url="/index.cfm/wheels/wheels/%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81?normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81", query_string="normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81"};
			loc.scope = {script_name="/index.cfm", path_info="/wheels/wheels/????", unencoded_url="/index.cfm/wheels/wheels/%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81?normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81", query_string="normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81"};
			loc.r = $cgiScope(keys="script_name,path_info,unencoded_url,query_string", scope=loc.scope);
			assert('loc.r.path_info IS URLDecode(loc.e.path_info)');
		</cfscript>
	</cffunction>

</cfcomponent>