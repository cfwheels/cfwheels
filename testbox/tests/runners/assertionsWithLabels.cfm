<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple"> 
<!--- One runner --->
<cfset r = new testbox.system.TestBox( bundles="testbox.tests.specs.AssertionsTest", labels="lucee" ) >
<cfoutput>#r.run(reporter="#url.reporter#")#</cfoutput>