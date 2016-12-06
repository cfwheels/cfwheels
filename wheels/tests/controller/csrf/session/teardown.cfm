<cfscript>

request.cgi.request_method = $oldRequestMethod;
request.cgi.http_x_requested_with = $oldHttpXRequestedWith;
StructDelete(request.headers, "X-CSRF-TOKEN");
application.wheels.csrfStore = $oldCsrfStore;

</cfscript>
