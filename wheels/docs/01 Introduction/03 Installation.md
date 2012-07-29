# Installation

*Instructions for installing Wheels on your system.*

Installing Wheels is so simple that there is barely a need for a chapter devoted to it. But we figured
we'd better make one anyway in case anyone is specifically looking for a chapter about installation.

So, here are the simple steps you need to follow to get rolling on Wheels...

## 1. Download Wheels

You have two choices when downloading Wheels. You can either use the latest official release of Wheels,
or you can take a walk on the wild side and go with the latest committed source code in our Subversion
(SVN) repository.

The latest official release can be found in the [downloads section][1] of this website, and the Git
repository is available at our [GitHub repo][2].

In most cases, we recommend going with the official release because it's well documented and has been
through a lot of bug testing. Only if you're in desperate need of a feature that has not been released
yet would we advise you to go with the version stored in the SVN trunk.

Let's assume you have downloaded the latest official release. (Really, you should go with this option.)
You now have a `.zip` file saved somewhere on your computer. On to the next step...

## 2. Setup the Website

Getting an empty website running with Wheels installed is an easy process if you already know your way
around IIS or Apache. Basically, you need to create a new website in your web server of choice and unzip
the contents of the file into the root of it.

In case you're not sure, here are the instructions for setting up an empty Wheels site that can be
accessed when typing `http://localhost` in your browser. The instructions refer to a system running
Windows Server 2003 and IIS, but you should be able to follow along and apply the instructions with
minor modifications to your system. (See the [Requirements][3] chapter for a list of tested systems).

  * Create a new folder under your web root (usually `C:\Inetpub\wwwroot`) named `mysite` and unzip the
  	Wheels `.zip` file into the root of it.
  * Create a new website using IIS called `My Site` with `localhost` as the host header name and
	`C:\Inetpub\wwwroot\mysite` as the path to your home directory.

If you want to run a Wheels powered application from a subfolder in an existing website, this is
entirely possible, but you may need to get a little creative with your URL rewrite rules if you want to
get pretty URLs - it will only work out of the box on recent versions of Apache. (Read more about this
in the [URL Rewriting][4] chapter.)

## 3. Setup the Database (optional)

Create a new database in MySQL, Oracle, PostgreSQL, Microsoft SQL Server, or H2 and add a new data source
for it in the ColdFusion/Railo Administrator, just as you'd normally do. Now open up
`config/settings.cfm` and call `set(dataSourceName="")` with the name you chose for the data source. 

If you don't want to be bothered by opening up a Wheels configuration file at all, there is a nice
convention you can follow for the naming. Just name your data source with the same name as the folder you
are running your website from (`mysite` in the example above), and Wheels will use that when you haven't
set the `dataSourceName` variable using the [`set()`][5] function.

This is all that you need to do before Wheels can connect to your database and start working its magic.

## 4. Test It

When you've followed the steps above, you can now test your installation by typing `http://localhost`
(or whatever you set as the host header name) in your web browser. You should get a page saying
"Congratulations!"

That's it. You're done. This is where the fun begins!

[1]: http://cfwheels.org/download
[2]: http://www.github.com/cfwheels
[3]: ../01%20Introduction/02%20Requirements.md
[4]: ../03%20Handling%20Requests%20with%20Controllers/11%20URL%20Rewriting.md
[5]: ../Wheels%20API/set.md
