<cfoutput>
<h1><cfif arguments.exception.cause.extendedinfo IS NOT "">#arguments.exception.cause.extendedinfo# Error<cfelse>Error</cfif></h1>
<p>#arguments.exception.cause.message#</p>

<h2>Suggested action</h2>
<p>#arguments.exception.cause.detail#</p>

<cfif arguments.exception.cause.extendedinfo IS NOT "">
	<h2>Error location</h2>
	<p>Line #arguments.exception.cause.tagcontext[3].line# in #replace(arguments.exception.cause.tagcontext[3].template, getDirectoryFromPath(getBaseTemplatePath()), "")#</p>
	<cfset local.pos = 0><pre><code><cfloop file="#arguments.exception.cause.tagcontext[3].template#" index="i"><cfset local.pos = local.pos + 1><cfif local.pos GTE (arguments.exception.cause.tagcontext[3].line-2) AND local.pos LTE (arguments.exception.cause.tagcontext[3].line+2)><cfif local.pos IS arguments.exception.cause.tagcontext[3].line><span style="color: red;">#local.pos#: #htmlEditFormat(i)#</span><cfelse>#local.pos#: #htmlEditFormat(i)#</cfif>
	</cfif></cfloop></code></pre>
</cfif>

</cfoutput>