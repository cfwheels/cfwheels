<!--- Include any HTML code you want displayed on every page in your application (if a controller-specific layout isn't available)
<cfoutput>
	#contentForLayout()#
</cfoutput>
 --->

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta name="Description" content="Singsnap is a free online karaoke community where you can sing and record from a large variety of karaoke songs and comment on other karaoke enthusiast's performances. To take full advantage, all you need is an inexpensive web cam and microphone." />
	<meta name="Keywords" content="karaoke, record, sing, singing, online, free, webcam, mic, microphone, music, singalong, tunes, songs, play, stream" />
	<title>SingSnap - Free online karaoke community</title>
	#styleSheetLinkTag("singsnap")#
	#javascriptIncludeTag("application,prototype,scriptaculous")#
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	
</head>
<body>
<div id="wrapper">

<cfif request.params.controller IS NOT "home" AND request.params.action IS NOT "index">
	#linkTo(controller="home", action="index", text=imageTag(source="singsnap.gif", attributes="id='logo'"))#
<cfelse>
	#ImageTag(source="singsnap.gif", attributes="id='logo'")#
</cfif>

<div id="topmenu">
<ul>
<cfif NOT structKeyExists(session, "active_user")>
	<li id="current_top">#linkTo(text="Home", controller="home", action="index")#</li>
<cfelseif request.params.controller IS "profile">
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
	<li<cfif request.params.controller IS "community"> id="current_top"</cfif>>#linkTo(controller="community", action="communication", text="Community")#</li>
	<li<cfif request.params.controller IS "account"> id="current_top"</cfif>>#linkTo(controller="account", action="profile", text="My Account")#</li>
</cfif>
</ul>
</div>

<div id="submenu">
<ul>
<cfif NOT structKeyExists(session, "active_user")>
	<li<cfif request.params.action IS "beta"> id="current_sub"</cfif>>#linkTo(controller="home", action="beta", text="Join The Waiting List")#</li>
	<li<cfif request.params.action IS "login"> id="current_sub"</cfif>>#linkTo(controller="account", action="login", text="Beta User Login")#</li>			
<cfelse>
	<cfif request.params.controller IS "home">
		<li<cfif request.params.action IS "index"> id="current_sub"</cfif>>#linkTo(action="index", text="Home")#</li>
		<li<cfif request.params.action IS "invite"> id="current_sub"</cfif>>#linkTo(action="invite", text="Invite Your Friends")#</li>
		<li<cfif request.params.action IS "feedback"> id="current_sub"</cfif>>#linkTo(action="feedback", text="Send Us Feedback")#</li>			
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
		<li<cfif request.params.action IS "charts"> id="current_sub"</cfif>>#linkTo(action="charts", text="Charts")#</li>
		<li<cfif request.params.action IS "favoriteSongs"> id="current_sub"</cfif>>#linkTo(action="favoriteSongs", text="Favorite Songs")#</li>
		<li<cfif request.params.action IS "favoriteArtists"> id="current_sub"</cfif>>#linkTo(action="favoriteArtists", text="Favorite Artists")#</li>
	<cfelseif request.params.controller IS "community">
		<li<cfif request.params.action IS "communication"> id="current_sub"</cfif>>#linkTo(action="communication", text="Your Communication")#</li>
		<li<cfif request.params.action IS "messageBoard"> id="current_sub"</cfif>>#linkTo(action="messageBoard", text="Message Board")#</li>
		<li<cfif request.params.action IS "chat"> id="current_sub"</cfif>>#linkTo(action="chat", text="Chat Room")#</li>
	<cfelseif request.params.controller IS "account">
		<li<cfif request.params.action IS "profile"> id="current_sub"</cfif>>#linkTo(action="profile", text="Profile")#</li>
		<li<cfif request.params.action IS "picture"> id="current_sub"</cfif>>#linkTo(action="picture", text="Picture")#</li>
		<li<cfif request.params.action IS "recordings"> id="current_sub"</cfif>>#linkTo(action="recordings", text="Recordings")#</li>
		<li<cfif listFindNoCase("favorites,favoriteMembers,favoriteRecordings,favoriteArtists,favoriteSongs", request.params.action) IS NOT 0> id="current_sub"</cfif>>#linkTo(action="favorites", text="Favorites")#</li>
		<li<cfif request.params.action IS "settings"> id="current_sub"</cfif>>#linkTo(action="settings", text="Notifications")#</li>
		<li<cfif request.params.action IS "password"> id="current_sub"</cfif>>#linkTo(action="password", text="Password")#</li>
		<li<cfif request.params.action IS "logout"> id="current_sub"</cfif>>#linkTo(action="logout", text="Log Out")#</li>
	<cfelseif request.params.controller IS "profile">
		<li<cfif request.params.action IS "overview"> id="current_sub"</cfif>>#linkTo(action="overview", id=user.id, text="View Profile")#</li>
		<li<cfif request.params.action IS "recordings"> id="current_sub"</cfif>>#linkTo(action="recordings", id=user.id, text="View Recordings")#</li>
		<li<cfif request.params.action IS "guestbook"> id="current_sub"</cfif>>#linkTo(action="guestbook", id=user.id, text="View / Sign Guestbook")#</li>
		<li<cfif request.params.action IS "message"> id="current_sub"</cfif>>#linkTo(action="message", id=user.id, text="Send Private Message")#</li>
	<cfelseif request.params.controller IS "admin">
		<li<cfif request.params.action IS "dashboard"> id="current_sub"</cfif>>#linkTo(action="dashboard", text="Dashboard")#</li>
	</cfif>
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

#contentForLayout()#
</div>

<div id="footer">
<p class="smalltext">&##169; #year(now())#, SingSnap | #linkTo(text="Terms Of Use", controller="home", action="terms")#<cfif structKeyExists(session, "active_user")> | #linkTo(text="Invite Your Friends", controller="home", action="invite")# | #linkTo(text="Send Us Feedback", controller="home", action="feedback")#<cfif structKeyExists(session, "active_user") AND session.active_user.admin IS 1> | #linkTo(text="Admin", controller="admin", action="dashboard")#</cfif></cfif></p>
</div>

</div>

<cfif application.settings.environment IS "production" AND CGI.server_name Does Not Contain "djurner.net" AND CGI.server_name Does Not Contain "esmdev.com" AND CGI.server_name Does Not Contain "production.singsnap.com">
	<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
	</script>
	<script type="text/javascript">
	_uacct = "UA-618042-9";
	urchinTracker();
	</script>
</cfif>

</body>
</html>
</cfoutput>