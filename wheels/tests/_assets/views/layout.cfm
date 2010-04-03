<cfoutput>
start:defaultlayout
#contentForLayout()#
<cfif structKeyExists(variables, "variableForLayout")>
	#variableForLayout#
</cfif>
end:defaultlayout
</cfoutput>