/**
 * Functional Interface that maps to java.lang.Runnable
 * See https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html
 */
component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @target The lambda or closure or CFC to be used as the runnable
     */
    function init( required target ){
		super.init( arguments.target );
        return this;
    }

    function run(){
		loadContext();
        if( isClosure( variables.target ) || isCustomFunction( variables.target ) ){
            variables.target();
        } else{
            variables.target.run();
        }
    }

}