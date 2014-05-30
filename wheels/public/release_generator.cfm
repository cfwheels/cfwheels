<cfset release = createObject("component", "builders.release.ReleaseGenerator").init(application.wheels.version)>
<cfset release.build()>
<cfoutput>
<h1>Build Successful!</h1>
<p>Zip file is located at: #release.getReleaseZipPath()#</p>
</cfoutput>
