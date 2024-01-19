/**
 * Functional Interface that maps to java.util.function.Function
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html
 */
component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @f The lambda or closure to be used in the <code>apply()</code> method
     */
    function init( required f ){
        super.init( arguments.f );
        return this;
    }

    /**
     * Represents a function that accepts one argument and produces a result.
     */
    function apply( t ){
		loadContext();
        return variables.target( t );
    }

    function andThen( after ){}

    function compose( before ){}

    function identity(){}

}