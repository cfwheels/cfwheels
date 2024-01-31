<cfsilent>
	<!--- There is not need for the comment below because now all the dispatch requests are being made directly to this file. I am keeping it here temporarily --->
<!---
	Included from index.cfm (or /wheels/index.cfm when URL rewriting is in use) in the root folder.
	Uses the Dispatch object, which has been created on app start, to render content.
--->
</cfsilent><cfoutput>#application.wheels.dispatch.$request()#</cfoutput>