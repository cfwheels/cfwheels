<cfscript>
	this.name = Hash(GetDirectoryFromPath(GetBaseTemplatePath()));
	this.mappings["/wheelsMapping"] = GetDirectoryFromPath(GetBaseTemplatePath()) & "wheels";
	this.mappings["/wheels"] = GetDirectoryFromPath(GetBaseTemplatePath()) & "wheels";
	this.sessionManagement = true;

    if(StructKeyExists(server, "lucee")){ 
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

