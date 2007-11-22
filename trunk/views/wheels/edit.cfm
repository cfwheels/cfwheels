<cfoutput>
<h1><cfif structKeyExists(params, "primary_key") AND params.primary_key IS NOT "">Edit<cfelse>Add</cfif></h1>
<p><cfif structKeyExists(params, "primary_key") AND params.primary_key IS NOT "">Edit<cfelse>Add</cfif> using the form below.</p>
<cfset args.class = "admin-form">
<cfset args.params = "model=#params.model#">
<cfif structKeyExists(params, "primary_key") AND params.primary_key IS NOT "">
	<cfset args.params = args.params & "&primary_key=#params.primary_key#">
</cfif>
#errorMessagesFor("record")#
#startFormTag(argumentCollection=args)#
<fieldset>
	<legend><cfif structKeyExists(params, "primary_key") AND params.primary_key IS NOT "">Edit<cfelse>Add</cfif> #params.model#:</legend>
	<dl>
		<cfset column_info = model(params.model).getColumns()>
		<cfloop list="#structKeyList(column_info)#" index="i">
			<cfif i IS NOT model(params.model).getPrimaryKey()>
				#textField(object_name="record", field=i, label="#humanize(i)#:", wrap_label="false", prepend="<dd>", append="</dd>", prepend_to_label="<dt>", append_to_label="</dt>")#
			</cfif>
		</cfloop>
	</dl>
	<cfif CGI.http_referer Does Not Contain "wheels/edit">
		<cfset backlink = CGI.http_referer>
	<cfelse>
			<cfset backlink = params.backlink>
	</cfif>
	#hiddenFieldTag(name="backlink", value=backlink)#
	#submitTag(value="Submit")#
</fieldset>
#endFormTag()#
<p><cfoutput>#linkTo(text="<< Back", link=backlink)#</cfoutput></p>
</cfoutput>