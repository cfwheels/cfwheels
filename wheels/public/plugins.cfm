<cfset variables[params.name] = application.wheels.plugins[params.name]>
<cfinclude template="../../plugins/#$fileForInclude(params.name&'/index')#">