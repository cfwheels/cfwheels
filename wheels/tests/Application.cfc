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

}