<!--- <br> --->
<!--- <cfoutput>root.cfm</cfoutput>
<cfdump var="#local#"> --->
<!--- <cfinvoke
	component="#local.component#"
	method="#local.method#"
	returnVariable="#local.returnVariable#"
	argumentCollection="#local.argumentCollection#"
> --->

<cfif local.method EQ 'init'>
	<cfset evaluate('#local.returnVariable# = application.wirebox.getInstance(name = "#local.component#", initArguments = local.argumentCollection)')>
<cfelse>
	<cfset evaluate('#local.returnVariable# = application.wirebox.getInstance(name = "#local.component#").#local.method#(argumentCollection = local.argumentCollection)')>
</cfif>
<!--- <cfdump var="#local.rv#"> --->