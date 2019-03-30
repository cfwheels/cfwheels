<cfscript>
/**
* Internal GUI Routes
* TODO: seperate out into their own tab in interface
* TODO: formalise how the cli interacts
* TODO: fix migrator loop/js
* TODO: add some redirects for old params?
**/
mapper()
 	.namespace(name="wheels")
		.get(name="info", pattern="info", to="gui##info")
		.get(name="routes", pattern="routes", to="gui##routes")
		.get(name="packages", pattern="packages", to="gui##packages")
		.get(name="migrate", pattern="migrate", to="gui##migrate")
		.get(name="tests", pattern="tests", to="gui##tests")
		.get(name="docs", pattern="docs", to="gui##docs")
		.root(method="get", to="gui##index", mapFormat=false)
 	.end()
.end();

</cfscript>
