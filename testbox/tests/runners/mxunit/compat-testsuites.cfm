<cfsetting showdebugoutput="false" >
<cfset suite = new testbox.system.compat.framework.TestSuite().TestSuite()>
<cfset suite.addAll( "testbox.tests.specs.MXUnitCompatTest" )>
<cfset r = suite.run()>
<cfoutput>#r.getResultsOutput( reporter="simple" )#</cfoutput>

<cfset suite = new testbox.system.compat.framework.TestSuite().TestSuite()>
<cfset suite.add( "testbox.tests.specs.MXUnitCompatTest", "testAssertTrue" )>
<cfset suite.add( "testbox.tests.specs.MXUnitCompatTest", "testAssert" )>
<cfset r = suite.run()>
<cfoutput>#r.getResultsOutput( reporter="simple" )#</cfoutput>
