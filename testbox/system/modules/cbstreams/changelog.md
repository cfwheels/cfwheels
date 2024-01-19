# Changelog

## v1.5.0

* Added ACF support for `java.util.ArrayList` native arrays to be casted correctly to Java Streams.
* Experimental: Added the ability to transfer page contexts and fusion contexts for running parallel threads. This is a major breakthrough for parallelization of the fork join framework and bridging to the CFML engines. Only works on ACF, and partially.

## v1.4.0

* Ability to add a file encoding when doing file streams via `ofFile( path, encoding = "UTF-8" )` with UTF-8 being the default.
* The `Optional` class gets several new methods:
  * `isEmpty()` - Returns true if the value is empty else false
  * `ifPresentOrElse( consumer, runnable )` - If a value is present, performs the given action with the value, otherwise performs the given empty-based action.
  * `orElseRun( runnable )` - Runs the `runnable` closure/lambda if the value is not set and the same optional instance is returned.
  * `$or( supplier ), or( supplier )` - If a value is present, returns an Optional describing the value, otherwise returns an Optional produced by the supplying function value.
  * `orElseThrow( type, message )` - If a value is present, returns the value, otherwise throws NoSuchElementException.


## v1.3.0

* Native ColdFusion Query Support
* Native Java arrays support when passing native java arrays to build streams out of them

## v1.2.1

* Fixes on `map()` when using ranges to switch the types to `any`

## v1.2.0

* Fix the `generate()` to use the correct stream class. Only works on lucee, adobe fails on interface default method executions.
* Removed the `iterate()` not working with dynamic proxies
* Rework of ranges in order to work with strong typed streams

## v1.1.0

* Added Adobe 2018 Build process
* Updated keyserver for build process
* Updated API Doc generation
* Updated usage docs on API
* CFConfig additions for further testing
* Fixes to interfaces for ACF Compat

## v1.0.0

* First iteration of this module