/**
 * Functional Interface that maps to java.util.function.Predicate
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html
 */
component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @f The lambda or closure to be used in the <code>apply()</code> method
     */
    function init( required f ){
		super.init( arguments.f );
        // Stupid ACF Compiler
        variables[ "and" ]  = variables[ "$and" ];
        variables[ "or" ]   = variables[ "$or" ];
        return this;
    }

    /**
     * Evaluates this predicate on the given argument.
     *
     * @t
     */
    boolean function test( t ){
		loadContext();
        return variables.target( arguments.t );
    }


    function isEqual( targetRef ){}

    function negate(){}

    function $and( other ){}
    function $or( other ){}

}