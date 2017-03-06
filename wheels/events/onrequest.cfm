<cfscript>

public void function onRequest(required targetpage) {
	lock name="reloadLock#application.applicationName#" type="readOnly" timeout="180" {
		include "#arguments.targetpage#";
	}
}

</cfscript>
