<h1><cfoutput>#capitalize(pluralize(params.model))#</cfoutput></h1>
<p>Listing <cfoutput>#pluralize(params.model)# #numberFormat(start_at)# to #numberFormat(end_at)# out of #numberFormat(total_records)# total.</cfoutput></p>

<cfoutput>
#startFormTag(method="get", class="admin-form")#
<fieldset>
	<legend>Find</legend>
	<dl>
		#textFieldTag(name="primary_key", label="#capitalize(params.model)# ID:", wrap_label="false", prepend="<dd>", append="</dd>", prepend_to_label="<dt>", append_to_label="</dt>")#
	</dl>
	#hiddenFieldTag(name="model", value=params.model)#
	#hiddenFieldTag(name="page", value=params.page)#
	<input type="submit" value="Display" />
</fieldset>
#endFormTag()#
</cfoutput>

<table class="admin-list" cellspacing="0">
<tr>
<cfloop list="#columns#" index="i">
	<th><cfoutput>#truncate(humanize(i), 10)#</cfoutput></th>
</cfloop>
<th>Edit</th>
<th>Delete</th>
</tr>
<cfoutput query="records">
	<cfset primary_key = records[model(params.model).getPrimaryKey()][records.currentrow]>
	<tr class="#cycle('admin-even,admin-odd')#">
	<cfloop list="#columns#" index="i">
		<td>#HTMLEditFormat(records[i][records.currentrow])#</td>
	</cfloop>
	<td><strong>#linkTo(text="Edit", action="edit", params="model=#params.model#&primary_key=#primary_key#")#</strong></td>
	<td>#buttonTo(text="Delete", action="delete", params="model=#params.model#&primary_key=#primary_key#", confirm="Are you sure you want to delete #params.model# ###primary_key#?")#</td>
	</tr>
</cfoutput>
</table>

<cfif paginationTotalPages() GT 1>
	<p class="admin-pagination"><strong><cfoutput>#paginationLinks(window_size=10, params="model=#params.model#")#</cfoutput></strong></p>
</cfif>

<p><cfoutput>#linkTo(text="<< Back", action="admin")#</cfoutput></p>