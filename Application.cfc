component {
	// Put variables we just need internally inside a wheels struct.
	this.wheels = {};
	this.wheels.rootPath = GetDirectoryFromPath(GetBaseTemplatePath());

	this.name = createUUID();
	// Give this application a unique name by taking the path to the root and hashing it.
	// this.name = Hash(this.wheels.rootPath);

	this.bufferOutput = true;

	// Setup paths to the webroot then set the paths to the app folders and wheels folder based on the webroot
	this.webrootDir = getDirectoryFromPath( getCurrentTemplatePath() );
	this.appDir     = this.webrootDir;
	this.wheelsDir  = this.webrootDir & 'wheels';
	// You can move the application folders and wheels folder out of the webroot
	// this.appDir     = this.webrootDir & '../app';
	// this.wheelsDir  = this.webrootDir & '../vendor/wheels';

	this.mappings["/app"] = this.appDir;
	this.mappings["/wheels"] = this.wheelsDir;

	// We turn on "sessionManagement" by default since the Flash uses it.
	this.sessionManagement = true;

	// If a plugin has a jar or class file, automatically add the mapping to this.javasettings.
	this.wheels.pluginDir = this.appDir & "plugins";
	this.wheels.pluginFolders = DirectoryList(
		this.wheels.pluginDir,
		"true",
		"path",
		"*.class|*.jar|*.java"
	);

	for (this.wheels.folder in this.wheels.pluginFolders) {
		if (!StructKeyExists(this, "javaSettings")) {
			this.javaSettings = {};
		}
		if (!StructKeyExists(this.javaSettings, "LoadPaths")) {
			this.javaSettings.LoadPaths = [];
		}
		this.wheels.pluginPath = GetDirectoryFromPath(this.wheels.folder);
		if (!ArrayFind(this.javaSettings.LoadPaths, this.wheels.pluginPath)) {
			ArrayAppend(this.javaSettings.LoadPaths, this.wheels.pluginPath);
		}
	}

	// Put environment vars into env struct
	if ( !structKeyExists(this,"env") ) {
		this.env = {};
		envFilePath = this.appDir & ".env";
		if (fileExists(envFilePath)) {
			envStruct = {};

			envFile = fileRead(envFilePath);
			if (isJSON(envFile)) {
				envStruct = deserializeJSON(envFile);
			}
			else { // assume it is a .properties file
				properties = createObject('java', 'java.util.Properties').init();
				properties.load(CreateObject('java', 'java.io.FileInputStream').init(envFilePath));
				envStruct = properties;
			}

			// Append to env struct
			for (key in envStruct) {
				this.env["#key#"] = envStruct[key];
			}
		}
	}

	function onServerStart() {}

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
		include "/wheels/events/onerror.cfm";
	}

	public boolean function onMissingTemplate( string targetPage ) {
		include "/wheels/events/onmissingtemplate.cfm";
		return true;
	}

}
