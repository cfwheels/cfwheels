/**
 * A mutable builder for a Stream. This allows the creation of a Stream by generating elements individually and adding them to the Builder (without the copying overhead that comes from using an ArrayList as a temporary buffer.) 
 * 
 * A stream builder has a lifecycle, which starts in a building phase, during which elements can be added, and then transitions to a built phase, after which elements may not be added. The built phase begins when the build() method is called, which creates an ordered Stream whose elements are the elements that were added to the stream builder, in the order they were added.
 * 
 * See https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.Builder.html
 */
component accessors="true"{

    /**
     * The Java Builder we represent
     */
    property name="jBuilder";

    /**
     * Construct a CFML builder out of the Java Builder
     */
    function init( required builder ){
        variables.jBuilder = arguments.builder;
        return this;
    }

    /**
     * Adds an element to the stream being built.
     *
     * @element The element to add to the builder
     */
    Builder function add( required element ){
        variables.jBuilder.add( arguments.element );
        return this;
    }

    /**
     * Builds the stream, transitioning this builder to the built state. An IllegalStateException is thrown if there are further attempts to operate on the builder after it has entered the built state.
     */
    Stream function build(){
        var oStream = new Stream();
        oStream.setjStream( variables.jBuilder.build() );
        return oStream;
    }
}