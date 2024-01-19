<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple"> 
<cfscript>
  /* One Runner */
  r = new testbox.system.TestBox( "testbox.tests.specs.BDDTest" );

  writeOutput( r.run( reporter="#url.reporter#", callbacks={
	onBundleStart 	= function( bundle, testResults ){
                writeDump( var="onBundleStart", output="console" );
        },
	onBundleEnd 	= function( bundle, testResults ){
		writeDump( var="onBundleEnd", output="console" );
	},
	onSuiteStart 	= function( bundle, testResults, suite ){
		writeDump( var="onSuiteStart", output="console" );
	},
	onSuiteEnd		= function( bundle, testResults, suite ){
		writeDump( var="onSuiteEnd", output="console" );
	},
	onSpecStart		= function( bundle, testResults, suite, spec ){
		writeDump( var="onSpecStart", output="console" );
	},
	onSpecEnd 		= function( bundle, testResults, suite, spec ){
		writeDump( var="onSpecEnd", output="console" );
	}
} ) );
</cfscript>
