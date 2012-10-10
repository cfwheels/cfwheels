<cfset release = createObject("component", "ReleaseGenerator").init()>
<cfset release.build()>
<h1>Build Successful!</h1>