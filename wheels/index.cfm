<!---
	Included from index.cfm (or rewrite.cfm when URL rewriting is in use) in the root folder.
	Uses the Dispatch object, which has been created on app start, to render content.
--->
<cfoutput>#application.wheels.dispatch.$request()#</cfoutput>