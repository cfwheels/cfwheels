<cfscript>

// Give this application a unique name by taking the path to the root and hashing it.
this.name = Hash(GetDirectoryFromPath(GetBaseTemplatePath()));

// Add mapping to the root of the site (e.g. C:\inetpub\wwwroot\, C:\inetpub\wwwroot\appfolder\).
// This is useful when extending controllers and models in parent folders (e.g. extends="app.controllers.Controller").
this.mappings["/app"] = GetDirectoryFromPath(GetBaseTemplatePath());

// Add mapping to the wheels folder inside the app folder (e.g. C:\inetpub\wwwroot\appfolder\wheels).
// This is used extensively when writing tests.
this.mappings["/wheels"] = GetDirectoryFromPath(GetBaseTemplatePath()) & "wheels";

// We turn on "sessionManagement" by default since the Flash uses it.
this.sessionManagement = true;

this.javaSettings={
	"LoadPaths"=[]
}

// If a plugin has a jar or class file, automatically add the mapping to this.javasettings
// This is perhaps a little high up in the load order? Need to double check effects of user overrides to `this`.
this.pluginFolders=DirectoryList(
	path=GetDirectoryFromPath(GetBaseTemplatePath()) & "plugins", recurse="true", filter="*.class|*.jar|*.java");
	
for (folder in this.pluginFolders) {
	if(!ArrayFind(this.javaSettings.LoadPaths, GetDirectoryFromPath(folder))){
		ArrayAppend(this.javaSettings.LoadPaths, GetDirectoryFromPath(folder));
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
