# Requirements

What you need to know and have installed before you start programming in CFWheels.

We can identify 3 different types of requirements that you should be aware of:

*  **Project Requirements.** Is CFWheels a good fit for your project?
*  **Developer Requirements.** Do you have the knowledge and mindset to program effectively in CFWheels?
*  **System Requirements.** Is your server ready for CFWheels?

## 1. Project Requirements

Before you start learning CFWheels and making sure all the necessary software is installed on your computer you really
need to take a moment and think about the project you intend to use CFWheels on. Is it a ten page website that won't be
updated very often? Is it a space flight simulator program for NASA? Is it something in between?

Most websites are, at their cores, simple data manipulation applications. You fetch a row, make some updates to it,
stick it back in the database and so on. This is the "target market" for CFWheels--simple CRUD (create, read, update,
delete) website applications.

A simple ten page website won't do much data manipulation, so you don't need CFWheels for that (or even ColdFusion in
some cases). A flight simulator program will do so much more than simple CRUD work, so in that case, CFWheels is a poor
match for you (and so is ColdFusion).

If your website falls somewhere in between these two extreme examples, then read on. If not, go look for another
programming language and framework. ;)

Another thing worth noting right off the bat (and one that ties in with the simple CRUD reasoning above) is that
CFWheels takes a very data-centric approach to the development process. What we mean by that is that it should be
possible to visualize and implement the database design early on in the project's life cycle. So, if you're about to
embark on a project with an extensive period of object oriented analysis and design which, as a last step almost, looks
at how to persist objects, then you should probably also look for another framework.

Still reading?

Good!

Moving on...

2. Developer Requirements

Yes, there are actually some things you should familiarize yourself with before starting to use CFWheels. Don't worry
though. You don't need to be an expert on any on of them. A basic understanding is good enough.

*  **CFML.** You should know CFML, the ColdFusion programming language. (Surprise!)
*  **Object Oriented Programming.** You should grasp the concept of object oriented programming and how it applies to
   ColdFusion.
*  **Model-View-Controller.** You should know the theory behind the Model-View-Controller development pattern.

### CFML

Simply the best web development language in the world! The best way to learn it, in our humble opinion, is to get the
free developer edition of Adobe ColdFusion, buy Ben Forta's ColdFusion Web Application Construction Kit series, and
start coding using your programming editor of choice.

### Object Oriented Programming (OOP)

This is a programming methodology that uses constructs called objects to design applications. Objects model real world
entities in your application. OOP is based on several techniques including _inheritance_, _modularity_, _polymorphism_,
and _encapsulation_. Most of these techniques are supported in CFML, making it a fairly functional object oriented
language. At the most basic level, a `.cfc` file in ColdFusion is a class, and you create an instance of a class by
using the `CreateObject` function or the `<cfobject>` tag.

Trying to squeeze an explanation of object oriented programming and how it's used in CFML into a few sentences is
impossible, and a detailed overview of it is outside the scope of this chapter. There is lots of high quality
information online, so go ahead and Google it.

### Model-View-Controller

Model-View-Controller, or MVC for short, is a way to structure your code so that it is broken down into 3 easy-to-manage
pieces:

*  **Model.** Just another name for the representation of data, usually a database table.
*  **View.** What the user sees and interacts with (a web page in our case).
*  **Controller.** The behind-the-scenes guy that's coordinating everything.

MVC is how CFWheels structures your code for you. As you start working with CFWheels applications, you'll see that most
of the code you write is very nicely separated into one of these 3 categories.

## 3. System Requirements

CFWheels requires that you use one of these CFML engines:

*  [Adobe ColdFusion][1] 8.0.1+
*  [Railo][2] 4.2.1+

CFWheels makes heavy use of CFML's `OnMissingMethod` event, which wasn't available until the release of CF 8.

### Operating Systems

Your ColdFusion or Railo engine can be installed on Windows, Mac, UNIX, or Linux—they all work just fine.

### Web Servers

You also need a web server. CFWheels runs on all popular web servers, including Apache, Microsoft IIS, Jetty, and the
JRun or Tomcat web server that ships with Adobe ColdFusion. Some web servers support URL rewriting out of the box, some
support the `cgi.PATH_INFO` variable which is used to achieve partial rewriting, and some don't have support for either.

Don't worry though. CFWheels will adopt to your setup and run just fine, but the URLs that it creates might differ a
bit. You can read more about this in the [URL Rewriting][3] chapter.
Database Engines

Finally, to build any kind of meaningful website application, you will likely interact with a database. Currently
supported databases are SQL Server 7 or later, Oracle 10g or later, MySQL 5, PostgreSQL, and H2.

Regarding MySQL, please note that MySQL 4 is not supported. We also recommend using the InnoDB engine if you want for
[Transactions][4] to work.

OK, hopefully this chapter didn't scare you too much. You can move on knowing that you have the basic knowledge needed,
the software to run CFWheels, and a suitable project to start with.

[1]: http://www.adobe.com/products/coldfusion/
[2]: http://www.getrailo.org/
[3]: ../03-Handling-Requests-with-Controllers/URL-Rewriting.md
[4]: ../04-Database-Interaction-Through-Models/Transactions.md
