<h1>Database Admin</h1>
<p>Available options:</p>
<ul>
<cfloop list="#models#" index="i">
	<li><cfoutput>#linkTo(text=i, action="list", params="model=#i#")#</cfoutput></li>
</cfloop>
</ul>