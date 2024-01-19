/**
 * A container object which may or may not contain a non-null value. If a value is present, isPresent() will return true and get() will return the value.
 *
 * Additional methods that depend on the presence or absence of a contained value are provided, such as orElse() (return a default value if value not present) and ifPresent() (execute a block of code if the value is present).
 *
 * See https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html
 */
component accessors="true"{

     /**
     * The Java Builder we represent
     */
    property name="jOptional";

    // The Core Optional Library
	variables.coreOptional = createObject( "java", "java.util.Optional" );
	// Adobe CF Hack because their compiler sucks!
	this[ "or" ] = this.$or;

    /**
     * Construct a CFML Optional out of the Java Optional.
     * If no optional passed, we will generate an empty one.
     *
     * @optional A Java optional to initialize this CFML Optional with.
     */
    Optional function init( optional ){
        if( !isNull( arguments.optional ) ){
            variables.jOptional = arguments.optional;
        } else {
            variables.jOptional = variables.coreOptional.empty();
        }
        return this;
    }

    /**
     * Returns an Optional with the specified present non-null value.
     *
     * @value The value to be present, which must be NON NULL
     *
     * @return an Optional with the value present
     */
    Optional function of( required value ){
        variables.jOptional = variables.jOptional.of( arguments.value );
        return this;
    }

    /**
     * Returns an Optional describing the specified value, if non-null, otherwise returns an empty Optional.
     *
     * @value the possibly-null value to describe
     *
     * @return     an Optional with a present value if the specified value is non-null, otherwise an empty Optional
     */
    Optional function ofNullable( value ){
        if( isNull( arguments.value ) ){
            return this.empty();
        } else {
            return this.of( arguments.value );
        }
    }

    /**
     * Build an empty optional out.
     */
    Optional function empty(){
        variables.jOptional = variables.coreOptional.empty();
        return this;
    }

    /**
     * Indicates whether some other object is "equal to" this Optional.
     * Please note that the incoming <source>obj</source> must also be an Optional
     */
    boolean function isEqual( required obj ){
        return variables.jOptional.equals( arguments.obj );
    }

    /**
     * Return true if there is a value present, otherwise false.
     */
    boolean function isPresent(){
        return variables.jOptional.isPresent();
	}

	/**
	* Return true if there is no value present, otherwise false
	*/
	boolean function isEmpty(){
		return !this.isPresent();
	}

    /**
     * If a value is present, invoke the specified consumer with the value, otherwise do nothing.
     *
     * @consumer block to be executed if a value is present
     */
    void function ifPresent( required consumer ){
        variables.jOptional.ifPresent(
            createDynamicProxy(
				new proxies.Consumer( arguments.consumer ),
				[ "java.util.function.Consumer" ]
			)
        );
	}

	/**
	 * If a value is present, performs the given action with the value, otherwise performs the given empty-based action.
	 *
	 * @consumer The closure/lambda to execute if the value is present
	 * @runnable The closure/lambda to execute if the value is NOT present
	 */
	void function ifPresentOrElse( required consumer, required runnable ){
		if( this.isPresent() ){
			arguments.consumer( this.get() );
		}
		arguments.runnable();
	}

    /**
     * If a value is present, and the value matches the given predicate, return an Optional describing the value, otherwise return an empty Optional.
     *
     * @predicate a predicate to apply to the value, if present
     *
     * @return an Optional describing the value of this Optional if a value is present and the value matches the given predicate, otherwise an empty Optional
     */
    Optional function filter( required predicate ){
        variables.jOptional = variables.jOptional.filter(
            createDynamicProxy(
				new proxies.Predicate( arguments.predicate ),
				[ "java.util.function.Predicate" ]
			)
        );
        return this;
    }

    /**
     * If a value is present, apply the provided mapping function to it, and if the result is non-null, return an Optional describing the result. Otherwise return an empty Optional.
     *
     * @mapper a mapping function to apply to the value, if present
     *
     * @return an Optional describing the result of applying a mapping function to the value of this Optional, if a value is present, otherwise an empty Optional
     */
    Optional function map( required mapper ){
        variables.jOptional = variables.jOptional.map(
            createDynamicProxy(
				new proxies.Function( arguments.mapper ),
				[ "java.util.function.Function" ]
			)
        );
        return this;
    }

    /**
     * If a value is present in this Optional, returns the value, otherwise throws NoSuchElementException.
     */
    function get(){
        return getNativeType( getValueFromOptional() );
    }

    /**
     * Return the value if present, otherwise return other.
     *
     * @other the value to be returned if there is no value present, may be null
     *
     * @return the value, if present, otherwise other
     */
    function orElse( required other ){
        return ( isPresent() ? get() : arguments.other );
    }

     /**
     * Return the value if present, otherwise invoke other and return the result of that invocation.
     *
     * @other a Supplier lambda or closure whose result is returned if no value is present
     *
     * @return the value if present otherwise the result of other.get()
     */
    function orElseGet( required other ){
        return ( isPresent() ? get() : arguments.other() );
	}

	/**
	 * If a value is present, returns the value, otherwise throws NoSuchElementException.
	 *
	 * @type The type of the exception to throw or defaults to NoSuchElementException,
	 * @message The message of the exception, defaults to empty string
	 */
	any function orElseThrow( type="NoSuchElementException", message="" ){
		if( this.isPresent() ){
			return this.get();
		}
		throw( type=arguments.type, message=arguments.message );
	}

	/**
	* Runs the `runnable` closure/lambda if the value is not set and the same optional instance is returned.
	*
	* @runnable a lambda or closure that will run
	*
	* @return the same optional instance
	*/
	Optional function orElseRun( required runnable ){
		if( !this.isPresent() ){
			arguments.runnable();
		}
		return this;
	}

	/**
	 * If a value is present, returns an Optional describing the value, otherwise returns an Optional produced by the supplying function.
	 *
	 * @supplier A closure/lambda that must return a cbOptional
	 */
	Optional function $or( required supplier ){
		if( this.isPresent() ){
			return this;
		}
		return this.ofNullable( arguments.supplier() );
	}

    /**
     * Returns the hash code value of the present value, if any, or 0 (zero) if no value is present.
     */
    numeric function hashCode(){
        return variables.jOptional.hashcode();
    }

    /**
     * Returns a non-empty string representation of this Optional suitable for debugging.
     */
    String function toString(){
        return variables.jOptional.toString();
    }

    /**
	 * Return a native CF type from incoming Java type. This is our Java to CF Bridge. Expand as needed
	 *
	 * @results The native Java return
	 */
	function getNativeType( results ){
		if( isNull( arguments.results ) ){
			return;
		}

		var className 	= arguments.results.getClass().getName();
		var isEntrySet 	= isInstanceOf( arguments.results, "java.util.Map$Entry" ) OR isInstanceOf( arguments.results, "java.util.HashMap$Node" );

		if( isEntrySet ){
			return {
				"#arguments.results.getKey()#" : arguments.results.getValue()
			};
		}

		return arguments.results;
	}

    /**
	 * Verify if the optional is of a certain primitive type and call the appropriate function to return it's value.
     * If not, it reverts to a default typedless Optional.
	 */
	private function getValueFromOptional(){
		if( !isPresent() ){
			return;
		}

		if( isInstanceOf( variables.jOptional, "java.util.OptionalInt" ) ){
			return variables.jOptional.getAsInt();
		}

		if( isInstanceOf( variables.jOptional, "java.util.OptionalLong" ) ){
			return variables.jOptional.getAsLong();
		}

		if( isInstanceOf( variables.jOptional, "java.util.OptionalDouble" ) ){
			return variables.jOptional.getAsDouble();
        }

        return variables.jOptional.get();
    }

}