<cfscript>
// This file is included from Application.cfc in the root folder.

// Put variables we just need internally inside a wheels struct.
this.wheels = {};
this.wheels.rootPath = GetDirectoryFromPath(GetBaseTemplatePath());

// Give this application a unique name by taking the path to the root and hashing it.
this.name = Hash(this.wheels.rootPath);

// Add mapping to the root of the site (e.g. C:\inetpub\wwwroot\, C:\inetpub\wwwroot\appfolder\).
// This is useful when extending controllers and models in parent folders (e.g. extends="app.controllers.Controller").
this.mappings["/app"] = this.wheels.rootPath;

// Add mapping to the wheels folder inside the app folder (e.g. C:\inetpub\wwwroot\appfolder\wheels).
// This is used extensively when writing tests.
this.mappings["/wheels"] = this.wheels.rootPath & "wheels";

// We turn on "sessionManagement" by default since the Flash uses it.
this.sessionManagement = true;

// If a plugin has a jar or class file, automatically add the mapping to this.javasettings.
this.wheels.pluginDir = this.wheels.rootPath & "plugins";
this.wheels.pluginFolders = DirectoryList(this.wheels.pluginDir, "true", "path", "*.class|*.jar|*.java");

for (this.wheels.folder in this.wheels.pluginFolders) {
	if(!structKeyExists(this, "javaSettings")){
		this.javaSettings={};
	}
	if(!structKeyExists(this.javaSettings, "LoadPaths")){
		this.javaSettings.LoadPaths=[];
	}
	this.wheels.pluginPath = GetDirectoryFromPath(this.wheels.folder);
	if (!ArrayFind(this.javaSettings.LoadPaths, this.wheels.pluginPath)) {
		ArrayAppend(this.javaSettings.LoadPaths, this.wheels.pluginPath);
	}
}

// Include developer's app config so they can set their own variables in this scope (or override "sessionManagement").
// Include Wheels controller and global functions.
// Include Wheels event functions (which in turn includes the developer's event files).
if (StructKeyExists(server, "lucee")) {
	include "../config/app.cfm";
	include "controller/appfunctions.cfm";
	include "global/appfunctions.cfm";
	include "events/onapplicationend.cfm";
	include "events/onapplicationstart.cfm";
	include "events/onerror.cfm";
	include "events/onmissingtemplate.cfm";
	include "events/onsessionend.cfm";
	include "events/onsessionstart.cfm";
	include "events/onrequest.cfm";
	include "events/onrequestend.cfm";
	include "events/onrequeststart.cfm";
} else {
	include "config/app.cfm";
	include "wheels/controller/appfunctions.cfm";
	include "wheels/global/appfunctions.cfm";
	include "wheels/events/onapplicationend.cfm";
	include "wheels/events/onapplicationstart.cfm";
	include "wheels/events/onerror.cfm";
	include "wheels/events/onmissingtemplate.cfm";
	include "wheels/events/onsessionend.cfm";
	include "wheels/events/onsessionstart.cfm";
	include "wheels/events/onrequest.cfm";
	include "wheels/events/onrequestend.cfm";
	include "wheels/events/onrequeststart.cfm";
}

</cfscript>
