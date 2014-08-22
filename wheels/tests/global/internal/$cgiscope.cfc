<cfcomponent extends="wheelsMapping.Test">

	<!--- <cffunction name="test_basic_functionality">
		<cfscript>
			loc.e = {request_method="GET", server_port=80};
			loc.r = $cgiScope(keys="request_method,server_port");
			$assert('loc.e.equals(loc.r)');
		</cfscript>
	</cffunction>

	<cffunction name="test_path_info">
		<cfscript>
			loc.e = {request_method="GET", server_port=80, path_info="test/test/1"};
			loc.cgiScope = {request_method="GET", server_port=80, path_info="test/test/1"};
			loc.r = $cgiScope(keys="request_method,server_port,path_info", cgiScope=loc.cgiScope);
			$assert('loc.e.equals(loc.r)');
		</cfscript>
	</cffunction> --->

	<!--- <cffunction name="test_path_info_non_ascii">
		<cfscript>
			loc.e = {script_name="/index.cfm", path_info="/wheels/wheels/%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81", unencoded_url="/index.cfm/wheels/wheels/%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81?normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81", query_string="normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81"};
			loc.cgiScope = {script_name="/index.cfm", path_info="/wheels/wheels/????", unencoded_url="/index.cfm/wheels/wheels/%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81?normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81", query_string="normal=1&chinese=%E5%A5%B3%E5%A3%AB%E7%94%A8%E5%93%81"};
			loc.r = $cgiScope(keys="script_name,path_info,unencoded_url,query_string", cgiScope=loc.cgiScope);
			assert('loc.r.path_info IS URLDecode(loc.e.path_info)');
		</cfscript>
	</cffunction> --->

</cfcomponent>