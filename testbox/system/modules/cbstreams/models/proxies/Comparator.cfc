/**
 * Functional interface that maps to java.util.Comparator
 * See https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html
 */
component extends="BaseProxy"{

    /**
     * Constructor
     *
     * @f Target lambda or closure
     */
    function init( required f ){
		super.init( arguments.f );
        variables[ "equals" ] = variables.isEqual;
        return this;
    }

    /**
     * Compares its two arguments for order.
     */
    function compare( o1, o2 ){
		loadContext();
        return variables.target( arguments.o1, arguments.o2 );
    }

    function comparing(keyExtractor, keyComparator){}
    function comparingDouble( keyExtractor){}
    function comparingInt(keyExtractor){}
    function comparingLong(keyExtractor){}
    function isEqual(Object obj){}
    function naturalOrder(){}
    function nullsFirst(comparator){}
    function nullsLast(comparator){}
    function reversed(){}
    function reverseOrder(){}
    function thenComparing(other){}
    function thenComparingDouble(keyExtractor){}
    function thenComparingInt(keyExtractor){}
    function thenComparingLong(keyExtractor){}

}