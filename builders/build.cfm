<cfset release = createObject("component", "ReleaseGenerator").init(application.wheels.version)>
<cfset release.build()>
<h1>Build Successful!</h1>