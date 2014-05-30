# ColdFusion on Wheels

[ColdFusion on Wheels][1] provides fast application development, a great organization system for your
code, and is just plain fun to use.

One of our biggest goals is for you to be able to get up and running with Wheels quickly. We want for you
to be able to learn it as rapidly as it is to write applications with it.

## Getting Started

In this [Beginner Tutorial: Hello World][2], we'll be writing a simple application to make sure we have
Wheels installed properly and that everything is working as it should. Along the way, you'll get to know
some basics about how applications built on top of Wheels work.

## Contributing

We encourage you to contribute to ColdFusion on Wheels! Please check out the [Coding Guidelines][3] for
guidelines about how to proceed. Join us! 

If you would like to contribute or update doumentation, you can edit the guides located in `wheels/docs`.

**_NOTE:_** When writing or updating documentation for the API themselves, update the documentation
directly in the associated method and **NOT** in the `wheels/docs/Wheels API` directory. Afterwards, run
the documentation generator (this will update the `wheels/docs/Wheels API` directory automatically) and
commit your changes. See the `Generating API Documentation` section of this README for more information. 

## Running Tests

**_Note:_** CFWheels uses [RocketUnit][4] as its testing framework.

**Before running tests, make sure that all debugging is turned OFF**. This could add a consideral amount
of time for the tests to complete and may cause your engine to become unresponsive.

 1. Create a database on a supported database server name `wheelstestdb`. At this time the supported
    database servers are H2, Microsoft SQL Server, Oracle, PostgreSQL, MySQL.
 2. Create a datasource in your CFML engine's administrator named `wheelstestdb` pointing to the
    `wheelstestdb` database and make sure to give it CLOB and BLOB support.
 3. Open your browser to the CFWheels Welcome Page.
 4. In the grey debug area at the bottom of the page, click the `Run Tests` link next the version number
    on the `Framework` line.

Please report any errors that you may encounter on our [issue tracker][5]. Please be sure to report the
database engine (including version), CFML engine (including version), and HTTP server (including
version).

## Building and Releasing

**_Note:_** The build script has only been tested against Railo 3.3.0.007 or higher at this time.

 1.	Make sure the URL rewriting is _**OFF**_
 2. Open `wheels/version.cfm` file and edit the version to correspond with the build.
 3. Update `wheels/CHANGELOG` to reflect version and build date.
 4. Click the `Generate Release` on the Framework line in the `grey debug area`
 5. The build will create a zip file named `cfwheels.<version>.zip` in `builders/output/release`
 	directory of the repo.
 6. Annouce and post the build to the Core Team.

## Generating API Documentation

**UPDATE 20130927** The API generation script can now work with both Railo and ACF

It is important to repeat again that all documentation pertaining to methods should be done directly
in the source code itself and **NOT** in the `wheels/docs/Wheels API` directly as any changes will be
overwritten when the API generator is ran again.

 1. Make sure the URL rewriting is _**OFF**_
 2. Click the `Generate Documentation` on the Framework line in the `grey debug area`
 3. The generator will automatically create all the pages for the Wheels API in `wheels/docs/Wheels API`
 4.	A `cfwheels-api.xml` XML file will be created in the `builders/output/docs` directory. This can be
 	used to create a syntax or code hinting library for Wheels for your favorite editor.
	
You may overload or overwrite any of the outputted API documentation by adding to the
`builders/api/overload.cfm`. A diagram of the generated API structure is provided in the document.

## View API Documentation

You will need a Markdown viewer in order to view the documentation locally. If you use Google Chrome,
you can install the [Markdown Preview][6] extension.

## License

[ColdFusion on Wheels][1] is released under the Apache License Version 2.0.
 
[1]: http://cfwheels.org/
[2]: http://cfwheels.org/docs/chapter/beginner-tutorial-hello-world
[3]: http://cfwheels.org/docs/chapter/coding-guidelines
[4]: http://rocketunit.riaforge.org/
[5]: https://github.com/cfwheels/cfwheels/issues
[6]: https://chrome.google.com/webstore/detail/jmchmkecamhbiokiopfpnfgbidieafmd
