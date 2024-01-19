/**
*********************************************************************************
* Copyright Since 2014 by Ortus Solutions, Corp
* www.coldbox.org | www.ortussolutions.com
********************************************************************************
* @author Brad Wood
*
* I represent a single globbing pattern and provide a fluent API to access the matching files
* Unlike the PathPatternMatcher, which only handles comparisons of patterns, this model
* actually interacts with the file system to resolve a pattern to a list of real file system
* resources.
*
*/
component accessors="true" {
	// DI
	property name='pathPatternMatcher' inject='pathPatternMatcher@globber';

	/** The file globbing pattern to match. */
	property name='pattern';
	/** The file globbing pattern NOT to match. */
	property name='excludePattern';
	property name='notExcludePattern';
	/** query of real file system resources that match the pattern */
	property name='matchQuery';
	property name='matchQueryArray';
	/** Return matches as a query instead of an array */
	property name='format' default='array';
	/** Uses Gitignore rules that match pattern anywhere inside path, not requiring explicit * at the start or end of the pattern */
	property name='loose' default='false';
	/** Sort to use */
	property name='sort' default='type, name';
	/** Directory the list was pulled from */
	property name='baseDir' default='';


	function init() {
		variables.separator = server.system.properties['file.separator'] ?: '/';
		variables.format = 'array';
		variables.pattern = [];
		variables.excludePattern = [];
		variables.notExcludePattern = [];
		variables.loose = false;
		variables.matchQueryArray=[];
		return this;
	}

	/**
	* Enable loose matching
	*/
	function inDirectory( required string baseDirectory ) {
		baseDirectory = pathPatternMatcher.normalizeSlashes( baseDirectory );
		setBaseDir( baseDirectory & ( baseDirectory.endsWith( '/' ) ? '' : '/' ) );
		return this;
	}

	/**
	* Enable loose matching
	*/
	function loose( boolean loose=true ) {
		setLoose( loose );
		return this;
	}

	/**
	* Return results as query
	*/
	function asQuery() {
		setFormat( 'query' );
		return this;
	}

	/**
	* Return results as array
	*/
	function asArray() {
		setFormat( 'array' );
		return this;
	}

	/**
	* Return results as array
	*/
	function withSort( thisSort ) {
		setSort( thisSort );
		return this;
	}

	/**
	* Override setter to ensure consistent slashes in pattern
	* Can be list of patterns or array of patterns.
	* Empty patterns will be ignored
	*/
	function setPattern( required any thisPattern ) {
		variables.pattern = [];
		if( isSimpleValue( arguments.thisPattern ) ) {
			arguments.thisPattern = listToArray( arguments.thisPattern );
		}
		arguments.thisPattern.each( function( p ) {
			addPattern( arguments.p );
		});
		return this;
	}

	/**
	* Add additional pattern to process
	*/
	function addPattern( required string pattern ) {
		if( len( arguments.pattern ) ) {
			arguments.pattern = pathPatternMatcher.normalizeSlashes( arguments.pattern );
			variables.pattern.append( arguments.pattern  );
		}
		return this;
	}

	/**
	* Always returns a string which is a list of patterns
	*/
	function getPattern() {
		return variables.pattern.toList();
	}

	/**
	*
	*/
	function getPatternArray() {
		return variables.pattern;
	}


	/**
	* Can be list of excludePatterns or array of excludePatterns.
	* Empty excludePatterns will be ignored
	*/
	function setExcludePattern( required any thisExcludePattern ) {
		variables.excludePattern = [];
		if( isSimpleValue( arguments.thisExcludePattern ) ) {
			arguments.thisExcludePattern = listToArray( arguments.thisExcludePattern );
		}
		arguments.thisExcludePattern.each( function( p ) {
			addExcludePattern( p );
		});
		return this;
	}

	/**
	* Add additional excludePattern to process
	*/
	function addExcludePattern( required string excludePattern ) {
		if( len( arguments.excludePattern ) ) {
			if ( arguments.excludePattern.startsWith( '!' ) ) {
				addNotExcludePattern( mid( arguments.excludePattern, 2, len( arguments.excludePattern ) - 1 ) );
			} else {
				arguments.excludePattern = pathPatternMatcher.normalizeSlashes( arguments.excludePattern );
				variables.excludePattern.append( arguments.excludePattern  );
			}
		}
		return this;
	}

	/**
	* Add not excludePattern to process
	*/
	function addNotExcludePattern( required string notExcludePattern ) {
		if( len( arguments.notExcludePattern ) ) {
			arguments.notExcludePattern = pathPatternMatcher.normalizeSlashes( arguments.notExcludePattern );
			variables.notExcludePattern.append( arguments.notExcludePattern  );
		}
		return this;
	}

	/**
	* Always returns a string which is a list of excludePatterns
	*/
	function getExcludePattern() {
		return variables.excludePattern.toList();
	}

	/**
	*
	*/
	function getExcludePatternArray() {
		return variables.excludePattern;
	}

	/**
	* Pass a closure to this function to have it
	* applied to each paths matched by the pattern.
	*/
	function apply( required udf ) {
		matches().each( udf );
		return this;
	}

	/**
	* Copy all matched paths to a new folder
	*/
	function copyTo( required string targetPath ) {
		targetPath = pathPatternMatcher.normalizeSlashes( targetPath );
		if( !targetPath.endsWith( '/' ) ) {
			targetPath &= '/';
		}
		ensureMatches();
		var paths = getMatchQuery();
		if( !directoryExists( targetPath ) ) {
			directoryCreate( targetPath, true, true );
		}
		// Create all folders first
		paths
			.filter( (p)=>p.type=='dir' )
			.sort( (a,b)=>len(a.directory&a.name )-len(b.directory&b.name ) )
			.each( (p)=>{
				var newDir = pathAppend( p.directory, p.name );
				newDir = pathPatternMatcher.normalizeSlashes( newDir );
				newDir = newDir.replace( getBaseDir(), '' )
				directoryCreate( targetPath & newDir, true, true )
			} );
		// Copy files asynch
		paths
			.filter( (p)=>p.type=='file' )
			.each( (p)=>{
				var oldDir = pathPatternMatcher.normalizeSlashes( p.directory );
				if ( !oldDir.endsWith( '/' ) ) {
					oldDir &= "/";
				}
				var oldFile = oldDir & p.name;
				var newFile = targetPath & oldFile.replace( getBaseDir(), '' );
				// Just in case
				newDirectory = getDirectoryFromPath( newFile );
				if( !directoryExists( newDirectory ) ) {
					directoryCreate( newDirectory, true, true );
				}
				fileCopy( oldFile, newFile )
			}, true );

		return this;
	}

	/**
	* Get array of matched file system paths
	*/
	function matches() {
		ensureMatches();
		if( getFormat() == 'query' ) {
			return getMatchQuery();
		} else {
			return getMatchQuery().reduce( function( arr, row ) {
				var thisPath = row.directory;
				if( !thisPath.endsWith( '\' ) && !thisPath.endsWith( '/' ) ) {
					thisPath &= separator;
				}
				if( len( row.name ) ) {
					thisPath &= row.name & ( row.type == 'Dir' ? separator : '' );
				}
				return arr.append( thisPath );
			}, [] );
		}
	}

	/**
	* Get count of matched files
	*/
	function count() {
		return getFormat() == 'query' ? matches().recordCount : matches().len();
	}

	/**
	* Make sure the MatchQuery has been loaded.
	*/
	private function ensureMatches() {
		if( isNull( getMatchQuery() ) ) {
			process();
		}
	}

	/**
	* Load matching file from the file system
	*/
	private function process() {
		var patterns = getPatternArray();

		if( !patterns.len() && !getBaseDir().len() ) {
			throw( 'Cannot glob empty pattern with no base directory.' );
		} else if( !patterns.len() ) {
			patterns = [ '**' ];
		}

		if( getLoose() && !len( getBaseDir() ) ) {
			throw( 'You must use [inDirectory()] to set a base dir when using loose matching.' );
		}

		for( var thisPattern in patterns ) {
			processPattern( thisPattern );
		}

		var matchQuery = getMatchQuery();

		combineMatchQueries();

		if( patterns.len() > 1 && !getLoose() ) {
			var dirs = queryColumnData( getMatchQuery(), 'directory' );
			var lookups = {};
			dirs.each( function( dir ) {
				// Account for *nix paths & Windows UNC network shares
				var prefix = '';
				if( dir.startsWith( '/' ) ) {
					prefix = '/';
				} else if( dir.startsWith( '\\' ) ) {
					prefix = '//';
				}
				evaluate( 'lookups["#prefix##dir.listChangeDelims( '"]["', '/\' )#"]={}' );
			} );
			var findRoot = function( lookups ){
				if( lookups.count() == 1 ) {
					return lookups.keyList() & '/' & findRoot( lookups[ lookups.keyList() ] );
				} else {
					return '';
				}
			}
			setBaseDir( findRoot( lookups ) );
		}

	}

	function appendMatchQuery( matchQuery ) {
		matchQueryArray.append( matchQuery );
		return;
	}

	private function processPattern( string pattern, baseDir, skipExcludes=false ) {
		local.thisPattern = pathPatternMatcher.normalizeSlashes( arguments.pattern );
		var exactPattern = thisPattern.startsWith('/');
		var fileFilter = '';
		var fullPatternPath = ( getLoose() ? pathAppend( getBaseDir(), thisPattern ) : thisPattern );

		// Optimization for exact file path
		if( ( !getLoose() || exactPattern )
			&& ( thisPattern does not contain '*' && thisPattern does not contain '?' && fileExists( fullPatternPath ) )
		) {
			arguments.baseDir = getDirectoryFromPath( fullPatternPath );
			fileFilter = '*' & listLast( fullPatternPath, '/' )
		} else {
			if( isNull( arguments.baseDir ) ) {
				// Special handing for Windows drive letter and no folder as you can't run directoryList() and get a drive letter back!
				// This only kicks in for C: not C:/ as the latter would list all children folders
				if( pattern.listLen( '/' ) == 1 && pattern contains ':' && !pattern.endsWith( '/' ) ) {
					// Spoof a directory listing that contains just the drive letter directly
					appendMatchQuery( queryNew(
						'name,size,type,dateLastModified,attributes,mode,directory',
						'string,string,string,date,string,string,string',
						['',0,'Dir',now(),'','',pattern]
					) );
					setBaseDir( baseDir & ( baseDir.endsWith( '/' ) ? '' : '/' ) );
					return true;
				}

				// To optimize this as much as possible, we want to get a directory listing as deep as possible so we process a few files as we can.
				// Find the deepest folder that doesn't have a wildcard in it.
				if( getLoose() ) {
					if( exactPattern ) {
						arguments.baseDir = calculateBaseDir( getBaseDir() & thisPattern.right( -1 ) )
					} else {
						arguments.baseDir = calculateBaseDir( getBaseDir() )
					}
				} else {
					arguments.baseDir = calculateBaseDir( thisPattern );
				}
			}
		}

		// Strip off the "not found" part
		var remainingPattern = findUnmatchedPattern( thisPattern, baseDir )
		var dl = directoryList (
				listInfo='query',
				recurse=false,
				path=baseDir,
				filter=fileFilter
			).filter( ( path )=>{
				// All of this nonsense is to build the full normalized path of this item WITH a trailing slash if it's a directory
				if( arguments.path.directory.endsWith( '/' ) || arguments.path.directory.endsWith( '\' ) ) {
					var thisPath = arguments.path.directory & arguments.path.name & ( arguments.path.type == 'dir' ? '/' : '' );
				} else {
					var thisPath = arguments.path.directory & '/' & arguments.path.name & ( arguments.path.type == 'dir' ? '/' : '' );
				}
				local.thisPath = pathPatternMatcher.normalizeSlashes( thisPath );

				var pathToMatch = local.thisPath;
				if( getLoose() ) {
					pathToMatch = local.thisPath.replaceNoCase( getBaseDir(), '' );
				}

				// If we've hit an exclude pattern, we can bail now-- skipping all recursion and processing of files at this level.
				var thisExcludePattern = this.getExcludePatternArray();
				if( !skipExcludes && thisExcludePattern.len() && pathPatternMatcher.matchPatterns( thisExcludePattern, pathToMatch, !getLoose() ) ) {
					// UNLESS we have a negated ignore!
					var possiblePatterns = pathMayNotBeExcluded( pathToMatch, path.type, baseDir );
					if( possiblePatterns.len() ) {
						// If we're looking at a file, just check it.  No need to recurse.
						if(  path.type == 'file' ) {
							if( pathPatternMatcher.matchPatterns( possiblePatterns, pathToMatch, !getLoose() ) ) {
								return true;
							}
						} else {
							// For each of our possible patterns, let's recurse and check each of them.
							// TODO: optimize this by recursing once and checking all patterns at a time,
							// but that will require a major refactor of processPatterns() to accept more than one pattern.
							for( var possiblePattern in possiblePatterns) {
								if( getLoose() ) {
									if( possiblePattern.startsWith( '/' ) ) {
										// Exact patterns in loose mode like /foo/bar/baz.txt we want to zoom straight down to the
										// deepest folder possible to reduce unnessary recursion.
										possiblePattern = pathAppend( getBaseDir(), possiblePattern );

										var thisBaseDir = calculateBaseDir( possiblePattern );
										possiblePattern = possiblePattern.replace( thisBaseDir, '' );
										processPattern( possiblePattern, thisBaseDir, true );
									} else {
										// non-exact patters which can be in any sub directory such as foo.txt just recurse down from the current folder we're looking at
										processPattern( possiblePattern, thisPath, true )
									}
								} else {
									// For non-loose mode just grab the deepest folder we can and start there.
									var thisBaseDir = calculateBaseDir( possiblePattern );
									processPattern( possiblePattern, thisBaseDir, true )
								}
							}
						}
					}
					return false;
				}

				// If we're inside a **, then we just blindly recurse forever
				if( arguments.path.type == 'dir' && remainingPattern.startsWith( '**' ) ) {
					processPattern( thisPattern, local.thisPath, skipExcludes )
				// If we're in loose mode, see if the next folder is a positive match
				} else if( arguments.path.type == 'dir' && getLoose() ) {
					if( exactPattern ) {
						if( pathPatternMatcher.matchPattern( '/' & remainingPattern.listFirst( '/' ), pathToMatch, !getLoose() ) ) {
							processPattern( '/' & remainingPattern.listRest( '/' ), local.thisPath, skipExcludes );
						}
					} else {
						processPattern( thisPattern, local.thisPath, skipExcludes );
					}
				// For all other remaining patterns, only recurse if we've found a folder that matches the next part of the pattern
				} if( arguments.path.type == 'dir' && remainingPattern.listLen( '/' ) > 1 ) {
					if( pathPatternMatcher.matchPattern( baseDir & remainingPattern.listFirst( '/' ) & '/**', pathToMatch, !getLoose() ) ) {
						processPattern( local.thisPath & remainingPattern.listRest( '/' ), local.thisPath, skipExcludes );
					}
				}

				// This check applies to files/folders that are immediate children of the current base dir.
				// We've already recursed into all worthy subfolders above
				if( pathPatternMatcher.matchPattern( thisPattern, local.pathToMatch, !getLoose() ) ) {
					return true;
				}
				return false;
			} );

		appendMatchQuery( dl );
		if( !getLoose() ) {
			setBaseDir( baseDir & ( baseDir.endsWith( '/' ) ? '' : '/' ) );
		}

	}

	/**
	* The sort function in CFDirectory will simply ignore invalid sort columns so I'm mimicking that here, as much as I dislike it.
	* The sort should be in the format of "col asc, col2 desc, col3, col4" like a SQL order by
	* If any of the columns or sort directions don't look right, just bail and return the default sort.
	*/
	function getCleanSort() {
		// Loop over each sort item
		for( var item in listToArray( getSort() ) ) {
			// Validate column name
			if( !listFindNoCase( 'name,directory,size,type,dateLastModified,attributes,mode', trim( item.listFirst( ' 	' ) ) ) ) {
				return 'type, name';
			}
			// Validate sort direction
			if( item.listLen( ' 	' ) == 2 && !listFindNoCase( 'asc,desc', trim( item.listLast( ' 	' ) ) ) ) {
				return 'type, name';
			}
			// Ensure no more than 2 tokens
			if( item.listLen( ' 	' ) > 2 ) {
				return 'type, name';
			}
		}
		// Ok, everything passes.
		return getSort();
	}

	private function calculateBaseDir( required string pattern ) {
		var baseDir = '';
		var i = 0;
		// Skip last token
		while( ++i <= pattern.listLen( '/' ) ) {
			var token = pattern.listGetAt( i, '/' );
			if( token contains '*' || token contains '?' ) {
				break;
			}
			// If we have a partial name like /foo/bar we may still match /foo/barstool.
			// Only if it's /foo/bar/ do we know we can trust that in the base path
			if( i == pattern.listLen( '/' ) && !pattern.endsWith( '/' ) && !(token contains ':' ) ) {
				break;
			}
			baseDir = pathAppend( baseDir, token );
		}

		// Unix paths need the leading slash put back
		if( pattern.startsWith( '/' ) ) {
			baseDir = '/' & baseDir;
		}

		// Directories must always end with trailing slash
		if( !pattern.endsWith( '/' ) ) {
			baseDir &= '/';
		}

		return baseDir;
	}

	private function combineMatchQueries() {
		if( !matchQueryArray.len() ) {
			setMatchQuery( queryNew( 'name,size,type,dateLastModified,attributes,mode,directory' ) );
		} else {
			var SQL = ''
			var i = 0;
			for( var thisQ in matchQueryArray ) {
				i++;
				local[ 'thisMatchQuery#i#' ] = thisQ;
				SQL &= ' SELECT * FROM thisMatchQuery#i# ';
				if( i < matchQueryArray.len() ) {
					SQL &= ' UNION ALL'
				}
			}

			var newMatchQuery = queryExecute(
				SQL,
				[],
				{ dbtype="query" }
			);

			var newMatchQuery = queryExecute(
				'SELECT * FROM newMatchQuery
				GROUP BY directory, name '
				& ( len( getSort() ) ? ' ORDER BY #getCleanSort()#' : '' ),
				[],
				{ dbtype="query" }
			);

			setMatchQuery( local.newMatchQuery );
		}
	}

	function pathMayNotBeExcluded( pathToMatch, type, currentBaseDir ) {
		if( !getNotExcludePattern().len() ) {
			return [];
		}
		var possiblePatterns=[];

		for( notExclude in getNotExcludePattern() ) {
			var exactPattern = notExclude.startsWith('/');
			var remainingPattern = findUnmatchedPattern( notExclude, currentBaseDir )

			// Well, crumbs-- all bets are off!
			// /temp/**
			// !foo.txt
			if( type == 'dir' && getLoose() && !exactPattern ) {
				possiblePatterns.append( notExclude );
				continue;
			}

			// If it's a file, just check it
			if( type == 'file' ) {
				if( pathPatternMatcher.matchPattern( notExclude, pathToMatch, false ) ) {
					possiblePatterns.append( notExclude );
				}
				// Even if we didn't find a match, all the checks below only apply to directories
				continue;
			}

			// These all apply to directories.  The question is whether or not we MAY need to recurse into the dir
			// based on whether there is a notexclude pattern that could possibly be inside the dir

			// If we're inside a **, then we just blindly recurse forever
			if( remainingPattern.startsWith( '**' ) ) {
				possiblePatterns.append( notExclude );
				continue;
			// If we're in loose mode with an exact pattern, see if the next folder is a positive match
			} else if( getLoose() && exactPattern && pathPatternMatcher.matchPattern( '/' & remainingPattern.listFirst( '/' ), pathToMatch, !getLoose() ) ) {
				possiblePatterns.append( notExclude );
				continue;
			// For all other remaining patterns, only recurse if we've found a folder that matches the next part of the pattern
			} if( remainingPattern.listLen( '/' ) > 1 && pathPatternMatcher.matchPattern( currentBaseDir & remainingPattern.listFirst( '/' ) & '/**', pathToMatch, !getLoose() ) ) {
				possiblePatterns.append( notExclude );
				continue;
			}

		}
		return possiblePatterns;
	}

	function findUnmatchedPattern( thisPattern, currentBaseDir ) {
		var exactPattern = thisPattern.startsWith('/');
		if( getLoose() ) {
			if( exactPattern ) {
				if( currentBaseDir == getBaseDir() ) {
					var remainingPattern = thisPattern;
				} else {
					var remainingPattern = thisPattern.replaceNoCase( currentBaseDir.replaceNoCase( getBaseDir(), '' ), '' );
				}
			} else {
				// A loose pattern without a leading slash can be any levels deep
				remainingPattern = '**';
			}
		} else {		// Windows drive letters need trailing slash.
			if( thisPattern.listLen( '/' ) == 1 && thisPattern contains ':' && !thisPattern.endsWith( '/' ) ) {
				thisPattern &= '/';
			}

			var remainingPattern = thisPattern.replaceNoCase( currentBaseDir, '' );
			// if our base path isn't contained inside the pattern, we have entered a ** portion and we can't short circuit anything now
			if( remainingPattern == thisPattern ) {
				remainingPattern = '**';
			}
		}
		return remainingPattern;
	}

	/**
	* Concatenate a folder or file to an existing base path, taking into account forward or backslashes
	* Won't remove leading slashes on *nix.
	* If base is an empty string, path is returned untouched.
	*
	* @base The base path to append to
	* @path The path segment or segments to add on to the base
	*/
	function pathAppend( base, path ) {
		if( base == '' ) {
			return path;
		}
		// Ensure trailing slash on base
		if( !base.endsWith( '/' ) && !base.endsWith( '\' ) ) {
			base  &= '/';
		}
		// Remove any leading slash on path
		if( path.startsWith( '/' ) || path.startsWith( '\' ) ) {
			path = path.right( -1 );
		}
		return base & path;
	}

}
