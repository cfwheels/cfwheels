# Sending Files

*Use Wheels to send files to your users securely and with better control of the user experience.*

Sending files?! Is that really a necessary feature of Wheels? Can't I just place the file on my web
server and link to it? You are correct, there is absolutely no need to use Wheels to send files. Your
web server will do a fine job of sending out files to your users.

However, if you want a little more control over the way the user's browser handles the download or be
able to secure access to your files then you might find the `sendFile()` function useful.

## Sending Files With the sendFile() Function

The convention in Wheels is to place all files you want users to be able to download in the `files`
folder.

Assuming you've placed a file named `wheels_tutorial_20081028_J657D6HX.pdf` in that folder, here is a
quick example of how you can deliver that file to the user. Let's start with creating a link to the
action that will handle the sending of the file first.

	#linkTo(text="Download Tutorial", action="sendTutorial")#

Now let's send the file to the user in the `sendTutorial` controller action. Just like the rendering
functions in Wheels, the `sendFile()` function should be placed as the very last thing you do in your
action code.

In this case, that's the only thing we are doing, but perhaps you want to track how many times the file
is being downloaded, for example. In that case, the tracking code needs to be placed _before_ the
`sendFile()` function.

Also, remember that the `sendFile()` function replaces any rendering. You cannot send a file _and_
render a page. (This will be quite obvious once you try this code because you'll see that the browser
will give you a dialog box, and you won't actually leave the page that you're viewing at the time.)

Here's the `sendTutorial` action:

	<cffunction name="sendTutorial">
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf")>
	</cffunction>

That's one ugly file name though, eh? Let's present it to the user in a nicer way by suggesting a
different name to the browser:

	<cffunction name="sendTutorial">
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf", name="Tutorial.pdf")>
	</cffunction>

Much better! :)

By default, the `sendFile()` function will try and force a download dialog box to be shown to the user.
The purpose of this is to make it easy for the user to save the file to their computer. If you want the
file to be shown inside the browser instead (when possible as decided by the browser in question), you
can set the `disposition` argument to `inline`.

Here's an example:

	<cffunction name="sendTutorial">
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf", disposition="inline")>
	</cffunction>

You can also specify what HTTP content type to use when delivering the file by using the `type`
argument. Please refer to the API for the `sendFile()` function for complete details.

## Securing Access to Files

Perhaps the main reason to use the `sendFile()` function is that it gives you an easy way to secure
access to your files. Maybe the tutorial file used in the above example is something the user paid for,
and you only want for that user to be able to download it (and no one else). To accomplish this, you
can just add some code to authenticate the user right before the `sendFile()` call in your action.

However, there is a security flaw here. Can you figure out what it is?

You may have guessed that the `files` folder is placed in your web root so anyone can download files
from it by typing `http://www.domain.com/files/wheels_tutorial_20081028_J657D6HX.pdf` in their browser.
Although users would need to guess the file names to be able to access the files, we would still need
something more robust as far as security goes.

There are two solutions to this.

The easiest one is to just lock down access to the folder using your web server. Wheels won't be
affected by it since it gets the file from the file system.

If that is not an option, the other option is to simply move the `files` folder out of the web root,
thus making it inaccessible. If you move the folder, you'll need to accommodate for this in your code
by changing your `sendFile()` calls to specify the path as well, like this:

	<cffunction name="sendTutorial">
		<cfset sendFile(file="../../tutorials/wheels_tutorial_20081028_J657D6HX.pdf")>
	</cffunction>

This assumes you've moved the folder two levels up in your file system and into a folder named
`tutorials`.

## Don't Open Any Holes with URL Parameters

*A final note of warning:* Be careful to not allow just any parameters from the URL to get passed
through to the `sendFile()` because then a user would be able to download any file from your server.
Be wary of how you're using the `params` struct in this context!

[1]: ../Wheels%20API/sendFile.md
