/**
 * Our Mocking Data CFC
 * Please review the readme.md for instructions on usage.
 */
component {

	/**
	 * Direct method for URL mocking service
	 */
	param name="url.method" default="mock";

	/**
	 * --------------------------------------------------------------------------
	 * Static Data Used For Generation
	 * --------------------------------------------------------------------------
	 */

	variables.cwd = getDirectoryFromPath( getCurrentTemplatePath() );

	// Defaults used for data, may move to a file later
	variables._firstNames = [
		"Alexia",
		"Alice",
		"Amy",
		"Ana",
		"Andy",
		"Barry",
		"Bob",
		"Charlie",
		"Clara",
		"Clarence",
		"Danny",
		"Delores",
		"Erin",
		"Esteban",
		"Fernando",
		"Frank",
		"Gary",
		"Gene",
		"George",
		"Heather",
		"Jacob",
		"Jorge",
		"Jose",
		"Juan",
		"Leah",
		"Lisa",
		"Lucas",
		"Lucia",
		"Luis",
		"Lynn",
		"Maria",
		"Mateo",
		"Nick",
		"Noah",
		"Pablo",
		"Ray",
		"Ricardo",
		"Roger",
		"Romeo",
		"Scott",
		"Todd",
		"Veronica"
	];

	variables._lastNames = [
		"Anderson",
		"Bearenstein",
		"Boudreaux",
		"Camden",
		"Castro",
		"Clapton",
		"Degeneres",
		"Elias",
		"Flores",
		"Hill",
		"Lainez",
		"Lopez",
		"Madeiro",
		"Maggiano",
		"Marquez",
		"Messi",
		"Moneymaker",
		"Padgett",
		"Pilato",
		"Reyes",
		"Rodrigues",
		"Rogers",
		"Sanabria",
		"Sandoval",
		"Segovia",
		"Sharp",
		"Smith",
		"Stroz",
		"Tobias",
		"Zelda"
	];

	variables._webDomains = [
		"adobe.com",
		"aol.com",
		"apple.com",
		"awesome.com",
		"box.com",
		"box.io",
		"box.net",
		"boxing.com",
		"example.sv.com",
		"example.co.uk",
		"example.jp",
		"example.edu",
		"example.com",
		"example.net",
		"email.com",
		"mail.io",
		"gmail.com",
		"google.com",
		"microsoft.com",
		"msn.com",
		"ortus.io",
		"ortus.com",
		"sample.io",
		"sample.edu",
		"sample.com",
		"test.com"
	];

	variables._loremData = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

	variables._words = deserializeJSON( fileRead( variables.cwd & "nouns.json" ) );

	variables._adjectives = deserializeJSON( fileRead( variables.cwd & "adjectives.json" ) );

	variables._baconloremData = arrayToList( [
		"Bacon ipsum dolor amet bacon biltong brisket sirloin kielbasa",
		"hock beef landjaeger boudin alcatra",
		"sausage beef beef ribs pancetta pork chop doner short ribs",
		"brisket alcatra shankle pork chop, turducken picanha",
		"Venison doner leberkas turkey ball tip tongue"
	] );

	variables._defaultTypes = [
		"age",
		"all_age",
		"baconlorem",
		"date",
		"datetime",
		"email",
		"fname",
		"gps",
		"guid",
		"lname",
		"name",
		"num",
		"sentence",
		"ssn",
		"tel",
		"uuid",
		"words"
	];

	variables._extensions = [
		".cfm",
		".css",
		".doc",
		".docx",
		".jpg",
		".js",
		".htm",
		".html",
		".pdf",
		".php",
		".png",
		".ppt",
		".pptx",
		".xls",
		".xlsx"
	];

	variables._imageExtensions = [
		".svg",
		".gif",
		".jpg",
		".jpeg",
		".pdf",
		".png"
	];

	variables.RESERVED_ARGUMENTS = [ "$num", "$returnType", "$type" ];

	/**
	 * This function is the remote entry point for our service or data calls
	 * The incoming arguments are evaluated for mocking data services.
	 *
	 * @return Array, struct, or single mocked data
	 */
	remote function mock() returnformat="json"{
		// cfheader( name="Content-Type", value="text/html" );

		// Did they specify how many they want?
		if ( !arguments.keyExists( "$num" ) ) {
			arguments.$num = 10;
		}

		// Did they specify the return type?
		if ( !arguments.keyExists( "$returnType" ) ) {
			arguments.$returnType = "array";
		}

		// If num is not numeric, then it must be our random number generator
		if ( !isNumeric( arguments.$num ) && arguments.$num.find( ":" ) > 0 ) {
			var parts = arguments.$num.listToArray( ":" );
			if ( !listFindNoCase( "rnd,rand", parts[ 1 ] ) ) {
				throw( "Invalid num prefix sent. Must be 'rnd' or 'rand'" );
			}
			// format is rnd:10 which means, from 1 to 10
			if ( parts.len() == 2 ) {
				arguments.$num = randRange( 1, parts[ 2 ] );
			} else {
				arguments.$num = randRange( parts[ 2 ], parts[ 3 ] );
			}
		}

		// Determine incoming models from argument definition excluding reserved args
		var aFieldModels = [];
		for ( var key in arguments ) {
			if ( !variables.RESERVED_ARGUMENTS.findNoCase( key ) ) {
				aFieldModels.append( { name : key, type : arguments[ key ] } );
			}
		}

		// Did we receive an explicit array of values type?
		if ( arguments.keyExists( "$type" ) ) {
			var result = [];
			for ( var i = 1; i <= arguments.$num; i++ ) {
				result.append( generateFakeData( arguments[ "$type" ], i ) );
			}
		}
		// Then we go on return types for return formats
		else if ( arguments.$returnType == "array" ) {
			// Array of struct objects
			var result = [];
			for ( var i = 1; i <= arguments.$num; i++ ) {
				result.append( generateNewItem( aFieldModels, i ) );
			}
		} else {
			// Struct objects
			var result = generateNewItem( aFieldModels, 0 );
		}

		// If in Service mode, then add headers
		if ( cgi.script_name contains "MockData.cfc" ) {
			cfheader( name = "Content-Type", value = "application/json" );
			// CORS for web service calls
			cfheader( name = "Access-Control-Allow-Origin", value = "*" );
		}

		return result;
	}

	/**
	 * Generate the fake data according to incoming type
	 *
	 * @type  The valid incoming fake data type, see docs for valid types
	 * @index The index location of the fake iteration if any
	 *
	 * @return The fake data
	 */
	function generateFakeData( required type, index = 1 ){
		// Supplier closure or lambda
		if ( isClosure( arguments.type ) || isCustomFunction( arguments.type ) ) {
			return arguments.type( arguments.index );
		}
		if ( arguments.type == "autoincrement" ) {
			return arguments.index;
		}
		if ( arguments.type == "ipaddress" ) {
			return ipAddress();
		}
		if ( arguments.type.findNoCase( "string" ) == 1 ) {
			return string( arguments.type );
		}
		if ( arguments.type == "uuid" ) {
			return createUUID();
		}
		if ( arguments.type == "guid" ) {
			return insert( "-", createUUID(), 23 ).lcase();
		}
		if ( arguments.type == "name" ) {
			return firstName() & " " & lastName();
		}
		if ( arguments.type == "fname" ) {
			return firstName();
		}
		if ( arguments.type == "lname" ) {
			return lastName();
		}
		if ( arguments.type == "age" ) {
			return randRange( 18, 75 );
		}
		if ( arguments.type == "all_age" ) {
			return randRange( 1, 100 );
		}
		if ( arguments.type == "email" ) {
			return email();
		}
		if ( arguments.type == "imageurl" ) {
			return imageUrl();
		}
		if ( arguments.type == "imageurl_http" ) {
			return imageUrl( httpOnly = true );
		}
		if ( arguments.type == "imageurl_https" ) {
			return imageUrl( httpsOnly = true );
		}
		if ( arguments.type == "url" ) {
			return uri();
		}
		if ( arguments.type == "url_http" ) {
			return uri( httpOnly = true );
		}
		if ( arguments.type == "url_https" ) {
			return uri( httpsOnly = true );
		}
		if ( arguments.type == "website" ) {
			return websiteUrl();
		}
		if ( arguments.type == "website_http" ) {
			return websiteUrl( httpOnly = true );
		}
		if ( arguments.type == "website_https" ) {
			return websiteUrl( httpsOnly = true );
		}
		if ( arguments.type == "ssn" ) {
			return ssn();
		}
		if ( arguments.type == "tel" ) {
			return telephone();
		}
		if ( arguments.type == "date" ) {
			return dateRange();
		}
		if ( arguments.type == "datetime" ) {
			return dateRange( showTime = true );
		}
		if ( arguments.type.findNoCase( "num" ) == 1 ) {
			return num(
				arguments.type.find( ":" ) ? arguments.type.REreplaceNoCase( "num\:?", "" ) : javacast(
					"null",
					""
				)
			);
		}
		if ( arguments.type.findNoCase( "oneof" ) == 1 ) {
			return oneOf(
				arguments.type.find( ":" ) ? arguments.type.REreplaceNoCase( "oneOf\:?", "" ) : javacast(
					"null",
					""
				)
			);
		}
		if ( arguments.type.findNoCase( "lorem" ) == 1 ) {
			return lorem(
				arguments.type.find( ":" ) ? arguments.type.REreplaceNoCase( "lorem\:?", "" ) : javacast(
					"null",
					""
				)
			);
		}
		if ( arguments.type.findNoCase( "baconlorem" ) == 1 ) {
			return baconLorem(
				arguments.type.find( ":" ) ? arguments.type.REreplaceNoCase( "baconlorem\:?", "" ) : javacast(
					"null",
					""
				)
			);
		}
		if ( arguments.type.findNoCase( "sentence" ) == 1 ) {
			return sentence(
				arguments.type.find( ":" ) ? arguments.type.REreplaceNoCase( "sentence\:?", "" ) : javacast(
					"null",
					""
				)
			);
		}
		if ( arguments.type.findNoCase( "words" ) == 1 ) {
			return words(
				arguments.type.find( ":" ) ? arguments.type.REreplaceNoCase( "words\:?", "" ) : javacast(
					"null",
					""
				)
			);
		}

		return "No Type ['#arguments.type#'] Found";
	}

	/********************************* GENERATORS ********************************/

	/**
	 * Generate random strings according to the passed string type
	 *
	 * The type can be of the following permutations pattern: string[-(secure|alpha|numeric):max]
	 *
	 * string - Generate 10 alphanumeric characters
	 * string:max - Generate {max} count of alphanumeric characters
	 * string-numeric - Generate numeric characters
	 * string-alpha - Generate alpha characters
	 * string-secure - Generate alpha+numeric+secure characters
	 *
	 * @type This can be string, or string:size
	 */
	function string( required type ){
		// Generation data
		var alpha = listToArray(
			"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
		);
		var numeric = listToArray( "0,1,2,3,4,5,6,7,8,9" );
		var secure  = listToArray( "!,@,$,%,&,*,-,_,=,+,?,~" );

		// The return type to use: alphanumeric (default), alpha, numeric, secure
		if ( arguments.type.findNoCase( "string-alphanumeric" ) ) {
			var returnType = "alphanumeric";
		} else if ( arguments.type.findNoCase( "string-numeric" ) ) {
			var returnType = "numeric";
		} else if ( arguments.type.findNoCase( "string-alpha" ) ) {
			var returnType = "alpha";
		} else if ( arguments.type.findNoCase( "string-secure" ) ) {
			var returnType = "secure";
		} else {
			var returnType = "alphanumeric";
		}

		// Check incoming type, if default of `string` default to 10 chars
		if ( !arguments.type.find( ":" ) ) {
			arguments.type &= ":10";
		}

		// Prepare Data List
		switch ( returnType ) {
			case "alpha": {
				var dataList = alpha;
				break;
			}
			case "numeric": {
				var dataList = numeric;
				break;
			}
			case "secure": {
				var dataList = alpha.append( numeric.append( secure, true ), true );
				break;
			}
			default: {
				var dataList = alpha.append( numeric, true );
			}
		}

		// Iterate and create string
		var result = "";
		var count  = getToken( arguments.type, 2, ":" );
		for ( var i = 1; i <= count; i++ ) {
			result &= dataList[ randRange( 1, dataList.len() ) ];
		}

		return result;
	}

	/**
	 * Generate random words
	 *
	 * @size The number of words to generate or can be a min:max range to produce random number of words
	 */
	function words( size = 1 ){
		// Do we have a random size request?
		if ( find( ":", arguments.size ) ) {
			arguments.size = randRange( getToken( arguments.size, 1, ":" ), getToken( arguments.size, 2, ":" ) );
		}
		// Generate it
		var result = [];
		for ( var i = 1; i <= arguments.size; i++ ) {
			if ( i mod 2 > 0 ) {
				result.append( variables._words[ randRange( 1, variables._words.len() ) ] );
			} else {
				result.append( variables._adjectives[ randRange( 1, variables._adjectives.len() ) ] );
			}
		}
		return result.toList( " " );
	}

	/**
	 * Generate sentences
	 *
	 * @size The number of sentences to produce, default is 1, or pass in a min:max to produce random sentences
	 */
	function sentence( size = 1 ){
		// Do we have a random size request?
		if ( find( ":", arguments.size ) ) {
			arguments.size = randRange( getToken( arguments.size, 1, ":" ), getToken( arguments.size, 2, ":" ) );
		}
		// Generate it
		var result = [];
		for ( var i = 1; i <= arguments.size; i++ ) {
			result.append( words( 15 ) & chr( 13 ) & chr( 10 ) );
		}
		return result.toList();
	}

	/**
	 * Generate Lorem
	 *
	 * @size The number of sentences of lorem to produce, default is 1, or pass in a min:max to produce random sentences
	 */
	function lorem( size = 1 ){
		// Do we have a random size request?
		if ( find( ":", arguments.size ) ) {
			arguments.size = randRange( getToken( arguments.size, 1, ":" ), getToken( arguments.size, 2, ":" ) );
		}
		// Generate it
		var result = [];
		for ( var i = 1; i <= arguments.size; i++ ) {
			result.append( variables._loremData );
		}
		return result.toList();
	}

	/**
	 * Generate bacon lorem text
	 *
	 * @size The number of sentences of lorem to produce, default is 1, or pass in a min:max to produce random sentences
	 */
	function baconLorem( size = 1 ){
		// Do we have a random size request?
		if ( find( ":", arguments.size ) ) {
			arguments.size = randRange( getToken( arguments.size, 1, ":" ), getToken( arguments.size, 2, ":" ) );
		}
		// Generate it
		var result = [];
		for ( var i = 1; i <= arguments.size; i++ ) {
			result.append( variables._baconloremData );
		}
		return result.toList();
	}

	/**
	 * Generate one of the data supplied randomly
	 *
	 * @data This can be a single value or a list of values val1:val2:valz
	 */
	function oneOf( required data ){
		// Support oneof:male:female, ie, pick a random one
		var items = arguments.data.listToArray( ":" );
		return items[ randRange( 1, items.len() ) ];
	}

	/**
	 * Generate a random number, if no count is passed we use a ceiling of 10
	 *
	 * @count The count of numbers to generate. This can be a whole number or the `min:max` format
	 */
	function num( count = 10 ){
		// Basic generation
		if ( !find( ":", arguments.count ) ) {
			return randRange( 1, arguments.count );
		}
		// Min/Max generation
		return randRange( getToken( arguments.count, 1, ":" ), getToken( arguments.count, 2, ":" ) );
	}

	/**
	 * Generate telephone
	 */
	function telephone(){
		return "(" & randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 ) & ") " &
		randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 ) & "-" &
		randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 );
	}

	/**
	 * Generate a social security number
	 */
	function ssn(){
		return randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 ) & "-" &
		randRange( 1, 9 ) & randRange( 1, 9 ) & "-" &
		randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 ) & randRange( 1, 9 );
	}

	/**
	 * Generate an email
	 */
	function email(){
		var fname       = firstName().toLowerCase();
		var lname       = lastName().toLowerCase();
		var emailPrefix = fname.charAt( 1 ) & lname;
		return emailPrefix & "@" & variables._webDomains[ randRange( 1, variables._webDomains.len() ) ];
	}

	/**
	 * Generate a random image URL including a random protocol
	 *
	 * @httpOnly  Only do http sites, mutex with httpsOnly
	 * @httpsOnly Only do https sites, mutex with httpOnly
	 */
	function imageUrl( boolean httpOnly, boolean httpsOnly ){
		arguments.imageExtensions = true;
		return uri( argumentCollection = arguments );
	}

	/**
	 * Generate a random URI including a random protocol
	 *
	 * @httpOnly  Only do http sites, mutex with httpsOnly
	 * @httpsOnly Only do https sites, mutex with httpOnly
	 */
	function uri(
		boolean httpOnly,
		boolean httpsOnly,
		boolean imageExtensions = false
	){
		var randomPaths = words( "1:#randRange( 1, 5 )#" )
			.listToArray( " " )
			.toList( "/" )
			.lcase();

		var randomHash = "";
		if ( ( randRange( 1, 10 ) % 2 ) ) {
			randomHash = "###words()#";
		}

		var randomFile = "";
		if ( ( randRange( 1, 10 ) % 2 ) ) {
			randomFile = words();
		}

		if ( arguments.imageExtensions ) {
			randomFile &= variables._imageExtensions[ randRange( 1, variables._imageExtensions.len() ) ];
		} else {
			randomFile &= variables._extensions[ randRange( 1, variables._extensions.len() ) ];
		}

		return websiteUrl( argumentCollection = arguments ) & "/" & randomPaths & randomFile & randomHash;
	}

	/**
	 * Generate a random website including random protocol
	 *
	 * @httpOnly  Only do http sites, mutex with httpsOnly
	 * @httpsOnly Only do https sites, mutex with httpOnly
	 */
	function websiteUrl( boolean httpOnly, boolean httpsOnly ){
		var prefix = "http";
		if ( !isNull( arguments.httpsOnly ) ) {
			prefix = "https";
		}
		if ( isNull( arguments.httpOnly ) && isNull( arguments.httpsOnly ) ) {
			prefix &= ( ( randRange( 1, 10 ) % 2 ) ? "s" : "" );
		}

		var webPart = "";
		if ( ( randRange( 1, 10 ) % 2 ) ) {
			webPart = "www.";
		}

		return "#prefix#://" & webpart & variables._webDomains[ randRange( 1, variables._webDomains.len() ) ];
	}

	/**
	 * Generate an ip address
	 */
	function ipAddress(){
		return "#randRange( 0, 255 )#.#randRange( 0, 255 )#.#randRange( 0, 255 )#.#randRange( 0, 255 )#";
	}

	/**
	 * Generate a first name
	 */
	function firstName(){
		return variables._firstNames[ randRange( 1, variables._firstNames.len() ) ];
	}

	/**
	 * Generate a last name
	 *
	 * @return {[type]} [description]
	 */
	function lastName(){
		return variables._lastNames[ randRange( 1, variables._lastNames.len() ) ];
	}

	/**
	 * Genereate a random data range
	 *
	 * @from       The date time start
	 * @to         The end date else defaults to today
	 * @showTime   Show time in the data
	 * @dateFormat The date formatting to use
	 * @timeFormat The time formmating to use
	 */
	function dateRange(
		date from  = "#createDateTime( "2010", "01", "01", "0", "0", "0" )#",
		date to    = "#now()#",
		showTime   = false,
		dateFormat = "medium",
		timeFormat = "medium"
	){
		var timeDifference = dateDiff( "s", arguments.from, arguments.to );
		var result         = dateAdd( "s", randRange( 0, timeDifference ), arguments.from );

		if ( arguments.showTime ) {
			return dateFormat( result, arguments.dateFormat ) & " " & timeFormat( result, arguments.timeFormat );
		} else {
			return dateFormat( result, arguments.dateFormat );
		}
	}

	/***************************** PRIVATE ****************************************/

	/**
	 * Check if an incoming type exists in our default types
	 *
	 * @target The target string to check
	 */
	private boolean function isDefaultType( required target ){
		return variables._defaultTypes.findNoCase( arguments.target ) > 0;
	}

	/**
	 * Generate a new mocked item, called by the mock() method when receiving arguments
	 * and parsing them into field models
	 *
	 * @fieldModels An array of field model structs: { name : "fieldName", type : "mocking type" }
	 * @index       The numerical index of the item being generated
	 *
	 * @return The generated faked item
	 */
	private struct function generateNewItem( required array fieldModels, index = 1 ){
		var result = {};
		arguments.fieldModels.each( function( field ){
			// Verify the field struct has a name, else generate it
			if ( !field.keyExists( "name" ) ) {
				field.name = "field" & i;
			}

			// if we are a default, that is our type, otherwise string
			if (
				isSimpleValue( field.type )
				&&
				!field.type.len()
				&&
				isDefaultType( field.name )
			) {
				field.type = field.name;
			}

			// Determine the type of field model
			if ( isStruct( field.type ) ) {
				// Bind the return type as a struct
				field.type.$returnType = "struct";
				// The field model defines a single object relationship
				result[ field.name ]   = mock( argumentCollection = field.type );
			} else if ( isArray( field.type ) ) {
				// The field model defines a one to many relationship
				result[ field.name ] = mock( argumentCollection = field.type[ 1 ] );
			} else {
				// Generate the fake data
				result[ field.name ] = generateFakeData( field.type, index );
			}
		} );

		return result;
	}

}
