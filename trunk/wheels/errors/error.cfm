<cfoutput>
<h1>Wheels Error!</h1>
<p>#arguments.exception.cause.message#</p>
<h2>Suggested action</h2>
<p>#arguments.exception.cause.extendedInfo#</p>
<h2>Error location</h2>
<p>Line #arguments.exception.cause.tagContext[3].line# in #replace(arguments.exception.cause.tagContext[3].template, getDirectoryFromPath(getBaseTemplatePath()), "")#</p>
<cfset loc.pos = 0><pre><code><cfloop file="#arguments.exception.cause.tagContext[3].template#" index="loc.i"><cfset loc.pos = loc.pos + 1><cfif loc.pos GTE (arguments.exception.cause.tagContext[3].line-2) AND loc.pos LTE (arguments.exception.cause.tagContext[3].line+2)><cfif loc.pos IS arguments.exception.cause.tagContext[3].line><span style="color: red;">#loc.pos#: #HTMLEditFormat(loc.i)#</span><cfelse>#loc.pos#: #HTMLEditFormat(loc.i)#</cfif>
</cfif></cfloop></code></pre>
</cfoutput>