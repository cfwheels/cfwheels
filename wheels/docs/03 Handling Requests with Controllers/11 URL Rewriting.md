# URL Rewriting

*Making URLs prettier using URL rewriting.*

URL rewriting is a completely optional feature of Wheels, and all it does is get rid of the `index.cfm` 
part of the URL.

For example, with no URL rewriting, a URL in your application could look like this:

	http://localhost/index.cfm/blog/new

After turning on URL rewriting, it would look like this:

	http://localhost/blog/new

Combine this with the routing functionality of Wheels, and you get the capablility of creating some 
really human-friendly (easier to remember, say over the phone, etc.) and search engine friendly (easier 
to crawl, higher PageRank, etc.) URLs.

Once you have uncommented the rewrite rules (found in either `.htaccess`, `web.config` or 
`IsapiRewrite4.ini`), Wheels will try and determine if your web server is capable of rewriting URLs and 
turn it on for you automatically. Depending on what web server you have and what folder you run Wheels 
from, you may need to tweak things a little though. Follow the instructions below for details on how to 
set up your web server and customize the rewrite rules when necessary.

## Instructions for Apache

On most Apache setups, you don't have to do anything at all to get URL rewriting to work. Just uncomment 
the rewrite rules in the `.htaccess` file and Apache will pick up and use them automatically on server 
start-up.

There are some exceptions though...

If you have installed Apache yourself you may need to turn on the rewrite module and/or change the 
security settings before URL rewriting will work:

  1. Check that the Apache `rewrite_module` has been loaded by ensuring there are no pound signs before the line that says `LoadModule rewrite_module modules/mod_rewrite.so` in the `httpd.conf` file.
  2. Make sure that Apache has permission to load the rewrite rules from the `.htaccess` file. This is done by setting `AllowOverride` to `All` under the `Directory` section corresponding to the website you plan on using Wheels on (still inside the `httpd.conf` file).

If you have an older version of Apache and you're trying to run your Wheels site in a sub folder of an 
existing site you may need to hard code the name of this folder in your rewrite rules.

  1. Change the last line of the `.htaccess` file to the following: `RewriteRule ^(.*)$ /sub_folder_name_goes_here/rewrite.cfm/$1 [L]`. Don't forget to change `sub_folder_name_goes_here` to the actual folder name first of course.

## Instructions for IIS 7

Similar to Apache, IIS 7 will pick up the rewrite rules from a file located in the Wheels installation. 
In the case of IIS 7, the rules are picked up from the `web.config` file. (Don't forget to uncomment the 
XML block containing the rewrite rules in that file first.)

This requires that the [URL Rewrite Module][1] is installed. It's an IIS extension from Microsoft that 
you can download for free.

## Instructions for IIS 6

Unfortunately, there is no built-in URL rewriting mechanism in IIS 6, so getting Wheels working with 
pretty URLs is a little more complicated than with Apache and IIS 7 (which often comes with the 
official "URL Rewrite Module" installed by default). Here's what you need to do:

  1. Download [Ionic's ISAPI Rewrite Filter][2]. *NOTE:* the version must be v1.2.16 or later.
  2. Unzip the file, get the `IsapiRewrite4.dll` file from the `lib` folder and put it in the root of your website. (It needs to be in the same folder as the `IsapiRewrite4.ini` file.)
  3. To enable the rewrite filter in IIS 6, click on _Properties_ for your website, then go to the _ISAPI Filters_ tab and click the _Add..._ button.
  4. Type in anything you want as the _Filter Name_ and point the _Executable_ to the `IsapiRewrite4.dll` file.
  5. Uncomment the rewrite rules in the `IsapiRewrite4.ini` file.

*NOTE:* Make sure you have "Verify that file exists" disabled for your site.

  1. Right click your website and select _Properties_.
  2. Click _Home Directory_ tab.
  3. Click the _Configuration_ button.
  4. Under the _Wildcard application mapping_ section, double-click path for the `jrun_iis6_wildcard.dll`.
  5. Uncheck _Verify that file exists_.
  6. Click _OK_ until all property screens are closed.

## Deleting Unnecessary Files

The sole purpose of the `.htaccess` (for Apache), `web.config` (for IIS 7), and `IsapiRewrite4.ini` (for 
IIS 6) files is to make it possible to use URL rewriting.

If you don't plan on using URL rewriting at all, you can safely delete these files. Also, if you're 
using URL rewriting on Apache, you can delete the IIS specific files and vice versa. 

## Don't Forget to Restart

If you need to make changes to get URL rewriting to work, it's important to remember to always restart 
the web server and the ColdFusion server to make sure the changes are picked up by Wheels.

If you don't have access to restart services on your server, you can issue a `reload=true` request. It's 
often enough.

[1]: http://www.iis.net/extensions/URLRewrite
[2]: http://iirf.codeplex.com/
