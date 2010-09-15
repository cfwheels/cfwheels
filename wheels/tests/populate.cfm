<cfdbinfo name="loc.dbinfo" datasource="wheelstestdb" type="version">
<cfset loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))>

<cfif loc.db IS "microsoftsqlserver">
	<cfset loc.ident = "IDENTITY(1,1)">
<cfelseif loc.db IS "mysql">
	<cfset loc.ident = "AUTO_INCREMENT">
<cfelse>
	<cfset loc.ident = "IDENTITY">
</cfif>

<cfset tables = "users,photogalleries,photogalleryphotos,posts,authors,classifications,comments,profiles,tags,cities,shops,userphotos">
<cfloop list="#tables#" index="loc.i">
	<cftry>
		<cfquery name="loc.query" datasource="wheelstestdb">
		DROP VIEW #loc.i#
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry>
	<cftry>
		<cfquery name="loc.query" datasource="wheelstestdb">
		DROP TABLE #loc.i#
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry>
</cfloop>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE users
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	username varchar(50) NOT NULL,
	password varchar(50) NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	address varchar(100) NULL,
	city varchar(50) NULL,
	state char(2) NULL,
	zipcode varchar(50) NULL,
	phone varchar(20) NULL,
	fax varchar(20) NULL,
	birthday datetime NULL,
	birthdaymonth int NULL,
	birthdayyear int NULL,
	birthtime datetime NULL DEFAULT '2000-01-01 18:26:08.690',
	isactive bit NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE photogalleries
(
	photogalleryid int NOT NULL #loc.ident# PRIMARY KEY,
	userid int NOT NULL,
	title varchar(255) NOT NULL,
	description text NOT NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE photogalleryphotos
(
	photogalleryphotoid int NOT NULL #loc.ident# PRIMARY KEY,
	photogalleryid int NOT NULL,
	filename varchar(255) NOT NULL,
	description varchar(255) NOT NULL,
	filedata <cfif loc.db IS "microsoftsqlserver">image<cfelse>blob</cfif> NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE posts
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	authorid int NULL,
	title varchar(250) NOT NULL,
	body text NOT NULL,
	createdat datetime NOT NULL,
	updatedat datetime NOT NULL,
	deletedat datetime NULL,
	views int NOT NULL DEFAULT 0,
	averagerating float NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE authors
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	firstname varchar(100) NOT NULL,
	lastname varchar(100) NOT NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE classifications
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	postid int NOT NULL,
	tagid int NOT NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE comments
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	postid int NOT NULL,
	body text NOT NULL,
	name varchar(100) NOT NULL,
	url varchar(100) NULL,
	email varchar(100) NULL,
	createdat datetime NOT NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE profiles
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	authorid int NULL,
	dateofbirth datetime NOT NULL,
	bio text NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE tags
(
	id int NOT NULL #loc.ident# PRIMARY KEY,
	name varchar(50) NOT NULL,
	description varchar(50) NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE cities
(
	countyid char(4) NOT NULL,
	citycode tinyint NOT NULL,
	name varchar(50) NOT NULL,
	PRIMARY KEY(countyid,citycode)
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE TABLE shops
(
	shopid char(9) NOT NULL PRIMARY KEY,
	citycode tinyint NULL,
	name varchar(80) NOT NULL
)
</cfquery>

<cfquery name="loc.query" datasource="wheelstestdb">
CREATE VIEW userphotos AS
SELECT u.id AS userid, u.username AS username, u.firstname AS firstname, u.lastname AS lastname, pg.title AS title, pg.photogalleryid AS photogalleryid
FROM users u INNER JOIN photogalleries pg ON u.id = pg.userid;
</cfquery>

<!--- populate with data --->
<cfset loc.user = model("user").create(
	username='tonyp'
	,password='tonyp123'
	,firstname='Tony'
	,lastname='Petruzzi'
	,address='123 Petruzzi St.'
	,city='SomeWhere1'
	,state='TX'
	,zipcode='11111'
	,phone='1235551212'
	,fax='4565551212'
	,birthday='11/01/1975'
	,birthdaymonth=11
	,birthdayyear=1975
	,isactive=true
)>

<cfset loc.user = model("user").create(
	username='chrisp'
	,password='chrisp123'
	,firstname='Chris'
	,lastname='Peters'
	,address='456 Peters Dr.'
	,city='SomeWhere2'
	,state='LA'
	,zipcode='22222'
	,phone='1235552323'
	,fax='4565552323'
	,birthday='10/05/1972'
	,birthdaymonth=10
	,birthdayyear=1972
	,isactive=true
)>

<cfset loc.user = model("user").create(
	username='perd'
	,password='perd123'
	,firstname='Per'
	,lastname='Djurner'
	,address='789 Djurner Ave.'
	,city='SomeWhere3'
	,state='CA'
	,zipcode='44444'
	,phone='1235554545'
	,fax='4565554545'
	,birthday='09/12/1973'
	,birthdaymonth=9
	,birthdayyear=1973
	,isactive=true
)>

<cfset loc.user = model("user").create(
	username='raulr'
	,password='raulr23'
	,firstname='Raul'
	,lastname='Riera'
	,address='987 Riera Blvd.'
	,city='SomeWhere4'
	,state='WI'
	,zipcode='55555'
	,phone='1235558989'
	,fax='4565558989'
	,birthday='06/14/1981'
	,birthdaymonth=6
	,birthdayyear=1981
	,isactive=true
)>

<cfset loc.user = model("user").create(
	username='joeb'
	,password='joeb'
	,firstname='Joe'
	,lastname='Blow'
	,address='123 Petruzzi St.'
	,city='SomeWhere4'
	,state='CA'
	,zipcode='22222'
	,phone='1235551212'
	,fax='4565554545'
	,birthday='11/12/1973'
	,birthdaymonth=11
	,birthdayyear=1973
	,isactive=true
)>

<cfset loc.per = model("author").create(firstName="Per", lastName="Djurner")>
<cfset loc.per.createProfile(dateOfBirth="20/02/1975", bio="ColdFusion Developer")>
<cfset loc.per.createPost(title="Title for first test post", body="Text for first test post", views=5)>
<cfset loc.per.createPost(title="Title for second test post", body="Text for second test post", views=5, averageRating="3.6")>
<cfset loc.per.createPost(title="Title for third test post", body="Text for third test post", averageRating="3.2")>
<cfset loc.tony = model("author").create(firstName="Tony", lastName="Petruzzi")>
<cfset loc.tony.createPost(title="Title for fourth test post", body="Text for fourth test post", views=3, averageRating="3.6")>
<cfset loc.chris = model("author").create(firstName="Chris", lastName="Peters")>
<cfset loc.peter = model("author").create(firstName="Peter", lastName="Amiri")>
<cfset loc.james = model("author").create(firstName="James", lastName="Gibson")>
<cfset loc.raul = model("author").create(firstName="Raul", lastName="Riera")>
<cfset loc.andy = model("author").create(firstName="Andy", lastName="Bellenie")>

<cfset loc.users = model("user").findAll(order="id")>

<cfloop query="loc.users">
	<cfloop from="1" to="5" index="loc.i">
		<cfset loc.gallery = model("photogallery").create(
			userid="#loc.users.id#"
			,title="#loc.users.firstname# Test Galllery #loc.i#"
			,description="test gallery #loc.i# for #loc.users.firstname#"
		)>

		<cfloop from="1" to="10" index="loc.i2">
			<cfset loc.photo = model("photogalleryphoto").create(
				photogalleryid="#loc.gallery.photogalleryid#"
				,filename="Gallery #loc.gallery.photogalleryid# Photo Test #loc.i2#"
				,description1="test photo #loc.i2# for gallery #loc.gallery.photogalleryid#"
			)>
		</cfloop>
	</cfloop>
</cfloop>

<cfset loc.posts = model("post").findAll(order="id")>

<cfloop query="loc.posts">
	<cfloop from="1" to="3" index="loc.i">
		<cfset loc.comment = model("comment").create(
			postid=loc.posts.id
			,body="This is comment #loc.i#"
			,name="some commenter #loc.i#"
			, url="http://#loc.i#.somecommenter.com"
			, email="#loc.i#@#loc.i#.com"
		)>
	</cfloop>
</cfloop>

<!--- cities and shops --->
<cfloop from="1" to="5" index="loc.i">
	<cfset model("city").create(
		countyid="3"
		,citycode="#loc.i#"
		,name="county #loc.i#"
	)>

	<cfset model("shop").create(
		shopid="shop#loc.i#"
		,citycode="#loc.i#"
		,name="shop #loc.i#"
	)>
</cfloop>

<cfquery name="del" datasource="wheelstestdb">
DELETE
FROM tags
</cfquery>
<cfquery name="ins" datasource="wheelstestdb">
INSERT INTO tags (name, description)
VALUES ('releases', 'testdesc')
</cfquery>