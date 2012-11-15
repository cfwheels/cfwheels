# Conventions

*With a convention-over-configuration framework like Wheels, it's important to know
these conventions. This is your guide.*

There is a specific set of standards that Wheels follows when you run it in its default state. This is
to save you time. With conventions in place, you can get started coding without worrying about
configuring every little detail.

But it is important for you to know these conventions, especially if you're running an operating system
and/or DBMS configuration that's picky about things like case sensitivity.

## URLs

Wheels uses a very flexible routing system to match your application's URLs to controllers, views, and
parameters.

Within this routing system is a _default route_ that handles many scenarios that you'll run across as a
developer. The default route is mapped using the pattern `[controller]/[action]/[key]`.

Consider this example URL:

	http://localhost/users/edit/12

This maps to the `user` controller, `edit` action, and a `key` of `12`. For all intents and purposes,
this will load a view for editing a user with a primary key value in the database of `12`.

This URL pattern works up the chain and will also handle the following example URLs:

<table>
	<thead>
		<tr>
			<th>URL</th>
			<th>Controller</th>
			<th>Action</th>
			<th>Key</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>http://localhost/users/edit/12</td>
			<td>users</td>
			<td>edit</td>
			<td>12</td>
		</tr>
		<tr>
			<td>http://localhost/users/add</td>
			<td>users</td>
			<td>add</td>
			<td>Undefined</td>
		</tr>
		<tr>
			<td>http://localhost/users</td>
			<td>users</td>
			<td>index</td>
			<td>Undefined</td>
		</tr>
	</tbody>
</table>

See [Using Routes][1] for instructions on overriding this behavior.

## Naming Conventions for Controllers, Actions, and Views

Controllers, actions, and views are closely linked together by default. And how you name them will
influence the URLs that Wheels will generate.

### Controllers

First, a controller is a CFC file placed in the `controllers` folder. It should be named in `PascalCase`.
For example, a site map controller would be stored at `controllers/SiteMap.cfc`.

Multi-word controllers will be delimited by hyphens in their calling URLs. For example, a URL of
`/site-map` will reference the `SiteMap` controller.

See [Using Routes][1] for instructions on overriding this behavior.

### Actions

Methods within the controllers, known as actions, should be named in `camelCase`.

Like with controllers, any time a capital letter is used in `camelCase`, a hyphen will be used as a word
delimiter in the corresponding URL. For example, a URL of `/site-map/search-engines` will reference the
`searchEngines` action in the `SiteMap` controller.

See [Using Routes][1] for instructions on overriding this behavior.

### Views

By default, view files are named after the action names and are stored in folders that correspond to
controller names. Both the folder names and view file names should be all lowercase, and there is no
word delimiter.

In our `/site-map/search-engines` URL example, the corresponding view file would be stored at
`views/sitemap/searchengines.cfm`.

For information on overriding this behavior, refer to documentation for the [`renderView()`][6] function and
read the [Pages][2] chapter.

### Layouts

A special type of view file called a _layout_ defines markup that should surround the views loaded by
the application. The default layout is stored at `views/layout.cfm` and is automatically used by all
views in the application.

Controller-level layouts can also be set automatically by creating a file called `layout.cfm` and
storing it in the given controller's view folder. For example, to create a layout for the `users`
controller, the file would be stored at `views/users/layout.cfm`.

When a controller-level layout is present, it overrides the default layout stored in the root `views`
folder.

For information on overriding the layout file to be loaded by an action, see the chapter on
[Using Layouts][3] and documentation for the [`renderView()`][6] function.

## Naming Conventions for Models and Databases

By default, the names of Wheels models, model properties, database tables, and database fields all
relate to each other. Wheels even sets a sensible default for the CFML data source used for database
interactions.

### Data Sources

Wheels will automatically look for a data source with the same name as the folder that your application
is deployed in. If your Wheels application is in a folder called `blog`, Wheels will look for a data
source called `blog`, for example.

Refer to the [Configuration and Defaults][4] chapter for instructions on overriding data source
information.

### Plural Database Table Names, Singular Model Names

Wheels adopts a Rails-style naming conventions for database tables and model files. Think of a database
table as a collection of model objects; therefore, it is named with a plural name. Think of a model
object as a representation of a single record from the database table; therefore, it is named with a
singular word.

For example, a `user` model represents a record from the `users` database table. Wheels also recognizes
plural patterns like `binary`/`binaries`, `mouse`/`mice`, `child`/`children`, etc.

Like controller files, models are also CFCs and are named `PascalCase`. They are stored in the `models`
folder. So the `user` model would be stored at `models/User.cfc`.

For instructions on overriding database naming conventions, refer to documentation for the [`table()`][7]
function and the chapter on [Object Relational Mapping][5].

### Everything in the Database Is Lowercase

In your database, both table names and column names should be lowercase. The `customersegments` table
could have fields called `title`, `regionid`, and `incomelevel`, for example.

Because of CFML's case insensitive nature, we recommend that you refer to model names and corresponding
properties in `camelCase`. This makes for easier readability in your application code.

In the `customersegments` example above, you could refer to the properties in your CFML as `title`,
`regionId`, and `incomeLevel` to stick to CFML's Java-style roots. (Built-in CFML functions are often
written in `camelCase` and `PascalCase`, after all.)

For information on overriding column and property names, refer to documentation for the [`property()`][8]
function and the [Object Relational Mapping][5] chapter.

## Configuration and Defaults

There are many default values and settings that you can tweak in Wheels when you need to. Some of them
are conventions and others are just configurations available for you to change. You can even change
argument defaults for built-in Wheels functions to keep your code DRYer.

For more details on what you can configure, read the [Configuration and Defaults][4] chapter.

[1]: ../03%20Handling%20Requests%20with%20Controllers/12%20Using%20Routes.md
[2]: ../05%20Displaying%20Views%20to%20Users/01%20Pages.md
[3]: ../05%20Displaying%20Views%20to%20Users/04%20Using%20Layouts.md
[4]: ../02%20Working%20with%20Wheels/02%20Configuration%20and%20Defaults.md
[5]: ../04%20Database%20Interaction%20Through%20Models/01%20Object%20Relational%20Mapping.md
[6]: ../Wheels%20API/renderView.md
[7]: ../Wheels%20API/table.md
[8]: ../Wheels%20API/property.md