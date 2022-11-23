<cfscript>
// public void function onApplicationEnd(required struct applicationScope) {
	$include(
		template = "/app/#arguments.applicationScope.wheels.eventPath#/onapplicationend.cfm",
		argumentCollection = arguments
	);
// }
</cfscript>
