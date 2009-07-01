<h1>Congratulations!</h1>
<p><strong>You have successfully installed version <cfoutput>#version#</cfoutput> of Wheels.</strong><br />
Welcome to the wonderful world of Wheels, we hope you will enjoy it!</p>

<h2>Now What?</h2>
<p>Now that you have a working installation of Wheels you may be wondering what to do next. Here are some suggestions...</p>
<ul>
<li><a href="http://cfwheels.org/docs/chapter/hello-world">View and code along with our "Hello World" tutorial.</a></li>
<li><a href="http://cfwheels.org/docs">Have a look at the rest of our documentation.</a></li>
<li><a href="http://groups.google.com/group/cfwheels">Say "Hello!" to everyone in the Google Group.</a></li>
<li>Build the next killer website on the World Wide Web...</li>
</ul>

<p><strong>Good Luck!</strong></p>

<!--- <cfset a = model("artist").findOne()> --->
<cfset a = model("artist").findAll()>

<cfoutput>#includePartial(name=a, spacer="|")#</cfoutput>
<hr>

includePartial(products) query
includePartial(product) object

any variable:
includePartial(name="comment", color="red")
access as comment.color (by putting comment in the arguments struct we scope it locally)

object
includePartial(name="comment", object=comment)
or shorthand
includePartial(comment)

query
includePartial(name="comment", query=comments)
or
includePartial(comments)
will iterate over query and include partial in each loop (passing in record as a struct to a comment variable?)
will set a commentCounter
