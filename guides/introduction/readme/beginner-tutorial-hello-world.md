---
description: >-
  In this tutorial, we'll be writing a simple application to make sure we have
  CFWheels installed properly and that everything is working as it should.
---

# Beginner Tutorial: Hello World

### Testing Your Install

Let's make sure we're all on the same page. I'm going to assume that you've followed the [Getting Started](https://guides.cfwheels.org/docs/commandbox) guide and have CommandBox all setup. If you haven't done that, stop and read that guide get everything setup. It's okay, this web page will wait for you.

Okay, so you have CFWheels installed and can see the CFWheels "Congratulations!"\
page as shown below. That wasn't that hard now, was it?

![Figure 1: Wheels congratulations screen](../../.gitbook/assets/a1f5810-Screen\_Shot\_2022-03-25\_at\_8.59.25\_AM.png)

### Hello World: Your First CFWheels App

Okay, let's get to some example code. We know that you've been dying to get your\
hands on some code!

To continue with Programming Tutorial Tradition, we'll create the ubiquitous _Hello World!_ application. But to keep things interesting, let's add a little CFWheels magic along the way.

### Setting up the Controller

Let's create a controller from scratch to illustrate how easy it is to set up a\
controller and plug it into the CFWheels framework.

First, create a file called `Say.cfc` in the `controllers` directory and add the\
code below to the file.

{% code title="controllers/Say.cfc" %}
```javascript
component extends="Controller"{
}
```
{% endcode %}

Congratulations, you just created your first CFWheels controller! What does this\
controller do, you might ask? Well, to be honest, not much. It has no methods\
defined, so it doesn't add any new functionality to our application. But because\
it extends the base `Controller` component, it inherits quite a bit of powerful\
functionality and is now tied into our CFWheels application.

So what happens if we try to call our new controller right now? Lets take a\
look. Open your browser and point your browser to the new controller. Because my\
local server is installed on port 60000, my URL is `http://127.0.0.1:60000/index.cfm/say`.\
You may need to enter a different URL, depending on how your web server is\
configured. In my case, I'm using [commandbox](https://guides.cfwheels.org/docs/commandbox).

![Figure 2: Wheels error after setting up your blank say controller](../../.gitbook/assets/660aaf3-cfwheels-tutorial\_0005\_2.png)

The error says "Could not find the view page for the 'index' action in the 'say'\
controller." Where did "index" come from? The URL we typed in only specified a\
controller name but no action. When an action is not specified in the URL,\
CFWheels assumes that we want the default action. Out of the box, the default\
action in CFWheels is set to `index`. So in our example, CFWheels tried to find\
the `index` action within the `say` controller, and it threw an error because it\
couldn't find its view page.

### Setting up an Action

But let's jump ahead. Now that we have the controller created, let's add an\
action to it called `hello`. Change your `say` controller so it looks like the\
code block below:

{% code title="controllers/Say.cfc" %}
```javascript
component extends="Controller" {
    function hello() {
    }
}
```
{% endcode %}

As you can see, we created an empty method named `hello`.

Now let's call our new action in the browser and see what we get. To call the\
`hello` action, we simply add `/hello` to the end of the previous URL that we\
used to call our `say` controller:

`http://127.0.0.1:60000/index.cfm/say/hello`

Once again, we get a ColdFusion error. Although we have created the controller\
and added the `hello` action to it, we haven't created the view.

### Setting up the View

By default, when an action is called, CFWheels will look for a view file with\
the same name as the action. It then hands off the processing to the view to\
display the user interface. In our case, CFWheels tried to find a view file for\
our `say/hello` action and couldn't find one.

Let's remedy the situation and create a view file. View files are simple CFML\
pages that handle the output of our application. In most cases, views will\
return HTML code to the brower. By default, the view files will have the same\
name as our controller actions and will be grouped into a directory under the\
view directory. This new directory will have the same name as our controller.

Find the `views` directory in the root of your CFWheels installation. There will\
be a few directories in there already. For now, we need to create a new\
directory in the `views` directory called `say`. This is the same name as the\
controller that we created above.

Now inside the `say` directory, create a file called `hello.cfm`. In the\
`hello.cfm` file, add the following line of code:

{% code title="views/say/hello.cfm" %}
```html
<h1>Hello World!</h>
```
{% endcode %}

Save your `hello.cfm` file, and let's call our `say/hello` action once again.\
You have your first working CFWheels page if your browser looks like _Figure 3_\
below.

![Figure 3: Your first working CFWheels action.](../../.gitbook/assets/5298d15-cfwheels-tutorial\_0004\_3.png)

You have just created your first functional CFWheels page, albeit it is a very\
simple one. Pat yourself on the back, go grab a snack, and when you're ready,\
let's go on and extend the functionality of our _Hello World!_ application a\
little more.

### Adding Dynamic Content to Your View

We will add some simple dynamic content to our `hello` action and add a second\
action to the application. We'll then use some CFWheels code to tie the 2\
actions together. Let's get get to it!

#### The Dynamic Content

The first thing we are going to do is to add some dynamic content to our\
`say/hello` action. Modify your `say` controller so it looks like the code block\
below:

{% code title="controllers/Say.cfc" %}
```javascript
component extends="Controller" {
    function hello() {
        time = Now();
    }
}
```
{% endcode %}

All we are doing here is creating a variable called `time` and setting its value\
to the current server time using the basic ColdFusion `Now()` function. When we\
do this, the variable becomes immediately available to our view code.

Why not just set up this value directly in the view? If you think about it,\
maybe the logic behind the value of time may eventually change. What if\
eventually we want to display its value based on the user's time zone? What if\
later we decide to pull it from a web service instead? Remember, the controller\
is supposed to coordinate all of the data and business logic, not the view.

#### Displaying the Dynamic Content

Next, we will modify our `say/hello.cfm` view file so that it looks like the\
code block bellow. When we do this, the value will be displayed in the browser.

{% code title="views/say/hello.cfm" %}
```html
<h1>Hello World!</h1>
<p>Current time: <cfoutput>#time#</cfoutput></p>
```
{% endcode %}

&#x20;call your `say/hello` action again in your browser. Your browser should look\
like _Figure 4_ below.

![Figure 4: Hello World with the current date and time](../../.gitbook/assets/9f1a966-cfwheels-tutorial\_0003\_4.png)

This simple example showed that any dynamic content created in a controller\
action is available to the corresponding view file. In our application, we\
created a `time` variable in the `say/hello` controller action and display that\
variable in our `say/hello.cfm` view file.

### Adding a Second Action: Goodbye

Now we will expand the functionality of our application once again by adding a\
second action to our `say` controller. If you feel adventurous, go ahead and add\
a `goodbye` action to the `say` controller on your own, then create a\
`goodbye.cfm` view file that displays a "Goodbye" message to the user. If you're\
not feeling that adventurous, we'll quickly go step by step.

First, modify the the `say` controller file so that it looks like the code block\
below.&#x20;

