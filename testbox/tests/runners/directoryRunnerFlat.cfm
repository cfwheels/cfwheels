<cfsetting showdebugoutput="false" >
<!--- Directory Runner --->
<cfset r = new testbox.system.TestBox( directory="testbox.tests.specs" ) >
<cfoutput>#r.run(reporter="simple")#</cfoutput>