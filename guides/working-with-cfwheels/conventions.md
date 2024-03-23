---
description: >-
  With a convention-over-configuration framework like CFWheels, it's important
  to know these conventions. This is your guide.
---

# Conventions

There is a specific set of standards that CFWheels follows when you run it in its default state. This is to save you time. With conventions in place, you can get started coding without worrying about configuring every little detail.

But it is important for you to know these conventions, especially if you're running an operating system and/or DBMS configuration that's picky about things like case sensitivity.

### URLs

CFWheels uses a very flexible routing system to match your application's URLs to controllers, views, and parameters.

Within this routing system is a _default route_ that handles many scenarios that you'll run across as a developer. The default route is mapped using the pattern `[controller]/[action]/[key]`.

Consider this example URL:http://localhost/users/edit/12

{% tabs %}
{% tab title="HTTP" %}
http://localhost/users/edit/12
{% endtab %}
{% endtabs %}

This maps to the `Users` controller, `edit` action, and a key of `12`. For all intents and purposes, this will load a view for editing a user with a primary key value in the database of `12`.

This URL pattern works up the chain and will also handle the following example URLs:

| URL                                                              | Controller | Action | Key |
| ---------------------------------------------------------------- | ---------- | ------ | --- |
| [http://localhost/users/edit/12](http://localhost/users/edit/12) | users      | edit   | 12  |
| [http://localhost/users/](http://localhost/users/edit/12)new     | users      | new    |     |
| [http://localhost/users](http://localhost/users/edit/12)         | users      | index  |     |

Note that the above conventions are for `GET` requests and only apply when you have a `wildcard()` call in `config/routes.cfm` (which is the default). See [Routing](https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/routing) for instructions on overriding this behavior and how to deal with `PUT`, `POST` etc.

### Naming Conventions for Controllers, Actions, and Views

Controllers, actions, and views are closely linked together by default. And how you name them will influence the URLs that CFWheels will generate.

### Controllers

First, a controller is a CFC file placed in the `controllers` folder. It should be named in `PascalCase`. For example, a site map controller would be stored at `controllers/SiteMap.cfc`.

Multi-word controllers will be delimited by hyphens in their calling URLs. For example, a URL of `/site-map` will reference the `SiteMap` controller.

See [Routing](https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/routing) for instructions on overriding this behavior.

### Actions

Methods within the controllers, known as actions, should be named in `camelCase`.

Like with controllers, any time a capital letter is used in `camelCase`, a hyphen will be used as a word delimiter in the corresponding URL. For example, a URL of `/site-map/search-engines` will reference the `searchEngines` action in the `SiteMap` controller.

See [Routing](https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/routing) for instructions on overriding this behavior.

### Views

By default, view files are named after the action names and are stored in folders that correspond to controller names. Both the folder names and view file names should be all lowercase, and there is no word delimiter.

In our `/site-map/search-engines` URL example, the corresponding view file would be stored at `views/sitemap/searchengines.cfm`.

For information on overriding this behavior, refer to documentation for the [renderView()](https://api.cfwheels.org/controller.renderview.html) function and read the [Pages](https://guides.cfwheels.org/cfwheels-guides/displaying-views-to-users/pages) chapter.

### Layouts

A special type of view file called a layout defines markup that should surround the views loaded by the application. The default layout is stored at `views/layout.cfm` and is automatically used by all views in the application.

Controller-level layouts can also be set automatically by creating a file called `layout.cfm` and storing it in the given controller's view folder. For example, to create a layout for the `users` controller, the file would be stored at `views/users/layout.cfm`.

When a controller-level layout is present, it overrides the default layout stored in the root `views` folder.

For information on overriding the layout file to be loaded by an action, see the chapter on [Layouts](https://guides.cfwheels.org/cfwheels-guides/displaying-views-to-users/layouts)] and documentation for the [renderView](https://api.cfwheels.org/controller.renderview.html) function.

### Naming Conventions for Models and Databases

By default, the names of CFWheels models, model properties, database tables, and database fields all relate to each other. CFWheels even sets a sensible default for the CFML data source used for database interactions.

### Data Sources

CFWheels will automatically look for a data source with the same name as the folder that your application is deployed in. If your CFWheels application is in a folder called `blog`, CFWheels will look for a data source called `blog`, for example.

Refer to the [Configuration and Defaults](https://guides.cfwheels.org/cfwheels-guides/working-with-cfwheels/configuration-and-defaults) chapter for instructions on overriding data source information.

### Plural Database Table Names, Singular Model Names

CFWheels adopts a Rails-style naming conventions for database tables and model files. Think of a database table as a collection of model objects; therefore, it is named with a plural name. Think of a model object as a representation of a single record from the database table; therefore, it is named with a singular word.

For example, a `user` model represents a record from the `users` database table. CFWheels also recognizes plural patterns like `binary/binaries`, `mouse/mice`, `child/children`, etc.

Like controller files, models are also CFCs and are named in `PascalCase`. They are stored in the `models` folder. So the user model would be stored at `models/User.cfc`.

For instructions on overriding database naming conventions, refer to documentation for the [table()](https://api.cfwheels.org/model.table.html) function and the chapter on [Object Relational Mapping](https://guides.cfwheels.org/cfwheels-guides/database-interaction-through-models/object-relational-mapping).

### Everything in the Database Is Lowercase

In your database, both table names and column names should be lowercase. The `customersegments` table could have fields called `title`, `regionid`, and `incomelevel`, for example.

Because of CFML's case insensitive nature, we recommend that you refer to model names and corresponding properties in `camelCase`. This makes for easier readability in your application code.

In the `customersegments` example above, you could refer to the properties in your CFML as `title`, `regionId`, and `incomeLevel` to stick to CFML's Java-style roots. (Built-in CFML functions are often written in `camelCase` and `PascalCase`, after all.)

For information on overriding column and property names, refer to documentation for the [property()](https://api.cfwheels.org/model.property.html) function and the [Object Relational Mapping](https://guides.cfwheels.org/cfwheels-guides/database-interaction-through-models/object-relational-mapping) chapter.

### Configuration and Defaults

There are many default values and settings that you can tweak in CFWheels when you need to. Some of them are conventions and others are just configurations available for you to change. You can even change argument defaults for built-in CFWheels functions to keep your code DRYer.

For more details on what you can configure, read the [Configuration and Defaults](https://guides.cfwheels.org/2.5.0/working-with-cfwheels/configuration-and-defaults) chapter.
