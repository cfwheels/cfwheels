<cfscript>

function setup() {
	variables.$oldRequestMethod = request.cgi.request_method;
}

function tearDown() {
	request.cgi.request_method = variables.$oldRequestMethod;
}

</cfscript>
