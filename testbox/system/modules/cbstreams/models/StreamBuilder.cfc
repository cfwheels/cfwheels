/**
 * This is a static factory class to build CFML Streams
 */
component singleton{

    /**
     * Constructor
     */
    StreamBuilder function init(){
        return this;
    }

    /**
	 * Construct a stream from an incoming collection.  The supported types are:
	 * structs, arrays, lists, and strings.  You can also strong type the stream according to the <source>predicate</source> argument.
	 * This is useful when doing mathematical operations on the stream.
	 *
	 * @collection This is an optional collection to build a stream on: List, Array, Struct, Query
	 * @isNumeric This is a shorthand for doing a numeric typed array of values. This will choose a long stream for you by default.
	 * @predicate If you will be doing operations on the stream, you can mark it with a predicate type of: int, long or double. Else we will use generic object streams
	 */
    Stream function new( any collection="", isNumeric=false, predicate="" ){
        return new Stream( argumentCollection = arguments );
    }

    /**
     * Returns a builder for a Stream.
     */
    Builder function builder(){
        return new Stream().builder();
    }

}