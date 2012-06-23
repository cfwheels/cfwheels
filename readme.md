## Welcome to CFWheels

[ColdFusion on Wheels][1] provides fast application development, a great organization system for your code, and is just plain fun to use.

One of our biggest goals is for you to be able to get up and running with Wheels quickly. We want for you to be able to learn it as rapidly as it is to write applications with it.

## Getting Started

In this [Beginner Tutorial: Hello World][2], we'll be writing a simple application to make sure we have Wheels installed properly and that everything is working as it should. Along the way, you'll get to know some basics about how applications built on top of Wheels work.

## Contributing

We encourage you to contribute to ColdFusion on Wheels! Please check out the [Coding Guidelines][3] for guidelines about how to proceed. Join us! 

## Running Tests

_NOTE:_ CFWheels uses [RocketUnit][4] as it's testing framework.

1. create a database on a supported database server name `wheelstestdb`. At this time the supported database servers are H2, Microsoft SQL Server, Oracle, PostgreSQL, MySQL
2. create a datasource in your CFML engine's administrator named `wheelstestdb` pointing to the `wheelstestdb` database and make sure to give it CLOB and BLOB support.
3. open your browser to the CFWheels Welcome Page.
4. in the grey debug area at the bottom of the page, click the `Run Tests` link next the version number on the `Framework` line.

Please report any errors that you may encounter on our [issue tracker][5]. Please be sure to report the database engine (including version), CFML engine (including version), http server (including version).

## Building

_NOTE:_ the build script has only been tested against Railo 3.3.0.007 or higher at this time.

1. open the build.cfm file in the root of the repo.
2. set the `release` variable with the version number of the release
3. point your browser to the build.cfm file (ex: http://localhost/build.cfm)
4. the build will create a zip file named `cfwheels.<release>.zip` in the root of the repo

## License

ColdFusion on Wheels is released under the Apache License Version 2.0.
 
 [1]: http://cfwheels.org/
 [2]: http://cfwheels.org/docs/1-1/chapter/beginner-tutorial-hello-world
 [3]: http://cfwheels.org/docs/1-1/chapter/coding-guidelines
 [4]: http://rocketunit.riaforge.org/
 [5]: http://code.google.com/p/cfwheels/issues/list