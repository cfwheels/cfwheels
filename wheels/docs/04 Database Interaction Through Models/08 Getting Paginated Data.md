# Getting Paginated Data

*Improve database performance and simplify your user interface by using pagination.*

If you searched for "ColdFusion" on Google, would you want all results to be returned on one page? 
Probably not because it would take a long time for Google to first get the records out its index and 
then prepare the page for you. Your browser would slow to a halt as it tried to render the page. When 
the page would finally show up, it would be a pain to scroll through all those results.

Rightly so, Google uses pagination to spread out the results on several pages.

And in Wheels, it's really simple to do this type of pagination. Here's how:

  1. Get records from the database based on a page number. Going back to the Google example, this would mean getting records 11-20 when the user is viewing the second results page. This is (mostly) done using the `findAll()` function and the `page` and `perPage` arguments.
  2. Display the links to all the other pages that the user should be able to go to. This is done in a view using the `paginationLinks()` function.

This chapter will deal with the first part: getting the paginated data. Please proceed to the chapter 
called [Displaying Links for Pagination][1] if you wish to learn how to output the page links in your 
view.

## Learning by Example

Let's jump straight to an example:

	<cfset authors = model("author").findAll(page=2, perPage=25, order="lastName")>

That simple code will return authors 26-50 from the database, ordered by their last name.

What SQL statements are actually being executed depends on which database engine you use. (For example, 
the MySQL adapter will use `LIMIT` and `OFFSET`, and the Microsoft SQL Server adapter will use `TOP` and 
some tricky sub queries.) Turn on debugging in the ColdFusion / Railo Administrator if you want to see 
exactly what's going on under the hood.

One important thing that you should be aware of is that pagination is done based on objects and not 
records. To illustrate what that means, we can expand on the above example a little:

	<cfset authorsAndBooks = model("author").findAll(include="books", page=2, perPage=25, order="lastName")>

Here, we tell Wheels that we also want to include any books written by the authors in the result. Since 
it's possible that an author has written many books, we can't know in advance how many records we'll get 
back (as opposed to the first example, where we know we will get 25 records back). If each author has 
written 2 books, for example, we will get 50 records back.

If you do want to paginate based on the books instead, all that you need to do is flip the `findAll()` 
statement around a little:

	<cfset booksAndAuthors = model("book").findAll(include="author", page=2, perPage=25, order="lastName")>

Here, we call the `findAll()` function on the `book` class instead, and thereby we ensure that the 
pagination is based on the books and not the authors. In this case, we will always get 25 records back.

That's all there is to it, really. The best way to learn pagination is to play around with it with 
debugging turned on.

[1]: ../05%20Displaying%20Views%20to%20Users/06%20Displaying%20Links%20for%20Pagination.md