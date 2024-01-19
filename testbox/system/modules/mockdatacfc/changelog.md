# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [3.6.0] => 2022-SEP-22

### Added

* New module layout

### Fixed

* DateRanges

----

## [3.5.0] => 2022-JAN-11

### Added

* Github actions migration
* Formatting and code quality rules
* `guid` generator thanks to @djcard

----

## [3.4.0] => 2020-JUN-03

### Added

* `string` type re-architected to produce more randomness and more permutations according to our new generation pattern: `string[-(secure|alpha|numeric):max]` #6
* More formatting rules
* Changelog standards
* Auto publishing to github (artifacts and changelogs)
* Types are now case-insensitive when called: `num,oneof,lorem,baconlorem,sentence,words`  #5
* `generateFakeData()` is now public
* All generators can now be called individually by function name
* `lorem,baconlorem,words,sentence` you can now produce random sizes with them via `min:max` notation
* Optimized generation by using arrays instead of strings
* Included libraries for nouns and adjectives

### Changed

* Access variables according to scopes instead of lookup
* Internal data generation names to avoid method conflicts

### Fixed

* Access variables according to scopes
* `$returnType` is not documented #8

----

## [3.3.1] => 2020-APR-16

### Fixed

* param the default method when executing via URL instead of setting it.

----

## [3.3.0] => 2020-JAN-28

### New Features

* `ipaddress` : Generates an ipv4 address
* New type: `string` which generates random hash strings of certain length. Default is 10 characters.
* New type: `website` to generate random protocol based websites
* New type: `website_http` to generate `http` only based websites
* New type: `website_https` to generate `https` only based websites
* New type: `imageurl` : Generates a random image URL with a random protocol
* New type: `imageurl_http` : Generates a random image URL with `http` only protocol
* New type: `imageurl_https` : Generates a random image URL with `https` only protocol
* New type: `url` : Generates a random URL with a random protocol
* New type: `url_http` : Generates a random URL with `http` only protocol
* New type: `url_https` : Generates a random URL with `https` only protocol

### Improvements

* Added new domains for more random generation
* Removed spacing from words

----

## [3.2.0] => 2020-JAN-08

### New Features

* Added the ability for a type to be a closure/lambda to act as a supplier. This way, this function will be called every time for you to supply the result.  It receives the current iterating `index` as well: `function( index ){}`

### Improvements

* Formatting of source via cfformat
* Fixes for api doc creations to use the project mapping
* Functional update of json service to filter out reserved rc keys
* TestBox 3 upgrade
* More direct scoping of the arguments scope

----

## [3.1.0] => 2019-MAY-19

* CommandBox ability to execute
* Template updates to standards

----

## [3.0.0] => 2018-SEP-4

* **Compatibility** : `num` arguments have been dropped and you must use `$num` as the identifier for how many items you like
* Introduction of nested mocking. You can now declare nested mocks as structs and the mock data will nest accordingly:

```js
getInstance( "MockData@MockDataCFC" )
	.mock(
		books=[{
			num=2,
			"id"="uuid",
			"title"="words:1:5"
		}],
		fullName="name",
		description="sentence",
		age="age",
		id="uuid",
		createdDate="datetime"
	);
```

This will produce top level mock data with 2 books per record.

* Nested Data for array of objects, array of values and simple objects
* ACF Compatibilities
* Updated readmes and syntax updates for modern engines
* Upgraded to new ColdBox module Harness

----

## [2.4.0]

* Added auto-incrementing ID's FOR REAL this time

----

## [2.3.0]

* Added auto-incrementing ID's
* Update on build control
* Syntax Ortus Updates, addition of private methods
* allow for use of `rand` or `rnd` for `num` generators
* Add CORS support for ColdBox REST Module
* Bug on `isDefault()` always returning true.
* Added tests and automation

----

## [2.2.0]

* Made it a module as well for ColdBox apps.

----

## [2.0.0]

* Added support for words, sentences, uuid, bacon lorem, date and datetime
* Added CommandBox Support
* Added Documentation
* Added ability to execute as a CFC instead of only via web service

----

## [1.0.0]

Original by Ray Camden
