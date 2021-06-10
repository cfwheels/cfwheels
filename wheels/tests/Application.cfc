component {

	// Put variables we just need internally inside a wheels struct.
	// this.wheels = {};
	// this.wheels.rootPath = GetDirectoryFromPath(GetBaseTemplatePath());

	this.name = createUUID();
	// this.name = Hash(this.wheels.rootPath);
	this.bufferOutput = true;
	// this.localMode = "modern"; <--- don't use this, logbox chokes.
	// this.applicationTimeout = createTimeSpan( 0, 0, 0, 1 );


	// We turn on "sessionManagement" by default since the Flash uses it.
	this.sessionManagement = true;


	this.webrootDir = getDirectoryFromPath( getCurrentTemplatePath() );
	this.appDir     = this.webrootDir;

	//this.mappings['/app']      = this.appDir;
	// this.mappings['/tests']    = this.testDir;
	this.mappings['/testbox']  	= getCanonicalPath(this.webrootDir & "../testbox");
	this.mappings['/wheels']   	= getCanonicalPath(this.webrootDir & "../");
	this.mappings['/app']   	= getCanonicalPath(this.webrootDir & "resources/app");

	function onApplicationStart() {
		include "/app/config/app.cfm";
		include "/wheels/controller/appfunctions.cfm";
		include "/wheels/global/appfunctions.cfm";
		include "/wheels/events/onapplicationstart.cfm";
		return true;
	}

	public void function onApplicationEnd( struct ApplicationScope ) {
		include "/wheels/events/onapplicationend.cfm";
	}

	public void function onSessionStart() {
		include "/wheels/events/onsessionstart.cfm";
	}

	public void function onSessionEnd( struct SessionScope, struct ApplicationScope ) {
		include "/wheels/events/onsessionend.cfm";
	}

	public boolean function onRequestStart( string targetPage ) {
		include "/wheels/events/onrequeststart.cfm";
		return true;
	}

	public boolean function onRequest( string targetPage ) {
		include "/wheels/events/onrequest.cfm";
		return true;
	}

	public void function onRequestEnd( string targetPage ) {
		include "/wheels/events/onrequestend.cfm";
	}

	public boolean function onAbort( string targetPage ) {
		include "/wheels/events/onabort.cfm";
		return true;
	}

	public void function onError( any Exception, string EventName ) {
		// include "/wheels/events/onerror.cfm";
		writedump(Exception);
	}

	public boolean function onMissingTemplate( string targetPage ) {
		include "/wheels/events/onmissingtemplate.cfm";
		return true;
	}
}