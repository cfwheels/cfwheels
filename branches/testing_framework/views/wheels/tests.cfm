<cfset testresults = $createObjectFromRoot(
	path=application.wheels.wheelsComponentPath
	,fileName="test"
	,method="WheelsRunner"
	,options=params
	)>
<cfoutput>#testresults#</cfoutput>