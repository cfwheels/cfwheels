/**
 * Functional interface that maps to java.util.function.ToLongFunction
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/ToLongFunction.html
 */
component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @f a function to be applied to to the previous element to produce a new element
     */
    function init( required f ){
		super.init( f );
        return this;
    }

    /**
     * Functional interface for the apply functionional interface
     */
    function applyAsLong( required value ){
		loadContext();
        return variables.target( arguments.value );
    }

}