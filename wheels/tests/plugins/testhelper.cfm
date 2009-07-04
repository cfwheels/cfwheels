<cfset global = {}>
<cfset global.repo = "wheelstest">
<cfset global.plugins = createobject("component", "wheels.plugins").$init(true)>
<cfset global.plugins.$registerRepo(
		repo=global.repo
		,name="WheelsTestRepo"
		,location="http://code.google.com/p/cfwheels/downloads/list?can=2&q=label:repotest&sort=-filename&colspec=Filename%20Summary"
		,parser="$GoogleCode"
	)>
<cfset global.plugins.$setRepo(global.repo)>