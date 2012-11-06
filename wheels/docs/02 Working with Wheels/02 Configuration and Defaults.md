# Configuration and Defaults

*An overview of Wheels configuration and how is it used in your applications. Learn how to override a
Wheels convention to make it your own.*

We all love the "Convention over Configuration" motto of Wheels, but what about those two cases that pop
into everyone's head? _What if I want to develop in my own way?_ Or, _What about an existing application
that I need to port into Wheels?_ Gladly, that's what configuration and defaults are there for. Let's
take a look at exactly how is this performed.

## Where Configurations Happen

You will find configuration files in the config folder of your Wheels application. In general, most of
your settings will go in config/settings.cfm.

You can also set values based on what environment you have set. For example, you can have different
values for your settings depending on whether you're in design mode or production mode. See the
chapter on [Switching Environments][1] for more details.

## How to Set Configurations

To change a Wheels application default, you generally use the [set()][5] function. With it, you can perform
all sorts of tweaks to the framework's default behaviors.

## How to Access Configuration Values

Use the [get()][6] function to access the value of a Wheels application setting. Just pass it the name of
the setting.


	<cfif get("environment") is "production">
		<!--- Do something for production environment --->
	</cfif>

## Setting CFML application Configurations

In CFML's standard Application.cfc, you can normally set values for your application's properties in
the this scope. Wheels still provides these options to you in the file at config/app.cfm.

Here is an example of what can go in config/app.cfm:

	<cfset this.Name = "TheNextSiteToBeatTwitter">
	<cfset this.AessionManagement = false>
	<cfset this.CustomTagPaths = ListAppend(this.CustomTagPaths, ExpandPath("../customtags"))>

## Types of Configurations Available

There are several types of configurations that you can perform in Wheels to override all those default
behaviors. In Wheels, you can find all these configuration options:

  * URL rewrite settings 
  * Data source settings
  * Environment settings
  * Caching settings
  * Function settings
  * Miscellaneous settings

Let's take a closer look at each of these options.

### URL Rewrite Settings

Sometimes it is useful for our applications to "force" URL rewriting. By default, Wheels will try to
determinate what type of URL rewriting to perform and set it up for you. But you can force in or out
this setting by using the example below:

	<cfset set(urlRewriting="Off")>

The code above will tell Wheels to skip its automatic detection of the URL Rewriting capabilities and
just set it as "Off".

You can also set it to "Partial" if you believe that your web server is capable of rewriting the URL as
folders after index.cfm.

For more information, read the chapter about [URL Rewriting][2].

### Data Source Settings

Probably the most important configuration of them all. What is an application without a database to
store all of its precious data?

The data source configuration is what tells Wheels which database to use for all of its models.
(This can be overridden on a per model basis, but that will be covered later.) To set this up in Wheels,
it's just as easy as the previous example:

	<cfset set(dataSourceName="yourDataSourceName")>
	<cfset set(dataSourceUserName="yourDataSourceUsername")>
	<cfset set(dataSourcePassword="yourDataSourcePassword")> 

### Debugging and Error Settings

Not only are the environments useful for separating your production settings from your
"under development" settings, but they are also opportunities for you to override settings that will
only take effect in a specified environment.

For example, let's say that we want to disable debugging information in our development environment
temporarily:

	<!--- /config/development/settings.cfm --->
	<cfset set(showDebugInformation=false)>

#### Full Listing of Environment Settings

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Type</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>errorEmailServer</td>
			<td>string</td>
			<td>[empty string]</td>
			<td>Server to use to send out error emails. When left blank, this defaults to settings in the ColdFusion Administrator (if set).</td>
		</tr>
		<tr>
			<td>errorEmailAddress</td>
			<td>string</td>
			<td>[empty string]</td>
			<td>Comma-delimited list of email address to send error notifications to. Only applies if sendEmailOnError is set to true.</td>
		</tr>
		<tr>
			<td>errorEmailSubject</td>
			<td>string</td>
			<td>Error</td>
			<td>Subject of email that gets sent to administrators on errors. Only applies if sendEmailOnError is set to true.</td>
		</tr>
		<tr>
			<td>excludeFromErrorEmail</td>
			<td>string</td>
			<td>[empty string]</td>
			<td>List of variables (or entire scopes) to exclude from the scope dumps included in error emails. Use this to keep sensitive information from being sent in plain text over email.</td>
		</tr>
		<tr>
		 	<td>sendEmailOnError</td>
			<td>boolean</td>
			<td>Enabled in production environments that have a TLD like .com, .org, etc.</td>
			<td>When set to true, Wheels will send an email to administrators whenever Wheels throws an error.</td>
		</tr>
		<tr>
			<td>showDebugInformation</td>
			<td>boolean</td>
			<td>Enabled in design and development</td>
			<td>When set to true, Wheels will show debugging information in the footers of your pages.</td>
		</tr>
		<tr>
			<td>showErrorInformation</td>
			<td>boolean</td>
			<td>Enabled in design, development, maintenance, and testing</td>
			<td>When set to false, Wheels will run and display code stored at events/onerror.cfm instead of revealing CFML errors.</td>
		</tr>
	</tbody>
</table>

For more information, refer to the chapter about [Switching Environments][1].

### Caching Settings

Wheels does a pretty good job at caching the framework and its output to speed up your application. But
if personalization is key in your application, finer control over caching settings will become more
important.

Let's say your application generates dynamic routes, and you need it to check the routes on each request.
This task will be as simple as this line of code:

	<cfset set(cacheRoutes=false)>

#### Full Listing of Caching Settings

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Type</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>cacheActions</td>
			<td>boolean</td>
			<td>Enabled in maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache output generated by actions when specified (in a caches() call, for example).</td>
		</tr>
		<tr>
			<td>cacheControllerInitialization</td>
			<td>boolean</td>
			<td>Enabled in development, maintenace, testing, and production</td>
			<td>When set to false, any changes you make to the init() function in the controller file will be picked up immediately.</td>
		</tr>
		<tr>
			<td>cacheCullInterval</td>
			<td>numeric</td>
			<td>5</td>
			<td>Number of minutes between each culling action. The reason the cache is not culled during each request is to keep performance as high as possible.</td>
		</tr>
		<tr>
			<td>cacheCullPercentage</td>
			<td>numeric</td>
			<td>10</td>
			<td>If you set this value to 10, then at most, 10% of expired items will be deleted from the cache.</td>
		</tr>
		<tr>
			<td>cacheDatabaseSchema</td>
			<td>boolean</td>
			<td>Enabled in development, maintenance, testing, and production</td>
			<td>When set to false, you can add a field to the database, and Wheels will pick that up right away.</td>
		</tr>
		<tr>
			<td>cacheFileChecking</td>
			<td>boolean</td>
			<td>Enabled in development, maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache whether or not controller, helper and layout files exist</td>
		</tr>
		<tr>
			<td>cacheImages</td>
			<td>boolean</td>
			<td>Enabled in development, maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache general image information used in imageTag() like width and height.</td>
		</tr>
		<tr>
			<td>cacheModelInitialization</td>
			<td>boolean</td>
			<td>Enabled in development, maintenance, testing, and production</td>
			<td>When set to false, any changes you make to the init() function in the model file will be picked up immediately.</td>
		</tr>
		<tr>
			<td>cachePages</td>
			<td>boolean</td>
			<td>Enabled in maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache output generated by a view page when specified (in a renderView() call, for example).</td>
		</tr>
		<tr>
			<td>cachePartials</td>
			<td>boolean</td>
			<td>Enabled in maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache output generated by partials when specified (in a includePartial() call, for example).</td>
		</tr>
		<tr>
			<td>cacheRoutes</td>
			<td>boolean</td>
			<td>Enabled in development, maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache routes across all pageviews.</td>
		</tr>
		<tr>
			<td>cacheQueries</td>
			<td>boolean</td>
			<td>Enabled in maintenance, testing, and production</td>
			<td>When set to true, Wheels will cache SQL queries when specified (in a findAll() call, for example).</td>
		</tr>
		<tr>
			<td>clearQueryCacheOnReload</td>
			<td>boolean</td>
			<td>true</td>
			<td>Set to true to clear any queries that Wheels has cached on application reload.</td>
		</tr>
		<tr>
			<td>defaultCacheTime</td>
			<td>numeric</td>
			<td>60</td>
			<td>Number of minutes an item should be cached when it has not been specifically set through one of the functions that perform the caching in Wheels (i.e., caches(), findAll(), includePartial(), etc.)</td>
		</tr>
		<tr>
			<td>maximumItemsToCache</td>
			<td>numeric</td>
			<td>5000</td>
			<td>Maximum number of items to store in Wheels's cache at one time. When the cache is full, items will be deleted automatically at a regular interval based on the other cache settings.</td>
		</tr>
	</tbody>
</table>

For more information, refer to the chapter on [Caching][3].

### Function Settings

OK, here it's where the fun begins! Wheels includes a lot of functions to make your life as a CFML
developer easier. A lot of those functions have sensible default argument values to minimize the amount
of code that you need to write. And yes, you guessed it, Wheels lets you override those default argument
values application-wide.

Let's look at a little of example:

	<cfset set(functionName="findAll", perPage=20)>

That little line of code will make all calls to the findAll() method in Wheels return a maximum number
of 20 record per page (if pagination is enabled for that findAll() call). How great is that? You don't
need to set the perPage value for every single call to findAll() if you have a different requirement
than the Wheels default of 10 records.

### ORM Settings

The Wheels ORM provides many sensible conventions and defaults, but sometimes your data structure
requires different column naming or behavior than what Wheels expects out of the box. Use these settings
to change those naming conventions or behaviors across your entire application.

For example, if we wanted to prefix all of the database table names in our application with blog_ but
didn't want to include that at the beginning of model names, we would do this:

	<cfset set(tableNamePrefix="blog_")>

Now your post model will map to the blog_posts table, comment model will map to the blog_comments
table, etc.

#### Full Listing of ORM Settings

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Type</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>afterFindCallbackLegacySupport</td>
			<td>boolean</td>
			<td>true</td>
			<td>When this is set to false and you're implementing an afterFind() callback, you need to write the same logic for both the this scope (for objects) and arguments scope (for queries). Setting this to false makes both ways use the arguments scope so you don't need to duplicate logic. Note that the default is true for backwards compatibility.</td>
		</tr>
		<tr>
			<td>automaticValidations</td>
			<td>boolean</td>
			<td>true</td>
			<td>Set to false to stop Wheels from automatically running object validations based on column settings in your database.</td>
		</tr>
		<tr>
		 	<td>tableNamePrefix</td>
			<td>string</td>
			<td>[empty string]</td>
			<td>String to prefix all database tables with so you don't need to define your model objects including it. Useful in environments that have table naming conventions like starting all table names with tbl</td>
		</tr>
		<tr>
			<td>timeStampOnCreateProperty</td>
			<td>string</td>
			<td>createdAt</td>
			<td>Name of database column that Wheels will look for in order to automatically store a "created at" time stamp when records are created.</td>
		</tr>
		<tr>
			<td>timeStampOnUpdateProperty</td>
			<td>string</td>
			<td>updatedAt</td>
			<td>Name of the database column that Wheels will look for in order to automatically store an "updated at" time stamp when records are updated.</td>
		</tr>
		<tr>
			<td>transactionMode</td>
			<td>string</td>
			<td>commit</td>
			<td>Use commit, rollback or none to set default transaction handling for creates, updates and deletes.</td>
		</tr>
		<tr>
			<td>setUpdatedAtOnCreate</td>
			<td>boolean</td>
			<td>true</td>
			<td>Set to false to stop Wheels from populating the updatedAt timestamp with the createdAt timestamp's value.</td>
		</tr>
		<tr>
			<td>softDeleteProperty</td>
			<td>string</td>
			<td>deletedAt</td>
			<td>Name of database column that Wheels will look for in order to enforce soft deletes.</td>
		</tr>
		<tr>
			<td>useExpandedColumnAliases</td>
			<td>boolean</td>
			<td>true</td>
			<td>When set to true, Wheels will always prepend children objects' names to columns included via findAll()'s include argument, even if there are no naming conflicts. For example, model("post").findAll(include="comment") in a fictitious blog application would yield these column names: id, title, authorId, body, createdAt, commentId, commentName, commentBody, commentCreatedAt, commentDeletedAt. When this setting is set to false, the returned column list would look like this: id, title, authorId, body, createdAt, commentId, name, commentBody, commentCreatedAt, deletedAt.</td>
		</tr>
	</tbody>
</table>

### Plugin Settings

There are several settings that make plugin development more convenient. We recommend only changing
these settings in design or development modes so there aren't any deployment issues in production,
testing, and maintenance modes. (At that point, your plugin should be properly packaged in a zip
file.)

If you want to keep what's stored in a plugin's zip file from overwriting changes that you made in its
expanded folder, set this in config/design/settings.cfm and/or config/development/settings.cfm:

	<cfset set(overwritePlugins=false)>

See the chapter on [Using and Creating Plugins][4] for more information.

#### Full Listing of Plugin Settings

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Type</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>deletePluginDirectories</td>
			<td>boolean</td>
			<td>true</td>
			<td>When set to true, Wheels will remove subdirectories within the plugins folder that do not contain corresponding plugin zip files. Set to false to add convenience to the process for developing your own plugins.</td>
		</tr>
		<tr>
			<td>loadIncompatiblePlugins</td>
			<td>boolean</td>
			<td>true</td>
			<td>Set to false to stop Wheels from loading plugins whose supported versions do not match your current version of Wheels.</td>
		</tr>
		<tr>
			<td>overwritePlugins</td>
			<td>boolean</td>
			<td>true</td>
			<td>When set to true, Wheels will overwrite plugin files based on their source zip files on application reload. Setting this to false makes plugin development easier because you don't need to keep rezipping your plugin files every time you make a change.</td>
		</tr>
	</tbody>
</table>

### Miscellaneous Settings

How about situations that don't fit into those previous 6 categories? Well, they all fall right into
this miscellaneous section.

Let's say that you want to set a reload password for your environment:

	<cfset set(reloadPassword="somepassword123")>

This will prevent others from being able to reload your application or change environments with the
reload URL argument without also providing a password URL argument of somepassword123.

#### Full Listing of Miscellaneous Settings

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Type</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>assetQueryString</td>
			<td>boolean</td>
			<td>false in design and development environments, true in the others</td>
			<td>Set to true to append a unique query string based on a time stamp to JavaScript, CSS, and image files included with the media view helpers. This helps force local browser caches to refresh when there is an update to your assets. This query string is updated when reloading your Wheels application. You can also hard code it by passing in a string.</td>
		</tr>
		<tr>
			<td>assetPaths</td>
			<td>struct</td>
			<td>false</td>
			<td>Pass false or a struct with up to 2 different keys to auto-populate the domains of your assets: http (required) and https. For example: {http="asset0.domain1.com,asset2.domain1.com,asset3.domain1.com", https="secure.domain1.com"}</td>
		</tr>
		<tr>
			<td>ipExceptions</td>
			<td>string</td>
			<td>[empty string]</td>
			<td>IP addresses that Wheels will ignore when the environment is set to maintenance. That way administrators can test the site while in maintenance mode, while the rest of users will see the message loaded in events/onmaintenance.cfm.</td>
		</tr>
		<tr>
			<td>loadDefaultRoutes</td>
			<td>boolean</td>
			<td>true</td>
			<td>Set to false to disable Wheels's default route patterns for controller/action/key, etc.</td>
		</tr>
		<tr>
			<td>obfuscateURLs</td>
			<td>boolean</td>
			<td>false</td>
			<td>Set to true to obfuscate primary keys in URLs.</td>
		</tr>
		<tr>
			<td>reloadPassword</td>
			<td>string</td>
			<td>[empty string]</td>
			<td>Password to require when reloading the Wheels application from the URL. Leave empty to require no password.</td>
		</tr>
	</tbody>
</table>

### Wrapping It Up

There are literally hundreds of configurations options in Wheels for you to play around with. So go
ahead and sink your teeth into Wheels configuration and defaults.

[1]: ../02%20Working%20with%20Wheels/04%20Switching%20Environments.md
[2]: ../03%20Handling%20Requests%20with%20Controllers/11%20URL%20Rewriting.md
[3]: ../03%20Handling%20Requests%20with%20Controllers/14%20Caching.md
[4]: ../02%20Working%20with%20Wheels/05%20Using%20and%20Creating%20Plugins.md
[5]: ../Wheels%20API/set.md
[6]: ../Wheels%20API/get.md