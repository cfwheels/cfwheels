#Overview of the Testing Framework

## The Theory Behind Testing

At some point your code is going to break and the scary thing is it might not even be your fault. 
Upgrades, feature enhancements, bug fixes are all part of the development lifecycle and with deadlines 
and screaming managers you don't have the time to test the functionality of your entire application with 
every change you make.

The problem is that today's fix could be tomorrow's bug. What if there was an automated way of seeing if 
that change you're making is going to break something? That's where writing tests for your application 
can be invaluable.

In the past writing test against your application meant downloading, configuring and learning a 
completely separate framework. Often times this caused more headaches then it was worth and was the 
reason why most developers didn't bother writing tests. With Wheels we've included a small and very 
simple testing framework to help address just this issue.

With Wheels, writing tests for your application is part of the development lifecycle itself and running 
the test is as simple as clicking a link.

## Touring the Testing Framework

Like everything else in Wheels, the testing framework is very simple yet powerful. You're not going to 
having to remember a hundred different commands and methods since Wheels' testing framework has only 
three commands and four methods (you can't get any simpler than that). Let's take a tour and go over the 
conventions, commands and methods that make up the different parts of the Testing Framework:

### Writing Tests

Any components that will contain tests **MUST** extend the **_wheelsMapping.Test_** component:

	<cfcomponent extends="wheelsMapping.Test">

If the testing engine sees that a component **DOES NOT** extend **_wheelsMapping.Test_**, that component 
skipped. This let's you create and store any _mock_ components you might want to use with your tests and 
keep everything together.

Any methods that will be used as tests **MUST** begin their name with **_test_**:

	<cffunction name="testAEqualsB">

If a method **DOES NOT** begin with **_test_** it is ignored and skipped. This let's you create as many 
helper methods for your testing components as you want.

### Conventions

**<font color="red">DO NOT VAR ANY VARIABLES</font>** used in your tests. In order for the testing 
framework to get access to the variables within the tests that you're writing, all variables need to be 
within the components **variables scope**. The easy way to do this is to just not "var" variables within 
your tests and [Railo][2] / [ColdFusion][3] will automatically assign these variables into the 
variables scope of the component for you.

The only gotcha with this approach is that this could cause some variables to overwrite each other and 
gets kinda of confusing of what's being thrown into the variables scope. In order to prevent this, we 
recommend that you create your own sudo-scope by prepending the variables used within your test. The 
suggested scope to use is **_loc_**. You will see this scope used through the examples below.

### Evaluation

**assert():** This is the main method that you will be using when developing tests. To use, all you have 
to do is provide a quoted expression. The power of this is that **ANY** expression can be used.

An example test that checks that two values equal each other:

	<cffunction name="testAEqualsB">
		<cfset loc.a = 1>
		<cfset loc.b = 1>
		<cfset assert("loc.a eq loc.b")>
	</cffunction>

An example test that checks that the first value is less then the second value:

	<cffunction name="testAIsLessThanB">
		<cfset loc.a = 1>
		<cfset loc.b = 5>
		<cfset assert("loc.a lt loc.b")>
	</cffunction>

You get the idea since you've used these kinds of expressions a thousand times. If you think of the 
assert() command as another way of using [evaluate()][1], it will all make sense. Remember that you can 
use **ANY** expression, so you can write assertions against structures, arrays, objects, you name it, 
you can test it!

An example test that checks that a key exists in a structure:

	<cffunction name="testKeyExistsInStructure">
		<cfset loc.a = {a=1\. b=2\. c=3}>
		<cfset loc.b = "d">
		<cfset assert("StructKeyExists(loc.a, loc.b)")>
	</cffunction>

**raised():** Used when you want to test that an exception will be thrown. Raised() will raise and catch 
the exception and return to you the exception type (think cfcatch.type). Just like assert(), raised() 
takes a quoted expression as it's argument.

An example of raising the Wheels.TableNotFound error when you specify an invalid model 
name:

	<cffunction name="testTableNotFound">
		<cfset loc.e = raised("model('thisHasNoTable')")>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

### Debugging

**debug():** Will display it's output after the test result so you can examine an expression more 
closely.

*   expression (string) - a quoted expression to display
*   display (boolean) - whether or not to display the output
_NOTE:_ overloaded arguments will be passed to the internal cfdump attributeCollection.

An example of displaying the debug output:

	<cffunction name="testKeyExistsInStructure">
		<cfset loc.a = {a=1\. b=2\. c=3}>
		<cfset loc.b = "d">
		<cfset debug("loc.a")>
		<cfset assert("StructKeyExists(loc.a, loc.b)")>
	</cffunction>

An example of calling debug but NOT displaying the output:

	<cffunction name="testKeyExistsInStructure">
		<cfset loc.a = {a=1\. b=2\. c=3}>
		<cfset loc.b = "d">
		<cfset debug("loc.a", false)>
		<cfset assert("StructKeyExists(loc.a, loc.b)")>
	</cffunction>

An example of displaying the output of debug as <tt>text</tt>:

	<cffunction name="testKeyExistsInStructure">
		<cfset loc.a = {a=1\. b=2\. c=3}>
		<cfset loc.b = "d">
		<cfset debug(expression="loc.a", format="text")>
		<cfset assert("StructKeyExists(loc.a, loc.b)")>
	</cffunction>

### Setup and Teardown

It's common when writing a group of tests that there will be some duplicate code, global configuration, 
and/or cleanup needed to be run before or after each test. In order to keep things DRY (Don't Repeat 
Yourself), the testing framework offers two special methods that you can optionally use to handle such 
configuration.

**setup():** Used to initialize or override any variables or execute any code that needs to be run 
**BEFORE EACH** test.

**teardown():** Used to cleanup any variables or execute any code that needs to be ran **AFTER EACH** 
test.

Example:

	<cfcomponent extends="wheelsMapping.Test">
	
		<cffunction name="setup">
			<cfset loc.controller = $controller(name="dummy")>
			<cfset loc.f = loc.controller.distanceOfTimeInWords>
			<cfset loc.args = {}>
			<cfset loc.args.fromTime = now()>
			<cfset loc.args.includeSeconds = true>
		</cffunction>
	
		<cffunction name="testWithSecondsBelow5Seconds">
			<cfset loc.c = 5 - 1>
			<cfset loc.args.toTime = DateAdd('s', c, args.fromTime)>
			<cfinvoke method="loc.f" argumentCollection="#loc.args#" returnVariable="loc.e">
			<cfset loc.r = "less than 5 seconds">
			<cfset assert("loc.e eq loc.r")>
		</cffunction>
	
		<cffunction name="testWithSecondsBelow10Seconds">
			<cfset loc.c = 1\. - 1>
			<cfset loc.args.toTime = DateAdd('s', loc.c, loc.args.fromTime)>
			<cfinvoke method="loc.f" argumentCollection="#loc.args#" returnVariable="loc.e">
			<cfset loc.r = "less than 1\. seconds">
			<cfset assert("loc.e eq loc.r")>
		</cffunction>
	
	</cfcomponent>
[1]: http://livedocs.adobe.com/coldfusion/8/htmldocs/functions_e-g_03.html
[2]: http://www.getrailo.org/
[3]: http://www.adobe.com/products/coldfusion-family.html
