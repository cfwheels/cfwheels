# Documentation Guidelines

We're very appreciative of the help you provide as a volunteer, so we want to
make it as efficient for everyone as possible. Here are the rules of the road
for contributing documentation to the project.

The [Docs][1] are as important as the code itself. How is anyone going to use
CFWheels if they can't learn how to? And the great docs by
Allaire/Macromedia/Adobe are a big reason why you've always loved ColdFusion,
right?

## Process

All documentation should go through this process. Let's not be a bunch of
cowboys!

1.  First off, [open an issue][2] to let project collaborators know what you're
    planning on doing. We would hate for you to spend hours writing a document
    that someone else is also working on. Plus core team members would be glad
    to help out answering any questions that you may have.
2.  If you're updating the [Reference Guide][6], draft content changes in the
    [`docs` folder][3]. If you're updating the API documentation, draft content
    changes within the CFWheels core (see the _API Documentation_ section
    below). Anyone can edit these files and submit a pull request.
3.  Commit your changes and [reference the issue number][4] in the commit
    message. An example commit message would be, "Fixes #238 - Typo in
    documentation chapter."
4.  Submit a [pull request][5] to have your fix included in core. Consider
    leaving a helpful message along with the pull request if you think it would
    be of value.
5.  After reviewing, a member of the core team will pull the new documentation
    in and generate the changes live on the website (if the changes apply to the
    current version). The core team member may also make stylistic and content
    edits to your changes before posting. Please don't take offense to this;
    they're only trying to help!

## Markdown Style Guide

The following are guidelines for authoring Markdown content for both the
Reference Guide and API documentation. If you submit documentation that doesn't
follow these guidelines, don't be surprised or offended when someone else edits
the content to follow the guidelines.

1.  In a text editor like Sublime Text, set a ruler to 80 characters and keep
    content within that guide. If you don't have this available, don't worry,
    but know that someone else will probably edit your content to fit within
    that ruler.

    An exception to this rule is with code blocks containing lines longer than
    80 characters.

2.  Use spaces for indentation.

3.  Blocks of code should be formatted with a block that identifies it as
    `ColdFusion`:

    <pre>
    ```ColdFusion
    &lt;cfset theTime = Now()&gt;
    &lt;cfoutput&gt;#DateFormat(theTime, &quot;m/d/yyyy&quot;)#&lt;/cfoutput&gt;
    ```
    </pre>

4.  When mentioning code within a paragraph, surround it with backticks
    <code>`</code>.

    Example:

    <pre>
    Use the `simpleFormat` method to insert `&lt;p&gt;` tags in a civilized
    manner.
    </pre>

5.  Use hash-style headers:

    ```Markdown
    # Heading 1

    ## Heading 2

    ### Heading 3

    etc.
    ```

6.  Use email-style blockquotes:

    ```Markdown
    > Less isn’t more; just enough is more.

    - Milton Glaser
    ```

7.  Lists should look like this:

    ```Markdown
    -   Unordered lists use hypen as bullet point character.
    -   Hyphens are followed by 3 spaces.
    -   Extra long content wraps to the next line and is indented to match the
        rest of the item.
    
    1.  Ordered lists use numerals followed by a period.
    2.  Numerals are followed by 2 spaces.
    3.  Extra long content wraps to the next line and is indented to match the
        rest of the item.
    ```

8.  Use reference-style links.

    Example:

    ```Markdown
    We really do love the [CFWheels][1] framework!

    Another paragraph.

    The last paragraph in the content.

    [1]: http://cfwheels.org/
    ```

## Chapters in the Reference Guide

The [Reference Guide][6] contains narrative chapters about using the framework.
It should contain a wealth of code samples and should be written in clear,
concise language.

## API Documentation

Like other forms of CFWheels documentation, the API documentation should be very
clear and concise.

### Generating API Documentation in Core Source Code

All API documentation is generated using attributes in the CFWheels core code's
`<cffunction>` and `<cfargument>` tags. This metadata will be parsed into HTML
files for use on the CFWheels website.

Use [Markdown][9] and HTML formatting where appropriate.

### Function Documentation

Within each public function (those not beginning with a `$` character), use the
following attributes:

<table>
	<thead>
		<tr>
			<th>Attribute</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><code>hint</code></td>
			<td>Yes</td>
			<td></td>
			<td>A concise description of what the function does. Also include any notes like what types of values that are supported and returned.</td>
		</tr>
		<tr>
			<td><code>examples</code></td>
			<td>Yes</td>
			<td></td>
			<td>Example code for common use cases</td>
		</tr>
		<tr>
			<td><code>categories</code></td>
			<td>Yes</td>
			<td></td>
			<td>Comma-delimited list of categories that the function belongs to. See the <em>List of Categories</em> section below for valid valies.</td>
		</tr>
	</tbody>
</table>

Note that you should use the `hint` attribute to clear up any ambiguities caused
by the function's declaration. For example, if a function returns either an
object or a string, this may only be indicated in the source code as
`returntype="any"`. Address this ambiguity in the `hint` attribute clearly.

Here is an example of what the source code would look like for the `addRoute()`
function declaration. Notice that clear indentation and proper choice of single
quotes for the `examples` attribute.

```ColdFusion
<cffunction name="addRoute" returntype="void" access="public" output="false" hint="Adds a new route to your application."
    examples=
    '
      <cfset addRoute(name="userProfile", pattern="users/[username]", controller="user", action="profile")>
    '
    categories="global">
```

Here is another example for the new() function:

```ColdFusion
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
    categories="model-class">
```

#### List of Categories


-  configuration
-  global
   -  miscellaneous
   -  string
-  controller-initialization
-  controller-request
   -  flash
   -  miscellaneous
   -  rendering
-  model-initialization
   -  associations
   -  callbacks
   -  miscellaneous
   -  validations
-  model-class
   -  create
   -  delete
   -  miscellaneous
   -  read
   -  statistics
   -  update
-  model-object
   -  changes
   -  crud
   -  errors
   -  miscellaneous
-  view-helper
   -  assets
   -  dates
   -  errors
   -  forms-general
   -  forms-object
   -  forms-plain
   -  links
   -  miscellaneous
   -  sanitize
   -  text
   -  urls

### Argument Documentation

Use all standard CFML attributes to document what is expected of function
arguments. Much like the function's documentation, the argument's `hint`
attribute should be used to clear up any ambiguities associated with
`type="any"` as an expected type.

One extra rule applies to argument documentation though. In some places of the
source code, there are `hint`s that refer to other functions' versions of that
argument. Take a look at the `defaults` argument of the `save()` function, for
example:

```ColdFusion
<cfargument name="defaults" type="boolean" required="false" default="#application.wheels.functions.new.defaults#" hint="See documentation for @save.">
```

In this case, the HTML generated will be copied from the `hint` attribute of the
`save()` function's `defaults` argument. Prefix the associated function with the
`@` character like in the example above.

### Example API Function Documentation Output

Most descriptions of CFWheels's functions should follow this general format,
inspired by the [ColdFusion Functions][8] reference in the ColdFusion Wiki.

> #### Description
>
> A concise description of what the function does. Also include any notes like
> what types of values that are supported and returned.
>
> #### Returns
>
> Short description of what is returned from the function, if anything.
>
> #### Function Syntax
> `functionName(argument1, argument2, [optionalArgument])`
>
> #### Parameters
> 
> <table>
>   <thead>
>     <tr>
>       <th>Parameter</th>
>       <th>Type</th>
>       <th>Required</th>
>       <th>Default</th>
>       <th>Description</th>
>     </tr>
>   </thead>
>   <tbody>
>     <tr>
>       <td><code>argument1</code></td>
>       <td><code>string</code></td>
>       <td>Yes</td>
>       <td>N/A</td>
>       <td>A description of <code>argument1</code>, including type and possible values if applicable.</td>
>     </tr>
>     <tr>
>       <td><code>argument2</code></td>
>       <td><code>string</code></td>
>       <td>Yes</td>
>       <td>N/A</td>
>       <td>A description of <code>argument2</code>.</td>
>     </tr>
>     <tr>
>       <td><code>optionalArgument</code></td>
>       <td><code>boolean</code></td>
>       <td>No</td>
>       <td><code>false</code></td>
>       <td>A description of <code>optionalArgument</code>, including default behavior if applicable.</td>
>     </tr>
>   </tbody>
> </table>
>
> #### Examples
>
> Example code for common use cases.

## Video Tutorials

Video tutorials should cover an area of CFWheels that hasn't been covered in
previous videos. Please provide the [discussion group][7] with a link to the
video in `mp4` format. The core team will make the final decision on whether or
not the video will be published on the CFWheels site, but you may post the video
anywhere else you please as well (YouTube, Vimeo, your blog, etc.).


[1]: http://cfwheels.org/docs
[2]: https://github.com/cfwheels/cfwheels/issues
[3]: https://github.com/cfwheels/cfwheels/tree/master/docs
[4]: https://github.com/blog/957-introducing-issue-mentions
[5]: https://help.github.com/articles/creating-a-pull-request
[6]: http://guides.cfwheels.org/
[7]: http://groups.google.com/group/cfwheels
[8]: https://wikidocs.adobe.com/wiki/display/coldfusionen/ColdFusion+Functions
[9]: http://daringfireball.net/projects/markdown/
