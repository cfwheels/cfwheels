/**
 * Functional Interface that maps to java.util.function.Consumer
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html
 */
component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @f The lambda or closure to be used in the <code>accept()</code> method
     */
    function init( required f ){
        super.init( arguments.f );
        return this;
    }

    /**
     * Performs this operation on the given argument.
     */
    void function accept( t ){
		loadContext();
        variables.target( t );
    }

    function andThen( after ){}

}