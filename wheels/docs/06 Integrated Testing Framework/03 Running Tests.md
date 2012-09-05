# Running Tests

Down in the debug area of your Wheels application (that grey area at the bottom of the page), you will 
notice a couple of **Run Tests** links in the following areas: 

**Application Name** and **Plugins**.These links runs the following suite of tests:

**Application Name**: Runs any tests that you have created for your application. You should run these 
tests before deploying your application.

**Plugins**: A **Run Tests** link will be next to **each** installed plugin you have in your wheels 
installation. You should run these tests whenever you install or update a plugin. **NOTE:** the <tt>Run 
Tests</tt> will appear if there are no tests that were packaged with the plugin.

## Running Selected Test Packages

Very often you might want to only run a package of tests (a group of tests within a single directory). 
In order to do this, just append the **package** argument to the url with the name of the package you 
want to run. For instance, say you had a test package called **UserVerifcation**. To run only that test 
package, add **&amp;package=UserVerifcation** to the end of the test url.