# Displaying Links for Pagination

###### How to create links to other pages in your paginated data in your views.

In the chapter titled [Getting Paginated Data][1], we talked about how to get pages of records from the database (records 11-20, for example). Now we'll show you how to create links to the other pages in your view.

### Displaying Paginated Links with the paginationLinks Function
If you have fetched a paginated query in your controller (normally done using [findAll()](http://cfwheels.org/docs/1-3/function/findall) and the page argument), all you have to do to get the page links to show up is this:

```cfml
<cfoutput>#paginationLinks()#</cfoutput>
```

Given that you have only fetched one paginated query in your controller, this will output the links for that query using some sensible defaults.

How simple is that?

### Arguments Used for Customization

Simple is good, but sometimes you want a little more control over how the links are displayed. You can control the output of the links in a number of different ways. We'll show you the most important ones here. Please refer to the [paginationLinks()](http://cfwheels.org/docs/1-3/function/paginationlinks) documentation for all other uses.

#### The _name_ Argument

By default, Wheels will create all links with page as the variable that holds the page numbers. So the HTML code will look something like this:

```html
<a href="/main/userlisting?page=1">
<a href="/main/userlisting?page=2">
<a href="/main/userlisting?page=3">
```

To change page to something else, you use the name argument like so:

```cfml
<cfoutput>#paginationLinks(name="pgnum")#</cfoutput>
```

By the way, perhaps you noticed how Wheels chose to use that hideous question mark in the URL, despite the fact that you have URL rewriting turned on? Because [paginationLinks()](http://cfwheels.org/docs/1-3/function/paginationlinks) uses [linkTo()](http://cfwheels.org/docs/1-3/function/linkto) in the background, you can easily get rid of it by creating a custom route. You can read more about this in the [Using Routes][2] chapter.

#### The _windowSize_ Argument
This controls how many links to show around the current page. If you are currently displaying page 6 and pass in `windowSize=3`, Wheels will generate links to pages 3, 4, 5, 6, 7, 8, and 9 (three on each side of the current page).

#### The _alwaysShowAnchors_ Argument
If you pass in true here, it means that no matter where you currently are in the pagination or how many page numbers exist in total, links to the first and last page will always be visible.

### Managing More Than One Paginated Query Per Page
Most of the time, you'll only deal with one paginated query per page. But in those cases where you need to get/show more than one paginated query, you can use the handle argument to tell Wheels which query it is that you are referring to.

This argument has to be passed in to both the `findAll()` function and the `paginationLinks()` function. (You assign a handle name in the `findAll()` function and then request the data for it in `paginationLinks()`.)

Here is an example of using handles:

In the controller...
```cfml
<cfset users = model("user").findAll(handle="userQuery", page=params.page, perPage=25)>
<cfset blogs = model("blog").findAll(handle="blogQuery", page=params.page, perPage=25)>
```

In the view...
```cfml
<ul>
    <cfoutput query="users">
        <li>#users.name#</li>
    </cfoutput>
</ul>

<cfoutput>#paginationLinks(handle="userQuery")#</cfoutput>

<cfoutput query="blog">
    #address#<br />
</cfoutput>

<cfoutput>#paginationLinks(handle="blogQuery")#</cfoutput>
```

That's all you need to know about showing pagination links to get you started. As always, the best way to learn how the view functions work is to just play around with the arguments and see what HTML is produced.

[1]: ../04-Database-Interaction-Through-Models/08-Getting-Paginated-Data.md
[2]: ../03-Handling-Requests-with-Controllers/12-Using-Routes.md