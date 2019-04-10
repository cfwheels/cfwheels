<cfscript>

/**
* Page Header
*
* @title string
* @subtitle string
**/
function pageHeader(string title ="", string subTitle=""){
	local.rv = '<h1 class="ui dividing header">';
	local.rv &= arguments.title;
	local.rv &= '<div class="sub header">';
	local.rv &= arguments.subtitle;
	local.rv &= '</div></h1>';
	return local.rv;
}
/**
* Start table markup
*
* @title Name for header title
* @colspan Colspan of header
**/
function startTable(string title ="", colspan=2){
	local.rv = '<table class="ui celled striped table"><thead><tr><th colspan="';
	local.rv &= arguments.colspan;
	local.rv &= '">';
	local.rv &= arguments.title;
	local.rv &= '</th></tr></thead><tbody>';
	return local.rv;
}
/**
* End table markup
**/
function endTable(){
	return "</tbody></table>";
}
/**
* Start tab markup
*
* @tab id of tab
* @active whether active
**/
function startTab(string tab="", boolean active = false){
	local.rv = '<div class="ui bottom attached tab segment';
	if(arguments.active)
		local.rv &= ' active ';
	local.rv &= '" data-tab="';
	local.rv &= arguments.tab;
	local.rv &= '">';
	return local.rv;
}
/**
* End tab markup
**/
function endTab(){
	return '</div>';
}
/**
* Determine CSS Class of http verb
*
* @verb http verb
**/
function httpVerbClass(string verb){
	switch(arguments.verb){
		case "GET":
			return "green";
		 break;
		case "POST":
			return "blue";
		 break;
		case "PUT":
			return "violet";
		 break;
		case "PATCH":
			return "purple";
		 break;
		case "DELETE":
			return "red";
		 break;
	}
}
/**
* Markup for main environment setting output
*
* @setting array of settings with corresponding env vars
**/
function outputSetting(array setting){
	local.rv = "";
	for (var i=1;i LTE ArrayLen(arguments.setting);i=i+1) {
		local.rv &= '<tr><td class="four wide">';
		local.rv &= rereplace(rereplace(arguments.setting[i],"(^[a-z])","\u\1"),"([A-Z])"," \1","all");
		local.rv &= '</td><td class="eight wide">';
		local.rv &= formatSettingOutput( get(arguments.setting[i]) );
		local.rv &= '</td></tr>';
	}
	return local.rv;
}
/**
* Format any setting into something more pretty for output
*
* @val any type of value
**/
function formatSettingOutput(any val){
	local.rv = '';
	local.val = arguments.val;
	if(isSimpleValue(local.val)){
		if(isBoolean(local.val)){
			if(local.val){
				local.rv = '<i class="icon check" />';
			} else {
				local.rv = '<i class="icon close" />';
			}
		} else if( listLen(local.val, ',') GT 4 ) {
			for(var item in local.val){
				local.rv &= item & '<br>';
			}
		} else if( !len(local.val) ){
			local.rv = '<em>Empty String</em>';
		} else {
			local.rv = arguments.val;
		}
	} else if(isArray(local.val)){
		for(var i=1;i LTE ArrayLen(local.val);i=i+1){
			local.rv &= i & '->' & local.val[i] & '<br>';
		}
	}  else if(isStruct(local.val)){
		for(var item in local.val){
			local.rv &= item & '->' & local.val[item] & '<br>';
		}
	} else {
		local.rv = '<i class="icon question"></i>';
	}
	return local.rv;
}
/**
* Return active route from nav
*
* @testFor name of route
* @navigation array
**/
function getActiveRoute(required string testFor, array navigation){
	local.rv = {};
	for(local.n in arguments.navigation){
		if(local.n.route == arguments.testFor)
			local.rv = local.n;
	}
	return local.rv;
}
/**
* Output a route row
**/
function outputRouteRow(struct route){
	local.rv = "<tr>";
	local.rv &= "<td>" & route.name & "</td>";
	local.rv &= "<td><div class='ui " & httpVerbClass(EncodeForHtml(ucase(route.methods))) & " horizontal label'>" & route.methods & "</div></td>";
	local.rv &= "<td>" & route.pattern & "</td>";
	if(StructKeyExists(route, "redirect")){
		local.rv &= "<td colspan='2'>" & truncate(EncodeForHtml(route.redirect), 70) & "</td>";
	} else {
		local.rv &= "<td>";
		if(StructKeyExists(route, "controller")){
			local.rv &= route.controller;
		}
		local.rv &= "</td><td>";
		if(StructKeyExists(route, "action")){
			local.rv &= route.action ;
		}
		local.rv &= "</td>";
	}
	local.rv &= "</td></tr>"
	return local.rv;
}

/**
 * Altered Internal function for route tester
 */
public struct function $findMatchingRoutes(
	string path = request.wheels.params.path,
	string requestMethod= request.wheels.params.verb
) {
	local.rv = {}
	local.matches = [];
	local.errors = [];

	// If this is a HEAD request, look for the corresponding GET route
	if (arguments.requestMethod == 'HEAD'){
		arguments.requestMethod = 'GET';
	}
	// Remove leading / if not '/'
	if(left(arguments.path, 1) EQ "/" && arguments.path != "/")
		arguments.path=right(arguments.path, (len(arguments.path) - 1));

	// Loop over Wheels routes.
	for (local.route in application.wheels.routes) {

		if (StructKeyExists(local.route, "methods") && !ListFindNoCase(local.route.methods, arguments.requestMethod))
			continue;

		if (!StructKeyExists(local.route, "regex"))
			local.route.regex = application.wheels.mapper.$patternToRegex(local.route.pattern);

		if (REFindNoCase(local.route.regex, arguments.path) || (!Len(arguments.path) && local.route.pattern == "/"))
			arrayAppend(local.matches, local.route);

	}

	local.alternativeMatchingMethodsForURL="";

	for (local.route in application.wheels.routes) {

		if (!StructKeyExists(local.route, "regex"))
			local.route.regex = application.wheels.mapper.$patternToRegex(local.route.pattern);

		if (REFindNoCase(local.route.regex, arguments.path) || (!Len(arguments.path) && local.route.pattern == "/"))
			local.alternativeMatchingMethodsForURL=ListAppend(local.alternativeMatchingMethodsForURL, local.route.methods);
	}

	if (!arrayLen(local.matches)){
		if ( len(local.alternativeMatchingMethodsForURL) ){
			arrayAppend(local.errors, {
				type="Wheels.RouteNotFound",
				message="Incorrect HTTP Verb for route",
				extendedInfo="The `#arguments.path#` path does not allow `#arguments.requestMethod#` requests, only `#UCASE(local.alternativeMatchingMethodsForURL)#` requests. Ensure you are using the correct HTTP Verb and that your `config/routes.cfm` file is configured correctly."
			});
		}
		else {
			arrayAppend(local.errors, {
				type="Wheels.RouteNotFound - 404",
				message="Could not find a route that matched this request",
				extendedInfo="Make sure there is a route configured in your `config/routes.cfm` file that matches the `#arguments.path#` request."
			});
		}
	}

	local.rv["matches"] = local.matches;
	local.rv["errors"] = local.errors;
	return local.rv;
}

function $getAllDatabaseInformation(){


	local.info = $dbinfo(
		type="version",
		datasource=application.wheels.dataSourceName,
		username=application.wheels.dataSourceUserName,
		password=application.wheels.dataSourcePassword
	);
	local.adapterName="";
	if (local.info.driver_name Contains "SQLServer" || local.info.driver_name Contains "Microsoft SQL Server" || local.info.driver_name Contains "MS SQL Server" || local.info.database_productname Contains "Microsoft SQL Server") {
		local.adapterName = "MicrosoftSQLServer";
	} else if (local.info.driver_name Contains "MySQL") {
		local.adapterName = "MySQL";
	} else if (local.info.driver_name Contains "PostgreSQL") {
		local.adapterName = "PostgreSQL";
	// NB: using mySQL adapter for H2 as the cli defaults to this for development
	} else if (local.info.driver_name Contains "H2") {
	// determine the emulation mode
	/*
	if (StructKeyExists(server, "lucee")) {
		local.connectionString = GetApplicationMetaData().datasources[application[local.appKey].dataSourceName].connectionString;
	} else {
		// TODO: use the coldfusion class to dig out dsn info
		local.connectionString = "";
	}
	if (local.connectionString Contains "mode=SQLServer" || local.connectionString Contains "mode=Microsoft SQL Server" || local.connectionString Contains "mode=MS SQL Server" || local.connectionString Contains "mode=Microsoft SQL Server") {
		local.adapterName = "MicrosoftSQLServer";
	} else if (local.connectionString Contains "mode=MySQL") {
		local.adapterName = "MySQL";
	} else if (local.connectionString Contains "mode=PostgreSQL") {
		local.adapterName = "PostgreSQL";
	} else {
		local.adapterName = "MySQL";
	}
	*/
		local.adapterName = "H2";
	}
	return local;
}
</cfscript>
