<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	
	<cffunction name="setup">
		<cfset $$oldCGIScope = request.cgi>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset request.cgi = $$oldCGIScope>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_html">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset request.cgi.http_accept = "text/html">
		<cfset assert("controller.$requestContentType() eq 'html'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_html">
		<cfset params.format = "html">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset assert("controller.$requestContentType() eq 'html'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_xml">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset request.cgi.http_accept = "text/xml">
		<cfset assert("controller.$requestContentType() eq 'xml'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_xml">
		<cfset params.format = "xml">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset assert("controller.$requestContentType() eq 'xml'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_json">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset request.cgi.http_accept = "text/json">
		<cfset assert("controller.$requestContentType() eq 'json'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_json">
		<cfset params.format = "json">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset assert("controller.$requestContentType() eq 'json'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_csv">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset request.cgi.http_accept = "text/csv">
		<cfset assert("controller.$requestContentType() eq 'csv'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_csv">
		<cfset params.format = "csv">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset assert("controller.$requestContentType() eq 'csv'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_xls">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset request.cgi.http_accept = "application/vnd.ms-excel">
		<cfset assert("controller.$requestContentType() eq 'xls'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_xls">
		<cfset params.format = "xls">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset assert("controller.$requestContentType() eq 'xls'")>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_pdf">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset request.cgi.http_accept = "application/pdf">
		<cfset assert("controller.$requestContentType() eq 'pdf'")>
	</cffunction>

	<cffunction name="test_$requestContentType_params_pdf">
		<cfset params.format = "pdf">
		<cfset controller = $controller(name="dummy").new(params)>
		<cfset assert("controller.$requestContentType() eq 'pdf'")>
	</cffunction>

</cfcomponent>