# CFWheels

[CFWheels][1] provides fast application development, a great organization system for your code, and is
just plain fun to use.

One of our biggest goals is for you to be able to get up and running with CFWheels quickly. We want for
you to be able to learn it as rapidly as it is to write applications with it.

## Getting Started

In this [Beginner Tutorial: Hello World][2], we'll be writing a simple application to make sure we have
CFWheels installed properly and that everything is working as it should. Along the way, you'll get to
know some basics about how applications built on top of CFWheels work.

## Contributing

We encourage you to contribute to CFWheels! Please check out the [Coding Guidelines][3] for guidelines
about how to proceed. Join us!

## Running Tests

**Before running tests, make sure that all debugging is turned OFF**. This could add a considerable amount
of time for the tests to complete and may cause your engine to become unresponsive.

 1. Create a database on a supported database server named `wheelstestdb`. At this time the supported
    database servers are H2, Microsoft SQL Server, Oracle, PostgreSQL and MySQL.
 2. Create a datasource in your CFML engine's administrator named `wheelstestdb` pointing to the
    `wheelstestdb` database and make sure to give it CLOB and BLOB support.
 3. Open your browser to the CFWheels Welcome Page.
 4. In the gray debug area at the bottom of the page, click the `Run Tests` link next to the version number
    on the `Framework` line.

Please report any errors that you may encounter on our [issue tracker][4]. Please be sure to report the
database engine (including version), CFML engine (including version), and HTTP server (including
version).

## Code Status

[![Build Status](https://travis-ci.org/cfwheels/cfwheels.svg?branch=master)](https://travis-ci.org/cfwheels/cfwheels)

## License

[CFWheels][1] is released under the Apache License Version 2.0.
 
[1]: http://cfwheels.org/
[2]: http://docs.cfwheels.org/docs/beginner-tutorial-hello-world
[3]: http://docs.cfwheels.org/docs/contributing-to-cfwheels
[4]: https://github.com/cfwheels/cfwheels/issues
