# Requirements

*What you need to know and have installed before you start programming in Wheels.*

We can identify 3 different types of requirements that you should be aware of:

  1. *Project Requirements.* Is Wheels a good fit for your project?
  2. *Developer Requirements.* Do you have the knowledge and mindset to program effectively in Wheels?
  3. *System Requirements.* Is your server ready for Wheels?

## 1. Project Requirements

Before you start learning Wheels and making sure all the necessary software is installed on your
computer you really need to take a moment and think about the project you intend to use Wheels on. Is it
a ten page website that won't be updated very often? Is it a space flight simulator program for NASA? Is
it something in between?

Most websites are, at their cores, simple data manipulation applications. You fetch a row, make some
updates to it, stick it back in the database and so on. This is the "target market" for
Wheels - simple CRUD (create, read, update, delete) website applications.

A simple ten page website won't do much data manipulation, so you don't need Wheels for that (or even
ColdFusion in some cases). A flight simulator program will do so much more than simple CRUD work, so in
that case, Wheels is a poor match for you (and so is ColdFusion).

If your website falls somewhere in between these two extreme examples, then read on. If not, go look for
another programming language and framework. ;)

Another thing worth noting right off the bat (and one that ties in with the simple CRUD reasoning above)
is that Wheels takes a very data-centric approach to the development process. What we mean by that is
that it should be possible to visualize and implement the database design early on in the project's life
cycle. So, if you're about to embark on a project with an extensive period of object oriented analysis
and design which, as a last step almost, looks at how to persist objects, then you should probably also
look for another framework.

Still reading?

Good. :)

Moving on...

## 2. Developer Requirements

Yes, there are actually some things you should familiarize yourself with before starting to use Wheels.
Don't worry though. You don't need to be an expert on any on of them. A basic understanding is good
enough.

  * *CFML.* You should know CFML, the ColdFusion programming language. (Surprise!)
  * *Object Oriented Programming.* You should grasp the concept of object oriented programming and how
  	it applies to ColdFusion.
  * *Model-View-Controller.* You should know the theory behind the Model-View-Controller development
	pattern.

### CFML

Simply the best web development language in the world! The best way to learn it, in our humble opinion,
is to [get the free developer edition of ColdFusion from Adobe][1], buy Ben Forta's
[ColdFusion Web Application Construction Kit][2] series, and start coding using your programming editor
of choice.

### Object Oriented Programming (OOP)

This is a programming methodology that uses constructs called _objects_ to design applications. Objects
model real world entities in your application. OOP is based on several techniques including
_inheritance_, _modularity_, _polymorphism_ and _encapsulation_. Most of these techniques are supported
in ColdFusion, making it a fairly functional object oriented language. At the most basic level, a `.cfc`
file in CFML is a class, and you create an instance of a class by using the `CreateObject` function or
the `<cfobject>` tag.

Trying to squeeze an explanation of object oriented programming and how it's used in CFML into a few
sentences is impossible, and a detailed overview of it is outside the scope of this chapter. There is
lots of high quality information online, so go ahead and Google it.

### Model-View-Controller

Model-View-Controller, or MVC for short, is a way to structure your code so that it is broken down into
3 easy-to-manage pieces:

  * *Model.* Just another name for the representation of data, usually a database table.
  * *View.* What the user sees and interacts with (a web page in our case).
  * *Controller.* The behind-the-scenes guy that's coordinating everything.

MVC is how Wheels structures your code for you. As you start working with Wheels applications, you'll
see that most of the code you write is very nicely separated into one of these 3 categories.

## 3. System Requirements

Wheels requires that you use one of these CFML engines:

  * [Adobe ColdFusion][4] (version 8.0.1 or greater)
  * [Railo][5] (version 3.1.2.020 or greater)

Wheels makes heavy use of CFML's `OnMissingMethod` event, which wasn't available until the release of
CF 8.

### Operating Systems

Your setup with Wheels can then can be installed on *Windows*, *Mac OS X*, *UNIX*, or *Linux* - they
all work just fine.

### Web Servers

You also need a web server. Wheels runs on all popular web servers including Apache, Microsoft IIS,
Jetty, and the JRun web server that ships with Adobe ColdFusion. Some web servers support URL rewriting
out of the box, some support the `cgi.path_info` variable which is used to achieve partial rewriting,
and some don't have support for either.

Don't worry though. Wheels will adapt to your setup and run just fine regardless, but the URLs that it
creates might differ a bit. You can read more about this in the [URL Rewriting][6] chapter.

### Database Engines

Finally, to build any kind of meaningful web application, you will likely interact with a database.
Currently supported databases are SQL Server 7 or later, Oracle 10g or later, MySQL 5, PostgreSQL, and
H2.

Regarding MySQL, please note that MySQL 4 is not supported. We also recommend using the InnoDB engine if
you want for [Transactions][7] to work.

OK, hopefully this chapter didn't scare you too much. You can move on knowing that you have the basic
knowledge needed, the software to run Wheels on, and a suitable project to start with.

[1]: http://www.adobe.com/products/coldfusion
[2]: http://www.forta.com/books/032151548x
[4]: http://www.adobe.com/products/coldfusion/
[5]: http://www.getrailo.org/
[6]: ../03%20Handling%20Requests%20with%20Controllers/11%20URL%20Rewriting.md
[7]: ../04%20Database%20Interaction%20Through%20Models/14%20Transactions.md
