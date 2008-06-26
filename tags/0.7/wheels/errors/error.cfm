<cfoutput>
<h1><cfif arguments.exception.cause.extendedInfo IS NOT "">#arguments.exception.cause.extendedInfo# Error<cfelse>Error</cfif></h1>
<p>#arguments.exception.cause.message#</p>

<h2>Suggested action</h2>
<p>#arguments.exception.cause.detail#</p>

<cfif arguments.exception.cause.extendedInfo IS NOT "">
	<h2>Error location</h2>
	<p>Line #arguments.exception.cause.tagContext[3].line# in #replace(arguments.exception.cause.tagContext[3].template, getDirectoryFromPath(getBaseTemplatePath()), "")#</p>
	<cfset locals.pos = 0><pre><code><cfloop file="#arguments.exception.cause.tagContext[3].template#" index="locals.i"><cfset locals.pos = locals.pos + 1><cfif locals.pos GTE (arguments.exception.cause.tagContext[3].line-2) AND locals.pos LTE (arguments.exception.cause.tagContext[3].line+2)><cfif locals.pos IS arguments.exception.cause.tagContext[3].line><span style="color: red;">#locals.pos#: #HTMLEditFormat(locals.i)#</span><cfelse>#locals.pos#: #HTMLEditFormat(locals.i)#</cfif>
	</cfif></cfloop></code></pre>
</cfif>
</cfoutput>