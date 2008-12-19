<cfoutput>
<h1>#arguments.exception.cause.type#</h1>
<p><strong>#arguments.exception.cause.message#</strong></p>
<h2>Suggested action</h2>
<p>#arguments.exception.cause.extendedInfo#</p>
<cfset loc.path = getDirectoryFromPath(getBaseTemplatePath())>
<cfset loc.errorPos = 0>
<cfloop array="#arguments.exception.cause.tagContext#" index="loc.i">
	<cfset loc.errorPos = loc.errorPos + 1>
	<cfif loc.i.template Does Not Contain loc.path & "wheels" AND loc.i.template IS NOT loc.path & "root.cfm" AND loc.i.template IS NOT loc.path & "index.cfm" AND loc.i.template IS NOT loc.path & "rewrite.cfm" AND loc.i.template IS NOT loc.path & "Application.cfc">
		<h2>Error location</h2>
		<p>Line #arguments.exception.cause.tagContext[loc.errorPos].line# in #Replace(arguments.exception.cause.tagContext[loc.errorPos].template, loc.path, "")#</p>
		<cfset loc.pos = 0><pre><code><cfloop file="#arguments.exception.cause.tagContext[loc.errorPos].template#" index="loc.i"><cfset loc.pos = loc.pos + 1><cfif loc.pos GTE (arguments.exception.cause.tagContext[loc.errorPos].line-2) AND loc.pos LTE (arguments.exception.cause.tagContext[loc.errorPos].line+2)><cfif loc.pos IS arguments.exception.cause.tagContext[loc.errorPos].line><span style="color: red;">#loc.pos#: #HTMLEditFormat(loc.i)#</span><cfelse>#loc.pos#: #HTMLEditFormat(loc.i)#</cfif>#Chr(13)##Chr(10)#</cfif></cfloop></code></pre>
		<cfbreak>
	</cfif>
</cfloop>
</cfoutput>