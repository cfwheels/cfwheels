<cffunction name="linkTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset local.named_arguments = "link,text,confirm,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset local.named_arguments = listDeleteAt(local.named_arguments, listFindNoCase(local.named_arguments, "id"))>
	</cfif>

	<cfset local.attributes = "">
	<cfloop collection="#arguments#" item="local.i">
		<cfif listFindNoCase(local.named_arguments, local.i) IS 0>
			<cfset local.attributes = "#local.attributes# #lCase(local.i)#=""#arguments[local.i]#""">
		</cfif>
	</cfloop>

	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<cfset structDelete(arguments, "id")>
	</cfif>

	<cfif len(arguments.link) IS NOT 0>
		<cfset local.href = arguments.link>
	<cfelse>
		<cfset local.href = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfif len(arguments.text) IS NOT 0>
		<cfset local.text = arguments.text>
	<cfelse>
		<cfset local.text = local.href>
	</cfif>

	<cfif len(arguments.confirm) IS NOT 0>
		<cfset local.html = "<a href=""#HTMLEditFormat(local.href)#"" onclick=""return confirm('#JSStringFormat(arguments.confirm)#');""#local.attributes#>#local.text#</a>">
	<cfelse>
		<cfset local.html = "<a href=""#HTMLEditFormat(local.href)#""#local.attributes#>#local.text#</a>">
	</cfif>

	<cfreturn local.html>
</cffunction>


<cffunction name="buttonTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<cfargument name="image" type="any" required="false" default="">
	<cfargument name="disable" type="any" required="false" default="">
	<cfargument name="class" type="any" required="false" default="button-to">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>

	<cfset arguments.FL_named_arguments = "link,text,confirm,image,disable,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset arguments.FL_named_arguments = listDeleteAt(arguments.FL_named_arguments, listFindNoCase(arguments.FL_named_arguments, "id"))>
	</cfif>
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<cfset structDelete(arguments, "id")>
	</cfif>

	<cfif len(arguments.link) IS NOT 0>
		<cfset local.action = arguments.link>
	<cfelse>
		<cfset local.action = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfif len(arguments.image) IS NOT 0>
		<cfset local.source = "#application.wheels.web_path##application.settings.paths.images#/#arguments.image#">
	</cfif>

	<cfif len(arguments.disable) IS NOT 0>
		<cfset local.onclick = "this.disabled=true;">
		<cfif len(arguments.image) IS 0 AND NOT isBoolean(arguments.disable)>
			<cfset local.onclick = local.onclick & "this.value='#arguments.disable#';">
		</cfif>
		<cfset local.onclick = local.onclick & "this.form.submit();">
	</cfif>

	<cfset local.html = "">
	<cfset local.html = local.html & "<form action=""#local.action#"" method=""post""">
	<cfif len(arguments.confirm) IS NOT 0>
		<cfset local.html = local.html & " onsubmit=""return confirm('#JSStringFormat(arguments.confirm)#');""">
	</cfif>
	<cfset local.html = local.html & local.attributes>
	<cfset local.html = local.html & ">">
	<cfset local.html = local.html & "<input">
	<cfif len(arguments.text) IS NOT 0>
		<cfset local.html = local.html & " value=""#arguments.text#""">
	</cfif>
	<cfif len(arguments.image) IS 0>
		<cfset local.html = local.html & " type=""submit""">
	<cfelse>
		<cfset local.html = local.html & " type=""image"" src=""#local.source#""">
	</cfif>
	<cfif len(arguments.disable) IS NOT 0>
		<cfset local.html = local.html & " onclick=""#local.onclick#""">
	</cfif>
	<cfset local.html = local.html & " /></form>">

	<cfreturn local.html>
</cffunction>


<cffunction name="mailTo" returntype="any" access="public" output="false">
	<cfargument name="email" type="any" required="true">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="encode" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset link_to_arguments = structNew()>

	<cfset link_to_arguments.link = "mailto:#arguments.email#">
	<cfif len(arguments.text) IS 0>
		<cfset link_to_arguments.text = arguments.email>
	<cfelse>
		<cfset link_to_arguments.text = arguments.text>
	</cfif>

	<cfsavecontent variable="local.html">
		<cfoutput>
			#linkTo(argumentCollection=link_to_arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfif arguments.encode>
		<cfset local.js = "document.write('#trim(local.html)#');">
		<cfset local.encoded = "">
		<cfloop from="1" to="#len(local.js)#" index="local.i">
			<cfset local.encoded = local.encoded & "%" & right("0" & formatBaseN(asc(mid(local.js,local.i,1)),16),2)>
		</cfloop>
		<cfset local.html = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#local.encoded#'))</script>">
	</cfif>

	<cfreturn FL_trimHTML(local.html)>
</cffunction>


<cffunction name="linkToUnlessCurrent" returntype="any" access="public" output="false">
	<!--- accepts URLFor arguments --->
	<cfset var local = structNew()>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif isCurrentPage(argumentCollection=arguments)>
				#arguments.text#
			<cfelse>
				#linkTo(argumentCollection=arguments)#
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="isCurrentPage" returntype="any" access="private" output="false">
	<!--- accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset local.new_url = urlFor(argumentCollection=arguments)>
	<cfset local.current_url = right(CGI.script_name, len(CGI.script_name)-1)>
	<cfif len(CGI.query_string) IS NOT 0>
		<cfset local.current_url = local.current_url & "?" & CGI.query_string>
	</cfif>
	<cfif local.current_url IS local.new_url>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>