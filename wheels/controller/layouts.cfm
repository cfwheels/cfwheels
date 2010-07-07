<cffunction name="usesLayout" access="public" returntype="void" output="false" hint="Used to specify a controller or action specific layout"
	examples=
	'
		<cffunction name="init">
			<!---
			We want this layout to be used as the default throughout the entire controller
			except for the index action
			 --->
			<cfset usesLayout("myLayout", except="myajax")>
		</cffunction>
		
		<cffunction name="index">
		</cffunction>
		
		<cffunction name="show">
		</cffunction>
		
		<cffunction name="create">
		</cffunction>		
		
		<cffunction name="edit">
		</cffunction>
		
		<cffunction name="myajax">
			<!---
			since this action is within the exception rule of the 
			default layout, it will not get a layout
			 --->
		</cffunction>
	'
	categories="controller-request,rendering" chapters="rendering-layout">
	<cfargument name="template" required="true" type="string" hint="the name of the layout template or method name you want to use">
	<cfargument name="except" type="string" required="false" hint="a list of actions that SHOULD NOT get the layout">
	<cfargument name="only" type="string" required="false" hint="a list of action that SHOULD ONLY get the layout">
	<cfargument name="useDefault" type="boolean" required="false" default="true" hint="when specifying conditions or a method, should we use the default layout if not satisfied">
	<!--- when the layout is a method, the method itself should handle all the logic --->
	<cfif (StructKeyExists(this, arguments.template) && IsCustomFunction(this[arguments.template])) || IsCustomFunction(arguments.template)>
		<cfset structDelete(arguments, "except", false)>
		<cfset structDelete(arguments, "only", false)>
	</cfif>
	<cfif StructKeyExists(arguments, "except")>		
		<cfset arguments.except = $listClean(arguments.except)>
	</cfif>
	<cfif StructKeyExists(arguments, "only")>
		<cfset arguments.only = $listClean(arguments.only)>
	</cfif>
	<cfset variables.$class.layout = arguments>
</cffunction>

<cffunction name="$useLayout" access="public" returntype="string" output="false">
	<cfargument name="$action" type="string" required="true">
	<cfscript>
	var loc= {};
	loc.ret = true;
	if (!StructIsEmpty(variables.$class.layout))
	{
		loc.ret = variables.$class.layout.useDefault;
		if ((StructKeyExists(this, variables.$class.layout.template) && IsCustomFunction(this[variables.$class.layout.template])) || IsCustomFunction(variables.$class.layout.template))
		{
			// if the developer doesn't return anything from the method or if they return a blank string
			// it should use the default layout still
			loc.temp = $invoke(method=variables.$class.layout.template, action=arguments.$action);
			if (StructKeyExists(loc, "temp"))
			{
				loc.ret = loc.temp;
			}
		}
		else if((!StructKeyExists(variables.$class.layout, "except") || !ListFindNoCase(variables.$class.layout.except, arguments.$action)) && (!StructKeyExists(variables.$class.layout, "only") || ListFindNoCase(variables.$class.layout.only, arguments.$action)))
		{
			loc.ret = variables.$class.layout.template;
		}
	}
	return loc.ret;
	</cfscript>
</cffunction>