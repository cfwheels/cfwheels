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
