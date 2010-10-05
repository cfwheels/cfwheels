<!--- get the version of the database we're running against --->
<cfdbinfo name="loc.dbinfo" datasource="#application.wheels.dataSourceName#" type="version">
<cfset loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))>

<!--- handle differences in database for identity inserts, column types etc--->
<cfset loc.storageEngine = "">
<cfset loc.dateTimeColumnType = "datetime">
<cfset loc.dateTimeDefault = "'2000-01-01 18:26:08.690'">
<cfset loc.binaryColumnType = "blob">
<cfset loc.textColumnType = "text">
<cfset loc.identityColumnType = "">

<cfif loc.db IS "microsoftsqlserver">
	<cfset loc.identityColumnType = "int NOT NULL IDENTITY(1,1)">
	<cfset loc.binaryColumnType = "image">
<cfelseif loc.db IS "mysql">
	<cfset loc.identityColumnType = "int NOT NULL AUTO_INCREMENT">
	<cfset loc.storageEngine = "ENGINE=InnoDB">
<cfelseif loc.db IS "h2">
	<cfset loc.identityColumnType = "int NOT NULL IDENTITY">
<cfelseif loc.db IS "postgresql">
	<cfset loc.identityColumnType = "SERIAL NOT NULL">
	<cfset loc.dateTimeColumnType = "timestamp">
	<cfset loc.binaryColumnType = "bytea">
<cfelseif loc.db IS "oracle">
	<cfset loc.identityColumnType = "int NOT NULL">
	<cfset loc.dateTimeColumnType = "timestamp">
	<cfset loc.textColumnType = "long">
	<cfset loc.dateTimeDefault = "to_timestamp(#loc.dateTimeDefault#,'yyyy-dd-mm hh24:mi:ss.FF')">
</cfif>

<!--- get a listing of all the tables and view in the database --->
<cfdbinfo name="loc.dbinfo" datasource="#application.wheels.dataSourceName#" type="tables">
<cfset loc.tableList = ValueList(loc.dbinfo.table_name, chr(7))>

<!--- list of tables to delete --->
<cfset loc.tables = "authors,cities,classifications,comments,photogalleries,photogalleryphotos,posts,profiles,shops,tags,users,collisiontests">
<cfloop list="#loc.tables#" index="loc.i">
	<cfif ListFindNoCase(loc.tableList, loc.i, chr(7))>
		<cftry>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			DROP TABLE #loc.i#
			</cfquery>
			<cfcatch>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>

<!--- list of views to delete --->
<cfset loc.views = "userphotos">
<cfloop list="#loc.views#" index="loc.i">
	<cfif ListFindNoCase(loc.tableList, loc.i, chr(7))>
		<cftry>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			DROP VIEW #loc.i#
			</cfquery>
			<cfcatch>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>


<!---
create tables
 --->
<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE authors
(
	id #loc.identityColumnType#
	,firstname varchar(100) NOT NULL
	,lastname varchar(100) NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE cities
(
	countyid char(4) NOT NULL
	,citycode int NOT NULL
	,name varchar(50) NOT NULL
	,PRIMARY KEY(countyid,citycode)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE classifications
(
	id #loc.identityColumnType#
	,postid int NOT NULL
	,tagid int NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE collisiontests
(
	id #loc.identityColumnType#
	,method varchar(100) NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE comments
(
	id #loc.identityColumnType#
	,postid int NOT NULL
	,body #loc.textColumnType# NOT NULL
	,name varchar(100) NOT NULL
	,url varchar(100) NULL
	,email varchar(100) NULL
	,createdat #loc.datetimeColumnType# NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE photogalleries
(
	photogalleryid #loc.identityColumnType#
	,userid int NOT NULL
	,title varchar(255) NOT NULL
	,description #loc.textColumnType# NOT NULL
	,PRIMARY KEY(photogalleryid)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE photogalleryphotos
(
	photogalleryphotoid #loc.identityColumnType#
	,photogalleryid int NOT NULL
	,filename varchar(255) NOT NULL
	,description varchar(255) NOT NULL
	,filedata #loc.binaryColumnType# NULL
	,PRIMARY KEY(photogalleryphotoid)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE posts
(
	id #loc.identityColumnType#
	,authorid int NULL
	,title varchar(250) NOT NULL
	,body #loc.textColumnType# NOT NULL
	,createdat #loc.datetimeColumnType# NOT NULL
	,updatedat #loc.datetimeColumnType# NOT NULL
	,deletedat #loc.datetimeColumnType# NULL
	,views int DEFAULT 0 NOT NULL
	,averagerating float NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE profiles
(
	id #loc.identityColumnType#
	,authorid int NULL
	,dateofbirth #loc.datetimeColumnType# NOT NULL
	,bio #loc.textColumnType# NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE shops
(
	shopid char(9) NOT NULL
	,citycode int NULL
	,name varchar(80) NOT NULL
	,PRIMARY KEY(shopid)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE tags
(
	id #loc.identityColumnType#
	,name varchar(50) NOT NULL
	,description varchar(50) NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE users
(
	id #loc.identityColumnType#
	,username varchar(50) NOT NULL
	,password varchar(50) NOT NULL
	,firstname varchar(50) NOT NULL
	,lastname varchar(50) NOT NULL
	,address varchar(100) NULL
	,city varchar(50) NULL
	,state char(2) NULL
	,zipcode varchar(50) NULL
	,phone varchar(20) NULL
	,fax varchar(20) NULL
	,birthday #loc.datetimeColumnType# NULL
	,birthdaymonth int NULL
	,birthdayyear int NULL
	,birthtime #loc.datetimeColumnType# DEFAULT #PreserveSingleQuotes(loc.dateTimeDefault)# NULL
	,isactive int NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<!---
create views
 --->
<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE VIEW userphotos AS
SELECT u.id AS userid, u.username AS username, u.firstname AS firstname, u.lastname AS lastname, pg.title AS title, pg.photogalleryid AS photogalleryid
FROM users u INNER JOIN photogalleries pg ON u.id = pg.userid
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
	,isactive=1
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
	,isactive=1
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
	,isactive=1
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
	,isactive=1
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
	,isactive=1
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

<!--- tags --->
<cfset model("tag").create(
	name="releases"
	,description="testdesc"
)>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
INSERT INTO collisiontests (method)
VALUES ('test')
</cfquery>