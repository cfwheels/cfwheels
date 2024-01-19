<cfset r = new testbox.system.compat.runner.DirectoryTestSuite()
				.run( directory="#expandPath( '/testbox/tests/specs' )#", 
					  componentPath="testbox.tests.specs" )>
<cfoutput>#r.getResultsOutput( 'simple' )#</cfoutput>
