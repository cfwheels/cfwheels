---
description: >-
  What you need to know and have installed before you start programming in
  CFWheels.
---

# Requirements

We can identify 3 different types of requirements that you should be aware of:

* **Project Requirements.** Is CFWheels a good fit for your project?
* **Developer Requirements.** Do you have the knowledge and mindset to program effectively in CFWheels?
* **System Requirements.** Is your server ready for CFWheels?

### Project Requirements

Before you start learning CFWheels and making sure all the necessary software is installed on your computer, you really need to take a moment and think about the project you intend to use CFWheels on. Is it a ten page website that won't be updated very often? Is it a space flight simulator program for NASA? Is it something in between?

Most websites are, at their cores, simple data manipulation applications. You fetch a row, make some updates to it, stick it back in the database and so on. This is the "target market" for CFWheels--simple CRUD (create, read, update, delete) website applications.

A simple ten page website won't do much data manipulation, so you don't need CFWheels for that (or even ColdFusion in some cases). A flight simulator program will do so much more than simple CRUD work, so in that case, CFWheels is a poor match for you (and so perhaps, is ColdFusion).

If your website falls somewhere in between these two extreme examples, then read on. If not, go look for another programming language and framework. ;)

Another thing worth noting right off the bat (and one that ties in with the simple CRUD reasoning above) is that CFWheels takes a very data-centric approach to the development process. What we mean by that is that it should be possible to visualize and implement the database design early on in the project's life cycle. So, if you're about to embark on a project with an extensive period of object oriented analysis and design which, as a last step almost, looks at how to persist objects, then you should probably also look for another framework.

Still reading?

Good!

Moving on...

### Developer Requirements

Yes, there are actually some things you should familiarize yourself with before starting to use CFWheels. Don't worry though. You don't need to be an expert on any on of them. A basic understanding is good enough.

* **CFML.** You should know CFML, the ColdFusion programming language. (Surprise!)
* **Object Oriented Programming.** You should grasp the concept of object oriented programming and how it applies to CFML.
* **Model-View-Controller.** You should know the theory behind the Model-View-Controller development pattern.

#### CFML

Simply the best web development language in the world! The best way to learn it, in our humble opinion, is to get the free developer edition of Adobe ColdFusion, buy Ben Forta's ColdFusion Web Application Construction Kit series, and start coding using your programming editor of choice. Remember it's not just the commercial Adobe offering that's available; [Lucee](https://lucee.org) offers an excellent open source alternative. Using [CommandBox](https://www.ortussolutions.com/products/commandbox) is a great and simple way to get a local development environment of your choice up and running quickly.

#### Object Oriented Programming (OOP)

This is a programming methodology that uses constructs called objects to design applications. Objects model real world entities in your application. OOP is based on several techniques including _inheritance_, _modularity_, _polymorphism_, and _encapsulation_. Most of these techniques are supported in CFML, making it a fairly functional object oriented language. At the most basic level, a `.cfc` file in CFML is a class, and you create an instance of a class by using the `CreateObject` function or the `<cfobject>` tag.

Trying to squeeze an explanation of object oriented programming and how it's used in CFML into a few sentences is impossible, and a detailed overview of it is outside the scope of this chapter. There is lots of high quality information online, so go ahead and Google it.

#### Model-View-Controller

Model-View-Controller, or MVC for short, is a way to structure your code so that it is broken down into 3 easy-to-manage pieces:

* **Model.** Just another name for the representation of data, usually a database table.
* **View.** What the user sees and interacts with (a web page in our case).
* **Controller.** The behind-the-scenes guy that's coordinating everything.

MVC is how CFWheels structures your code for you. As you start working with CFWheels applications, you'll see that most of the code you write is very nicely separated into one of these 3 categories.

### System Requirements

CFWheels requires that you use one of these CFML engines:

* [Adobe ColdFusion](http://www.adobe.com/products/coldfusion/) 10.0.23 / 11.0.12+ / 2016.0.4+ / 2018
* [Lucee](http://lucee.org) 4.5.5.006 + / 5.2.1.9+

#### Operating Systems

Your ColdFusion or Lucee engine can be installed on Windows, Mac, UNIX, or Linux—they all work just fine.

#### Web Servers

You also need a web server. CFWheels runs on all popular web servers, including Apache, Microsoft IIS, Jetty, and the JRun or Tomcat web server that ships with Adobe ColdFusion. Some web servers support URL rewriting out of the box, some support the `cgi.PATH_INFO` variable which is used to achieve partial rewriting, and some don't have support for either. For local development, we strongly encourage the use of [CommandBox](https://www.ortussolutions.com/products/commandbox).

Don't worry though. CFWheels will adopt to your setup and run just fine, but the URLs that it creates might differ a bit. You can read more about this in the [URL Rewriting](https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/url-rewriting) chapter.

#### Database Engines

Finally, to build any kind of meaningful website application, you will likely interact with a database. These are the currently supported databases:

* SQL Server 7+
* MySQL 5+ \*
* PostgreSQL 8.4+
* H2 1.4+

{% hint style="info" %}
**MySQL**

* CFWheels maybe incompatible with newer MySQL JDBC drivers. It is recommended you downgrade the driver to version 5.1.x for full ORM functionality.
* If you're using MySQL 5.7.5+ you should be aware that the `ONLY_FULL_GROUP_BY` setting is enabled by default and it's currently not compatible with the CFWheels ORM. However, you can work around this by either disabling the `ONLY_FULL_GROUP_BY` setting or using `ANY_VALUE()` in a calculated property. You can read more about it [here](https://dev.mysql.com/doc/refman/5.7/en/group-by-handling.html).
* We also recommend using the InnoDB engine if you want [Transactions](https://guides.cfwheels.org/cfwheels-guides/database-interaction-through-models/transactions) to work.
* **MySQL 4 is not supported.**
{% endhint %}

OK, hopefully this chapter didn't scare you too much. You can move on knowing that you have the basic knowledge needed, the software to run CFWheels, and a suitable project to start with.
