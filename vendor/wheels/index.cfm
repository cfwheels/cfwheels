<cfsilent>
<!---
	Included from index.cfm in the public folder.
	Uses the Dispatch object, which has been created on app start, to render content.
--->
</cfsilent><cfoutput>#application.wheels.dispatch.$request()#</cfoutput>