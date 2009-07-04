<!---
	This is a controller file that Wheels uses internally.
	Do not delete this file.
--->
<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset filters(through="$productionProtection", type="before", except="congratulations")>
	</cffunction>

	<!--- default --->
	<cffunction name="congratulations">
		<cfset version = application.wheels.version>
	</cffunction>

	<!--- tests --->
	<cffunction name="tests">
		<cfset testresults = $createObjectFromRoot(
			path=application.wheels.wheelsComponentPath
			,fileName="test"
			,method="WheelsRunner"
			,options=params
		)>
	</cffunction>

	<!--- plugins --->
	<cffunction name="plugins">
		<cfset pluginsObj = createobject("component", "wheels.plugins").$init(true)>
	</cffunction>

	<cffunction name="pluginsDownload">
		<cfif
			not structkeyexists(params, "name")
			or not structkeyexists(params, "version")
			or not structkeyexists(params, "repo")
			>
			<cfset redirectTo(route="home")>
		</cfif>

		<cfset pluginsObj = createobject("component", "wheels.plugins").$init(true)>
		<cfset pluginsObj.$installPlugin(argumentcollection=params)>
		<cflocation url="?controller=wheels&action=pluginsDetails&reload=true&name=#params.name#" addtoken="false">
	</cffunction>

	<cffunction name="pluginsDetails">
		<cfif !structkeyexists(params, "name")>
			<cfset redirectTo(route="home")>
		</cfif>
		<cfset renderPage(controller="", action="", template="../../plugins/#params.name#/index.cfm")>
	</cffunction>

	<cffunction name="pluginsUninstall">
		<cfif !structkeyexists(params, "name")>
			<cfset redirectTo(route="home")>
		</cfif>
		<cfset pluginsObj = createobject("component", "wheels.plugins").$init()>
		<cfset pluginsObj.$uninstallPlugin(argumentcollection=params)>
	</cffunction>

	<!--- filters --->
	<cffunction name="$productionProtection">
		<cfif get("environment") IS "production">
			<cfset redirectTo(route="home")>
		</cfif>
	</cffunction>

</cfcomponent>