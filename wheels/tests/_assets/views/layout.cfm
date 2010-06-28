<cfoutput>
start:defaultlayout
#yield()#
<cfif structKeyExists(variables, "variableForLayout")>
	#variableForLayout#
</cfif>
end:defaultlayout
</cfoutput>