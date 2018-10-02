component extends="wheels.tests.Test" {

	/**
	* Note, when testing headers, the result from getPageContext().getResponse().getHeader
	* Can't be assigned to a variable, as it will return Java Null:isEmpty
	* So you need to directly test it
	* Quote from ACF : Don't JavaCast("null","") to a ColdFusion variable. Unexpected results will occur.
	**/

	function setup() {
		$$oldCGIScope = request.cgi;
		$$oldHeaders = request.wheels.httprequestdata.headers;
		$$originalRoutes = application[$appKey()].routes;
		application.wheels.allowCorsRequests = true;
		d = $createObjectFromRoot(path="wheels", fileName="Dispatch", method="$init");
		$resetHeaders();
    	application[$appKey()].routes = [];
		config = {
		  path="wheels",
		  fileName="Mapper",
		  method="$init"
		};
	}

	function teardown() {
		request.cgi = $$oldCGIScope;
		request.wheels.httprequestdata.headers = $$oldHeaders;
    	application[$appKey()].routes = $$originalRoutes;
		application[$appKey()].allowCorsRequests = false;
		d="";
		$resetHeaders();
	}

	function test_$setCORS_Headers_sets_Defaults(){
		 d.$setCORSHeaders();
		 origin = $getHeader('Access-Control-Allow-Origin');
		 allowHeaders = $getHeader('Access-Control-Allow-Headers');
		 allowMethods = $getHeader('Access-Control-Allow-Methods');
		 assert("origin EQ '*'");
		 assert("allowHeaders EQ 'Origin, Content-Type, X-Auth-Token, X-Requested-By, X-Requested-With'");
		 assert("allowMethods EQ 'GET, POST, PATCH, PUT, DELETE, OPTIONS'");
	}
	function test_$setCORS_Headers_sets_Origin_as_wildcard(){
		 d.$setCORSHeaders(allowOrigin = "*");
		 origin = $getHeader('Access-Control-Allow-Origin');
		 assert("origin EQ '*'");
	}
	function test_$setCORS_Headers_sets_Origin_as_simple_string(){
		request.wheels.httprequestdata.headers['origin'] = "http://www.mydomain.com";
		 d.$setCORSHeaders(allowOrigin = "http://www.mydomain.com");
		 origin = $getHeader('Access-Control-Allow-Origin');
		 assert("origin EQ 'http://www.mydomain.com'");
	}
	function test_$setCORS_Headers_ignores_Origin_as_simple_string(){
		request.wheels.httprequestdata.headers['origin'] = "http://www.baddomain.com";
		 d.$setCORSHeaders(allowOrigin = "http://www.mydomain.com");
		 assert("$getHeader('Access-Control-Allow-Origin') IS JavaCast('null', '')");
	}
	function test_$setCORS_Headers_sets_Origin_as_Array(){
		request.wheels.httprequestdata.headers['origin'] = "https://domain.com";
		 d.$setCORSHeaders(allowOrigin = "http://www.mydomain.com,https://domain.com");
		 origin = $getHeader('Access-Control-Allow-Origin');
		 assert("origin EQ 'https://domain.com'");
	}
	function test_$setCORS_Headers_ignores_Origin_as_Array(){
		request.wheels.httprequestdata.headers['origin'] = "https://BADdomain.com";
		 d.$setCORSHeaders(allowOrigin = "http://www.mydomain.com,https://domain.com");
		 assert("$getHeader('Access-Control-Allow-Origin') IS JavaCast('null', '')");
	}
	function test_$setCORS_Headers_sets_Credentials(){
 		d.$setCORSHeaders(allowCredentials = true);
 		result = $getHeader('Access-Control-Allow-Credentials');
 		assert("result");
	}
	function test_$setCORS_Headers_sets_AllowHeaders(){
 		d.$setCORSHeaders(allowHeaders = "Origin, Content-Type, X-Auth-Token, X-Foo-Bar");
 		result = $getHeader('Access-Control-Allow-Headers');
 		assert("result EQ 'Origin, Content-Type, X-Auth-Token, X-Foo-Bar'");
	}
	function test_$setCORS_Headers_sets_AllowMethods(){
 		d.$setCORSHeaders(allowMethods = "GET, PUT, PATCH");
 		result = $getHeader('Access-Control-Allow-Methods');
 		assert("result EQ 'GET, PUT, PATCH'");
	}
	function test_$setCORS_Headers_sets_AllowMethodsByRouteGet(){
		$mapper().$draw()
			.resources(name="cats")
		.end();

 		d.$setCORSHeaders(allowMethodsByRoute = true, $pattern="/cats");

 		returnedMethods = $getHeader('Access-Control-Allow-Methods');
 		assert("returnedMethods EQ 'GET, POST'");
	}
	function test_$setCORS_Headers_sets_AllowMethodsByRouteShow(){
		$mapper().$draw()
			.resources(name="cats")
		.end();

 		d.$setCORSHeaders(allowMethodsByRoute = true, $pattern="/cats/[key]");

 		returnedMethods = $getHeader('Access-Control-Allow-Methods');
 		assert("returnedMethods EQ 'GET, PATCH, PUT, DELETE'");
	}
/**
* Helpers:
**/
	private function $getHeader(string name){
		if (StructKeyExists(server, "lucee")) {
			return getPageContext().getResponse().getHeader(arguments.name);
		} else {  
			// ACF: getHeader() doesn't exist in getResponse().. need alternative:::
			return getPageContext().getResponse().getHeader(arguments.name);
		}
	}

	private function $resetHeaders(){
		local.pc = getPageContext().getResponse(); 
		local.pc.setHeader('Access-Control-Allow-Origin', JavaCast("null", ""));
 		local.pc.setHeader('Access-Control-Allow-Headers', JavaCast("null", ""));
		local.pc.setHeader('Access-Control-Allow-Methods', JavaCast("null", ""));
		local.pc.setHeader('Access-Control-Allow-Credentials', JavaCast("null", "")); 
	}

	private struct function $mapper() {
		local.args = Duplicate(config);
		StructAppend(local.args, arguments, true);
		return $createObjectFromRoot(argumentCollection=local.args);
	}
}
