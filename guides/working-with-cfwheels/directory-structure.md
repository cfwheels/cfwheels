---
description: Finding your way around a Wheels application.
---

# Directory Structure

After downloading and unzipping Wheels, here's the directory structure that you will see:

{% tabs %}
{% tab title="Directory Structure" %}
config/\
controllers/ \
events/ \
files/ \
global/ \
images/ \
javascripts/ \
migrator/\* \
miscellaneous/ \
models/ \
plugins/ \
stylesheets/ \
tests/ \
views/ \
wheels/ \
Application.cfc \
index.cfm \
rewrite.cfm \
root.cfm
{% endtab %}

{% tab title="Second Tab" %}

{% endtab %}
{% endtabs %}

#### Quick Summary

Your configuration settings will be done in the _**config**_ directory.

Your application code will end up in four of the folders, namely _**controllers**_, _**events**_, _**models**_, and _**views**_.

Static media files should be placed in the _**files**_, _**images**_, _**javascripts**_ and _**stylesheets**_ folders.

Place anything that need to be executed outside of the framework in the _**miscellaneous**_ folder. The framework does not get involved when executing `.cfm` files in this folder. (The empty `Application.cfc` takes care of that.) Also, no URL rewriting will be performed in this folder, so it's a good fit for placing CFCs that need to be accessed remotely via `<cfajaxproxy>` and Flash AMF binding, for example.

Place Wheels plugins in the _**plugins**_ folder.

And the last directory? That's the framework itself. It exists in the _**wheels**_ directory. Please go in there and have a look around. If you find anything you can improve or new features that you want to add, let us know!

### Detailed Overview

Let's go through all of the files and directories now starting with the ones you'll spend most of your time in: the code directories.

#### controllers

This is where you create your controllers. You'll see two files in here already: `Controller.cfc` and `Wheels.cfc`. You can place functions inside `Controller.cfc` to have that function shared between all the controllers you create. (This works because all your controllers will extend `Controller`.) `Wheels.cfc` is an internal file used by Wheels.

#### models

This is where you create your model files (or classes if you prefer that term). Each model file you create should map to one table in the database.

The setup in this directory is similar to the one for controllers, to share methods you can place them in the existing `Model.cfc` file.

#### views

This is where you prepare the views for your users. As you work on your website, you will create one view directory for each controller.

#### events

If you want code executed when ColdFusion triggers an event, you can place it here (rather than directly in `Application.cfc`).

#### config

Make all your configuration changes here. You can set the environment, routes, and other settings here. You can also override settings by making changes in the individual settings files that you see in the subdirectories.

#### files

Any files that you intend to deliver to the user using the `sendFile()` function should be placed here. Even if you don't use that function to deliver files, this folder can still serve as file storage if you like.

#### global

For application-wide globally accessible functions

#### images

This is a good place to put your images. It's not required to have them here, but all Wheels functions that involve images will, by convention, assume they are stored here.

#### javascripts

This is a good place to put your JavaScript files.

#### stylesheets

This is a good place to put your CSS files.

#### tests

This is where unit tests for your application should go

#### miscellaneous

Use this folder for code that you need to run completely outside of the framework. (There is an empty `Application.cfc` file in here, which will prevent Wheels from taking part in the execution.)

This is most useful if you're using Flash to connect directly to a CFC via AMF binding or if you're using `<cfajaxproxy>`in your views to bind directly to a CFC as well.

#### plugins

Place any plugins you have downloaded and want installed here.

#### migrator \*

Database Migration CFC files and generated SQL files\
(This directory will only visible once you start using the migrator)

#### wheels

This is the framework itself. When a new version of Wheels is released it is often enough to just drop it in here (unless there has been changes to the general folder structure).

#### .htaccess

This file is used by Apache, and you specifically need it for URL rewriting to work properly. If you're not using Apache, then you can safely delete it. No longer included by default in 2.x

#### urlrewrite.xml

If you use Tomcat and Tuckey, or Commandbox [URL Rewriting](https://guides.cfwheels.org/docs/url-rewriting), you'll need this file. Otherwise, you can safely delete it. No longer included by default in 2.x

#### web.config

URL rewriting for version 7 of IIS. If you're not using IIS, then you can safely delete it. No longer included by default in 2.x

#### Application.cfc, index.cfm, root.cfm, and rewrite.cfm

These are all needed for the framework to run. No changes should be done to these files.

You can add more directories if you want to, of course. Just remember to include a blank `Application.cfc` in those directories. Otherwise, Wheels will try to get itself involved with those requests as well.

\
\
