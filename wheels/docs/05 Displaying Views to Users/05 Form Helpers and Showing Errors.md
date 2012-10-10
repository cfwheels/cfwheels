# Form Helpers and Showing Errors

*Wheels ties your application's forms together with your model layer elegantly. With Wheels form 
conventions, you'll find yourself spending less time writing repetitive markup to display forms and 
error messages.*

The majority of applications are not all about back-end. There is a great deal of work to perform on the 
front-end as well. It can be argued that most of your users will think of the interface _as_ the 
application.

Wheels is here to take you to greener pastures with its [View Helper Functions][1]. Let's get visual 
with some code examples.

## Simple Example: The Old Way

Here is a simple form for editing a user profile. Normally, you would code your web form similarly to 
this:

    <cfoutput>

    <form action="/profile/save" method="post">

        <div>
            <label for="firstName">First Name</label>
            <input id="firstName" name="firstName" value="#profile.firstName#" />
        </div>

        <div>
            <label for="lastName">Last Name</label>
            <input id="lastName" name="lastName" value="#profile.lastName#" />
        </div>

        <div>
            <label for="department">Department</label>
            <select id="department" name="departmentId">
                <cfloop query="departments">
                    <option
                        value="#departments.id#"
                        <cfif profile.departmentId eq departments.id>
                            selected="selected"
                        </cfif>
                    >#departments.name#</option>
                </cfloop>
            </select>
        </div>
        
        <div>
            <input type="hidden" name="id" value="#department.id#" />
            <input type="submit" value="Save Changes" />
        </div>
    </form>

    </cfoutput>

Then you would write a script for the form that validates the data submitted, handles interactions with 
different data sources, and displays the form with errors that may happen as a result of user input.

We know that you are quite familiar with the drudgery of typing this sort of code over and over again. 
Let's not even mention the pain associated with debugging it or adding new fields and business logic!

## Making Life Easier: Wheels Form Helpers

The good news is that Wheels simplifies this quite a bit for you. At first, it looks a little different 
using these conventions. But you'll quickly see how it all ties together and saves you some serious time.

### Rewriting the Form with Wheels Conventions

Let's rewrite and then explain.

    <cfoutput>

    #startFormTag(action="save")#

        #textField(label="First Name", objectName="profile", property="firstName", prependToLabel="<div>", append="</div>", labelPlacement="before")#
        #textField(label="Last Name", objectName="profile", property="lastName", prependToLabel="<div>", append="</div>", labelPlacement="before")#
        #select(label="Department", objectName="profile", property="departmentId", options=departments, prependToLabel="<div>", append="</div>", labelPlacement="before")#
        <div>
            #hiddenField(objectName="department", property="id")#
            #submitTag()#
        </div>

    #endFormTag()#

    </cfoutput>

I know what you are thinking. 9 lines of code can't replace all that work, right? In fact, they do. The 
HTML output will be exactly the same as the previous example. By using Wheels conventions, you are 
saving yourself a lot of key strokes and a great deal of time.

### Factoring out Common Settings with Global Defaults

By setting up global defaults (as explained in the [Configuration and Defaults][2] chapter) for the 
`prependToLabel`, `append`, and `labelPlacement` arguments, you can make the form code ever simpler 
across your whole application.

Here are the settings that you would apply in `config/settings.cfm`:

    <cfset set(functionName="textField", prependToLabel="<div>", append="</div>", labelPlacement="before")>
    <cfset set(functionName="select", prependToLabel="<div>", append="</div>", labelPlacement="before")>

And here's how our example code can be simplified as a result:

    <cfoutput>

    #startFormTag(action="save")#

        #textField(label="First Name", objectName="profile", property="firstName")#
        #textField(label="Last Name", objectName="profile", property="lastName")#
        #select(label="Department", objectName="department", property="departmentId", options=departments)#
        <div>
            #hiddenField(objectName="profile", property="departmentId", options=departments)#
            #submitTag()#
        </div>

    #endFormTag()#

    </cfoutput>

All that the controller needs to provide at this point is a model object instance named `profile` that 
contains `firstName`, `lastName`, and `departmentId` properties and a query object named `departments` 
that contains identifier and text values. Note that the instance variable is named `profile`, though the 
model itself doesn't necessarily need to be named `profile`.

If you pass the form an empty instance named `profile` (for example, created by `new()`, the form will 
display blank values for all the fields. If you pass it an object created by a finder like `findOne()` 
or `findByKey()`, then the form will display the values provided through the object. This allows for us 
to potentially use the same view file for both create and update scenarios in our application.

## Form Feedback

If you really want to secure a form, you need to do it server side. Sure, you can add JavaScript here 
and there to validate your web form. Unfortunately, disabling JavaScript (and thus your 
JavaScript-powered form validation) is simple in web browsers, and (God forbid) malicious bots tend not 
to listen to JavaScript.

Securing the integrity of your web forms in Wheels on the server side is very easy. Assuming that you 
have read the chapter on [Object Validation][3], you can rest assured that your code is a lot more 
secure now.

### Displaying a List of Model Validation Errors

Wheels provides you with a tool set of [Helper Functions][1] just for displaying error messages as well.

In the controller, let's say that this just happened. Your model includes validations that require the 
presence of both `firstName` and `lastName`. The user didn't enter either. So in the controller's `save` 
action, it loads the model object, sets the values that the user submitted, sees that there was a 
validation error after calling `save()`, and displays the form view again.

The `save` action may look something like this:

    <cffunction name="save">
        <!--- In this example, we're loading a new object with the form data --->
        <cfset profile = model("userProfile").new(params.profile)>
        <cfset profile.save()>
        
        <!--- If there were errors with the form submission, show the form again with errors --->
        <cfif profile.hasErrors()>
            <cfset renderView(template="profileForm")>
        <!--- If everything validated, then send user to success message --->
        <cfelse>
            <cfset flashInsert(success="The user profile for #profile.firstName# #profile.lastName# was created successfully.")>
            <cfset redirectTo(controller=params.controller)>
        </cfif>
    </cffunction>

Notice that the `profileForm` template is called if the `profile` object's `hasErrors()` 
method returns `true`.

Let's take the previous form example and add some visual indication to the user about what he did wrong 
and where, by simply adding the following code on your form page.

    <cfoutput>

    #errorMessagesFor("profile")#

    #startFormTag(action="save")#

        #textField(label="First Name", objectName="profile", property="firstName")#
        #textField(label="Last Name", objectName="profile", property="lastName")#
        #select(label="Department", objectName="department", property="departmentId", options=departments)#
        <div>
            #hiddenField(objectName="department", property="id")#
            #submitTag()#
        </div>

    #endFormTag()#

    </cfoutput>

How about that? With just that line of code (and the required validations on your object model), Wheels 
will do the following: 

  * Generate an HTML unordered list with a HTML class name of `errorMessages`. 
  * Display all the error messages on your `profile` object as list items in that unordered list.
  * Wrap each of the erroneous fields in your form with a surrounding `<div class="fieldWithErrors">` 
  HTML tag for you to enrich with your ninja CSS skills.

There is no longer the need to manually code error logic in your form markup.

### Showing Individual Fields' Error Messages

Let's say that would rather display the error messages just below the failed fields (or anywhere else, 
for that matter). Wheels has that covered too. All that it takes is a simple line of code for each form 
field that could end up displaying feedback to the user. 

Let's get practical and create some error messages for the `firstName` and `lastName` fields:

    <cfoutput>

    #startFormTag(action="save")#

        #textField(label="First Name", objectName="profile", property="firstName")#
        #errorMessageOn(objectName="profile", property="firstName")#

        #textField(label="Last Name", objectName="profile", property="lastName")#
        #errorMessageOn(objectName="profile", property="lastName")#

        #selectTag(label="Department", objectName="department", property="departmentId, options=departments)#
        #errorMessageOn(objectName="profile", property="departmentId")#

        <div>
            #hiddenField(objectName="profile", property="departmentId", options=departments)#
            #submitTag()#
        </div>

    #endFormTag()#

    </cfoutput>

Notice the call to the `errorMessageOn()` function below the `firstName` and `lastName` fields. That's 
all it takes to display the corresponding error messages of each form control on your form.

And the error message(s) won't even display if there isn't one. That way you can yet again use the same 
form code for error and non-error scenarios alike.

## Types of Form Helpers

There is a Wheels form helper for basically every type of form element available in HTML. And they all 
have the ability to be bound to Wheels model instances to make displaying values and errors easier. Here 
is a brief description of each helper.

### Text, Password, and Text Area Fields

Text and password fields work similarly to each other. They allow you to show labels and bind to model 
object instances to determine whether or not a value should be pre-populated.

    #textField(label="Username", objectName="user", property="username")#
    #passwordField(label="Password", objectName="user", property="password")#
    #textArea(label="Bio", objectName="user", property="biography", rows="5", cols="40")#

May yield the equivalent to this HTML (if we assume the global defaults defined above in the section 
named _Factoring out Common Settings with Global Defaults_):

    <div>
        <label for="user-username">Username</label>
        <input id="user-username" type="text" name="user[username]" value="cfguy" />
    </div>
    <div>
        <label for="user-password">Password</label>
        <input id="user-password" type="password" name="user[password]" value="" />
    </div>
    <div>
        <label for="user-biography">Bio</label>
        <textarea id="user-biography" name="user[biography]" rows="5" cols="40">CF Guy really is a great 
        guy. He's much nicer than .NET guy.</textarea>
    </div>

(Note that we added `rows` and `cols` arguments so that we could meet XHTML compliance. They are 
optional arguments that only get passed through to the HTML tag if you provide them.)

### Hidden Fields

Hidden fields are powered by the `hiddenField()` form helper, and it also works similarly to 
`textField()` and `passwordField()`.

    #hiddenField(objectName="user", property="id")#

Would yield this type of markup:

    <input type="hidden" name="user[id]" value="425" />

The big difference is that hidden fields do not have labels.

### Select Fields

As hinted in our first example of form helpers, the `select()` function builds a `<select>` list with 
options. What's really cool about this helper is that it can populate the `<option>`s with values from a 
query, struct, or array.

Take a look at this line:

    #select(label="Department", objectName="user", property="departmentId", options=departments)#

Assume that the `departments` variable passed to the `options` argument contains a query, struct, or 
array of department data that should be selectable in the drop-down.

Each data type has its advantages and disadvantages:

  * *Queries* allow you to order your results, but you can only use one column. But this can be overcome 
  using [Calculated Properties][4].
  * *Structs* allow you to build out static or dynamic values using whatever data that you please, but 
  there is no guarantee that your CFML engine will honor the order in which you add the elements.
  * *Arrays* also allow you to build out static or dynamic values, and there is a guarantee that your 
  CFML engine will honor the order. But arrays are a tad more verbose to work with.

Wheels will examine the data passed to `options` and intelligently pick out elements to populate for the 
`<option>`s' values and text.

  * *Query:* Wheels will try to pick out the first numeric column for `value` and the first non-numeric 
  column for the display text. The order of the columns is determined how you have them defined in your 
  database.
  * *Struct:* Wheels will use the keys as the `value` and the values as the display text.
  * *Array:* Wheels will react depending on how many dimensions there are. If it's only a single 
  dimension, it will populate both the `value` and display text with the elements. When it's a 2D array, 
  Wheels will use each item's first element as the `value` and each element's second element as the 
  display text. For anything larger than 2 dimensions, Wheels only uses the first 2 sub-elements and 
  ignores the rest.

Here's an example of how you might use each option:

    <!--- Query generated in your controller --->
    <cfset departments = findAll(orderBy="name")>

    <!--- Hard-coded struct set up in events/onapplicationstart.cfm --->
    <cfset application.departments["1"] = "Sales">
    <cfset application.departments["2"] = "Marketing">
    <cfset application.departments["3"] = "Information Technology">
    <cfset application.departments["4"] = "Human Resources">

    <!--- Array built from query call in model --->
    <cfset departments = this.findAll(orderBy="lastName,hq")>
    <cfset departmentsArray = []>
    <cfloop query="departments">
        <cfset newDept = [department.id, departments.name & " - " & departments.hq]>
        <cfset ArrayAppend(departmentsArray, newDept)>
    </cfloop>
    <cfreturn departments>

When sending a query, if you need to populate your `<option>`s' values and display text with specific 
columns, you should pass the names of the columns to use as the `textField` and `valueField` arguments.

You can also include a blank option by passing `true` or the desired display text to the `includeBlank` 
argument.

Here's a full usage with this new knowledge:

    #select(label="Department", objectName="user", property="departmentId", options=departments, valueField="id", textField="departmentName", includeBlank="Select a Department")#

### Radio Buttons

Radio buttons via `radioButton()` also take `objectName` and `property` values, and they accept an 
argument called `tagValue` that determines whether or not the button should be checked on load as well 
as what value should be passed based on what the user selects.

Here is an example using a query object called `eyeColor` to power the possible values:

    <fieldset>
        <legend>Eye Color</legend>
        <cfloop query="eyeColor">
            #radioButton(label=eyeColor.color, objectName="profile", property="eyeColorId", tagValue=eyeColor.id, labelPlacement="after")#<br />
        </cfloop>
    </fieldset>

If the `profile` object already has a value set for `eyeColorId`, then `radioButton()` will make sure 
that that value is checked on page load.

If `profile.eyeColorId`'s value were already set to `1`, the rendered HTML for our example would appear 
similar to this:

    <fieldset>
        <legend>Eye Color</legend>
        <input type="radio" id="profile-eyeColorId-2" name="profile[eyeColorId]" value="2" /><label for="profile-eyeColorId-2">Blue</label><br />
        <input type="radio" id="profile-eyeColorId-1" name="profile[eyeColorId]" value="1" /><label for="profile-eyeColorId-1" checked="checked">Brown</label><br />
        <input type="radio" id="profile-eyeColorId-3" name="profile[eyeColorId]" value="3" /><label for="profile-eyeColorId-3">Hazel</label><br />
    </fieldset>

Note that if you don't specify `labelPlacement="after"` in your calls to `radioButton()`, Wheels will 
place the labels before the form controls.

### Check Boxes

Check boxes work similarly to radio buttons, except `checkBox()` takes parameters called `checkedValue` 
and `uncheckedValue` to determine whether or not the check box should be checked on load.

Note that binding check boxes to model objects is best suited for properties in your object that have a 
yes/no or true/false type value.

    #checkBox(label="Sign me up for the email newsletter.", objectName="customer", property="newsletterSubscription", labelPlacement="after")#

Because the concept of check boxes don't tie to well to models (you can select several for the same 
"property"), we recommend using `checkBoxTag()` instead if you want to use check boxes for more values 
than just true/false. See the _Helpers That Aren't Bound to Model Objects_ section below.

### File Fields

The `fieldField()` helper builds a file field form control based on the supplied `objectName` and 
`property`.

    #fileField(label="Photo", objectName="profile", property="photo")#

In order for your form to pass the correct `enctype`, you can pass `multipart=true` to `startFormTag()`:

    #startFormTag(action="save", multipart=true")#

## Helpers That Aren't Bound to Model Objects

Sometimes you'll want to output a form element that isn't bound to a model object.

A search form that passes the user's query as a variable in the URL called `q` is a good example. In 
this example case, you would use the `textFieldTag()` function to produce the `<input>` tag needed.

    #textFieldTag(label="Search", name="q", value=params.q)#

There are "tag" versions of all of the form helpers that we've listed in this chapter. As a rule of 
thumb, add `Tag` to the end of the function name and use the `name` and `value`, `checked`, and 
`selected` arguments instead of the `objectName` and `property` arguments that you normally use.

## Passing Extra Arguments for HTML Attributes

Much like Wheels's `linkTo()` function, any extra arguments that you pass to form helpers will be passed 
to the corresponding HTML tag as attributes.

For example, if we wanted to define a `class` on our starting form tag, we just pass that as an extra 
argument to `startFormTag()`:

    #startFormTag(action="save", class="login-form")#

Which would produce this HTML:

    <form action="/user/save" class="login-form">

## Special Form Helpers

Wheels provides a few extra form helpers that make it easier for you to generate accessible fields for 
dates and/or times. These also bind to properties that are of type `DATE`, `TIMESTAMP`, `DATETIME`, etc.

We won't go over these in detail, but here is a list of the date and time form helpers available:

  * `dateSelect()`
  * `dateSelectTags()`
  * `timeSelect()`
  * `timeSelectTags()`
  * `dateTimeSelect()`
  * `dateTimeSelectTags()`
  * `yearSelectTag()`
  * `monthSelectTag()`
  * `daySelectTag()`
  * `hourSelectTag()`
  * `minuteSelectTag()`
  * `secondSelectTag()`

[1]: 07%20Date,%20Media,%20and%20Text%20Helpers.md
[2]: ../02%20Working%20with%20Wheels/02%20Configuration%20and%20Defaults.md
[3]: ../04%20Database%20Interaction%20Through%20Models/11%20Object%20Validation.md
[4]: ../04%20Database%20Interaction%20Through%20Models/13%20Calculated%20Properties.md