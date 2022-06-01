<cfoutput>
	start:defaultlayout
	#includeContent()#
	<cfif StructKeyExists(variables, "variableForLayout")>
		#variableForLayout#
	</cfif>
	end:defaultlayout
</cfoutput>
