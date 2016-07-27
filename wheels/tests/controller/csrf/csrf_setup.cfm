<cfscript>

function setup() {
	variables.$oldRequestMethod = request.cgi.request_method;
  variables.$oldHttpXRequestedWith = request.cgi.http_x_requested_with;
}

function tearDown() {
	request.cgi.request_method = variables.$oldRequestMethod;
  request.cgi.http_x_requested_with = variables.$oldHttpXRequestedWith;
  StructDelete(request.headers, "X-CSRF-TOKEN");
}

</cfscript>
