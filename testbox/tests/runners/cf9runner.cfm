<cfsetting showdebugoutput="false" >
<!--- One runner --->
<cfset r = new testbox.system.TestBox( bundles="testbox.tests.specs.Assertionscf9Test" ) >
<cfoutput>#r.run(reporter="simple")#</cfoutput>