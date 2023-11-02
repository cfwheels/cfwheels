component {
	// Put variables we just need internally inside a wheels struct.
	this.wheels = {};
	this.wheels.rootPath = GetDirectoryFromPath(GetBaseTemplatePath());

	this.name = createUUID();
	// Give this application a unique name by taking the path to the root and hashing it.
	// this.name = Hash(this.wheels.rootPath);

	this.bufferOutput = true;
	
	this.webrootDir = getDirectoryFromPath( getCurrentTemplatePath() );
	this.appDir     = this.webrootDir;

	// Add mapping to the root of the site (e.g. C:\inetpub\wwwroot\, C:\inetpub\wwwroot\appfolder\).
	// This is useful when extending controllers and models in parent folders (e.g. extends="app.controllers.Controller").
	this.mappings["/app"] = this.appDir;

	// Add mapping to the wheels folder inside the app folder (e.g. C:\inetpub\wwwroot\appfolder\wheels).
	// This is used extensively when writing tests.
	this.mappings["/wheels"] = this.webrootDir & "wheels";

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
