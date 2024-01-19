/**
 * Functional interface that maps to java.util.function.BinaryOperator
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/BinaryOperator.html
 */
component extends="BiFunction"{ 

    function maxBy( required comparator ){}
    function minBy( required comparator ){}

}