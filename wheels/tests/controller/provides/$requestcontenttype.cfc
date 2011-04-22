<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>
	
	<cffunction name="setup">
		<cfset $$oldCGIScope = request.cgi>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset request.cgi = $$oldCGIScope>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_html">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "text/html">
		<cfset assert("loc.controller.$requestContentType() eq 'html'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_html">
		<cfset params.format = "html">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'html'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_xml">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "text/xml">
		<cfset assert("loc.controller.$requestContentType() eq 'xml'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_xml">
		<cfset params.format = "xml">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'xml'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_json">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "application/json">
		<cfset assert("loc.controller.$requestContentType() eq 'json'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_json">
		<cfset params.format = "json">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'json'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_csv">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "text/csv">
		<cfset assert("loc.controller.$requestContentType() eq 'csv'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_csv">
		<cfset params.format = "csv">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'csv'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_xls">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "application/vnd.ms-excel">
		<cfset assert("loc.controller.$requestContentType() eq 'xls'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_xls">
		<cfset params.format = "xls">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'xls'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_pdf">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "application/pdf">
		<cfset assert("loc.controller.$requestContentType() eq 'pdf'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_pdf">
		<cfset params.format = "pdf">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'pdf'")>
	</cffunction>
	
	<cffunction name="test_$requestContentType_header_cgi_js">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "text/javascript">
		<cfset assert("loc.controller.$requestContentType() eq 'js'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_js">
		<cfset params.format = "js">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert("loc.controller.$requestContentType() eq 'js'")>
	</cffunction>

</cfcomponent>