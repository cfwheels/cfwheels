```coldfusion
// Make sure that the `sidebar` value is provided for the parent layout
<cfsavecontent variable="categoriesSidebar">
	<cfoutput>
		<ul>
			##includePartial(categories)##
		</ul>
	</cfoutput>
</cfsavecontent>
contentFor(sidebar=categoriesSidebar)>

// Include parent layout at `views/layout.cfm`
<cfoutput>
	##includeLayout("/layout.cfm")##
</cfoutput>
```
