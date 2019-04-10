<cfscript>
/**
* Internal GUI Routes
* TODO: formalise how the cli interacts
* TODO: fix migrator loop/js
**/
mapper()
 	.namespace(name="wheels")
		.get(name="info", pattern="info", to="public##info")
		.get(name="routes", pattern="routes", to="public##routes")
		.post(name="routeTester", to="public##routetester")
		.get(name="packages", pattern="packages/[type]", to="public##packages")
		.get(name="migrator", pattern="migrator", to="public##migrator")
		.get(name="tests", pattern="tests", to="public##tests")
		.get(name="docs", pattern="docs", to="public##docs")
		.get(name="cli", pattern="cli", to="public##cli")
		.get(name="plugins", pattern="plugins", to="public##plugins")
		.get(name="build", pattern="build", to="public##build")
		.get(name="legacy", pattern="wheels/[view]", to="public##legacy")
		.root(method="get", to="public##index", mapFormat=false)
 	.end()
.end();

</cfscript>
