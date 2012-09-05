# Documentation Guidelines

*summary We know what volunteering is like, so we want to make it as efficient for everyone as possible. 
Here are the rules of the road for contributing documentation to the project.*

The Docs are as important as the code itself. How is anyone going to use Wheels if they can't learn how 
to? And the great docs by Allaire/Macromedia/Adobe are a big reason why you've always loved !ColdFusion, 
right?

### Steve, Our Persona

In hopes of keeping everyone in the same spirit, let's give the narrator of the website and 
documentation the name *Steve*. Let's pretend that we're Steve when writing in order to keep things 
interesting, friendly to our audience, and consistent.

Here's a description of Steve's persona. Being a Wheels nerd, you'll probably find himself easy to 
relate to.

 * Snarky and not afraid to color outside of the lines of formalities a little bit.
 * Has a dry sense of humor but is still funny.
 * An OOP and MVC know-it-all, but also very willing to explain things in simple terms when needed.
 * Tried Fusebox and Mach-II a few years ago and never quite "got it."
 * Giddy about the simplicity and elegance of Wheels.
 * The kind of guy that you'd like to grab a beer with.
 * The only other guy in meetings that you attend that "gets it" and doesn't annoy others or waste time.

### Process

All documentation should go through these processes. Let's not be a bunch of cowboys like !MySpace 
developers!

 * First off, let the [Google Group][1] know what you're planning on doing! We would hate for you to 
 spend hours writing a document that someone else is also working on. Plus the group would be glad to 
 help out answering any questions that you may have.
 * [Fork][6] the [cfwheels repo][5] to you github account.
 * Add the content to the documentation located in the `wheels/docs` directory.  
 * [Submit a pull request][7] so that core is notified of your changes. It is also a good idea to post a
 link to the pull request in the [Google Group][1] so that everyone in the community is notified.
 * After you address any questions or issues and the pull request is ready to be merged, a member of the
 core team will [merge][8] new documentation into the repo.
 * Keep the documentation to a width of **105 columns**.

## Chapters in the Reference Guide

The [Reference Guide][2] contains narrative chapters about using the framework. It should contain a
wealth of code samples and should be written in clear, concise language.

## Video Tutorials

Video tutorials should cover an area of Wheels that hasn't been covered in previous videos. Please 
publish the video in Flash or Quicktime format at a maximum width of 720 pixels.

The core team will make the final decision on whether or not the video will be published on the Wheels 
website, but you may post the video on your blog, !YouTube, or anywhere else that you please.

## API Documentation

The API documentation should be very clear and concise. Let's keep Steve out of it for the most part. He 
understands.

### Example API Function Documentation

Most descriptions of Wheels' functions should follow this general format, inspired by the CFML function 
reference in the [ColdFusion 8 Live Docs][3].

### Description
 
 A concise description of what the function does. Also include any notes like what types of values that 
 are supported and returned.
 
### Returns
 
 Short description of what is returned from the function, if anything.
 
### Function Syntax
 
	functionName(argument1, argument2, [optionalArgument])
 
### History (for All Versions Past 1.0)
 
 * *1.1:* History of how function behavior changes from version to version of Wheels.
 
### Parameters

	|| *Parameter* || *Type* || *Required* || *Default* || *Description* ||
	|| `argument1` || string || Yes || N/A || A description of `argument1`, including type and possible values if applicable. ||
	|| `argument2` || string || Yes || N/A || A description of `argument2`. ||
	|| `optionalArgument` || boolean || No || Default Value || A description of `optionalArgument`, including default value if applicable. ||
  
### Examples
 
 Example code for common use cases.

### Generating API Documentation in Core Source Code

We will be generating all API documentation using attributes in the Wheels core code's `<cffunction>` 
and `<cfargument>` tags. This metadata will be parsed and imported into a database for use on the website.

Use [Markdown][4] and HTML formatting where appropriate.

###Function Documentation

Within each public function (those not beginning with a `$` character), use the following attributes:

	|| *Attribute* || *Required* || *Default* || *Description* ||
	|| `hint` || Yes || || A concise description of what the function does. Also include any notes like what types of values that are supported and returned. ||
	|| `examples` || Yes || || Example code for common use cases. ||
	|| `categories` || Yes || || Comma-delimited list of parent and optional subcategory that the function belongs to. See the _List of Categories_ section below for valid valies. ||
	|| `chapters` || No || `[empty string]` || Comma-delimited list of related documentation chapters' URL slugs. For example, `using-routes` for the [UsingRoutes Using Routes] chapter. ||
	|| `functions` || No || `[empty string]` || Related Wheels core functions. For example, `validatesPresenceOf`, `addRoute`, or `timeAgoInWords`. ||
	|| `history` || No || || Bulleted list of how function behavior changes from version to version of Wheels. ||

Note that you should use the `hint` attribute to clear up any ambiguities caused by the function's 
declaration. For example, if a function returns either an object or a string, this may only be indicated 
in the source code as `returntype="any"`. Clearly address this ambiguity in the `hint` attribute.

Here is an example of what the source code would look like for the `addRoute()` function 
declaration. Notice that clear indentation and proper choice of single quotes for the `examples` 
attribute.


	<cffunction name="addRoute" returntype="void" access="public" output="false" hint="Adds a new route to your application."
	    examples=
	    '
	        <cfset addRoute(name="userProfile", pattern="user/[username]", controller="user", action="profile")>
	    '
	    categories="global" chapters="using-routes">

Here is another example for the `new()` function:


	<cffunction name="new" returntype="any" access="public" output="false" hint="Creates a new object based on supplied properties and returns it. The object is not saved to the database, it only exists in memory. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument."
	    examples=
	    '
	        <--- Blank model object --->
	        <cfset newAuthor = model("author").new()>
	        
	        <!--- Built with data from the params.author struct --->
	        <cfset newAuthor = model("author").new(params.author)>
	        
	        <!--- Built with default values for firstName and lastName --->
	        <cfset newAuthor = model("author").new(firstName="John", lastName="Doe")>
	    '
	    categories="model-class" chapters="creating-records" functions="create">

### List of Categories

Here is a current list of categories and subcategories that can be used in the `categories` attribute of 
the `cffunction` tags.

 * `configuration`
 * `global`
   * `miscellaneous`
   * `string`
 * `controller-initialization`
 * `controller-request`
   * `flash`
   * `miscellaneous`
   * `rendering`
 * `model-initialization`
   * `associations`
   * `callbacks`
   * `miscellaneous`
   * `validations`
 * `model-class`
   * `create`
   * `delete`
   * `miscellaneous`
   * `read`
   * `statistics`
   * `transactions` 
   * `update`
 * `model-object`
   * `changes`
   * `crud`
   * `errors`
   * `miscellaneous`
 * `view-helper`
   * `assets`
   * `dates`
   * `errors`
   * `forms-general`
   * `forms-object`
   * `forms-plain`
   * `links`
   * `miscellaneous`
   * `sanitize`
   * `text`
   * `urls`

### Argument Documentation

Use all standard CFML attributes to document what is expected of function arguments. Much like the 
functions' documentation, the argument's `hint` attribute should be used to clear up any ambiguities 
associated with `type="any"` as an expected type.

One extra rule applies to argument documentation though. In some places of the source code, there are 
`hint`s that refer to other functions' versions of that argument. Take a look at the `defaults` argument 
of the `save()` function, for example:

	<cfargument name="defaults" type="boolean" required="false" default="#application.wheels.functions.new.defaults#" hint="@save.">

In this case, the documentation in the website database will be copied from the `hint` attribute of the 
`save()` function's `defaults` argument. Prefix the associated function with the `@` character like in 
the example above.

[1]: http://groups.google.com/group/cfwheels
[2]: http://www.cfwheels.com/docs
[3]: http://livedocs.adobe.com/coldfusion/8/htmldocs/index.html
[4]: http://en.wikipedia.org/wiki/Markdown
[5]: https://github.com/cfwheels/cfwheels
[6]: https://help.github.com/articles/fork-a-repo
[7]: https://help.github.com/articles/creating-a-pull-request
[8]: https://help.github.com/articles/merging-a-pull-request
