<cfscript>
	/*
		Here you can add routes to your application and edit the default one.
		The default route is the one that will be called on your application's "home" page.
	*/

	drawRoutes().root(to="wheels##wheels", method="get").end();
</cfscript>
