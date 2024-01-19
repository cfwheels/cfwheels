# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

## [] - 2023-05-10

### Fixed

- [TESTBOX-341](https://ortussolutions.atlassian.net/browse/TESTBOX-341) toHaveLength param should be numeric
- [TESTBOX-354](https://ortussolutions.atlassian.net/browse/TESTBOX-354) Element $DEBUGBUFFER is undefined in THIS
- [TESTBOX-356](https://ortussolutions.atlassian.net/browse/TESTBOX-356) Don't assume TagContext has length on simpleReporter
- [TESTBOX-357](https://ortussolutions.atlassian.net/browse/TESTBOX-357) notToThrow() incorrectly passes when no regex is specified
- [TESTBOX-360](https://ortussolutions.atlassian.net/browse/TESTBOX-360) full null support not working on Application env test
- [TESTBOX-361](https://ortussolutions.atlassian.net/browse/TESTBOX-361)  MockBox Suite: Key \[aNull] doesn't exist
- [TESTBOX-362](https://ortussolutions.atlassian.net/browse/TESTBOX-362) Cannot create sub folders within testing spec directories.

### Improvements

- [TESTBOX-333](https://ortussolutions.atlassian.net/browse/TESTBOX-333) Add contributing.md to repo
- [TESTBOX-339](https://ortussolutions.atlassian.net/browse/TESTBOX-339) full null support automated testing
- [TESTBOX-353](https://ortussolutions.atlassian.net/browse/TESTBOX-353) allow globbing path patterns in testBundles argument
- [TESTBOX-355](https://ortussolutions.atlassian.net/browse/TESTBOX-355) Add debugBuffer to JSONReporter
- [TESTBOX-366](https://ortussolutions.atlassian.net/browse/TESTBOX-366) ANTJunit Reporter better visualization of the fail origin and details
- [TESTBOX-368](https://ortussolutions.atlassian.net/browse/TESTBOX-368) Support list of Directories for HTMLRunner to allow more modular tests structure
- [TESTBOX-370](https://ortussolutions.atlassian.net/browse/TESTBOX-370) \`toHaveKey\` works on queries in Lucee but not ColdFusion

### Added

- [TESTBOX-371](https://ortussolutions.atlassian.net/browse/TESTBOX-371) Add CoverageReporter for batching code coverage reports
- [TESTBOX-137](https://ortussolutions.atlassian.net/browse/TESTBOX-137) Ability to spy on existing methods: $spy()
- [TESTBOX-342](https://ortussolutions.atlassian.net/browse/TESTBOX-342) Add development dependencies to box.json
- [TESTBOX-344](https://ortussolutions.atlassian.net/browse/TESTBOX-344) Performance optimizations for BaseSpec creations by lazy loading external objects
- [TESTBOX-345](https://ortussolutions.atlassian.net/browse/TESTBOX-345) add a skip(\[message]) like fail() for skipping from inside a spec
- [TESTBOX-365](https://ortussolutions.atlassian.net/browse/TESTBOX-365) New build process using CommandBox
- [TESTBOX-372](https://ortussolutions.atlassian.net/browse/TESTBOX-372) Adobe 2023 and Lucee 6 Support

[Unreleased]: https://github.com/Ortus-Solutions/TestBox/compare/v...HEAD

[]: https://github.com/Ortus-Solutions/TestBox/compare/9f820840b1012dd89b79c62494333d4117bc1a7c...v
