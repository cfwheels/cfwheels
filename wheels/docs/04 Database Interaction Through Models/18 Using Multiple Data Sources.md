# Using Multiple Data Sources

*How to use more than one database in your Wheels application.*

Sometimes you need to pull data from more than one database, whether it's by choice (for performance or 
security reasons, perhaps) or because that's the way your infrastructure is set up. It's something you 
have to find a way to deal with.

Wheels has built-in functionality for this so that you don't have to revert back to writing the queries 
and setting the data source manually whenever you need to use a data source other than the default one. 
In order accomplish this, you will use the `dataSource()` function.

## Using the `dataSource()` Function

Overriding the default data source is done on a per model basis in Wheels by calling the `dataSource()` 
function from within your model's `init()` method. By doing this, you instruct wheels to use that data 
source whenever it interacts with that model.

Here's an example of a model file:

    <cfcomponent extends="Model">

        <cffunction name="init">
            <cfset dataSource("mySecondDatabase")>
        </cffunction>

    </cfcomponent>

It's important to note that in order for Wheels to use the data source, it must first be configured in 
your respective CFML engine (i.e. in the Adobe ColdFusion or Railo Administrator).

## Does Not Work with Associations

One thing to keep in mind when using multiple data sources with Wheels is that it doesn't work across 
associations. When including another model within a query, Wheels will use the calling model's data 
source for the context of the query.

Let's say you have the following models set up:

`models/Photo.cfc`:

    <cfcomponent extends="Model">

        <cffunction name="init">
            <cfset dataSource("myFirstDatabase")>
            <cfset hasMany("photoGalleries")>
        </cffunction>

    </cfcomponent>

`models/PhotoGallery.cfc`:

    <cfcomponent extends="Model">

        <cffunction name="init">
            <cfset dataSource("mySecondDatabase")>
        </cffunction>

    </cfcomponent>

Because the `photo` model is the main model being used in the following example, its data source 
(`myFirstDatabase`) will be the one used in the query that `findAll()` ends up executing.

    <cfset myPhotos = model("photo").findAll(include="photoGalleries")>