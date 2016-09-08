<cfscript>
	request.cgi.request_method = variables.$oldRequestMethod;
	request.cgi.http_x_requested_with = variables.$oldHttpXRequestedWith;
	StructDelete(request.headers, "X-CSRF-TOKEN");
</cfscript>
