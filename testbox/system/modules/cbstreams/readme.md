# CB Streams

Welcome to the wonderful world of Java Streams ported for the CFML world!

> The whole idea of streams is to enable functional-style operations on streams of elements. A stream is an abstraction, it’s not a data structure. It’s not a collection where you can store elements. The most important difference between a stream and a structure is that a stream doesn’t hold the data. For example you cannot point to a location in the stream where a certain element exists. You can only specify the functions that operate on that data. A stream is an abstraction of a non-mutable collection of functions applied in some order to the data.

The beauty of streams is that the elements in a stream are processed and passed across the processing pipeline. Unlike traditional CFML functions like `map(), reduce() and filter()` which create completely new collections until all items in the pipeline are processed.  With streams, the elements are streamed across the pipeline to increase efficiency and performance.

You can also leverage streams in parallel for parallel execution and take it further with concurrent programming.

```js
// Lucee 5 lambdas 

streamBuilder.new( [ "d2", "a2", "b1", "b3", "c" ] )
    .map( (s) => {
        writedump( "map: " & s );
        return s.ucase();
    } )
    .filter( (s) => {
        writedump( "filter: " & s );
        return s.startsWith( "A" );
    } )
    .forEach( (s) => {
        writedump( "forEach: " & s );
    } );
```

The output is in this order.  Note how the `map()`, `filter()`, and `forEach()` are running simultaneously!

```
map:     d2
filter:  D2
map:     a2
filter:  A2
forEach: A2
map:     b1
filter:  B1
map:     b3
filter:  B3
map:     c
filter:  C
```

## Installation

To install `cbstreams`, you need [CommandBox](https://www.ortussolutions.com/products/commandbox/) :rocket:

Once you have that set-up, just run `box install cbstreams` in your shell and :boom:

You're now ready to leverage streams!

## In-Depth Tutorial

These tutorials on Java Streams are fantastic. We encourage you to read them to see the power of streams. You can also find the `cbstreams` API Docs to be a great source of information: [http://apidocs.ortussolutions.com/#/coldbox-modules/cbstreams](http://apidocs.ortussolutions.com/#/coldbox-modules/cbstreams)

- [Streams Cheatsheet](http://files.zeroturnaround.com/pdf/zt_java8_streams_cheat_sheet.pdf)
- [Java Streams Examples](http://winterbe.com/posts/2014/07/31/java8-stream-tutorial-examples/)
- [Java 8 Streams Introduction](http://www.baeldung.com/java-8-streams-introduction)
- [Java 8 Streams](http://www.baeldung.com/java-8-streams)
- [Dr Venkat Subramaniam - The Real Powerhouse in Java 8](https://www.youtube.com/embed/HVID35J7h_I)

## Usage

In order to start working with streams you must leverage WireBox and inject `StreamBuilder@cbstreams`.  This factory has two methods for your streaming pleasure:

- `new( any collection="", isNumeric=false, primitive=""  )` - Returns a new `Stream.cfc` according to passed arguments
- `builder()` - Returns a Stream Builder that maps to the `Builder.cfc` so you can build a stream manually.

We encourage you to learn our [API Docs](http://apidocs.ortussolutions.com/#/coldbox-modules/cbstreams) to see how to interact with streams.  We try our best to map static Java types to loose typed ColdFusion types. If you find anything that doesn't work, please create issues here: [Issues](https://github.com/coldbox-modules/cbstreams/issues)

## Creating Streams

You can easily create streams from CFML string lists, arrays or structs (Queries are not supported yet.).  You can also generate streams using several built-in functions.

### `new/init()` Approach

Streams can be generated from almost any collection in CFML (string lists, arrays, structs).  Query support is still not there, but will come later.  The `init()` function of the `Stream.cfc` class allows you to create streams rather easily with a few arguments:

- `collection` - The collection to build the stream from. This can be a string, a list, an array or a struct.
- `isNumeric` - If the collection you passed is only composed of numerical values then turn this to true to allow for mathematical computations to be available to you in the stream
- `primitive` - If you marked the collection as numeric, you can cast it to a Java primitive type.  By default we choose `long` for you, but you can choose from: `int,long, double`.

You can also pass **nothing** and create an empty stream.

### Empty Streams

You can generate empty streams by just calling on the `new()` method or using the `empty()` method in the Stream class.

```js
emptyStream = streamBuilder.new();
emptyStream = streamBuilder.new().empty();
```

### Building Streams

You can build your own stream with your own data by using our Stream Builder. Just get access to the builder and add your data with the `add()` method.

```js
builder = streamBuilder.builder();
myData.each( function( item ){
    builder.add( item );
} );
myStream = builder.build();
```

Make sure you call the `build()` method on the builder to give you an instance of the Stream CFC.

### Of() Streams

You can leverage the `of()` method to pass in arguments to build a stream out of all the arguments passed to it:

```js
stream = streamBuilder.new().of( "a", "hello", "stream" );
```

### OfChars() Streams

You can leverage the `ofChars()` method to create a character stream from an existing string.

```js
stream = streamBuilder.new().ofChars( "Welcome to Streams" );
```

This will create a stream of every character in the string sequence.

### File Streams

We have also added an `ofFile()` method to help you create streams from files using the Java non-blocking IO classes.  The stream will represent every line in the file so you can navigate through it.  

```js
stream = streamBuilder.new().ofFile( absolutePath );
try{
    work on the stream and close it in the finally block;
} finally{
    stream.close();
}
```

**Important** : Once you are done working with the file stream, make sure you manually call the `close()` command on it in order to avoid open IO threads.

### Generating Infinite Streams: `generate(), iterate()`

You can also use the `generate(), iterate()` method to generate an infinite stream by leveraging a closure/lambda as your supplier of data. In the itreation approach, we start with a seed that is passed to the supplier method and will dictate the next element in the stream.

```js
// Generation lambda/closure
stream = streamBuilder.new().generate( function(){
    return randRange( 1, 100 );
} ).limit( 100 );

// Iteration
stream = streamBuilder.new().iterate( 40, function( x ){
    return x+2;
} ).limit( 20 );
```

Please note that you can eat up all the memory in the JVM if you don't limit the stream. So make sure you use the `limit()` method to limit the generation, or not :see_no_evil:. 

### Ranged Streams

You can also leverage the `range() and rangeClosed()` methods to create ranged element streams.  The `rangeClosed()` will use the end number in the sequence, while `range()` will not.  All sequences are incremented by 1.

```js
stream = streamBuilder.new().range( 1, 200 );

stream = streamBuilder.new().rangeClosed( 1, 2030 );
```

### Sequential vs Parallel

By default all streams are generated as sequential streams.  You can also mark a stream to leverage parallel programming by calling on the `parallel()` method.  You can also convert it back to sequential by using the `sequential()` method.

```js
stream = streamBuilder.new().range(1, 200 ).parallel();
```

## Intermediate Operations

Once you have generated streams you can work on the elements of the stream by leveraging **intermediate operations**, meaning they are not **terminal operations** that will evaluate all intermediate operations and produce results.  What does evaluate mean? Well, ALL intermediate operations are lazy evaluated. Meaning they will never execute until a terminal operation has been assigned to the stream.

The result of an intermediate operation is **always** a stream, so you can infinitely stream to your :heart:'s content.

- `limit( maxSize )` - Limit a stream
- `distinct()` - Return only distinct elements
- `skip( n )` - Skip from the first element to `n`
- `sorted( [comparator] )` - sort a numerical stream or sort by passing a comparator closure or lambda
- `unordered()` - Return an unordered stream.
- `onClose( closehandler )` - Returns a stream with the `onClose()` handler closure or lambda to be executed when the `close()` oepration is called on the stream.
- `concat( stream1, stream2 )` - This will return a stream composed of concatenating the elements in stream 1 to stream 2
- `peek( action )` - Allows you to peek into the elements in the order of being called. Great for debugging.
- `map( mapper )` - transforms the stream elements into something else, it accepts a function to apply to each and every element of the stream and returns a stream of the values the parameter function produced. This is the bread and butter of the streams API, map allows you to perform a computation on the data inside a stream.
- `filter( predicate )` - returns a new stream that contains some of the elements of the original. It accepts the predicate to compute which elements should be returned in the new stream and removes the rest. In the imperative code we would employ the conditional logic to specify what should happen if an element satisfies the condition. In the functional style we don’t bother with ifs, we filter the stream and work only on the values we require.

## Terminal Operations

Terminal operations are a way to finalize the execution of the stream.  Please note that **ALL** streams are lazy. Meaning that intermediate operations will **NEVER** execute until a single terminator has been called.

- `iterator()` - Return a java iterator of the stream
- `spliterator()` - Return a java spliterator of the stream
- `close()` - Close the stream
- `toArray()` - Convert the stream back into an array
- `count()` - Count the elements in the stream
- `findAny()` - Find any element in the stream
- `findFirst()` - Find the first element in the stream
- `forEach( action )` - Iterate through all elements and call the action consuming closure or lambda.
- `forEachOrdered( action )` - Iterate through all elements in order and call the action consuming closure or lambda.
- `reduce( accumulator, identity )` - (also sometimes called a fold) performs a reduction of the stream to a single element. You want to sum all the integer values in the stream – you want to use the reduce function. You want to find the maximum in the stream – reduce is your friend.  **Important:** Using reduce in a parallel stream is currently not supported and can cause unexpected results as the initial identity value and accumulator need to run sequentially (otherwise they would need to maintain state and streams are stateless). Either use a `map` or run your reducer in a `sequential` stream. 
- `anyMatch( predicate )` - Returns a boolean that indicates if any elements match the predicate closure/lambda
- `allMatch( predicate )` - Returns a boolean that indicates if ALL elements matched the predicate closure/lambda
- `noneMatch( predicate )` - Returns a boolean that indicates if NONE of the elements matched the predicate closure/lambda
- `max(), min(), average()` - Return the appropriate max, min or average of the elements in the stream.  Only for numerical streams
- `max( comparator ), min( comparator ), average( comparator )` - Same as above but for any stream, but you must pass your own comparator closure or lambda.
- `summaryStatistics()` - Give you a struct of stats of the numerical elements: min, max, count, sum, average

### Collectors

Collectors are the way to get out of the streams world and obtain a concrete collection of values, like a list, struct, etc.  Here are our collector methods available to you:

- `collect()` - Return an array of the final elements
- `collectGroupingBy( classifier )` - Build a final collection according to the classifier lambda/closure that will classify the keys in the group.  This is usually a structure of elements.
- `collectAverage( mapper, primitive=long )` - Collect an average according to the mapper function/closure
- `collectSum( mapper, primitive=long )` - Collect a sum according to the mapper function/closure
- `collectSummary( mapper, primitive=long )` - Collect a statistics struct according to the mapper function/closure 
- `collectAsList( delimiter=",", prefix, suffix )` - Collect results into a string list with a delimiter and attached prefix and/or suffix.
- `collectAsStruct( keyID, valueID, overwrite=true )` - Collect the elements into a struct by leveraging the key identifier and the value identifier from the stream of elements to pass into the collection.
- `collectPartitioningBy( predicate )` - partitions the input elements according to a Predicate closure/lambda, and organizes them into a Struct of <Boolean, array >.


## Lambda/Closure References

The Java API has very specific names for the lambdas/closures it accepts.  Below is a reference for them to help you out.

```
// BiFunction, BinaryOperator
function( previous, item ){
    return item;
}

// Comparator
function compare( o1, o2 ){
    return -,+ or 0 for equal
}

// Consumer
void function( item ){

}

// Function, ToDoubleFunction, ToIntFunction, ToLongFunction, UnaryOperator
function( item ){
    return something;
}

// Predicate
boolean function( item ){
    return false;
}

// Supplier
function(){
    return something;
}

// Runnable
void function(){
    // execute something
}
```

## Optionals

Some of the terminal operations on streams do not return a value back to you but rather an `Optional.cfc` which mimics a Java Optional.  Optional is a simple container for a value which can be null or non-null.  This class has some cool methods so you can work with the returned results from streams.

- `isPresent()` - Checks if the optional has a value returned from the stream or maybe a null
- `ifPresent( consumer )` - Pass in a consumer closure/lambda and will call it for you if the optional has a value present
- `filter( predicate )` - If a value is present and the value matches the predicate closure/lambda, then return another Optional.
- `map( mapper )` - If a value is present, apply the mapping function to the value and return another Optional
- `get()` - Get the value in the optional
- `orElse( other )` - Get the value and if not present, return the other value.
- `orElseGet( other )` - Get the value and if not present, call the other closure/lambda that must return the value you want instead.
- `hashCode()` - a unique hash code of the value if present
- `toString()` - debugging for the optional


## Examples Galore

Here are some samples for you to enjoy.

```js
myArray = [
    "ddd2",
    "aaa2",
    "bbb1",
    "aaa1",
    "bbb3",
    "ccc",
    "bbb2",
    "ddd1"
];

// Filtering
streamBuilder.new( myArray )
    .filter( function( item ){
        return item.startsWith( "a" );
    } )
    .forEach( function( item ){
        writedump( item );
    } );

// "aaa2", "aaa1"

// Sorted Stream
streamBuilder.new( myArray )
    .sorted()
    .filter( function( item ){
        return item.startsWith( "a" );
    } )
    .forEach( function( item ){
        writedump( item );
    } );
// "aaa1", "aaa2"

// Mapping
streamBuilder.new( myArray )
    .map( function( item ){
        return item.ucase();
    })
    .sorted( function( a, b ){
        return a.compareNoCase( b );
    }
    .forEach( function( item ){
        writedump( item );
    } );

// "DDD2", "DDD1", "CCC", "BBB3", "BBB2", "AAA2", "AAA1"

// Matching
anyStartsWithA = 
    streamBuilder
        .new( myArray )
        .anyMatch( function( item ){
            return item.startsWith( "a" );
        } );
writeDump( anyStartsWithA );      // true

allStartsWithA =
    streamBuilder
        .new( myArray )
        .allMatch( function( item ){
            return item.startsWith( "a" );
        } );
writeDump( anyStartsWithA );      // false

noneStartsWithZ =
    streamBuilder
        .new( myArray )
        .noneMatch((s) -> s.startsWith("z"));

noneStartsWithZ =
    streamBuilder
        .new( myArray )
        .noneMatch( function( item ){
            return item.startsWith( "z" );
        } );
writeDump( noneStartsWithZ );      // true

// Counting
startsWithB =
    streamBuilder
        .new( myArray )
        .filter( function( item ){
            return item.startsWith( "b" );
        } )
        .count();
writeDump( startsWithB );    // 3

// Reduce
optional =
    streamBuilder
        .new( myArray )
        .sorted()
        .reduce( function( s1, s2 ){
            return s1 & "#" & s2;
        } );
writedump( optional.get() );
// "aaa1#aaa2#bbb1#bbb2#bbb3#ccc#ddd1#ddd2"

// Parallel Sorted Count
count =
    streamBuilder
        .new( myArray )
        .parallel()
        .sorted()
        .count();
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
#### HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
