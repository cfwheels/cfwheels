/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * I contain the logic to force a compilation on Railo/Lucee.
 * I will not compile on Adobe ColdFusion, so I require my own CFC.
 */
component accessors=true {

	function init(){
		// Create this class for some static helper methods
		variables.PageSourceImpl = createObject( "java", "lucee.runtime.PageSourceImpl" );
		return this;
	}

	/**
	 * Call me to force a .cfm or .cfc to be compiled and the class loaded into memory
	 */
	function compileAndLoad( required filePath ){
		// Attempt to compile and load the class
		PageSourceImpl
			.best( getPageContext().getPageSources( makePathRelative( arguments.filePath ) ) )
			.loadPage( getPageContext(), true );
	}

	/**
	 * Accepts an absolute path and returns a relative path
	 * Does NOT apply any canonicalization
	 */
	string function makePathRelative( required string absolutePath ){
		// If one of the folders has a period, we've got to do something special.
		// C:/users/brad.development/foo.cfc turns into /C__users_brad_development/foo.cfc
		if ( getDirectoryFromPath( arguments.absolutePath ) contains "." ) {
			var leadingSlash = arguments.absolutePath.startsWith( "/" );
			var UNC          = arguments.absolutePath.startsWith( "\\" );
			var mappingPath  = getDirectoryFromPath( arguments.absolutePath );
			mappingPath      = mappingPath.replace( "\", "/", "all" );
			mappingPath      = mappingPath.listChangeDelims( "/", "/" );

			var mappingName = mappingPath.replace( ":", "_", "all" );
			mappingName     = mappingName.replace( ".", "_", "all" );
			mappingName     = mappingName.replace( "/", "_", "all" );
			mappingName     = "/" & mappingName;

			// *nix needs this
			if ( leadingSlash ) {
				mappingPath = "/" & mappingPath;
			}

			// UNC network paths
			if ( UNC ) {
				var mapping = locateUNCMapping( mappingPath );
				return mapping & "/" & getFileFromPath( arguments.absolutePath );
			} else {
				createMapping( mappingName, mappingPath );
				return mappingName & "/" & getFileFromPath( arguments.absolutePath );
			}
		}

		// *nix needs to include first folder due to Lucee bug.
		// So /usr/brad/foo.cfc becomes /usr
		if ( !isWindows() ) {
			var firstFolder = listFirst( arguments.absolutePath, "/" );
			var path        = listRest( arguments.absolutePath, "/" );
			var mapping     = locateUnixDriveMapping( firstFolder );
			return mapping & "/" & path;
		}

		// UNC network path.
		if ( arguments.absolutePath.left( 2 ) == "\\" ) {
			// Strip the \\
			arguments.absolutePath = arguments.absolutePath.right( -2 );
			if ( arguments.absolutePath.listLen( "/\" ) < 2 ) {
				throw(
					"Can't make relative path for [#absolutePath#].  A mapping must point ot a share name, not the root of the server name."
				);
			}

			// server/share
			var UNCShare = listFirst( arguments.absolutePath, "/\" ) & "/" & listGetAt(
				arguments.absolutePath,
				2,
				"/\"
			);
			// everything after server/share
			var path    = arguments.absolutePath.listDeleteAt( 1, "/\" ).listDeleteAt( 1, "/\" );
			var mapping = locateUNCMapping( UNCShare );
			return mapping & "/" & path;

			// Otherwise, do the "normal" way that re-uses top level drive mappings
			// C:/users/brad/foo.cfc turns into /C_Drive/users/brad/foo.cfc
		} else {
			var driveLetter = listFirst( arguments.absolutePath, ":" );
			var path        = listRest( arguments.absolutePath, ":" );
			var mapping     = locateDriveMapping( driveLetter );
			return mapping & path;
		}
	}

	/**
	 * Accepts a Windows drive letter and returns a CF Mapping
	 * Creates the mapping if it doesn't exist
	 */
	string function locateDriveMapping( required string driveLetter ){
		var mappingName = "/" & arguments.driveLetter & "_drive";
		var mappingPath = arguments.driveLetter & ":/";
		createMapping( mappingName, mappingPath );
		return mappingName;
	}

	/**
	 * Accepts a Unix root folder and returns a CF Mapping
	 * Creates the mapping if it doesn't exist
	 */
	string function locateUnixDriveMapping( required string rootFolder ){
		var mappingName = "/" & arguments.rootFolder & "_root";
		var mappingPath = "/" & arguments.rootFolder & "/";
		createMapping( mappingName, mappingPath );
		return mappingName;
	}

	/**
	 * Accepts a Windows UNC network share and returns a CF Mapping
	 * Creates the mapping if it doesn't exist
	 */
	string function locateUNCMapping( required string UNCShare ){
		var mappingName = "/" & arguments.UNCShare.replace( "/", "_" ).replace( ".", "_", "all" ) & "_UNC";
		var mappingPath = "\\" & arguments.UNCShare & "/";
		createMapping( mappingName, mappingPath );
		return mappingName;
	}

	function createMapping( mappingName, mappingPath ){
		var mappings = getApplicationSettings().mappings;
		if ( !structKeyExists( mappings, mappingName ) || mappings[ mappingName ] != mappingPath ) {
			mappings[ mappingName ]= mappingPath;
			application action     ="update" mappings="#mappings#";
		}
	}

	/*
	 * Turns all slashes in a path to forward slashes except for \\ in a Windows UNC network share
	 * Also changes double slashes to a single slash
	 */
	function normalizeSlashes( string path ){
		if ( path.left( 2 ) == "\\" ) {
			return "\\" & path.replace( "\", "/", "all" ).right( -2 );
		} else {
			return path.replace( "\", "/", "all" ).replace( "//", "/", "all" );
		}
	}

	/**
	 * Detect if OS is Windows
	 */
	private boolean function isWindows(){
		return createObject( "java", "java.lang.System" )
			.getProperty( "os.name" )
			.toLowerCase()
			.contains( "win" );
	}

}
