<cfsetting showdebugoutput="false" >
<cfset r = new testbox.system.TestBox( "testbox.tests.specs.MXUnitCompatTest" ) >
<cfoutput>#r.run()#</cfoutput>