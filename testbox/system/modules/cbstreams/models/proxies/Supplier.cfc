component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @supplier The lambda or closure that will supply the elements
     */
    function init( required supplier ){
		super.init( arguments.supplier );
        return this;
    }

    /**
     * Functional interface for supplier to get a result
     * See https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html
     */
    function get(){
		loadContext();
        return variables.target();
    }
}