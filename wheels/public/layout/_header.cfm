<cfscript>
// NB ACF10/11 throw duplicate routines if aleady defined here
if (!IsDefined("pageHeader")) {
	include "../helpers.cfm";
}

// Css Path
request.wheelsInternalAssetPath = application.wheels.webpath & "wheels/public/assets";

// Primary Navigation
request.navigation = [
	{
		route = "wheelsInfo",
		title = "System Information",
		isFluid = false,
		text = "<i class='info circle icon'></i> Info"
	},
	{
		route = "wheelsRoutes",
		title = "Routes",
		isFluid = false,
		text = "<i class='random icon'></i> Routes"
	},
	{
		route = "wheelsDocs",
		title = "Docs",
		isFluid = true,
		text = "<i class='icon file alternate'></i> Docs"
	},
	{
		route = "wheelsPackages",
		type = "app",
		title = "Test Packages",
		isFluid = false,
		text = "<i class='tasks icon'></i> Tests"
	}
];
if (application.wheels.enableMigratorComponent) {
	ArrayAppend(
		request.navigation,
		{
			route = "wheelsMigrator",
			title = "Migrator",
			isFluid = false,
			text = "<i class='database icon'></i> Migrator"
		}
	);
}
if (application.wheels.enablePluginsComponent) {
	ArrayAppend(
		request.navigation,
		{
			route = "wheelsPlugins",
			title = "Plugins",
			isFluid = false,
			text = "<i class='plug icon'></i> Plugins"
		}
	);
}

// Get Active Route Info
request.currentRoute = getActiveRoute(request.wheels.params.route, request.navigation);

// Page Title
request.internalPageTitle = StructKeyExists(request.currentRoute, 'title') ? request.currentRoute.title & ' | ' & "CFWheels" : "CFWheels";

request.wheels.internalHeaderLoaded = true;

if (StructKeyExists(url, "refresh")) {
	_refresh = 3;
	if (IsNumeric(url.refresh)) {
		_refresh = url.refresh;
	}
}
</cfscript>
<cfparam name="request.isFluid" default="false">
<cfoutput>
	<DOCTYPE html>
	<html>
	<head>
		<title>#request.internalPageTitle#</title>
		<meta charset="utf-8">
		<meta name="robots" content="noindex,nofollow">
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="Expires" content="0">
		<cfif StructKeyExists(variables, "_refresh")>
			<meta http-equiv="refresh" content="#_refresh#">
		</cfif>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.css">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.js"></script>
		<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css">
		<script src="https://semantic-ui.com/javascript/library/highlight.min.js"></script>
		<style>
			.h-100 {height:100%;}
			.forcescroll { overflow-y: scroll; max-height: 40rem;   }
			.margin-top { margin-top: 5em; }
		</style>
	</head>
	<body>
	<cfif request.isFluid>
		<div id="main" class="ui grid stackable h-100">
		<cfinclude template="_navigation.cfm">
		<div id="top" class="sixteen wide stretched column ">
		<div class="ui grid stackable">
	<cfelse>
		<div id="main">
		<cfinclude template="_navigation.cfm">
		<div id="top" class="margin-top">
	</cfif>
</cfoutput>
