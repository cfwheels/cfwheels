<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Author           	 		: Luis Majano
Date                   		: April 20, 2009
Description		:
A mock generator
----------------------------------------------------------------------->
<cfcomponent output="false" hint="The guy in charge of creating mocks">
	<cfscript>
	variables.instance = structNew();
	</cfscript>

	<cffunction name="init" access="public" output="false" returntype="MockGenerator" hint="Constructor">
		<cfargument name="mockBox" required="true"/>
		<cfargument
			name    ="removeStubs"
			required="false"
			default ="true"
			hint    ="Always remove stubs unless we are debugging"
		/>
		<cfscript>
		variables.instance.lb          = "#chr( 13 )##chr( 10 )#";
		variables.instance.mockBox     = arguments.mockBox;
		variables.instance.removeStubs = arguments.removeStubs;

		return this;
		</cfscript>
	</cffunction>

	<!--- generate --->
	<cffunction
		name      ="generate"
		output    ="false"
		access    ="public"
		returntype="string"
		hint      ="Generate a mock method and return the generated path"
	>
		<!--- ************************************************************* --->
		<cfargument name="method" type="string" required="true" hint="The method you want to mock or spy on"/>
		<cfargument
			name    ="returns"
			type    ="any"
			required="false"
			hint    ="The results it must return, if not passed it returns void or you will have to do the mockResults() chain"
		/>
		<cfargument
			name    ="preserveReturnType"
			type    ="boolean"
			required="true"
			default ="true"
			hint    ="If false, the mock will make the returntype of the method equal to ANY"
		/>
		<cfargument
			name    ="throwException"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="If you want the method call to throw an exception"
		/>
		<cfargument
			name    ="throwType"
			type    ="string"
			required="false"
			default =""
			hint    ="The type of the exception to throw"
		/>
		<cfargument
			name    ="throwDetail"
			type    ="string"
			required="false"
			default =""
			hint    ="The detail of the exception to throw"
		/>
		<cfargument
			name    ="throwMessage"
			type    ="string"
			required="false"
			default =""
			hint    ="The message of the exception to throw"
		/>
		<cfargument
			name    ="throwErrorCode"
			type    ="string"
			required="false"
			default =""
			hint    ="The errorCode of the exception to throw"
		/>
		<cfargument name="metadata" type="any" required="true" default="" hint="The function metadata"/>
		<cfargument name="targetObject" type="any" required="true" hint="The target object to mix in"/>
		<cfargument
			name    ="callLogging"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Will add the machinery to also log the incoming arguments to each subsequent calls to this method"
		/>
		<cfargument
			name    ="preserveArguments"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="If true, argument signatures are kept, else they are ignored. If true, BEWARE with $args() matching as default values and missing arguments need to be passed too."
		/>
		<cfargument
			name    ="callback"
			type    ="any"
			required="false"
			hint    ="A callback to execute that should return the desired results, this can be a UDF or closure."
		/>
		<!--- ************************************************************* --->
		<cfscript>
		var udfOut         = createObject( "java", "java.lang.StringBuilder" ).init( "" );
		var genPath        = expandPath( instance.mockBox.getGenerationPath() );
		var tmpFile        = "";
		var fncMD          = arguments.metadata;
		var isReservedName = false;
		var safeMethodName = arguments.method;
		var stubCode       = "";

		// Check reserved list and if so, rename it so we can include it, stupid CF
		if ( structKeyExists( getFunctionList(), arguments.method ) ) {
			isReservedName = true;
			safeMethodName = "$reserved_#arguments.method#";
		}

		// Create Method Signature
		udfOut.append(
			"<cfsc" & "ript>
			variables[ ""#safeMethodName#"" ] = variables[ ""@@tmpMethodName@@"" ];
			this[ ""#safeMethodName#"" ]           = variables[ ""@@tmpMethodName@@"" ];
			// Clean up
			structDelete( variables, ""@@tmpMethodName@@"" );
			structDelete( this, ""@@tmpMethodName@@"" );

			#fncMD.access# #fncMD.returntype# function @@tmpMethodName@@( #instance.lb#"
		);

		// Create Arguments Signature
		if ( structKeyExists( fncMD, "parameters" ) AND arguments.preserveArguments ) {
			for ( var x = 1; x lte arrayLen( fncMD.parameters ); x++ ) {
				var thisParam = fncMD.parameters[ x ];
				udfOut.append( "						" );
				if ( !isNull( thisParam.required ) && thisParam.required ) {
					udfOut.append( "required " );
				}
				if ( !isNull( thisParam.type ) && len( thisParam.required ) ) {
					udfOut.append( thisParam.type & " " );
				}
				udfOut.append( thisParam.name & " " );
				if ( !isNull( thisParam.default ) && thisParam.default != "[runtime expression]" ) {
					udfOut.append( "= " & outputQuotedValue( thisParam.default ) & " " );
				}
				// Remove these standard keys
				structDelete( thisParam, "required" );
				structDelete( thisParam, "type" );
				structDelete( thisParam, "name" );
				structDelete( thisParam, "default" );
				// Just loop over the rest and output them
				for ( var thisParamProp in thisParam ) {
					udfOut.append( thisParamProp & " = " & outputQuotedValue( thisParam[ thisParamProp ] ) & " " );
				}
				if ( x < arrayLen( fncMD.parameters ) ) {
					udfOut.append( "," );
				}
				udfOut.append( "#instance.lb#" );
			}
		}

		udfOut.append(
			"
			) output=#fncMD.output# {#instance.lb# "
		);

		// Continue Method Generation
		udfOut.append(
			"
			var results                 = this._mockResults;
			var resultsKey           = ""#arguments.method#"";
			var resultsCounter   = 0;
			var internalCounter = 0;
			var resultsLen           = 0;
			var callbackLen         = 0;
			var argsHashKey         = resultsKey & ""|"" & this.mockBox.normalizeArguments( arguments );
			var fCallBack             = """";

			// If Method & argument Hash Results, switch the results struct
			if( structKeyExists( this._mockArgResults, argsHashKey ) ) {
				// Check if it is a callback
				if( isStruct( this._mockArgResults[ argsHashKey ] ) &&
					  structKeyExists( this._mockArgResults[ argsHashKey ], ""type"" ) &&
					  structKeyExists( this._mockArgResults[ argsHashKey ], ""target"" ) ) {
					fCallBack = this._mockArgResults[ argsHashKey ].target;
				} else {
					// switch context and key
					results       = this._mockArgResults;
					resultsKey = argsHashKey;
				}
			}

			// Get the statemachine counter
			if( isSimpleValue( fCallBack ) ) {
				resultsLen = arrayLen( results[ resultsKey ] );
			}

			// Get the callback counter, if it exists
			if( structKeyExists( this._mockCallbacks, resultsKey ) ) {
				callbackLen = arrayLen( this._mockCallbacks[ resultsKey ] );
			}

			// Log the Method Call
			this._mockMethodCallCounters[ listFirst( resultsKey, ""|"" ) ] = this._mockMethodCallCounters[ listFirst( resultsKey, ""|"" ) ] + 1;

			// Get the CallCounter Reference
			internalCounter = this._mockMethodCallCounters[listFirst(resultsKey,""|"")];
			"
		);

		// Call Logging argument or Global Flag
		if ( arguments.callLogging OR arguments.targetObject._mockCallLoggingActive ) {
			udfOut.append( "arrayAppend(this._mockCallLoggers[""#arguments.method#""], arguments);#instance.lb#" );
		}

		// Exceptions? To Throw
		if ( arguments.throwException ) {
			udfOut.append(
				"

				throw( #outputQuotedValue( arguments.throwMessage )#, #outputQuotedValue( arguments.throwType )#, #outputQuotedValue( arguments.throwDetail )#, #outputQuotedValue( arguments.throwErrorCode )# );#instance.lb#"
			);
		}

		// Returns Something according to metadata?
		if ( fncMD[ "returntype" ] neq "void" ) {
			/* Results Recycling Code, basically, state machine code */
			udfOut.append(
				"
				if( resultsLen neq 0 ) {
					if( internalCounter gt resultsLen ) {
						resultsCounter = internalCounter - ( resultsLen*fix( (internalCounter-1)/resultsLen ) );
						return results[resultsKey][resultsCounter];
					} else {
						return results[resultsKey][internalCounter];
					}
				}
				"
			);
			// Callback Single
			udfOut.append(
				"
				if( callbackLen neq 0 ) {
					fCallBack = this._mockCallbacks[ resultsKey ][ 1 ];
					return fCallBack( argumentCollection = arguments );
				}
				"
			);
			// Callback Args
			udfOut.append(
				"
				if( not isSimpleValue( fCallBack ) ){
					return fCallBack( argumentCollection = arguments );
				}
				"
			);
		}
		udfOut.append( "}#instance.lb#" );
		udfOut.append( "</cfsc" & "ript>" );

		// Write it out
		stubCode = trim( udfOUt.toString() );
		tmpFile  = hash( stubCode ) & ".cfm";

		// This is necessary for methods named after CF keywords like "contains"
		var tmpMethodName = "tmp_#arguments.method#_" & hash( stubCode );
		stubCode          = replaceNoCase(
			stubCode,
			"@@tmpMethodName@@",
			tmpMethodName,
			"all"
		);

		if ( !fileExists( genPath & tmpFile ) ) {
			writeStub( genPath & tmpFile, stubCode );
		}

		// Mix In Stub
		try {
			// include it
			arguments.targetObject.$include = variables.$include;
			arguments.targetObject.$include( instance.mockBox.getGenerationPath() & tmpFile );
			structDelete( arguments.targetObject, "$include" );

			// reserved rename to original
			if ( isReservedName ) {
				arguments.targetObject[ arguments.method ] = arguments.targetObject[ safeMethodName ];
			}

			// Remove Stub
			removeStub( genPath & tmpFile );
		} catch ( Any e ) {
			// Remove Stub
			removeStub( genPath & tmpFile );
			rethrow;
		}
		</cfscript>
	</cffunction>

	<cffunction name="outputQuotedValue" output="false">
		<cfargument name="value">
		<cfreturn """#replaceNoCase( value, """", """""", "all" )#""">
	</cffunction>

	<!--- writeStub --->
	<cffunction
		name      ="writeStub"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Write a method generator stub"
	>
		<cfargument name="genPath" type="string" required="true"/>
		<cfargument name="code" type="string" required="true"/>

		<cffile action="write" file="#arguments.genPath#" output="#arguments.code#" addnewline="false">
	</cffunction>

	<!--- removeStub --->
	<cffunction
		name      ="removeStub"
		output    ="false"
		access    ="public"
		returntype="boolean"
		hint      ="Remove a method generator stub"
	>
		<cfargument name="genPath" type="string" required="true"/>

		<cfif fileExists( arguments.genPath ) and instance.removeStubs>
			<cffile action="delete" file="#arguments.genPath#">
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- generateCFC --->
	<cffunction
		name      ="generateCFC"
		output    ="false"
		access    ="public"
		returntype="any"
		hint      ="Generate CFC's according to specs"
	>
		<cfargument name="extends" type="string" required="false" default="" hint="The class the CFC should extend"/>
		<cfargument
			name    ="implements"
			type    ="string"
			required="false"
			default =""
			hint    ="The class(es) the CFC should implement"
		/>
		<cfscript>
		var udfOut   = createObject( "java", "java.lang.StringBuilder" ).init( "" );
		var genPath  = expandPath( instance.mockBox.getGenerationPath() );
		var tmpFile  = "";
		var cfcPath  = "";
		var oStub    = "";
		var local    = {};
		var stubCode = "";

		// Create CFC Signature
		udfOut.append( "<cfcomponent output=""false"" hint=""A MockBox awesome Component""" );
		// extends
		if ( len( trim( arguments.extends ) ) ) {
			udfOut.append( " extends=""#arguments.extends#""" );
		}
		// implements
		if ( len( trim( arguments.implements ) ) ) {
			udfOut.append( " implements=""#arguments.implements#""" );
		}

		// close tag
		udfOut.append( ">#instance.lb#" );

		// iterate over implementations
		for ( local.x = 1; local.x lte listLen( arguments.implements ); local.x++ ) {
			// generate interface methods
			generateMethodsFromMD( udfOut, getComponentMetadata( listGetAt( arguments.implements, x ) ) );
		}

		// close it
		udfOut.append( "</cfcomponent>" );

		// Write it out
		stubCode = udfOUt.toString();
		tmpFile  = hash( stubCode ) & ".cfc";
		if ( !fileExists( genPath & tmpFile ) ) {
			writeStub( genPath & tmpFile, stubCode );
		}

		try {
			// create stub + clean first . if found.
			cfcPath = replace(
				instance.mockBox.getGenerationPath(),
				"/",
				".",
				"all"
			) & listFirst( tmpFile, "." );
			cfcPath = reReplace( cfcPath, "^\.", "" );
			oStub   = createObject( "component", cfcPath );
			// Remove Stub
			removeStub( genPath & tmpFile );
			// Return it
			return oStub;
		} catch ( Any e ) {
			// Remove Stub
			removeStub( genPath & tmpFile );
			rethrow;
		}
		</cfscript>
	</cffunction>

	<!--- generateMethodsFromMD --->
	<cffunction
		name      ="generateMethodsFromMD"
		output    ="false"
		access    ="private"
		returntype="any"
		hint      ="Generates methods from functions metadata"
	>
		<cfargument name="buffer" type="any" required="true" hint="The string buffer to append stuff to"/>
		<cfargument name="md" type="any" required="true" hint="The metadata to generate"/>
		<cfscript>
		var local  = {};
		var udfOut = arguments.buffer;

		// local functions if they exist
		local.oMD = [];
		if ( structKeyExists( arguments.md, "functions" ) ) {
			local.oMD = arguments.md.functions;
		}

		// iterate and create functions
		for ( local.x = 1; local.x lte arrayLen( local.oMD ); local.x++ ) {
			// start function tag
			udfOut.append( "<cffunction" );

			// iterate over the values of the function
			for ( local.fncKey in local.oMD[ x ] ) {
				// Do Simple values only
				if ( isSimpleValue( local.oMD[ x ][ local.fncKey ] ) ) {
					udfOut.append( " #lCase( local.fncKey )#=""#local.oMD[ x ][ local.fncKey ]#""" );
				}
			}
			// close function start tag
			udfOut.append( ">#instance.lb#" );

			// Do parameters if they exist
			for ( local.y = 1; local.y lte arrayLen( local.oMD[ x ].parameters ); local.y++ ) {
				// start argument
				udfOut.append( "<cfargument" );
				// do attributes
				for ( local.fncKey in local.oMD[ x ].parameters[ y ] ) {
					udfOut.append(
						" #lCase( local.fncKey )#=""#local.oMD[ x ].parameters[ y ][ local.fncKey ]#"""
					);
				}
				// close argument
				udfOut.append( ">#instance.lb#" );
			}

			// close full function
			udfOut.append( "</cffunction>#instance.lb#" );
		}

		// Check extends and recurse
		if ( structKeyExists( arguments.md, "extends" ) ) {
			for ( var thisKey in arguments.md.extends ) {
				generateMethodsFromMD( udfOut, arguments.md.extends[ thisKey ] );
			}
		}
		</cfscript>
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------>

	<!--- $include --->
	<cffunction name="$include" output="false" access="private" returntype="void" hint="Mix in a template">
		<cfargument name="templatePath" type="string" required="true"/>
		<cfinclude template="#arguments.templatePath#">
	</cffunction>
</cfcomponent>
