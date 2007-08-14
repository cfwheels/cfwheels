<!--- Include any HTML code you want displayed on every page in your application (if a controller-specific layout isn't available)
<cfoutput>
	#contentForLayout()#
</cfoutput> --->

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta name="Description" content="Singsnap is a free online karaoke community where you can sing and record from a large variety of karaoke songs and comment on other karaoke enthusiast's performances. To take full advantage, all you need is an inexpensive web cam and microphone." />
	<meta name="Keywords" content="karaoke, record, sing, singing, online, free, webcam, mic, microphone, music, singalong, tunes, songs, play, stream" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>SingSnap | #pageTitle()#</title>
	#styleSheetLinkTag("singsnap_feb_7")#
	#javascriptIncludeTag("singsnap,prototype,scriptaculous")#
	<link rel="shortcut icon" type="image/ico" href="/favicon.ico" />
</head>
<body>

<cfif application.settings.environment IS "production" AND CGI.server_name Does Not Contain "djurner.net" AND CGI.server_name Does Not Contain "esmdev.com" AND CGI.server_name Does Not Contain "production.singsnap.com">
	<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
	</script>
	<script type="text/javascript">
	_uacct = "UA-618042-9";
	urchinTracker();
	</script>
</cfif>

<div id="wrapper">

<cfif request.params.controller IS "home" AND (request.params.action IS "index" OR request.params.action IS "beta")>
	#ImageTag(source="singsnap.gif", attributes="alt="""" id=""logo""")#
<cfelse>
	#linkTo(controller="home", action="index", text=imageTag(source="singsnap.gif", attributes="alt="""" id=""logo"""))#
</cfif>

<div id="topmenu">
<ul>
<cfif request.params.controller IS "profile">
	<cfif structKeyExists(cookie, "backlink")>
		<li>#linkTo(text="<< Back", link=cookie.backlink)#</li>
	<cfelse>
		<li>#linkTo(text="<< Back", link="/")#</li>
	</cfif>
	<li id="current_top">#linkTo(text="Member Profile", action="overview", id=user.id)#</li>
<cfelseif request.params.controller IS "admin">
	<li>#linkTo(text="<< Back", controller="home", action="index")#</li>
	<li id="current_top">#linkTo(text="Administration", action="dashboard")#</li>
<cfelse>
	<li<cfif request.params.controller IS "watchAndListen"> id="current_top"</cfif>>#linkTo(controller="watchAndListen", action="featuredRecordings", text="Watch &amp; Listen")#</li>
	<li<cfif request.params.controller IS "singAndRecord"> id="current_top"</cfif>>#linkTo(controller="singAndRecord", action="search", text="Sing &amp; Record")#</li>
	<li<cfif request.params.controller IS "messageBoard"> id="current_top"</cfif>>#linkTo(controller="messageBoard", action="categories", text="Message Board")#</li>
	<li<cfif request.params.controller IS "account"> id="current_top"</cfif>>
	<cfif structKeyExists(session, "user_id")>
		#linkTo(controller="account", action="profile", text="My Account")#
	<cfelse>
		#linkTo(controller="account", action="entrance", text="My Account")#
	</cfif>
	</li>
</cfif>
</ul>
</div>

<div id="submenu">
<ul>
<cfif request.params.controller IS "home">
	<li<cfif request.params.action IS "index"> id="current_sub"</cfif>>#linkTo(action="index", text="Home")#</li>
	<li<cfif request.params.action IS "guide"> id="current_sub"</cfif>>#linkTo(action="guide", text="Getting Started")#</li>
	<li<cfif request.params.action IS "tell"> id="current_sub"</cfif>>#linkTo(action="tell", text="Tell A Friend")#</li>
	<li<cfif request.params.action IS "blog"> id="current_sub"</cfif>>#linkTo(action="blog", text="Our Blog")#</li>
<cfelseif request.params.controller IS "watchAndListen">
	<li<cfif request.params.action IS "featuredRecordings"> id="current_sub"</cfif>>#linkTo(action="featuredRecordings", text="Featured")#</li>
	<li<cfif request.params.action IS "newRecordings"> id="current_sub"</cfif>>#linkTo(action="newRecordings", text="New")#</li>
	<li<cfif request.params.action IS "topRecordings"> id="current_sub"</cfif>>#linkTo(action="topRecordings", text="Top")#</li>
	<li<cfif request.params.action IS "duets"> id="current_sub"</cfif>>#linkTo(action="duets", text="Duets")#</li>
	<li<cfif request.params.action IS "artistBrowse" OR request.params.action IS "recordingsForArtist"> id="current_sub"</cfif>>#linkTo(action="artistBrowse", text="By Artist")#</li>
	<li<cfif request.params.action IS "songBrowse" OR request.params.action IS "recordingsForSong"> id="current_sub"</cfif>>#linkTo(action="songBrowse", text="By Song")#</li>
	<li<cfif request.params.action IS "userBrowse" OR request.params.action IS "recordingsForUser"> id="current_sub"</cfif>>#linkTo(action="userBrowse", text="By Member")#</li>
	<li<cfif request.params.action IS "favorites"> id="current_sub"</cfif>>#linkTo(action="favorites", text="Your Favorites")#</li>
<cfelseif request.params.controller IS "singAndRecord">
	<li<cfif request.params.action IS "search"> id="current_sub"</cfif>>#linkTo(action="search", text="Search")#</li>
	<li<cfif request.params.action IS "browseArtists"> id="current_sub"</cfif>>#linkTo(action="browseArtists", text="Browse Artists")#</li>
	<li<cfif request.params.action IS "browseSongs"> id="current_sub"</cfif>>#linkTo(action="browseSongs", text="Browse Songs")#</li>
	<li<cfif request.params.action IS "newReleases"> id="current_sub"</cfif>>#linkTo(action="newReleases", text="New Releases")#</li>
	<li<cfif request.params.action IS "charts"> id="current_sub"</cfif>>#linkTo(action="charts", text="Charts")#</li>
	<li<cfif request.params.action IS "favorites"> id="current_sub"</cfif>>#linkTo(action="favorites", text="Your Favorites")#</li>
<cfelseif request.params.controller IS "messageBoard">
	<li<cfif request.params.action IS "categories"> id="current_sub"</cfif>>#linkTo(action="categories", text="Categories")#</li>
	<li<cfif request.params.action IS "newTopic"> id="current_sub"</cfif>>#linkTo(action="newTopic", text="New Topic")#</li>
	<li<cfif listFindNoCase("search,searchResults", request.params.action) IS NOT 0> id="current_sub"</cfif>>#linkTo(action="search", text="Search")#</li>
<cfelseif request.params.controller IS "account">
	<cfif structKeyExists(session, "user_id")>
		<li<cfif request.params.action IS "profile"> id="current_sub"</cfif>>#linkTo(action="profile", text="Profile")#</li>
		<li<cfif request.params.action IS "communication"> id="current_sub"</cfif>>#linkTo(action="communication", text="Communication")#</li>
		<li<cfif request.params.action IS "picture"> id="current_sub"</cfif>>#linkTo(action="picture", text="Picture")#</li>
		<li<cfif request.params.action IS "recordings"> id="current_sub"</cfif>>#linkTo(action="recordings", text="Recordings")#</li>
		<li<cfif listFindNoCase("favorites,favoriteMembers,favoriteRecordings,favoriteArtists,favoriteSongs", request.params.action) IS NOT 0> id="current_sub"</cfif>>#linkTo(action="favorites", text="Favorites")#</li>
		<li<cfif request.params.action IS "settings"> id="current_sub"</cfif>>#linkTo(action="settings", text="Notifications")#</li>
		<li<cfif request.params.action IS "password"> id="current_sub"</cfif>>#linkTo(action="password", text="Password")#</li>
		<li<cfif request.params.action IS "logout"> id="current_sub"</cfif>>#linkTo(action="logout", text="Log Out")#</li>
	<cfelse>
		<li id="current_sub">#linkTo(action="entrance", text="Entrance")#</li>
	</cfif>
<cfelseif request.params.controller IS "profile">
	<li<cfif request.params.action IS "overview"> id="current_sub"</cfif>>#linkTo(action="overview", id=user.id, text="Profile")#</li>
	<li<cfif request.params.action IS "recordings"> id="current_sub"</cfif>>#linkTo(action="recordings", id=user.id, text="Recordings")#</li>
	<li<cfif request.params.action IS "fans"> id="current_sub"</cfif>>#linkTo(action="fans", id=user.id, text="Fans")#</li>
	<li<cfif request.params.action IS "favorites"> id="current_sub"</cfif>>#linkTo(action="favorites", id=user.id, text="Favorites")#</li>
	<li<cfif request.params.action IS "guestbook"> id="current_sub"</cfif>>#linkTo(action="guestbook", id=user.id, text="Guestbook")#</li>
	<li<cfif request.params.action IS "message"> id="current_sub"</cfif>>#linkTo(action="message", id=user.id, text="Send Message")#</li>
<cfelseif request.params.controller IS "admin">
	<li<cfif request.params.action IS "dashboard"> id="current_sub"</cfif>>#linkTo(action="dashboard", text="Dashboard")#</li>
</cfif>
</ul>
</div>

<div id="content">

<cfif structKeyExists(request.flash, "alert") OR structKeyExists(request.flash, "notice")>
	<cfif structKeyExists(request.flash, "alert")>
		<p class="message alert">#request.flash.alert#</p>
	<cfelse>
		<p class="message notice">#request.flash.notice#</p>
	</cfif>
</cfif>

<h1>#pageTitle()#</h1>
#contentForLayout()#
</div>

<div id="footer">
<p class="smalltext">&##169; #year(now())#, SingSnap | #linkTo(text="Terms Of Use", controller="home", action="terms")# | #linkTo(text="FAQ &amp; Support", controller="home", action="faq")# | #linkTo(text="Feedback", controller="home", action="feedback")# | #linkTo(text="Report Abuse", controller="home", action="abuse")#</p>
</div>

</div>

</body>
</html>
</cfoutput>