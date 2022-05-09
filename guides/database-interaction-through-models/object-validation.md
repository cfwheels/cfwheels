---
description: >-
  Wheels utilizes validation setup within the model to enforce appropriate data
  constraints and persistence. Validation may be performed for saves, creates,
  and updates.
---

# Object Validation

### Basic Setup

In order to establish the full cycle of validation, 3 elements need to be in place:

* **Model** file containing business logic for the database table. Example: `models/User.cfc`
* **Controller** file for creating, saving or updating a model instance. Example: `controllers/Users.cfc`
* **View** file for displaying the original data inputs and an error list. Example: `views/users/index.cfm`

**Note**: Saving, creating, and updating model objects can also be done from the model file itself (or even in the view file if you want to veer completely off into the wild). But to keep things simple, all examples in this chapter will revolve around code in the controller files.

### The Model

Validations are always defined in the `config()` method of your model. This keeps everything nice and tidy because another developer can check `config()` to get a quick idea on how your model behaves.

Let's dive right into a somewhat comprehensive example:

```javascript
component extends="Model" output="false" {

 function config() {
        validatesPresenceOf(
            properties="firstName,lastName,email,age,password"
        );
        validatesLengthOf(properties="firstName,lastName", maximum=50);
        validatesUniquenessOf(property="email");
        validatesNumericalityOf(property="age", onlyInteger=true);
        validatesConfirmationOf(property="password");
    }

}
```

This is fairly readable on its own, but this example defines the following rules that will be run before a create, update, or save is called:

* The `firstName`, `lastName`, `email`, `age`, and `password` fields must be provided, and they can't be blank.
* At maximum, `firstName` and `lastName` can each be up to 50 characters long.
* The value provided for `email` cannot already be used in the database.
* The value for `age` can only be an integer.
* `password` must be provided twice, the second time via a field called `passwordConfirmation`.

If any of these validations fail, Wheels will not commit the create or update to the database. As you'll see later in this chapter, the controller should check for this and react accordingly by showing error messages generated by the model.

### Listing of Validation Functions

* [validatesConfirmationOf()](https://api.cfwheels.org/model.validatesconfirmationof.html)
* [validatesExclusionOf()](https://api.cfwheels.org/model.validatesexclusionof.html)
* [validatesFormatOf()](https://api.cfwheels.org/model.validatesformatof.html)
* [validatesInclusionOf()](https://api.cfwheels.org/model.validatesinclusionof.html)
* [validatesLengthOf()](https://api.cfwheels.org/model.validateslengthof.html)
* [validatesNumericalityOf()](https://api.cfwheels.org/model.validatesnumericalityof.html)
* [validatesPresenceOf()](https://api.cfwheels.org/model.validatespresenceof.html)
* [validatesUniquenessOf()](https://api.cfwheels.org/model.validatesuniquenessof.html)
* [validate()](https://api.cfwheels.org/model.validate.html)
* [validateOnCreate()](https://api.cfwheels.org/model.validateoncreate.html)
* [validateOnUpdate()](https://api.cfwheels.org/model.validateonupdate.html)

### Automatic Validations

Now that you have a good understanding of how validations work in the model, here is a piece of good news. By default, Wheels will perform many of these validations for you based on how you have your fields set up in the database.

By default, these validations will run without your needing to set up anything in the model:

* Fields set to `NOT NULL` will automatically trigger [validatesPresenceOf()](https://api.cfwheels.org/model.validatespresenceof.html).
* Numeric fields will automatically trigger [validatesNumericalityOf()](https://api.cfwheels.org/model.validatesnumericalityof.html).
* Date or time fields will be checked for the appropriate format.
* Fields that have a maximum length will automatically trigger [validatesLengthOf()](https://api.cfwheels.org/model.validateslengthof.html).

Note these extra behaviors as well:

* Automatic validations will not run for [Automatic Time Stamps](https://guides.cfwheels.org/docs/automatic-time-stamps).
* If you've already set a validation on a particular property in your model, the automatic validations will be overridden by your settings.
* If your database column provides a default value for a given field, Wheels will not enforce a [validatesPresenceOf()](https://api.cfwheels.org/model.validatespresenceof.html)rule on that property.

To disable automatic validations in your Wheels application, change this setting in `config/settings.cfm:`

```javascript
set(automaticValidations=false);
```

You can also turn on or off the automatic validations on a per model basis by calling the [automaticValidations()](https://api.cfwheels.org/model.automaticvalidation.html) method from a model's `config()` method.

See the chapter on [Configuration and Defaults](https://guides.cfwheels.org/docs/configuration-and-defaults) for more information on available Wheels ORM settings.

### Use when, condition, or unless to Limit the Scope of Validation

If you want to limit the scope of the validation, you have 3 arguments at your disposal: `when`, `condition`, and `unless`.

### when Argument

The `when` argument accepts 3 possible values.

* `onSave` (the default)
* `onCreate`
* `onUpdate`

To limit our email validation to run only on create, we would change that line to this:

```javascript
validatesUniquenessOf(property="email", when="onCreate");
```

### condition and unless Arguments

`condition` and `unless` provide even more flexibility when the `when` argument isn't specific enough for your validation's needs.

Each argument accepts a string containing an expression to evaluate. `condition` specifies when the validation should be run. `unless` specifies when the validation should not be run.

As an example, let's say that the model should only verify a CAPTCHA if the user is logged out, but not when they enter their name as "Ben Forta":

```javascript
validate(
    method="validateCaptcha",
    condition="not isLoggedIn()",
    unless="this.name is 'Ben Forta'"
);
```

### Custom Validations

At the end of the listing above are 3 custom validation functions: [validate()](https://api.cfwheels.org/model.validate.html), [validateOnCreate()](https://api.cfwheels.org/model.validateoncreate.html), and [validateOnUpdate()](https://api.cfwheels.org/model.validateonupdate.html). These functions allow you to create your own validation rules that aren't covered by Wheels's out-of-the-box functions.

There is only one difference between how the different functions work:

* [validate()](https://api.cfwheels.org/model.validate.html) runs on the save event, which happens on both create and update.
* [validateOnCreate()](https://api.cfwheels.org/model.validateoncreate.html) runs on create.
* [validateOnUpdate()](https://api.cfwheels.org/model.validateonupdate.html) runs on update.

To use a custom validation, we pass one of these functions a method or set of methods to run:

```javascript
validate(method="validateEmailFormat");
```

We then should create a method called `validateEmailFormat`, which in this case would verify that the value set for `this.email` is in the proper format. If not, then the method sets an error message for that field using the [addError()](https://api.cfwheels.org/model.adderror.html)function.

```javascript
private function validateEmailFormat() {
    if ( !IsValid("email", this.email) ) {
        addError(property="email", message="Email address != in a valid format.");
    }
}
```

Note that `IsValid()` is a function build into your CFML engine.

This is a simple rule, but you can surmise that this functionality can be used to do more complex validations as well. It's a great way to isolate complex validation rules into separate methods of your model.

### Adding Errors to the Model Object as a Whole

We've mainly focused on adding error messages at a property level, which admittedly is what you'll be doing 80% of the time. But we can also add messages at the model object level with the [addErrorToBase()](https://api.cfwheels.org/model.adderrortobase.html) function.

As an example, here's a custom validation method that doesn't allow the user to sign up for an account between the hours of 3:00 and 4:00 am in the server's time zone:

```javascript
private function disallowMaintenanceWindowRegistrations() {
    local.hourNow = DatePart("h", Now());
    if ( local.hourNow >= 3 && local.hourNow < 4 ) {
        local.timeZone = CreateObject("java", "java.util.TimeZone").getDefault();
        addErrorToBase(
                message="We're sorry, but we don't allow new registrations between
                the hours of 3:00 && 4:00 am #local.timeZone#."
            );
    }
}
```

Sure, we could add logic to the view to also not show the registration form, but this validation in the model would make sure that data couldn't be posted via a script between those hours as well. Better safe than sorry if you're running a public-facing application!

### The Controller

The controller continues with the simplicity of validation setup, and at the most basic level requires only 5 lines of code to persist the form data or return to the original form page to display the list of errors.

```javascript
component extends="Controller" {

    public function save() {
        //  User model from form fields via params 
        newUser = model("user").new(params.newUser);
        //  Persist new user 
        if ( newUser.save() ) {
            redirectTo(action="success");
            //  Handle errors 
        } else {
            renderView(action="index");
        }
    }

}
```

The first line of the action creates a `newUser` based on the `user` model and the form inputs (via the `params` struct).

Now, to persist the object to the database, the model's [save()](https://api.cfwheels.org/model.save.html) call can be placed within a `<cfif>` test. If the save succeeds, the [save()](https://api.cfwheels.org/model.save.html) method will return `true`, and the contents of the `<cfif>` will be executed. But if any of the validations set up in the model fail, the [save()](https://api.cfwheels.org/model.save.html) method returns `false`, and the `<cfelse>` will execute.

The important step here is to recognize that the `<cfelse>` renders the original form input page using the [renderView()](https://guides.cfwheels.org/docs/renderview)function. When this happens, the view will use the `newUser` object defined in our [save()](https://api.cfwheels.org/model.save.html) method. If a [redirectTo()](https://api.cfwheels.org/controller.redirectto.html) were used instead, the validation information loaded in our [save()](https://api.cfwheels.org/model.save.html) method would be lost.

### The View

Wheels factors out much of the error display code that you'll ever need. As you can see by this quick example, it appears to mainly be a normal form. But when there are errors in the provided model, Wheels will apply styles to the erroneous fields.

```javascript
<cfoutput>

#errorMessagesFor("newUser")#

#startFormTag(action="save")#
    #textField(label="First Name", objectName="newUser", property="nameFirst")#
    #textField(label="Last Name", objectName="newUser", property="nameLast")#
    #textField(label="Email", objectName="newUser", property="email")#
    #textField(label="Age", objectName="newUser", property="age")#
    #passwordField(label="Password", objectName="newUser", property="password")#
    #passwordField(
        label="Re-type Password to Confirm", objectName="newUser",
        property="passwordConfirmation"
    )#
    #submitTag()#
#endFormTag()#

</cfoutput>
```

The biggest thing to note in this example is that a field called `passwordConfirmation` was provided so that the [validatesConfirmationOf()](https://api.cfwheels.org/model.validate.htmlsconfirmationof) validation in the model can be properly tested.

For more information on how this code behaves when there is an error, refer to the [Form Helpers and Showing Errors](https://guides.cfwheels.org/docs/form-helpers-and-showing-errors)chapter.

### Error Messages

For your reference, here are the default error message formats for the different validation functions:

| Function                  | Format                                  |
| ------------------------- | --------------------------------------- |
| validatesConfirmationOf() | \[property] should match confirmation   |
| validatesExclusionOf()    | \[property] is reserved                 |
| validatesFormatOf()       | \[property] is invalid                  |
| validatesInclusionOf()    | \[property] is not included in the list |
| validatesLengthOf()       | \[property] is the wrong length         |
| validatesNumericalityOf() | \[property] is not a number             |
| validatesPresenceOf()     | \[property] can't be empty              |
| validatesUniquenessOf()   | \[property] has already been taken      |

### Custom Error Messages

Wheels models provide a set of sensible defaults for validation errors. But sometimes you may want to show something different than the default.

There are 2 ways to accomplish this: through global defaults in your config files or on a per-property basis.

### Setting Global Defaults for Error Messages

Using basic global defaults for the validation functions, you can set error messages in your config file at `config/settings.cfm`.

```javascript
set(functionName="validatesPresenceOf", message="Please provide a value for [property]");
```

As you can see, you can inject the property's name by adding `[property]` to the message string. Wheels will automatically separate words based on your camelCasing of the variable names.

### Setting an Error Message for a Specific Model Property

Another way of adding a custom error message is by going into an individual property in the model and adding an argument named `message`.

Here's a change that we may apply in the `config()` method of our model:

```javascript
validatesNumericalityOf(
    property="email",
    message="Email address is already in use in another account"
);
```