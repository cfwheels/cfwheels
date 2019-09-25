<cfscript>

public void function onAbort(required targetpage) {
	$include(template="#application.wheels.eventPath#/onabort.cfm");
}

</cfscript>
