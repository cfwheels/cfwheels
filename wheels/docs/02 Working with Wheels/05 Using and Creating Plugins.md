# Using and Creating Plugins

*Extend Wheels functionality by using plugins or creating your own.*

Wheels is a fairly lightweight framework, and we like to keep it that way. We won't be adding thousands
of various features to Wheels just because a couple of developers find them "cool." ;)

Our intention is to only have functionality we consider "core" inside of Wheels itself and then
encourage the use of _plugins_ for everything else.

By using plugins created by the community or yourself, you're able to add brand new functionality to
Wheels or completely change existing features. The possibilities are endless.

Plugins are also the recommended way to get new code accepted into Wheels. If you have written code that
you think constitutes core functionality and should be added to Wheels, then write a plugin. After the
community has used it for a while, it will be a simple task for us to integrate it into Wheels itself.

## Installing and Uninstalling Plugins

This couldn't be any simpler. To install a plugin, just download the plugin's `zip` file and drop it in
the `plugins` folder.

If you want to remove it later simply delete the `zip` file. (Wheels will clean up any leftover folders
and files.)

Reloading Wheels is required when installing/uninstalling. (Issue a `reload=true` request. See the
[Switching Environments][1] chapter for more details.)

### File Permissions on `plugins` Folder

You may need to change access permissions on your application's `plugins` folder so that Wheels can
writethe subfolders and files that it needs to run. If you get an error when testing out a plugin, you
may need to loosen up the permission level.

## Plugin Naming, Versioning, and Dependencies

When you download plugins, you will see that they are named something like this: `Scaffold-0.1.zip`. In
this case, `0.1` is the version number of the `Scaffold` plugin. If you drop both `Scaffold-0.1.zip` and
`Scaffold-0.2.zip` in the `plugins` folder, Wheels will use the one with the highest version number and
ignore any others.

If you try to install a plugin that is not compatible with your installed version of Wheels or not
compatible with a previously installed plugin (i.e., they try to add/override the same functions),
Wheels will throw an error on application start.

If you install a plugin that depends on another plugin you will get a warning message displayed in the
debug area. This message will name the plugin that you'll need to download and install to make the
originally installed plugin work correctly.

## Available Plugins

To view all official plugins that are available for Wheels you can go to the [Plugins Directory][2] on
our website.

While there, you can also download the [PluginManager][2]. It lets you browse and install plugins
directly from inside your Wheels application. It's quite handy!

## Creating Your Own Plugins

To create a plugin named `MyPlugin`, you will need to create a `MyPlugin.cfc` and an `index.cfm` file.
Then zip these together as `MyPlugin-x.x.zip`, where `x.x` is the version number of your plugin.

The only other requirement to make a plugin work is that `MyPlugin.cfc` must contain a method named
`init`. This method must set a variable called `this.version`, specifying the Wheels version (or several
Wheels version numbers in a list) the plugin is meant to be used on, and then return itself.

Here's an example:

	<cfcomponent output="false">
	
		<cffunction name="init">
			<cfset this.version = "1.0,1.1">
			<cfreturn this>
		</cffunction>
	
	</cfcomponent>

The `index.cfm` file is the user interface for your plugin and will be viewable when clicking through to
it from the debug area of your application.

## Using a Plugin to Add or Alter Capabilities

A plugin can add brand new functions to Wheels or override existing ones. A plugin can also have a
simple one-page user interface so that the users of the plugin can provide input, display content, etc.

To add or override a function, you simply add the function to `MyPlugin.cfc`, and Wheels will inject it
into Wheels on application start.

Please note that all functions in your plugin need to be public (`access="public"`). If you have
functions that should only be called from the plugin itself, we recommend starting the function name
with the `$` character (this is how many internal Wheels functions are named as well) to avoid any
naming collisions.

It is also important to note that although you can overwrite functions, they are still available for you
to leverage with the use of `core.functionName()`.

### Example: Overriding `timeAgoInWords()`

Let's say that we wanted Wheels's built-in function `timeAgoInWords()` to return the time followed by
the string " (approximately)":

	<cffunction name="timeAgoInWords" returntype="string" access="public" output="false">
		<cfreturn core.timeAgoInWords(argumentCollection=arguments) & " (approximately)">
	</cffunction>

## Plugin Attributes

There are 3 attributes you can set on your plugin to customize its behavior. The first and most
important one is the `mixin` attribute.

By default, the functions in your plugins will be injected into all Wheels objects (`controller`,
`model`, etc.). This is usually not necessary, and to avoid this overhead, you can use the `mixin`
attribute to specify exactly where the functions should be injected. If you have a function that should
be available in a controller (or view), this is how it could look:

	<cfcomponent output="false" mixin="controller">

The `mixin` attribute can be set either on the `cfcomponent` tag or on the individual `cffunction` tags.

The following values can be used for the `mixin` attribute:

  * `application`
  * `global`
  * `none`
  * `controller`
  * `model`
  * `dispatch`
  * `microsoftsqlserver`
  * `mysql`
  * `oracle`
  * `postgresql`
  * `h2`

Another useful attribute is the `environment` attribute. Using this, you can tell Wheels that a plugin
should only inject its functions in certain environment modes. Here's an example of that, taken from the
`Scaffold` plugin, which doesn't need to inject any functions to Wheels at all.

	<cfcomponent output="false" mixin="controller" environment="design,development">

Finally, there is a way to specify that your plugin needs another plugin installed in order to work.
Here's an example of that:

	<cfcomponent output="false" dependency="someOtherPlugin">

## Making Plugin Development More Convenient with Wheels Settings

When your Wheels application first initializes, it will unzip and cache the zip files in the `plugins`
folder. Each plugin then has its own expanded subfolder. If a subfolder exists but has no corresponding
zip file, Wheels will delete the folder and its contents.

This is convenient when you're deploying plugins but can be annoying when you're developing your own
plugins. By default, every time you make a change to your plugin, you need to rezip your plugin files
and reload the Wheels application by adding `?reload=true` to the URL.

### Disabling Plugin Overwriting

To force Wheels to skip the unzipping process, set the `overwritePlugins` setting to `false` for your
`design` and/or `development` environments.

	<!--- In `config/design/settings.cfm` --->
	<cfset set(overwritePlugins=false)>

With this setting, you'll be able to reload your application without worrying about your file being
overwritten by the contents of the corresponding zip file.

### Disabling Plugin Folder Deletion

To force Wheels to skip the folder deletion process, set the `deletePluginDirectories` setting to
`false` for your `design` and/or `development` environments.

	<!--- In `config/design/settings.cfm` --->
	<cfset set(deletePluginDirectories=false)>

With this setting, you can now develop new plugins in your application without worrying about having a
corresponding zip file in place.

See the chapter on [Configurations and Defaults][4] for more details about changing Wheels settings.

## Stand-Alone Plugins

If your plugin is completely stand-alone, you can call it from its view page using just the name of the
plugin. This works because Wheels has created a pointer to the plugin object residing in the
`application` scope. One example of a stand-alone plugin is the PluginManager. If you check out its view
code, you will see that it calls itself like this:

	<cfset pluginManager.installPlugin(URL.plugin)>

## Now Go Build Some Plugins

Armed with this knowledge about plugins, you can now go and add that feature you've always wanted or
change that behavior you've always hated. We've stripped you of any right to blame us for your
discontents. :)

[1]: ../02%20Working%20with%20Wheels/04%20Switching%20Environments.md
[2]: http://cfwheels.org/plugins
[3]: http://cfwheels.org/plugins/listing/8
[4]: ../02%20Working%20with%20Wheels/02%20Configuration%20and%20Defaults.md