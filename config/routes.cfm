<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// See http://docs.cfwheels.org/docs/using-routes for more info.

	drawRoutes()
		// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
		// This way you don't need to explicitly add a route every time you create a new action in a controller.
		.wildcard()

		// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
		// You can, for example, change "wheels##wheels" to "home##index" to call the "index" action on the "home" controller instead.
		.root(to="wheels##wheels", method="get")
	.end();

</cfscript>
