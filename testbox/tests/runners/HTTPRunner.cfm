<cfparam name="url.reporter" default="simple">
<cfhttp url="http://#cgi.server_name#:#cgi.server_port#/testbox/system/TestBox.cfc" throwonerror="true" redirect="true" result="results">
	<cfhttpparam name="method" value="runRemote" type="URL"/>
	<cfhttpparam name="bundles" value="testbox.tests.specs.BDDTest" type="URL"/>
	<cfhttpparam name="reporter" value="#url.reporter#" type="URL"/>
</cfhttp>
<cfdump var="#results#">