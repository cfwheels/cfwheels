/**
 * Functional interface base dynamically compiled via dynamic proxy
 */
component accessors="true"{

	/**
	 * The target function to be applied via dynamic proxy to the required Java interface(s)
	 */
	property name="target";

    /**
     * Constructor
     *
     * @target The target function to be applied via dynamic proxy to the required Java interface(s)
     */
    function init( required target ){
		// Store target closure/lambda
		variables.target = arguments.target;
		variables.loadedContextHashCode = "";

		// Preapre for parallel executions to enable the right fusion context
		if( server.keyExists( "lucee") ){
			// TODO: Need lucee way to approach this
		} else {
			variables.cfContext = getPageContext().getFusionContext();
		}


        return this;
	}

	/**
	 * Ability to load the context into the running thread
	 */
	function loadContext(){
		// Only load it, if in a streamed thread.
		if( inStreamThread() ){

			if( !isContextLoaded() ){
				lock
					name="cbstreams.contextloading.#getCurrentThreadName()#"
					throwOnTimeout=true
					timeout=5
					type="exclusive"
				{
					if( !isContextLoaded() ){

						this.println( "==> Context NOT loaded for thread: #getCurrentThreadName()#, loading it..." );

						// Lucee vs Adobe Implementations
						if( server.keyExists( "lucee") ){

						} else {
							getCFMLContext().getFusionContext().setCurrent( variables.cfContext.clone() );
						}

						request[ "cbstreams-pcloaded-#getCurrentThreadName()#" ] = true;
					}
				}
			} else {
				this.println( "Context loaded for thread: #getCurrentThreadName()#, skipping it..." );
			}

		} // end if in stream thread
	}

	/**
	 * Verify if context is loaded or not
	 */
	boolean function isContextLoaded(){
		return structKeyExists( request, "cbstreams-pcloaded-#getCurrentThreadName()#" );
	}

	/**
	 * This function is used for the engine to compile the page context bif into the page scope
	 */
	function getCFMLContext(){
		return getPageContext();
	}

	/**
	* Check if you are in cfthread or not for any CFML Engine
	*/
	boolean function inStreamThread(){
		return ( findNoCase( "fork", getCurrentThread().getName() ) NEQ 0 );
	}

	/**
	 * Get the current thread instance
	 *
	 * @return java.lang.Thread
	 */
	function getCurrentThread(){
		return createObject( "java", "java.lang.Thread" ).currentThread();
	}

	/**
	 * Get the current Thread name
	 *
	 * @text
	 */
	function getCurrentThreadName(){
		return getCurrentThread().getName();
	}

	/**
	 * Out helper for debugging, else all is in vanity
	 *
	 * @text
	 */
	function println( required text ){
		createObject( "java", "java.lang.System" ).out.printLn( arguments.text );
		return this;
	}

}