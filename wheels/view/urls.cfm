<cffunction name="linkTo" returntype="any" access="public" output="false">
	<cfargument name="url" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var locals = structNew()>

	<cfif len(arguments.url) IS NOT 0>
		<cfset locals.href = arguments.url>
	<cfelse>
		<cfset locals.href = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfif len(arguments.text) IS 0>
		<cfset arguments.text = locals.href>
	</cfif>

	<cfif len(arguments.confirm) IS NOT 0>
		<cfset locals.confirm = " onclick=""return confirm('#arguments.confirm#')"" ">
	<cfelse>
		<cfset locals.confirm = "">
	</cfif>

	<cfset locals.result = "<a href=""#locals.href#""#locals.confirm##_HTMLAttributes(attributes)#>#arguments.text#</a>">

	<cfreturn locals.result>
</cffunction>


<cffunction name="buttonTo" returntype="any" access="public" output="false">
	<cfargument name="url" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<cfargument name="disable" type="any" required="false" default="">
	<cfargument name="source" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var locals = structNew()>

	<cfif len(arguments.url) IS NOT 0>
		<cfset locals.action = arguments.url>
	<cfelse>
		<cfset locals.action = URLFor(argumentCollection=arguments)>
	</cfif>

	<!--- create the form tag --->
	<cfset locals.result = "<form action=""#locals.action#"" method=""post""">
	<cfif len(arguments.confirm) IS NOT 0>
		<cfset locals.result = locals.result & " onsubmit=""return confirm('#JSStringFormat(replace(arguments.confirm, """", '&quot;', 'all'))#');""">
	</cfif>
	<cfset locals.result = locals.result & ">">

	<!--- create the input tag --->
	<cfset locals.result = locals.result & "<input">
	<cfif len(arguments.text) IS NOT 0>
		<cfset arguments.html_value = arguments.text>
	</cfif>
	<cfif len(arguments.source) IS 0>
		<cfset arguments.html_type = "submit">
	<cfelse>
		<cfset arguments.html_type = "image">
		<cfset arguments.html_src = "#application.wheels.web_path##application.settings.paths.images#/#arguments.source#">
	</cfif>
	<cfif len(arguments.disable) IS NOT 0>
		<cfset arguments.html_onclick = locals.onclick>
	</cfif>
	<cfif len(arguments.disable) IS NOT 0>
		<cfset arguments.html_onclick = "this.disabled=true;">
		<cfif len(arguments.source) IS 0 AND NOT isBoolean(arguments.disable)>
			<cfset arguments.html_onclick = arguments.html_onclick & "this.value='#arguments.disable#';">
		</cfif>
		<cfset arguments.html_onclick = arguments.html_onclick & "this.form.submit();">
	</cfif>
	<cfset locals.result = locals.result & "#_HTMLAttributes(argumentCollection=arguments)# />">

	<!--- create the closing form tag --->
	<cfset locals.result = locals.result & "</form>">

	<cfreturn locals.result>
</cffunction>


<cffunction name="mailTo" returntype="any" access="public" output="false">
	<cfargument name="email" type="any" required="true">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="encode" type="any" required="false" default="false">
	<cfset var locals = structNew()>

	<cfset locals.linkToArguments = structNew()>
	<cfset locals.linkToArguments.url = "mailto:#arguments.email#">
	<cfif len(arguments.text) IS 0>
		<cfset locals.linkToArguments.text = arguments.email>
	<cfelse>
		<cfset locals.linkToArguments.text = arguments.text>
	</cfif>
	<cfset locals.result = linkTo(argumentCollection=locals.linkToArguments)>

	<cfif arguments.encode>
		<cfset locals.js = "document.write('#trim(locals.result)#');">
		<cfset locals.encoded = "">
		<cfloop from="1" to="#len(locals.js)#" index="locals.i">
			<cfset locals.encoded = locals.encoded & "%" & right("0" & formatBaseN(asc(mid(locals.js,locals.i,1)),16),2)>
		</cfloop>
		<cfset locals.result = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#locals.encoded#'))</script>">
	</cfif>

	<cfreturn locals.result>
</cffunction>


<cffunction name="linkToUnlessCurrent" returntype="any" access="public" output="false">
	<!--- accepts linkTo and URLFor arguments --->
	<cfset var locals = structNew()>
	<cfif isCurrentPage(argumentCollection=arguments)>
		<cfset locals.result = arguments.text>
	<cfelse>
		<cfset locals.result = linkTo(argumentCollection=arguments)>
	</cfif>
	<cfreturn locals.result>
</cffunction>


<cffunction name="isCurrentPage" returntype="any" access="public" output="false">
	<!--- accepts URLFor arguments --->
	<cfset var locals = structNew()>
	<cfset locals.new_url = urlFor(argumentCollection=arguments)>
	<cfset locals.current_url = CGI.script_name>
	<cfif CGI.script_name IS NOT CGI.path_info>
		<cfset locals.current_url = locals.current_url & CGI.path_info>
	</cfif>
	<cfset locals.current_url = replace(locals.current_url, "rewrite.cfm/", "")>
	<cfif len(CGI.query_string) IS NOT 0>
		<cfset locals.current_url = locals.current_url & "?" & CGI.query_string>
	</cfif>
	<!--- <cfoutput>#locals.current_url# IS #locals.new_url#</cfoutput><cfabort> --->
	<cfif locals.current_url IS locals.new_url OR locals.current_url IS "/index.cfm" AND locals.new_url IS "/">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>