<cffunction name="layout" access="public" returntype="void" output="false" hint="Used to specify a controller or action specific layout"
	examples=
	'
		<cffunction name="init">
			<!---
			We want this layout to be used as the default throughout the entire controller
			except for the index action
			 --->
			<cfset layout("myLayout", except="myajax")>
		</cffunction>
		
		<cffunction name="index">
			<!--- in this action we want an action specific layout --->
			<cfset layout("layoutForIndex")>
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
	<cfargument name="template" required="true" type="string" hint="the name of the layout template you want rendered">
	<cfargument name="except" type="string" required="false" hint="a list of actions that SHOULD NOT get the layout">
	<cfargument name="only" type="string" required="false" hint="a list of action that SHOULD ONLY get the layout">
	<!--- 
	when called from the controller's init method, the only class variables
	exists, so put the layout there. when called from within an action, place
	the layout with the controller instance.
	 --->
	<cfif StructKeyExists(variables, "$instance")>
		<!--- 
		Do not allow conditions when called from an action
		 --->
		<cfset structdelete(arguments, "except", false)>
		<cfset structdelete(arguments, "only", false)>
		<cfset variables.$instance.layout = arguments>
	<cfelse>
		<cfif StructKeyExists(arguments, "except")>		
			<cfset arguments.except = $listClean(arguments.except)>
		</cfif>
		<cfif StructKeyExists(arguments, "only")>
			<cfset arguments.only = $listClean(arguments.only)>
		</cfif>
		<cfset variables.$class.layout = arguments>
	</cfif>
</cffunction>

<cffunction name="$layoutForAction" access="public" returntype="string" output="false">
	<cfargument name="$action" type="string" required="true">
	<cfscript>
	if(!StructIsEmpty(variables.$instance.layout) && ((!StructKeyExists(variables.$instance.layout, "except") || !ListFindNoCase(variables.$instance.layout.except, arguments.$action)) && (!StructKeyExists(variables.$instance.layout, "only") || ListFindNoCase(variables.$instance.layout.only, arguments.$action))))
	{
		return variables.$instance.layout.template;;
	}
	return false;
	</cfscript>
</cffunction>