<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset $$oldCGIScope = request.cgi>
		<cfset params = {controller="dummy", action="dummy"}>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = $$oldCGIScope>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_html">
		<cfset loc.controller = controller("dummy", params)>
		<cfset request.cgi.http_accept = "text/html">
		<cfset assert(loc.controller.$requestContentType() eq 'html')>
	</cffunction>

	<cffunction name="test_$requestContentType_params_html">
		<cfset params.format = "html">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert(loc.controller.$requestContentType() eq 'html')>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_xml">
		<cfscript>
			loc.controller = controller("dummy", params);
			request.cgi.http_accept = "text/xml";
			assert(loc.controller.$requestContentType() == "xml");
		</cfscript>
	</cffunction>

	<cffunction name="test_$requestContentType_params_xml">
		<cfset params.format = "xml">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert(loc.controller.$requestContentType() eq 'xml')>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_json">
		<cfscript>
			loc.controller = controller("dummy", params);
			request.cgi.http_accept = "application/json";
			assert(loc.controller.$requestContentType() eq 'json');
		</cfscript>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_json_and_js">
		<cfscript>
			loc.controller = controller("dummy", params);
			request.cgi.http_accept = "application/json, application/javascript";
			assert(loc.controller.$requestContentType() eq 'json');
		</cfscript>
	</cffunction>

	<cffunction name="test_$requestContentType_params_json">
		<cfset params.format = "json">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert(loc.controller.$requestContentType() eq 'json')>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_csv">
		<cfscript>
			loc.controller = controller("dummy", params);
			request.cgi.http_accept = "text/csv";
			assert(loc.controller.$requestContentType() eq 'csv');
		</cfscript>
	</cffunction>

	<cffunction name="test_$requestContentType_params_csv">
		<cfset params.format = "csv">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert(loc.controller.$requestContentType() eq 'csv')>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_xls">
		<cfscript>
			loc.controller = controller("dummy", params);
			request.cgi.http_accept = "application/vnd.ms-excel";
			assert(loc.controller.$requestContentType() eq 'xls');
		</cfscript>
	</cffunction>

	<cffunction name="test_$requestContentType_params_xls">
		<cfset params.format = "xls">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert(loc.controller.$requestContentType() eq 'xls')>
	</cffunction>

	<cffunction name="test_$requestContentType_header_cgi_pdf">
		<cfscript>
			loc.controller = controller("dummy", params);
			request.cgi.http_accept = "application/pdf";
			assert(loc.controller.$requestContentType() eq 'pdf');
		</cfscript>
	</cffunction>

	<cffunction name="test_$requestContentType_params_pdf">
		<cfset params.format = "pdf">
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert(loc.controller.$requestContentType() eq 'pdf')>
	</cffunction>

</cfcomponent>
