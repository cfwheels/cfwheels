<!--- get the version of the database we're running against --->
<cftry>
	<cfdbinfo name="loc.dbinfo" datasource="#application.wheels.dataSourceName#" type="version">
	<cfcatch type="any">
		<cfthrow message="Datasource not found?" detail="The CFDBINFO call appears to have failed when looking for #application.wheels.dataSourceName#">
	</cfcatch>
</cftry>
<cfset loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))>

<!--- handle differences in database for identity inserts, column types etc--->
<cfset loc.storageEngine = "">
<cfset loc.dateTimeColumnType = "datetime">
<cfset loc.dateTimeDefault = "'2000-01-01 18:26:08.490'">
<cfset loc.binaryColumnType = "blob">
<cfset loc.textColumnType = "text">
<cfset loc.intColumnType = "int">
<cfset loc.floatColumnType = "float">
<cfset loc.identityColumnType = "">
<cfset loc.bitColumnType = "bit">
<cfset loc.bitColumnDefault = 0>

<cfif loc.db IS "microsoftsqlserver">
	<cfset loc.identityColumnType = "int NOT NULL IDENTITY(1,1)">
	<cfset loc.binaryColumnType = "image">
<cfelseif loc.db IS "mysql" or loc.db IS "mariadb">
	<cfset loc.identityColumnType = "int NOT NULL AUTO_INCREMENT">
	<cfset loc.storageEngine = "ENGINE=InnoDB">
<cfelseif loc.db IS "h2">
	<cfset loc.identityColumnType = "int NOT NULL IDENTITY">
<cfelseif loc.db IS "postgresql">
	<cfset loc.identityColumnType = "SERIAL NOT NULL">
	<cfset loc.dateTimeColumnType = "timestamp">
	<cfset loc.binaryColumnType = "bytea">
	<cfset loc.bitColumnType = "boolean">
	<cfset loc.bitColumnDefault = "false">
<cfelseif loc.db IS "oracle">
	<cfset loc.identityColumnType = "number(38,0) NOT NULL">
	<cfset loc.dateTimeColumnType = "timestamp">
	<cfset loc.textColumnType = "varchar2(4000)">
	<cfset loc.intColumnType = "number(38,0)">
	<cfset loc.floatColumnType = "number(38,2)">
	<cfset loc.dateTimeDefault = "to_timestamp(#loc.dateTimeDefault#,'yyyy-dd-mm hh24:mi:ss.FF')">
	<cfset loc.bitColumnType = "number(1)">
</cfif>

<!--- get a listing of all the tables and view in the database --->
<cfdbinfo name="loc.dbinfo" datasource="#application.wheels.dataSourceName#" type="tables">
<cfset loc.tableList = ValueList(loc.dbinfo.table_name, chr(7))>

<!--- list of views to delete --->
<cfset loc.views = "userphotos">
<cfloop list="#loc.views#" index="loc.i">
	<cfif ListFindNoCase(loc.tableList, loc.i, chr(7))>
		<cftry>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			DROP VIEW #loc.i#
			</cfquery>
			<cfcatch></cfcatch>
		</cftry>
	</cfif>
</cfloop>

<!--- list of tables to delete --->
<cfset loc.tables = "authors,cities,classifications,comments,photos,galleries,posts,profiles,shops,tags,users,collisiontests,combikeys,tblusers,sqltypes">
<cfloop list="#loc.tables#" index="loc.i">
	<cfif ListFindNoCase(loc.tableList, loc.i, chr(7))>
		<cftry>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			DROP TABLE #loc.i#
			</cfquery>
			<cfcatch></cfcatch>
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
	,citycode #loc.intColumnType# NOT NULL
	,name varchar(50) NOT NULL
	,PRIMARY KEY(countyid,citycode)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE classifications
(
	id #loc.identityColumnType#
	,postid #loc.intColumnType# NOT NULL
	,tagid #loc.intColumnType# NOT NULL
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
CREATE TABLE combikeys
(
	id1 int NOT NULL
	,id2 int NOT NULL
	,userId int NOT NULL
	,PRIMARY KEY(id1,id2)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE comments
(
	id #loc.identityColumnType#
	,postid #loc.intColumnType# NOT NULL
	,body #loc.textColumnType# NOT NULL
	,name varchar(100) NOT NULL
	,url varchar(100) NULL
	,email varchar(100) NULL
	,createdat #loc.datetimeColumnType# NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE galleries
(
	id #loc.identityColumnType#
	,userid #loc.intColumnType# NOT NULL
	,title varchar(255) NOT NULL
	,description #loc.textColumnType# NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE photos
(
	id #loc.identityColumnType#
	,galleryid #loc.intColumnType# NOT NULL
	,filename varchar(255) NOT NULL
	,description varchar(255) NOT NULL
	,filedata #loc.binaryColumnType# NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<!--- create a foreign key for testing automatic associations --->
<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
ALTER TABLE photos ADD CONSTRAINT fk_photos_galleryid FOREIGN KEY (galleryid) REFERENCES galleries(id)
</cfquery>

<!--- disable foreign key checks/constraints as the test data does not currently have referential integrity --->
<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
	<cfswitch expression="#loc.db#">
		<cfcase value="microsoftsqlserver">
			ALTER TABLE photos NOCHECK CONSTRAINT fk_photos_galleryid
		</cfcase>
		<cfcase value="mysql,mariadb">
			SET FOREIGN_KEY_CHECKS = 0
		</cfcase>
		<cfcase value="h2">
			SET REFERENTIAL_INTEGRITY FALSE
		</cfcase>
		<cfcase value="postgresql">
			ALTER TABLE photos DISABLE TRIGGER ALL
		</cfcase>
		<cfcase value="oracle">
			ALTER TABLE photos DISABLE CONSTRAINT fk_photos_galleryid
		</cfcase>
	</cfswitch>
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE posts
(
	id #loc.identityColumnType#
	,authorid #loc.intColumnType# NULL
	,title varchar(250) NOT NULL
	,body #loc.textColumnType# NOT NULL
	,createdat #loc.datetimeColumnType# NOT NULL
	,updatedat #loc.datetimeColumnType# NOT NULL
	,deletedat #loc.datetimeColumnType# NULL
	,views #loc.intColumnType# DEFAULT 0 NOT NULL
	,averagerating #loc.floatColumnType# NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE profiles
(
	id #loc.identityColumnType#
	,authorid #loc.intColumnType# NULL
	,dateofbirth #loc.datetimeColumnType# NOT NULL
	,bio #loc.textColumnType# NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE shops
(
	shopid char(9) NOT NULL
	,citycode #loc.intColumnType# NULL
	,name varchar(80) NOT NULL
	,PRIMARY KEY(shopid)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE sqltypes
(
	id #loc.identityColumnType#
	,booleanType #loc.bitColumnType# DEFAULT #loc.bitColumnDefault# NOT NULL
	,binaryType #loc.binaryColumnType# NULL
	,dateTimeType #loc.datetimeColumnType# DEFAULT #PreserveSingleQuotes(loc.dateTimeDefault)# NOT NULL
	,floatType #loc.floatColumnType# DEFAULT 1.25 NULL
	,intType #loc.intColumnType# DEFAULT 1 NOT NULL
	,stringType char(4) DEFAULT 'blah' NOT NULL
	,stringVariableType varchar(80) NOT NULL
	,textType #loc.textColumnType# NOT NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE tags
(
	id #loc.identityColumnType#
	,parentid #loc.intColumnType# NULL
	,name varchar(50) NULL
	,description varchar(50) NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE TABLE tblusers
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
	,birthdaymonth #loc.intColumnType# NULL
	,birthdayyear #loc.intColumnType# NULL
	,birthtime #loc.datetimeColumnType# DEFAULT #PreserveSingleQuotes(loc.dateTimeDefault)# NOT NULL
	,isactive #loc.intColumnType# NULL
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
	,birthdaymonth #loc.intColumnType# NULL
	,birthdayyear #loc.intColumnType# NULL
	,birthtime #loc.datetimeColumnType# DEFAULT #PreserveSingleQuotes(loc.dateTimeDefault)# NOT NULL
	,isactive #loc.intColumnType# NULL
	,PRIMARY KEY(id)
) #loc.storageEngine#
</cfquery>

<!--- create oracle sequences --->
<cfif loc.db eq "oracle">
	<cfloop list="#loc.tables#" index="loc.i">
		<cfif !ListFindNoCase("cities,shops,combikeys", loc.i)>
			<cfset loc.seq = "#loc.i#_seq">
			<cftry>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			DROP SEQUENCE #loc.seq#
			</cfquery>
			<cfcatch></cfcatch>
			</cftry>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			CREATE SEQUENCE #loc.seq# START WITH 1 INCREMENT BY 1
			</cfquery>
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			CREATE TRIGGER bi_#loc.i# BEFORE INSERT ON #loc.i# FOR EACH ROW BEGIN SELECT #loc.seq#.nextval INTO :NEW.<cfif loc.i IS "photogalleries">photogalleryid<cfelseif loc.i IS "photogalleryphotos">photogalleryphotoid<cfelse>id</cfif> FROM dual; END;
			</cfquery>
		</cfif>
	</cfloop>
</cfif>


<!---
create views
 --->
<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
CREATE VIEW userphotos AS
SELECT u.id AS userid, u.username AS username, u.firstname AS firstname, u.lastname AS lastname, g.title AS title, g.id AS galleryid
FROM users u INNER JOIN galleries g ON u.id = g.userid
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
<cfset loc.tony.createPost(title="Title for fifth test post", body="Text for fifth test post", views=2, averageRating="3.6")>
<cfset loc.chris = model("author").create(firstName="Chris", lastName="Peters")>
<cfset loc.peter = model("author").create(firstName="Peter", lastName="Amiri")>
<cfset loc.james = model("author").create(firstName="James", lastName="Gibson")>
<cfset loc.raul = model("author").create(firstName="Raul", lastName="Riera")>
<cfset loc.andy = model("author").create(firstName="Andy", lastName="Bellenie")>

<cfset loc.users = model("user").findAll(order="id")>

<cfloop query="loc.users">
	<cfloop from="1" to="5" index="loc.i">
		<cfset loc.gallery = model("gallery").create(
			userid="#loc.users.id#"
			,title="#loc.users.firstname# Test Galllery #loc.i#"
			,description="test gallery #loc.i# for #loc.users.firstname#"
		)>

		<cfloop from="1" to="10" index="loc.i2">
			<cfset loc.photo = model("photo").create(
				galleryid="#loc.gallery.id#"
				,filename="Gallery #loc.gallery.id# Photo Test #loc.i2#"
				,description1="test photo #loc.i2# for gallery #loc.gallery.id#"
			)>
		</cfloop>
	</cfloop>
</cfloop>

<cfset model("user2").create(username="Chris", password="x", firstName="x", lastName="x")>
<cfset model("user2").create(username="Tim", password="x", firstName="x", lastName="x")>
<cfset model("user2").create(username="Tom", password="x", firstName="x", lastName="x")>

<!--- create a profile with an author --->
<cfset model("profile").create(dateOfBirth="1/1/1970", bio="Unknown Author")>

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
		id="3"
		,citycode="#loc.i#"
		,name="county #loc.i#"
	)>

	<cfset model("shop").create(
		shopid="shop#loc.i#"
		,citycode="#loc.i#"
		,name="shop #loc.i#"
	)>
</cfloop>

<cfset model("shop").create(shopid=" shop6", citycode=0, name="x")>

<!--- tags --->
<cfset loc.releases = model("tag").create(name="releases",description="testdesc")>
<cfset model("tag").create(name="minor",description="a minor release", parentid=3)>
<cfset model("tag").create(name="major",description="a major release")>
<cfset model("tag").create(name="point",description="a point release", parentid=2)>

<cfset loc.fruit = model("tag").create(name="fruit",description="something to eat")>
<cfset model("tag").create(name="apple",description="ummmmmm good", parentid=loc.fruit.id)>
<cfset model("tag").create(name="pear",description="rhymes with Per", parentid=loc.fruit.id)>
<cfset model("tag").create(name="banana",description="peal it", parentid=loc.fruit.id)>

<!--- classifications --->
<cfset model("classification").create(postid=1,tagid=7)>

<!--- collisiontests --->
<cfset model("collisiontest").create(
	method="test"
)>

<!--- collisiontests --->
<cfloop from="1" to="5" index="i">
	<cfloop from="1" to="5" index="a">
		<cfset model("CombiKey").create(
			id1="#i#",
			id2="#a#",
			userId="#a#"
		)>
	</cfloop>
</cfloop>

<!--- sqltype --->
<cfset model("sqltype").create(
	stringVariableType="tony"
	,textType="blah blah blah blah"
)>

<!--- assign posts for multiple join test --->
<cfset loc.andy.update(favouritePostId=1, leastFavouritePostId=2)>
