/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner Suite " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;
	this.enableNullSupport  = shouldEnableFullNullSupport();

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	// Map back to its root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)$", "" );
	this.mappings[ "/testbox" ] = rootPath;
	// Map resources
	this.mappings[ "/coldbox" ] = this.mappings[ "/tests" ] & "resources/coldbox";

	// any orm definitions go here.

	// request start
	public boolean function onRequestStart( String targetPage ){
		return true;
	}

	private boolean function shouldEnableFullNullSupport() {
		param value = url.keyExists( "FULL_NULL" );
		var system = createObject( "java", "java.lang.System" );
        var value = system.getEnv( "FULL_NULL" ) ?: false;
        return !!value;
    }
}
