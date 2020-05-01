<cfscript>
/*
This is just a proof of concept
*/
function index() {
	include "views/congratulations.cfm";
	return "";
}
function info() {
	include "views/info.cfm";
	return "";
}
function routes() {
	include "views/routes.cfm";
	return "";
}
function routetester(verb, path) {
	include "views/routetester.cfm";
	return "";
}
function routetesterprocess(verb, path) {
	include "views/routetesterprocess.cfm";
	return "";
}
function docs() {
	include "views/docs.cfm";
	return "";
}
function packages() {
	include "views/packages.cfm";
	return "";
}
function tests() {
	include "views/tests.cfm";
	return "";
}
function migrator() {
	include "views/migrator.cfm";
	return "";
}
function migratortemplates() {
	include "views/templating.cfm";
	return "";
}
function migratortemplatescreate() {
	include "migrator/templating.cfm";
	return "";
}
function migratorcommand() {
	include "migrator/command.cfm";
	return "";
}
function migratorsql() {
	include "migrator/sql.cfm";
	return "";
}
function cli() {
	include "views/cli.cfm";
	return "";
}
function plugins() {
	include "views/plugins.cfm";
	return "";
}
function pluginentry() {
	include "views/pluginentry.cfm";
	return "";
}
function build() {
	setting requestTimeout=10000 showDebugOutput=false;
	zipPath = $buildReleaseZip();
	$header(name = "Content-disposition", value = "inline; filename=#GetFileFromPath(zipPath)#");
	$content(file = zipPath, type = "application/zip", deletefile = true);
	return "";
}

/*
	Check for legacy urls and params
	Example Strings to test against
	?controller=wheels&action=wheels&
		view=routes
		view=docs
		view=build
		view=migrate
		view=cli

		// Pacakges
		view=packages&type=core
		view=packages&type=app
		view=packages&type=[PLUGIN]

		// Test Runnner
		view=tests&type=core
		view=tests&type=app
		view=tests&type=[PLUGIN]
	*/
function wheels() {
	local.action = StructKeyExists(request.wheels.params, "action") ? request.wheels.params.action : "";
	local.view = StructKeyExists(request.wheels.params, "view") ? request.wheels.params.view : "";
	local.type = StructKeyExists(request.wheels.params, "type") ? request.wheels.params.type : "";
	switch (local.view) {
		case "routes":
		case "docs":
		case "cli":
		case "tests":
			include "views/#local.view#.cfm";
			break;
		case "packages":
			include "views/packages.cfm";
			break;
		case "migrate":
			include "views/migrator.cfm";
			break;
		default:
			include "views/congratulations.cfm";
			break;
	}
	return "";
}
</cfscript>
