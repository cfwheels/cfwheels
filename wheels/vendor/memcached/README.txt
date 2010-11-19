
******************************
Known Issues
******************************

getStats(), getVersions() - Calling either of these functions against a memcached instance
that is not running will result in a hung request.  the request will remain hung until the 
memcached instance comes back up.  Please be careful about how you use either of those two functions.
this issue is endemic to the behavior of the java libraries and I am working to get it fixed.

There is some wierdness around using deserialized cfcs.  You can serialize and store a cfc with memcached,
however, there seems to be some wierdness when you try to reinit any connections to server or application scope
values.  I don't know how to completely replicate this issue, but i've run into it a couple of times.  if you
notice anything weird here, please let me know.


******************************
Change Log
******************************

version 1.2 
-------------------
getStats() - This has now been fixed thanks to a snippet of code sent in by Ken Kolodziej.

updated several of the functions to include try catches, to fail gracefully

An issue was identified where timeouts weren't happening, so if you tried to run your site
and the system couldn't connect to memcached, then the client would hang and leave a running 
process on your system.  this is an underlying java client library issue, that needs to be 
taken care of in the java libraries.  I've worked around it as best as I can without those changes.
calling get() and getBulk() now will not hang the client.  I've updated the cfmemcached code so that you
can configure your own timeout.  You can set a default timeout for the entire client, as well as modifying
that time out on a per request basis.



*******************************
CREDITS
*******************************

this memcached client brought to you by:  

Jon Hirschi
http://www.flexablecoder.com


if you decide to make derivitive works off of this client,
please include my url and mention in your comments. :)

This memcached client and any updates can be found at:

http://cfmemcached.riaforge.org


This memcached client is a coldfusion client based off of the java client made by Dustin Sallings.

http://bleu.west.spy.net/~dustin/projects/memcached/

without his handiwork, we wouldn't have this nice caching solution.

This also depends on the javaloader by Mark Mandel.  I'm sure we could do this without
the javaloader, but it makes it so much easier.

Thanks also to Shayne Sweeney who put the first memcached client together which put me on the path to 
making this caching solution.


Also, please visit the best Flex resource on the planet - community flex at http://www.cflex.net

