# Testing Your Application

In order to run tests against your application, you must first create a <tt>tests</tt> directory off the 
root of your Wheels application. All tests **MUST** reside in the <tt>tests</tt> directory or within a 
subdirectory thereof.

When you run the tests for your application, Wheels recursively scans your application's <tt>tests</tt> 
directory and looks for any available valid tests to run, so feel free to organize the subdirectories 
and place whatever files needed to run your tests under the <tt>tests</tt> directory any way you like.

### Model Testing

The first part of your application that you are going to want to test against are your models since this 
is where all the business logic of your application lives. Suppose that we have the following model:

	<cfcomponent extends="Model" output="false">
	
		<cffunction name="init">
	
			<!--- validations on the properties of model --->
			<cfset validatesPresenceOf("username,firstname,lastname")>
			<cfset validatesPresenceOf(property="password", when="oncreate")>
			<cfset validatesConfirmationOf(property="password", when="oncreate")>
	
			<!--- we never want to retrieve the password --->
			<cfset afterFind("blankPassword")>
	
			<!--- this callback will secure the password when the model is saved --->
			<cfset beforeSave("securePassword")>
	
		</cffunction>
	
		<cffunction name="securePassword" access="private">
	
			<cfif not len(this.password)>
				<!--- we remove the password if it is blank. the password could be blank --->
				<cfset structdelete(this, "password")>
			<cfelse>
				<!--- else we secure it --->
				<cfset this.password = _securePassword(this.password)>
			</cfif>
	
		</cffunction>	
	
		<cffunction name="_securePassword">
			<cfargument name="password" type="string" required="true">
	
			<cfreturn hash(arguments.password)>	
	
		</cffunction>
	
		<cffunction name="_blankPassword" access="private">
	
			<cfif StructKeyExists(arguments, "password")>
				<cfset arguments.password = "">
			</cfif>
			<cfreturn arguments>
	
		</cffunction>
	
	</cfcomponent>

As you can see from the code above, our model has 4 properties (username, firstname, lastname and 
password). We have some validations against these properties and a callback that runs whenever a new 
model is created. Let's get started writing some tests against this model to make sure that these 
validations and callback work properly.

First, create a test component and in the setup create an instance of the model that we can use in each 
test we write along with some default values for the properties of the model using a structure.

	<cfcomponent extends="wheelsMapping.Test">
	
		<cffunction name="setup">
	
			<!--- create an instance of our model --->
			<cfset loc.user = model("user").new()>
	
			<!--- a struct that we wil use to set values of the property of the model --->
			<cfset loc.properties = {
				username = "myusername"
				,firstname = "Bob"
				,lastname = "Parkins"
				,password = "something"
				,passwordConfirmation = "something"
			}>
		</cffunction>
	
	</cfcomponent>

As you can see we invoke our model by using the _model()_ method just like you would normally do in your 
controllers:

The first thing we want to test is that if we assign are default properties to the model that the model 
will pass validations:

	<cffunction name="test_user_valid">
	
		<!--- set the properties of the model --->
		<cfset loc.user.setProperties(loc.properties)>
	
		<!--- assert that because the properties are set correct and meet validation, the model is valid --->
		<cfset assert("loc.user.valid() eq true")>
	
	</cffunction>

Next, we add a simple test to make sure that the validatons we add to our model work. Notice that we 
haven't assigned values to any of the properties of the model:

	<cffunction name="test_user_not_valid">
	
		<!--- assert the model is invalid when no properties are set --->
		<cfset assert("loc.user.valid() eq false")>
	
	</cffunction>

Now we write a more specific test against the validations. Why don't we want make sure that when a 
password and passwordConfirmation are passed to the model and they are different, the model becomes 
invalid:

	<cffunction name="test_user_not_valid_password_confirmation">
	
		<!--- change the passwordConfirmation property so it doesn't match the password property --->
		<cfset loc.properties.passwordConfirmation = "something1">
	
		<!--- set the properties of the model --->
		<cfset loc.user.setProperties(loc.properties)>
	
		<!--- assert that because the password and passwordConfirmation DO NOT match, the model is invalid --->
		<cfset assert("loc.user.valid() eq false")>
	
	</cffunction>

We now have tests to make sure that the validations in model work. Now it's time to make sure that the 
callback works propertly when a valid model is created:

	<cffunction name="test_password_secure_before_save_testing_a_callback">
	
		<!--- set the properties of the model --->
		<cfset loc.user.setProperties(loc.properties)>
	
		<!--- call the _securePassword directly so we can test the value after the record is saved --->
		<cfset loc.hashed = loc.user._securePassword(loc.properties.password)>
	
		<!--- 
			save the model, but use transactions so we don't actually write to the database.
			this prevents us from having to have to reload a new copy of the database everytime the test run
		--->
		<cfset loc.user.save(transaction="rollback")>
	
		<!--- get the password property of the model --->
		<cfset loc.password = loc.user.password>
	
		<!--- make sure that password was hashed --->
		<cfset assert('loc.password eq loc.hashed')>
	
	</cffunction>

### Controller Testing

The next part of our application that we need to test is our controllers. Below is what a typically 
controller for our user model would contain for creating and dsiplaying a list of users:

	<cfcomponent extends="Controller" output="false">
	
		<!--- users/index --->
		<cffunction name="index">
			<cfset users = model("User").findAll()>
		</cffunction>
	
		<!--- users/new --->
		<cffunction name="new">
			<cfset user = model("User").new()>
		</cffunction>
	
		<!--- users/create --->
		<cffunction name="create">
			<cfset user = model("User").new(params.user)>
	
			<!--- Verify that the user creates successfully --->
			<cfif user.save()>
				<cfset flashInsert(success="The user was created successfully.")>
				<!--- notice something about the next line? --->
				<cfreturn redirectTo(action="index", delay="true")>
			<!--- Otherwise --->
			<cfelse>
				<cfset flashInsert(error="There was an error creating the user.")>
				<cfset renderView(action="new")>
			</cfif>
		</cffunction>
	
	</cfcomponent>

**Woa woa woa**, what in the world is that <tt>cfreturn</tt> doing in the <tt>create</tt> action and why 
does the <tt>redirectTo()</tt> method have a <tt>delay</tt> argument? First, I would like to say that 
I'm very proud of you for noticing that line :) Secondly the reason for this is quite simple, underneath 
the hood when you call <tt>redirectTo()</tt>, Wheels is using <tt>cflocation</tt>. As we all know, there 
is no way to intercept or stop a cflocation from happening. This can cause quite a number of problems 
when testing out a controller as you will never be able to get back any information about the 
redirection. To work around this, Wheels allow you to "delay" the execution of a redirect until after 
the controller has finished processing. This allow Wheels to gather and present some information to you 
about what redirection will occur. The drawback to this though is that the controller will continue 
processing and as such we need to explicitly exit out of the controller action on our own, thus the 
reason why we use <tt>cfreturn</tt>.

Now we can look at the test we will write to make sure the create action works as expected: 

	<cfcomponent extends="wheelsMapping.Test">
	
		<cffunction name="test_redirects_to_index_after_a_user_is_created">
	
			<!--- default params that are required by the controller --->
			<cfset loc.params = {controller="users", action="create"}>
	
			<!--- set the user params for creating a user --->
			<cfset loc.params.user = {
				username = "myusername"
				,firstname = "Bob"
				,lastname = "Parkins"
				,password = "something"
				,passwordConfirmation = "something"
			}>
	
			<!--- create an instance of the controller --->
			<cfset loc.controller = controller(name="users", params=loc.params)>
	
			<!--- process the create action of the controller --->
			<cfset loc.controller.$processAction()>
	
			<!--- get the information about the redirect that should have happened --->
			<cfset loc.redirect = loc.controller.$getRedirect()>
	
			<!--- make sure that the redirect happened --->
			<cfset assert('StructKeyExists(loc.redirect, "$args")')>
			<cfset assert('loc.redirect.$args.action eq "index"')>
	
		</cffunction>
	
	</cfcomponent>

Obviously a lot more goes into testing a controller then a model. The first step is setting up the 
params that will need to be passed to the controller. Next we have to create an instance of the 
controller. Finally we tell the controller to process the action that we want to test.

After the controller is finished processing the action, we can get the information about the redirection 
that happened by using the $getRedirect() method. We use this information to make sure that the 
controller redirected the visitor to the <tt>index</tt> action once the action was completed.

### View Testing

The last part of your application that we will look at testing is the <tt>view</tt> layer. Below is the 
view for the code (new.cfm) that are controller's new action would call:

	<cfoutput>
	<h1>Create a New user</h1>
	
	#flashMessages()#
	
	#errorMessagesFor("user")#
	
	#startFormTag(action="create")#
	
		#textField(objectName='user', property='username', label='Username')#
	
		#passwordField(objectName='user', property='password', label='Password')#
		#passwordField(objectName='user', property='passwordConfirmation', label='Confirm Password')#
	
		#textField(objectName='user', property='firstname', label='Firstname')#
	
		#textField(objectName='user', property='lastname', label='Lastname')#
	
		#submitTag()#
	
	#endFormTag()#
	
	#linkTo(text="Return to the listing", action="index")#
	</cfoutput>


Testing the view layer is very simiailar to testing controllers, you will create an instance of the 
controller, passing in the params required for the controller's action to run. The main difference is we 
will be calling the <tt>response()</tt> action of the controller which will return to us the output that 
the view generated. Once we have this output, we can then search through it to make sure that whenever 
we wanted the view to display is presented to our visitor. In the test below, we want to make sure that 
if the visitor recieves an error when creating a new user, a flash message is displaying telling them 
that errors have occurred.

	<cfcomponent extends="wheelsMapping.Test">
	
		<cffunction name="test_errors_display_when_new_user_is_invalid">
	
			<!--- setup some default params for the tests --->
			<cfset loc.params = {controller="users", action="create"}>
	
			<!--- create an empty user param to pass to the controller action --->
			<cfset loc.params.user = StructNew()>
	
			<!--- create an instance of the controller --->
			<cfset loc.controller = controller("users", loc.params)>
	
			<!--- process the create action of the controller --->
			<cfset loc.controller.$processAction()>
	
			<!--- get copy of the code the view generated --->
			<cfset loc.response = loc.controller.response()>
	
			<!--- make sure the flashmessage was displayed  --->
			<cfset loc.message = '<div class="flashMessages">'>
			<cfset assert('loc.response contains loc.message')>
	
		</cffunction>
	
	</cfcomponent>