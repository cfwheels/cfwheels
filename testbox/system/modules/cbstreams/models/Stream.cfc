/**
 * This is a transient class that models a Java Stream: https://docs.oracle.com/javase/8/docs/api/?java/util/stream/Stream.html
 */
component accessors="true"{

	/**
	 * The Java Stream we represent
	 */
	property name="jStream";

	/**
	 * If this stream has a specific Java Type, defaults to "" or any
	 */
	property name="jType" default="any";

	// Static Stream Class Access
	variables.coreStream    = createObject( "java", "java.util.stream.Stream" );
	variables.intStream    	= createObject( "java", "java.util.stream.IntStream" );
	variables.longStream    = createObject( "java", "java.util.stream.LongStream" );
	variables.Collectors    = createObject( "java", "java.util.stream.Collectors" );
	variables.Arrays        = createObject( "java", "java.util.Arrays" );

	// Lucee pivot
	variables.isLucee = server.keyExists( "lucee" );

	/**
	 * Construct a stream from an incoming collection.  The supported types are:
	 * structs, arrays, lists, and strings.  You can also strong type the stream according to the <source>predicate</source> argument.
	 * This is useful when doing mathematical operations on the stream.
	 *
	 * @collection This is an optional collection to build a stream on: List, Array, Struct, Query
	 * @isNumeric This is a shorthand for doing a numeric typed array of values. This will choose a long stream for you by default.
	 * @primitive If you will be doing operations on the stream, you can mark it with a primitive type of: int, long or double. Else we will use generic object streams
	 */
	Stream function init( any collection="", isNumeric=false, primitive="" ){
		// Determine carray ast type for incoming collection, default is any object.
		var castType = "java.lang.Object[]";

		// Defaults to any
		variables.type = "any";

		// Verify numeric shortcut
		if( arguments.isNumeric ){
			arguments.primitive = "long";
		}

		// Determine primitive type
		switch( arguments.primitive ){
			case "int"    : {
				castType = "int[]";
				variables.type = "int";
				break;
			}
			case "long"   : {
				castType = "long[]";
				variables.type = "long";
				break;
			}
			case "double" : {
				castType = "double[]";
				variables.type = "double";
				break;
			}
		}

		// If a list, enhance to array
		if( isSimpleValue( arguments.collection ) ){
			arguments.collection = listToArray( arguments.collection );
		}

		// If Array
		if( isArray( arguments.collection ) ){
			// Check if the array is already a Java array, no need of casting
			if(
				reFindNoCase( "(coldfusion|lucee|java\.util\.ArrayList)", arguments.collection.getClass().getCanonicalName() )
			){
				variables.jStream = variables.Arrays.stream(
					javaCast( castType, arguments.collection )
				);
			} else {
				variables.jStream = variables.Arrays.stream( arguments.collection );
			}
			return this;
		}

		// If Struct
		if( isStruct( arguments.collection ) ){

			if( variables.isLucee ){
				variables.jStream = arguments.collection.entrySet().stream();
			} else {
				arguments.collection = createObject( "java", "java.util.HashMap" )
					.init( arguments.collection )
					.entrySet()
					.toArray();

				variables.jStream = variables.Arrays.stream(
					arguments.collection
				);
			}

			return this;
		}

		// If Query, convert to a stream of appropriate ranged size.
		if( isQuery( arguments.collection ) ){
			return rangeClosed( 1, arguments.collection.recordcount )
				.map( function( index ){
					return collection.getRow( index );
				} );
		}

		throw(
			message = "Cannot create stream from incoming collection",
			type    = "InvalidColletionType",
			detail  = "#getMetadata( arguments.collection ).toString()#"
		);
	}

	/**
	 * Returns a builder for a Stream. So you can build a stream manually by calling on the builder's <code>add()</code> method.
	 */
	Builder function builder(){
		return new Builder( variables.coreStream.builder() );
	}

	/**
	 * Returns a sequential ordered stream whose elements are the specified values.
	 * Each argument passed to this function will generate the stream from.
	 *
	 */
	Stream function of(){
		if( arguments.isEmpty() ){
			throw( message="Please pass at least one value", type="InvalidValues" );
		}

		// Doing it this way so acf11 is supported
		var sequence = [];
		arguments.each( function( k,v ){
			sequence.append( v );
		} );

		return init( sequence );
	}

	/**
	 * Create a character stream from a string
	 * This won't work on ACF11 due to stupidity
	 *
	 * @target The string to convert to a stream using its characters
	 */
	Stream function ofChars( required string target ){
		if( variables.isLucee ){
			variables.jStream = arguments.target.chars();
		} else {
			variables.jStream = variables.Arrays.stream(
				javaCast( "java.lang.Object[]", listToArray( arguments.target, "" ) )
			);
		}
		return this;
	}

	/**
	 * Create a stream from a file. Every line of the text becomes an element of the stream:
	 *
	 * @path The absolute path of the file to generate a stream from
	 * @encoding The encoding of the file, the default is `UTF-8`
	 */
	Stream function ofFile( required string path, encoding="UTF-8" ){

        variables.jStream = createObject( "java", "java.nio.file.Files" )
            .lines(
                createObject( "java", "java.nio.file.Paths" ).get(
                    createObject( "java", "java.io.File" ).init( arguments.path ).toURI()
                ),
                createObject( "java", "java.nio.charset.Charset" ).forName( arguments.encoding )
		    );

		return this;
	}

	/**
	 * Returns an infinite sequential unordered stream where each element is generated by the provided Supplier.
	 * This is suitable for generating constant streams, streams of random elements, etc. Please make sure you limit
	 * your stream or this method will work until it reaches the memory limit. Use the <code>limit()</code>
	 *
	 * @supplier A closure or lambda that will supply the generated elements
	 */
	Stream function generate( required supplier ){
		variables.jStream = variables.coreStream.generate(

			createDynamicProxy(
				new proxies.Supplier( arguments.supplier ),
				[ "java.util.function.Supplier" ]
			)

		);
		return this;
	}

	/**
	 * Returns a sequential ordered LongStream from start (inclusive) to end (exclusive) by an incremental step of 1.
	 * See https://docs.oracle.com/javase/8/docs/api/java/util/stream/LongStream.html
	 */
	Stream function range( required numeric start, required numeric end ){
		if( variables.isLucee ){
			variables.jStream = variables.longStream.range(
				javaCast( "long", arguments.start ),
				javaCast( "long", arguments.end )
			);
			variables.jType = "long";
		} else {
			var a = [];
			for( var x = arguments.start; x lt arguments.end; x++ ){
				a.append( x );
			}
			init( a );
		}

		return this;
	}

	/**
	 * Returns a sequential ordered LongStream from start (inclusive) to end (inclusive) by an incremental step of 1.
	 * See https://docs.oracle.com/javase/8/docs/api/java/util/stream/LongStream.html
	 */
	Stream function rangeClosed( required numeric start, required numeric end ){
		if( variables.isLucee ){
			variables.jStream = variables.longStream.rangeClosed(
				javaCast( "long", arguments.start ),
				javaCast( "long", arguments.end )
			);
			variables.jType = "long";
		} else {
			var a = [];
			for( var x = arguments.start; x lte arguments.end; x++ ){
				a.append( x );
			}
			init( a );
		}

		return this;
	}

	/**
	 * Returns an empty sequential Stream.
	 */
	Stream function empty(){
		if( variables.isLucee ){
			variables.jStream = variables.coreStream.empty();
		} else {
			init();
		}

		return this;
	}

	/**************************************** OPERATIONS ****************************************/

	/**
	 * Returns a stream consisting of the elements of this stream, truncated to be no longer than maxSize in length.
	 * Please see warnings for parallel streams: https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#limit-long-
	 */
	Stream function limit( required numeric maxSize ){
		variables.jStream = variables.jStream.limit( javaCast( "long", arguments.maxSize ) );
		return this;
	}

	/**
	 * Returns a stream consisting of the distinct elements (according to Object.equals(Object)) of this stream.
	 */
	Stream function distinct(){
		variables.jStream = variables.jStream.distinct();
		return this;
	}

	/**
	 * Returns a stream consisting of the remaining elements of this stream after discarding the first n elements of the stream. If this stream contains fewer than n elements then an empty stream will be returned.
	 * @n the number of leading elements to skip
	 */
	Stream function skip( required numeric n ){
		variables.jStream = variables.jStream.skip( javaCast( "long", arguments.n ) );
		return this;
	}

	/**
	 * Returns a stream consisting of the elements of this stream, sorted according to natural order.
	 *
	 * You can pass in a lambda or closure to create your own Comparator.
	 *
	 * @comparator A lambda or closure to apply as a comparator when sorting.
	 */
	Stream function sorted( comparator ){
		if( isNull( arguments.comparator ) ){
			variables.jStream = variables.jStream.sorted();
		} else {
			variables.jStream = variables.jStream.sorted(
				createDynamicProxy(
					new proxies.Comparator( arguments.comparator ),
					[ "java.util.Comparator" ]
				)
			);
		}
		return this;
	}

	/**
	 * Returns a stream consisting of the results of applying the given function to the elements of this stream.
	 * @mapper The closure or lambda to map apply to each element
	 */
	Stream function map( required mapper ){
		if( isStrongTyped() ){
			variables.jStream = variables.jStream.mapToObj(
				createDynamicProxy(
					new proxies.Function( arguments.mapper ),
					[ "java.util.function.#getStrongTypePrefix()#Function" ]
				)
			);
			variables.jType = "any";
		} else {
			variables.jStream = variables.jStream.map(
				createDynamicProxy(
					new proxies.Function( arguments.mapper ),
					[ "java.util.function.Function" ]
				)
			);
		}

		return this;
	}

	/**
	 * Returns a stream consisting of the elements of this stream that match the given predicate.
	 *
	 * This is an intermediate operation.
	 *
	 * @predicate a non-interfering, stateless predicate to apply to each element to determine if it should be included
	 */
	Stream function filter( required predicate ){
		if( isStrongTyped() ){
			variables.jStream = variables.jStream.filter(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.#getStrongTypePrefix()#Predicate" ]
				)
			);
		} else {
			variables.jStream = variables.jStream.filter(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.Predicate" ]
				)
			);
		}

		return this;
	}

	/**
	 * Returns an equivalent stream that is sequential. May return itself, either because the stream was already sequential, or because the underlying stream state was modified to be sequential.
	 *
	 * This is an intermediate operation.
	 */
	Stream function sequential(){
		variables.jStream = variables.jStream.sequential();
		return this;
	}

	/**
	 * Returns an equivalent stream that is parallel. May return itself, either because the stream was already parallel, or because the underlying stream state was modified to be parallel.
	 *
	 * This is an intermediate operation.
	 */
	Stream function parallel(){
		variables.jStream = variables.jStream.parallel();
		return this;
	}

	/**
	 * Returns an equivalent stream that is unordered. May return itself, either because the stream was already unordered, or because the underlying stream state was modified to be unordered.
	 *
	 * This is an intermediate operation.
	 */
	Stream function unordered(){
		variables.jStream = variables.jStream.unordered();
		return this;
	}

	/**
	 * Returns an equivalent stream with an additional close handler.
	 * Close handlers are run when the close() method is called on the stream, and are executed in the order they were added.
	 *  All close handlers are run, even if earlier close handlers throw exceptions. If any close handler throws an exception,
	 * the first exception thrown will be relayed to the caller of close(), with any remaining exceptions added to that
	 * exception as suppressed exceptions (unless one of the remaining exceptions is the same exception as the first exception,
	 * since an exception cannot suppress itself.) May return itself.
	 *
	 * @closeHandler A lambda,closure or a CFC that implements a <code>run()</code> method. to be executed when the stream is closed.
	 */
	Stream function onClose( required closeHandler ){
		variables.jStream = variables.jStream.onClose(
			createDynamicProxy(
				new proxies.Runnable( arguments.closeHandler ),
				[ "java.lang.Runnable" ]
			)
		);
		return this;
	}

	/**
	 * Creates a lazily concatenated stream whose elements are all the elements of the first stream followed by all the elements of
	 * the second stream. The resulting stream is ordered if both of the input streams are ordered, and parallel if either of the
	 * input streams is parallel. When the resulting stream is closed, the close handlers for both input streams are invoked.
	 *
	 * Use caution when constructing streams from repeated concatenation. Accessing an element of a deeply concatenated stream can result in deep call chains, or even StackOverflowException.
	 *
	 * @a the first stream
	 * @b the second stream
	 *
	 * @return the concatenation of the two input streams
	 */
	Stream function concat( required a, required b ){
		variables.jStream = variables.jStream.concat( arguments.a, arguments.b );
		return this;
	}

	/**
	 * Returns a stream consisting of the elements of this stream, additionally performing the provided action on each element as elements are consumed from the resulting stream.
	 *
	 * This is an intermediate operation.
	 *
	 * For parallel stream pipelines, the action may be called at whatever time and in whatever thread the element is made available by the upstream operation. If the action modifies shared state, it is responsible for providing the required synchronization.
	 *
	 * This method exists mainly to support debugging, where you want to see the elements as they flow past a certain point in a pipeline:
	 *
	 * <pre>
	 * Stream.of("one", "two", "three", "four")
     *    .filter( (e) +> e.len() > 3 )
     *    .peek( (e) => SystemOutput( "Filtered value: " & e, true ) )
     *    .map( (item) => item.toUpperCase() )
     *    .peek( (e) => SystemOutput( "Mapped value: " & e, true ) )
     *    .collect();
	 *</pre>
	 *
	 * @action a non-interfering action to perform on the elements as they are consumed from the stream lambda or closure
	 */
	Stream function peek( required action ){
		if( isStrongTyped() ){
			variables.jStream = variables.jStream.peek(
				createDynamicProxy(
					new proxies.Consumer( arguments.action ),
					[ "java.util.function.#getStrongTypePrefix()#Consumer" ]
				)
			);
		} else {
			variables.jStream = variables.jStream.peek(
				createDynamicProxy(
					new proxies.Consumer( arguments.action ),
					[ "java.util.function.Consumer" ]
				)
			);
		}

		return this;
	}

	/**************************************** TERMINATORS ****************************************/

	/**
	 * Returns an iterator for the elements of this stream.
	 *
	 * This is an terminal operation.
	 *
	 * @return https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html
	 */
	function iterator(){
		return variables.jStream.iterator();
	}

	/**
	 * Returns a spliterator for the elements of this stream.
	 *
	 * This is a terminal operation.
	 *
	 * @return https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html
	 */
	function spliterator(){
		return variables.jStream.spliterator();
	}

	/**
	 * Only use this method for closing streams that require IO resources
	 */
	void function close(){
		variables.jStream.close();
	}

	/**
	 * Returns whether this stream, if a terminal operation were to be executed, would execute in parallel. Calling this method after invoking an terminal stream operation method may yield unpredictable results.
	 */
	boolean function isParallel(){
		return variables.jStream.isParallel();
	}

	/**
	 * Returns an array containing the elements of this stream.
	 */
	function toArray(){
		return variables.jStream.toArray();
	}


	/**
	 * Returns the count of elements in this stream.
	 */
	numeric function count(){
		return variables.jStream.count();
	}

	/**
	 * Returns an Optional describing some element of the stream, or an empty Optional if the stream is empty.
	 *
	 * This is a short-circuiting terminal operation.
	 *
	 * The behavior of this operation is explicitly nondeterministic; it is free to select any element in the stream. This is to allow for maximal performance in parallel operations; the cost is that multiple invocations on the same source may not return the same result. (If a stable result is desired, use findFirst() instead.)
	 *
	 * @return an Optional describing some element of this stream, or an empty Optional if the stream is empty
	 */
	Optional function findAny(){
		return new Optional( variables.jStream.findAny() );
	}

	/**
	 * Returns an Optional describing the first element of this stream, or an empty Optional if the stream is empty. If the stream has no encounter order, then any element may be returned.
	 *
	 * This is a short-circuiting terminal operation.
	 *
	 * @return an Optional describing the first element of this stream, or an empty Optional if the stream is empty. If the stream has no encounter order, then any element may be returned.
	 */
	Optional function findFirst(){
		return new Optional( variables.jStream.findFirst() );
	}

	/**
	 * Performs an action for each element of this stream.
	 *
	 * This is a terminal operation.
	 *
	 * The behavior of this operation is explicitly nondeterministic. For parallel stream pipelines, this operation does not guarantee to respect the encounter order of the stream, as doing so would sacrifice the benefit of parallelism. For any given element, the action may be performed at whatever time and in whatever thread the library chooses. If the action accesses shared state, it is responsible for providing the required synchronization.
	 *
	 * @action a non-interfering action to perform on the elements
	 */
	void function forEach( required action ){
		if( isStrongTyped() ){
			variables.jStream.forEach(
				createDynamicProxy(
					new proxies.Consumer( arguments.action ),
					[ "java.util.function.#getStrongTypePrefix()#Consumer" ]
				)
			);
		} else {
			variables.jStream.forEach(
				createDynamicProxy(
					new proxies.Consumer( arguments.action ),
					[ "java.util.function.Consumer" ]
				)
			);
		}
	}

	/**
	 * Performs an action for each element of this stream, in the encounter order of the stream if the stream has a defined encounter order.
	 *
	 * This is a terminal operation.
	 *
	 * This operation processes the elements one at a time, in encounter order if one exists. Performing the action for one element happens-before performing the action for subsequent elements, but for any given element, the action may be performed in whatever thread the library chooses.
	 *
	 * @action a non-interfering action to perform on the elements
	 */
	void function forEachOrdered( required action ){
		if( isStrongTyped() ){
			variables.jStream.forEachOrdered(
				createDynamicProxy(
					new proxies.Consumer( arguments.action ),
					[ "java.util.function.#getStrongTypePrefix()#Consumer" ]
				)
			);
		} else {
			variables.jStream.forEachOrdered(
				createDynamicProxy(
					new proxies.Consumer( arguments.action ),
					[ "java.util.function.Consumer" ]
				)
			);
		}
	}

	/**
	 * Performs a reduction on the elements of this stream.
	 *
	 * This function can run the reduction in 2 modes:
	 * 1 - Accumulation only: Using the accumulation function, and returns the reduced value, if any inside an Optional
	 * 2 - Accumulation with identity value: Performs a reduction on the elements of this stream, using the provided identity or starting value and an associative accumulation function, and returns the reduced value. NOT AN OPTIONAL
	 *
	 * This is a terminal operation.
	 *
	 * @accumulator an associative, non-interfering, stateless function for combining two values
	 * @identity the identity value for the accumulating function. If not used, then the accumulator is used in isolation
	 */
	function reduce( required accumulator, identity ){
		if( isStrongTyped() ){
			var proxy = createDynamicProxy(
				new proxies.BinaryOperator( arguments.accumulator ),
				[ "java.util.function.#getStrongTypePrefix()#BinaryOperator" ]
			);
		} else {
			var proxy = createDynamicProxy(
				new proxies.BinaryOperator( arguments.accumulator ),
				[ "java.util.function.BinaryOperator" ]
			);
		}

		// Accumulator Only
		if( isNull( arguments.identity ) ){
			return new Optional( variables.jStream.reduce( proxy ) );
		}
		// Accumulator + Identity Seed
		else {
			var results = variables.jStream.reduce( arguments.identity, proxy );
			return new Optional().getNativeType( results );
		}
	}

	/**
	 * Returns whether any elements of this stream match the provided predicate.
	 * May not evaluate the predicate on all elements if not necessary for determining the result.
	 * If the stream is empty then false is returned and the predicate is not evaluated.
	 *
	 * This is a terminal operation.
	 *
	 * @predicate a non-interfering, stateless predicate to apply to elements of this stream
	 */
	boolean function anyMatch( required predicate ){
		if( isStrongTyped() ){
			return variables.jStream.anyMatch(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.#getStrongTypePrefix()#Predicate" ]
				)
			);
		} else {
			return variables.jStream.anyMatch(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.Predicate" ]
				)
			);
		}
	}

	/**
	 * Returns whether all elements of this stream match the provided predicate.
	 * May not evaluate the predicate on all elements if not necessary for determining the result.
	 * If the stream is empty then true is returned and the predicate is not evaluated.
	 *
	 * This is a terminal operation.
	 *
	 * @predicate a non-interfering, stateless predicate to apply to elements of this stream
	 */
	boolean function allMatch( required predicate ){
		if( isStrongTyped() ){
			return variables.jStream.allMatch(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.#getStrongTypePrefix()#Predicate" ]
				)
			);
		} else {
			return variables.jStream.allMatch(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.Predicate" ]
				)
			);
		}
	}

	/**
	 * Returns whether no elements of this stream match the provided predicate.
	 * May not evaluate the predicate on all elements if not necessary for determining the result.
	 * If the stream is empty then true is returned and the predicate is not evaluated.
	 *
	 * This is a short-cicuiting terminal operation.
	 *
	 * @predicate a non-interfering, stateless predicate to apply to elements of this stream
	 */
	boolean function noneMatch( required predicate ){
		if( isStrongTyped() ){
			return variables.jStream.noneMatch(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.#getStrongTypePrefix()#Predicate" ]
				)
			);
		} else {
			return variables.jStream.noneMatch(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.Predicate" ]
				)
			);
		}
	}

	/**
	 * Returns an numeric describing the maximum element of this stream, or a null if this stream is empty.
	 * This can only be done with int, long, or double typed streams unless you pass in a
	 * Comparator function or lambda: (a,b) => return 0, +- value
	 *
	 * This is a terminal operation.
	 * 	 *
	 * obj1 and obj2 are the objects to be compared. This method returns zero if the objects are equal. It returns a positive value if obj1 is greater than obj2. Otherwise, a negative value is returned.
	 *
	 * @comparator A comparator function or lambda
	 */
	Optional function max( comparator ){
		if( isNull( arguments.comparator ) ){
			return new Optional( variables.jStream.max() );
		} else {
			var oProxy = createDynamicProxy(
				new proxies.Comparator( arguments.comparator ),
				[ "java.util.Comparator" ]
			);
			return new Optional( variables.jStream.max( oProxy ) );
		}
	}

	/**
	 * Returns an numeric describing the minimum element of this stream, or a null if this stream is empty.
	 * This can only be done with int, long, or double typed streams unless you pass in a
	 * Comparator function or lambda: (a,b) => return 0, +- value
	 *
	 * This is a terminal operation.
	 *
	 * obj1 and obj2 are the objects to be compared. This method returns zero if the objects are equal. It returns a positive value if obj1 is greater than obj2. Otherwise, a negative value is returned.
	 *
	 * @comparator A comparator function or lambda
	 */
	Optional function min( comparator ){
		if( isNull( arguments.comparator ) ){
			return new Optional( variables.jStream.min() );
		} else {
			var oProxy = createDynamicProxy(
				new proxies.Comparator( arguments.comparator ),
				[ "java.util.Comparator" ]
			);
			return new Optional( variables.jStream.min( oProxy ) );
		}
	}

	/**
	 * Returns an Optional describing the average of the elements of this stream, or a null if this stream is empty.
	 * This can only be done with int, long, or double typed streams
	 *
	 * This is a terminal operation.
	 */
	Optional function average(){
		return new Optional( variables.jStream.average() );
	}

	/**
	 * Returns a Summary describing various summary data about the elements in this stream.
	 * By default we return a struct with the following stats: average, count, max, min, and sum.
	 *
	 * This is a terminal operation.
	 *
	 * @returnNative If true, then we will return the native Java object, else a struct of stats
	 */
	struct function summaryStatistics( boolean returnNative=false ){
		var stats = variables.jStream.summaryStatistics();
		return ( arguments.returnNative ? stats : getNativeStatsStruct( stats ) );
	}

	/**
	 * A mutable reduction operation that accumulates input elements into a mutable result container, optionally transforming the accumulated result into a final representation after all input elements have been processed.
	 * By default we will collect to an array.
	 *
	 * This is a terminal operation.
	 *
	 */
	function collect(){
		return variables.jStream.collect( variables.Collectors.toList() );
	}

	/**
	 * Returns a Collector implementing a "group by" operation on input elements, grouping elements according to a
	 * classification function, and returning the results in a struct according to the classifier function
	 *
	 * @classifier the classifier function mapping input elements to keys
	 */
	function collectGroupingBy( required classifier ){
		return variables.jStream.collect( variables.Collectors.groupingBy(
			createDynamicProxy(
				new proxies.Function( arguments.classifier ),
				[ "java.util.function.Function" ]
			)
		) );
	}

	/**
	 * Returns a Collector that produces the arithmetic mean of an integer-valued function applied to the input elements.
	 * If no elements are present, the result is 0.
	 *
	 * @mapper The mapper lambda or closure to determine averages on
	 * @primitive The primitive type to cast with, we default to 'long'. Accepted values are int, long, double
	 */
	function collectAverage( required mapper, primitive="long" ){
		var proxy = createPrimitiveProxyFunction( arguments.mapper, arguments.primitive );
		switch( arguments.primitive ){
			case "int" : {
				return variables.jStream.collect( variables.Collectors.averagingInt( proxy ) );
			}
			case "double" :{
				return variables.jStream.collect( variables.Collectors.averagingDouble( proxy ) );
			}
			default : {
				return variables.jStream.collect( variables.Collectors.averagingLong( proxy ) );
			}
		}
	}

	/**
	 * Returns a Collector that produces the sum of a valued function applied to the input elements.
	 *
	 * @mapper The mapper lambda or closure to determine the sum on
	 * @primitive The primitive type to cast with, we default to 'long'. Accepted values are int, long, double
	 */
	function collectSum( required mapper, primitive="long" ){
		var proxy = createPrimitiveProxyFunction( arguments.mapper, arguments.primitive );
		switch( arguments.primitive ){
			case "int" : {
				return variables.jStream.collect( variables.Collectors.summingInt( proxy ) );
			}
			case "double" :{
				return variables.jStream.collect( variables.Collectors.summingDouble( proxy ) );
			}
			default : {
				return variables.jStream.collect( variables.Collectors.summingLong( proxy ) );
			}
		}
	}

	/**
	 * Returns a Collector which applies an producing mapping function to each input element, and
	 * returns summary statistics for the resulting values as a struct with the following keys:
	 * average, count, max, min, sum.  You can also get the raw stats report by using the <code>returnNative</code> argument.
	 *
	 * @mapper The mapper lambda or closure to determine the statistics on
	 * @primitive The primitive type to cast with, we default to 'long'. Accepted values are int, long, double
	 * @returnNative If true, this will return the SummaryStatistics object instead of the struct report.
	 *
	 * @return By default a struct with {average,count,max,min,sum}.
	 */
	function collectSummary( required mapper, primitive="long", boolean returnNative=false ){
		var proxy	= createPrimitiveProxyFunction( arguments.mapper, arguments.primitive );
		var oSummary = "";

		switch( arguments.primitive ){
			case "int" : {
				oSummary = variables.jStream.collect( variables.Collectors.summarizingInt( proxy ) );
			}
			case "double" :{
				oSummary = variables.jStream.collect( variables.Collectors.summarizingDouble( proxy ) );
			}
			default : {
				oSummary = variables.jStream.collect( variables.Collectors.summarizingLong( proxy ) );
			}
		}

		// Native Results
		if( arguments.returnNative ){
			return oSummary;
		}

		// Struct report
		return getNativeStatsStruct( oSummary );
	}

	/**
	 * Collect the items to a string list using delimiters and/or a prefix and suffix.
	 * The cool things is that you don't even need to know the start or end of the stream for applying the prefix and suffix
	 *
	 * This is a terminal operation.
	 *
	 * @delimiter The delimiter to use in the list. The default is a comma (,)
	 * @prefix A prefix to add to the stream result
	 * @suffix A suffix to add to the stream result
	 */
	function collectAsList( delimiter=",", prefix="", suffix="" ){
		return variables.jStream.collect(
			variables.Collectors.joining( arguments.delimiter, arguments.prefix, arguments.suffix )
		);
	}

	/**
	 * Collect the items to a struct. Please be sure to map the appropriate key and value identifiers
	 *
	 * NOTE: the struct type will only work if the collection we are collecting is a struct or an object
	 * This is a terminal operation.
	 *
	 * @keyID If using struct, then we need to know what will be the key value in the collection struct
	 * @valueID If using struct, then we need to know what will be the value key in the collection struct
	 * @overwrite If using struct, then do you overwrite elements if the same key id is found. Defaults is true.
	 */
	function collectAsStruct( required keyID, required valueID, boolean overwrite=true ){
		if( isNull( arguments.keyID ) || isNull( arguments.valueID ) ){
			throw( "Please pass in a 'keyID' and a 'valueID', if not we cannot build your struct." );
		}

		var keyFunction = createDynamicProxy(
			new proxies.Function( function( item ){
				// If CFC, execute the method
				if( isObject( arguments.item ) ){
					return invoke( arguments.item, keyID );
				}
				// If struct, get the key
				else if( isStruct( arguments.item ) ){
					return arguments.item[ keyID ];
				}
				// Else, just return the item, nothing we can map
				return arguments.item;
			} ),
			[ "java.util.function.Function" ]
		);

		var valueFunction = createDynamicProxy(
			new proxies.Function( function( item ){
				// If CFC, execute the method
				if( isObject( arguments.item ) ){
					return invoke( arguments.item, valueID );
				}
				// If struct, get the key
				else if( isStruct( arguments.item ) ){
					return arguments.item[ valueID ];
				}
				// Else, just return the item, nothing we can map
				return arguments.item;
			} ),
			[ "java.util.function.Function" ]
		);

		var overrideFunction = createDynamicProxy(
			new proxies.BinaryOperator( function( oldValue, newValue ){
				return ( overwrite ? newValue : oldValue );
			} ),
			[ "java.util.function.BinaryOperator" ]
		);

		return variables.jStream.collect(
			variables.Collectors.toMap( keyFunction, valueFunction, overrideFunction )
		);
	}

	/**
	 * Returns a Collector which partitions the input elements according to a Predicate, and organizes them into a Map<Boolean, List<T>>.
	 *
	 * @predicate a non-interfering, stateless predicate to apply to each element to determine if it should be included
	 */
	function collectPartitioningBy( required predicate ){
		return variables.jStream.collect(
			variables.Collectors.partitioningBy(
				createDynamicProxy(
					new proxies.Predicate( arguments.predicate ),
					[ "java.util.function.Predicate" ]
				)
			)
		);
	}

	/************************************ PRIVATE ************************************/

	/**
	 * Create a primitive typed proxy function
	 *
	 * @f The target closure or lambda
	 * @primitive The target primitive
	 */
	private function createPrimitiveProxyFunction( required f, required primitive ){
		switch( arguments.primitive ){
			case "int" : {
				return createDynamicProxy(
					new proxies.ToIntFunction( arguments.f ),
					[ "java.util.function.ToIntFunction" ]
				);
			}
			case "double" :{
				return createDynamicProxy(
					new proxies.ToDoubleFunction( arguments.f ),
					[ "java.util.function.ToDoubleFunction" ]
				);
			}
			default : {
				return createDynamicProxy(
					new proxies.ToLongFunction( arguments.f ),
					[ "java.util.function.ToLongFunction" ]
				);
			}
		}
	}

	/**
	 * Build a stats structure from a Java SummaryStatistics Object
	 */
	private function getNativeStatsStruct( required stats ){
		return {
			"average" 	: arguments.stats.getAverage(),
			"count"		: arguments.stats.getCount(),
			"max"		: arguments.stats.getMax(),
			"min"		: arguments.stats.getMin(),
			"sum" 		: arguments.stats.getSum()
		};
	}

	/**
	 * Check if this stream is strong typed
	 */
	private boolean function isStrongTyped(){
		return !!listFindNoCase( "long,int,double", variables.jType );
	}

	/**
	 * Return the strong type prefix for classes according to types
	 */
	private function getStrongTypePrefix(){
		switch( variables.jType ){
			case "int" : { return "Int"; }
			case "Long" : { return "Long"; }
			case "Double" : { return "Double"; }
			default : { return ""; }
		}
	}
}