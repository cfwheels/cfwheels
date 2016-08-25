<cfscript>
// get the version of the database we're running against
try {
	loc.dbinfo = $dbinfo(datasource=application.wheels.dataSourceName, type="version");
} catch(any e) {
	$throw(message="Datasource not found?", detail="The CFDBINFO call appears to have failed when looking for #application.wheels.dataSourceName#");
}
loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))

// handle differences in database for identity inserts, column types etc
loc.storageEngine = "";
loc.dateTimeColumnType = "datetime";
loc.dateTimeDefault = "'2000-01-01 18:26:08.490'";
loc.binaryColumnType = "blob";
loc.textColumnType = "text";
loc.intColumnType = "int";
loc.floatColumnType = "float";
loc.identityColumnType = "";
loc.bitColumnType = "bit";
loc.bitColumnDefault = 0;

if (loc.db IS "microsoftsqlserver") {
	loc.identityColumnType = "int NOT NULL IDENTITY(1,1)";
	loc.binaryColumnType = "image";
} else if (loc.db IS "mysql" or loc.db IS "mariadb") {
	loc.identityColumnType = "int NOT NULL AUTO_INCREMENT";
	loc.storageEngine = "ENGINE=InnoDB";
} else if (loc.db IS "h2") {
	loc.identityColumnType = "int NOT NULL IDENTITY";
} else if (loc.db IS "postgresql") {
	loc.identityColumnType = "SERIAL NOT NULL";
	loc.dateTimeColumnType = "timestamp";
	loc.binaryColumnType = "bytea";
	loc.bitColumnType = "boolean";
	loc.bitColumnDefault = "false";
} else if (loc.db IS "oracle") {
	loc.identityColumnType = "number(38,0) NOT NULL";
	loc.dateTimeColumnType = "timestamp";
	loc.textColumnType = "varchar2(4000)";
	loc.intColumnType = "number(38,0)";
	loc.floatColumnType = "number(38,2)";
	loc.dateTimeDefault = "to_timestamp(#loc.dateTimeDefault#,'yyyy-dd-mm hh24:mi:ss.FF')";
	loc.bitColumnType = "number(1)";
}

// get a listing of all the tables and view in the database
loc.dbinfo = $dbinfo(datasource=application.wheels.dataSourceName, type="tables");
loc.tableList = ValueList(loc.dbinfo.table_name, Chr(7));

// list of tables to delete
loc.tables = "authors,cities,classifications,comments,galleries,photos,posts,profiles,shops,tags,users,collisiontests,combikeys,tblusers,sqltypes";
for (loc.i in loc.tables) {
	if (ListFindNoCase(loc.tableList, loc.i, Chr(7))) {
		try {
			$query(datasource=application.wheels.dataSourceName, sql="DROP TABLE #loc.i#");
		} catch(any e) {
			// skip on fail
		}
	}
};

// list of views to delete
loc.views = "userphotos";
for (loc.i in loc.views) {
	if (ListFindNoCase(loc.tableList, loc.i, Chr(7))) {
		try {
			$query(datasource=application.wheels.dataSourceName, sql="DROP VIEW #loc.i#");
		} catch(any e) {
			// skip on fail
		}
	}
};

// create tables
$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE authors
		(
			id #loc.identityColumnType#
			,firstname varchar(100) NOT NULL
			,lastname varchar(100) NOT NULL
			,PRIMARY KEY(id)
		) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE cities
	(
		countyid char(4) NOT NULL
		,citycode #loc.intColumnType# NOT NULL
		,name varchar(50) NOT NULL
		,PRIMARY KEY(countyid,citycode)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE classifications
	(
		id #loc.identityColumnType#
		,postid #loc.intColumnType# NOT NULL
		,tagid #loc.intColumnType# NOT NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE collisiontests
	(
		id #loc.identityColumnType#
		,method varchar(100) NOT NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE combikeys
	(
		id1 int NOT NULL
		,id2 int NOT NULL
		,userId int NOT NULL
		,PRIMARY KEY(id1,id2)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
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
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE galleries
	(
		id #loc.identityColumnType#
		,userid #loc.intColumnType# NOT NULL
		,title varchar(255) NOT NULL
		,description #loc.textColumnType# NOT NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE photos
	(
		id #loc.identityColumnType#
		,galleryid #loc.intColumnType# NOT NULL
		,filename varchar(255) NOT NULL
		,description varchar(255) NOT NULL
		,filedata #loc.binaryColumnType# NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
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
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE profiles
	(
		id #loc.identityColumnType#
		,authorid #loc.intColumnType# NULL
		,dateofbirth #loc.datetimeColumnType# NOT NULL
		,bio #loc.textColumnType# NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE shops
	(
		shopid char(9) NOT NULL
		,citycode #loc.intColumnType# NULL
		,name varchar(80) NOT NULL
		,PRIMARY KEY(shopid)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE sqltypes
	(
		id #loc.identityColumnType#
		,booleanType #loc.bitColumnType# DEFAULT #loc.bitColumnDefault# NOT NULL
		,binaryType #loc.binaryColumnType# NULL
		,dateTimeType #loc.datetimeColumnType# DEFAULT #loc.dateTimeDefault# NOT NULL
		,floatType #loc.floatColumnType# DEFAULT 1.25 NULL
		,intType #loc.intColumnType# DEFAULT 1 NOT NULL
		,stringType char(4) DEFAULT 'blah' NOT NULL
		,stringVariableType varchar(80) NOT NULL
		,textType #loc.textColumnType# NOT NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
	CREATE TABLE tags
	(
		id #loc.identityColumnType#
		,parentid #loc.intColumnType# NULL
		,name varchar(50) NULL
		,description varchar(50) NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
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
		,birthtime #loc.datetimeColumnType# DEFAULT #loc.dateTimeDefault# NULL
		,isactive #loc.intColumnType# NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
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
		,birthtime #loc.datetimeColumnType# DEFAULT #loc.dateTimeDefault# NULL
		,isactive #loc.intColumnType# NULL
		,PRIMARY KEY(id)
	) #loc.storageEngine#
	"
);
</cfscript>

<!--- create oracle sequences --->
<cfif loc.db eq "oracle">
	<cfloop list="#loc.tables#" index="loc.i">
		<cfif !ListFindNoCase("cities,shops,combikeys", loc.i)>
			<cfscript>
			loc.seq = "#loc.i#_seq";
			try {
				$query(datasource=application.wheels.dataSourceName, sql="DROP SEQUENCE #loc.seq#");
			} catch(any e) {
				// skip on fail
			}
			$query(datasource=application.wheels.dataSourceName, sql="CREATE SEQUENCE #loc.seq# START WITH 1 INCREMENT BY 1");
			</cfscript>
			<!--- it seems ANY change to this query causes syntax errors in Travis CI --->
			<cfquery name="loc.query" datasource="#application.wheels.dataSourceName#">
			CREATE TRIGGER bi_#loc.i# BEFORE INSERT ON #loc.i# FOR EACH ROW BEGIN SELECT #loc.seq#.nextval INTO :NEW.<cfif loc.i IS "photogalleries">photogalleryid<cfelseif loc.i IS "photogalleryphotos">photogalleryphotoid<cfelse>id</cfif> FROM dual; END;
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<cfscript>
// create view
$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE VIEW userphotos AS
		SELECT u.id AS userid, u.username AS username, u.firstname AS firstname, u.lastname AS lastname, g.title AS title, g.id AS galleryid
		FROM users u INNER JOIN galleries g ON u.id = g.userid
	"
);

// populate with data
loc.user = model("user").create(
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
);

loc.user = model("user").create(
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
);

loc.user = model("user").create(
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
);

loc.user = model("user").create(
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
);

loc.user = model("user").create(
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
);

loc.per = model("author").create(firstName="Per", lastName="Djurner");
loc.per.createProfile(dateOfBirth="20/02/1975", bio="ColdFusion Developer");
loc.per.createPost(title="Title for first test post", body="Text for first test post", views=5);
loc.per.createPost(title="Title for second test post", body="Text for second test post", views=5, averageRating="3.6");
loc.per.createPost(title="Title for third test post", body="Text for third test post", averageRating="3.2");
loc.tony = model("author").create(firstName="Tony", lastName="Petruzzi");
loc.tony.createPost(title="Title for fourth test post", body="Text for fourth test post", views=3, averageRating="3.6");
loc.tony.createPost(title="Title for fifth test post", body="Text for fifth test post", views=2, averageRating="3.6");
loc.chris = model("author").create(firstName="Chris", lastName="Peters");
loc.peter = model("author").create(firstName="Peter", lastName="Amiri");
loc.james = model("author").create(firstName="James", lastName="Gibson");
loc.raul = model("author").create(firstName="Raul", lastName="Riera");
loc.andy = model("author").create(firstName="Andy", lastName="Bellenie");
loc.users = model("user").findAll(order="id");
for (loc.user in loc.users) {
	for (loc.i in [1,2,3,4,5]) {
		loc.gallery = model("gallery").create(
			userid=loc.users.id
			,title="#loc.users.firstname# Test Galllery #loc.i#"
			,description="test gallery #loc.i# for #loc.users.firstname#"
		);
		for (loc.j in [1,2,3,4,5,6,7,8,9,10]) {
			model("photo").create(
				galleryid=loc.gallery.id
				,filename="Gallery #loc.gallery.id# Photo Test #loc.j#"
				,description1="test photo #loc.j# for gallery #loc.gallery.id#"
			)
		};
	};
};

model("user2").create(username="Chris", password="x", firstName="x", lastName="x");
model("user2").create(username="Tim", password="x", firstName="x", lastName="x");
model("user2").create(username="Tom", password="x", firstName="x", lastName="x");

// create a profile with an author
model("profile").create(dateOfBirth="1/1/1970", bio="Unknown Author");
loc.posts = model("post").findAll(order="id");
for (loc.post in loc.posts) {
	for (loc.i in [1,2,3]) {
		model("comment").create(
			postid=loc.post.id
			,body="This is comment #loc.i#"
			,name="some commenter #loc.i#"
			,url="http://#loc.i#.somecommenter.com"
			,email="#loc.i#@#loc.i#.com"
		);
	};
};

// cities and shops
for (loc.i in [1,2,3,4,5]) {
	model("city").create(id="3", citycode=loc.i, name="county #loc.i#");
	model("shop").create(shopid="shop#loc.i#", citycode=loc.i, name="shop #loc.i#");
};
model("shop").create(shopid=" shop6", citycode=0, name="x");

// tags
loc.releases = model("tag").create(name="releases", description="testdesc");
model("tag").create(name="minor", description="a minor release", parentid=3);
model("tag").create(name="major", description="a major release");
model("tag").create(name="point", description="a point release", parentid=2);
loc.fruit = model("tag").create(name="fruit", description="something to eat");
model("tag").create(name="apple", description="ummmmmm good", parentid=loc.fruit.id);
model("tag").create(name="pear", description="rhymes with Per", parentid=loc.fruit.id);
model("tag").create(name="banana", description="peal it", parentid=loc.fruit.id);

// classifications
model("classification").create(postid=1,tagid=7);

// collisiontests
model("collisiontest").create(method="test");
for (loc.i in [1,2,3,4,5]) {
	for (loc.j in [1,2,3,4,5]) {
		model("CombiKey").create(id1=loc.i, id2=loc.j, userId=loc.j);
	};
};

// sqltype
model("sqltype").create(stringVariableType="tony", textType="blah blah blah blah");

// assign posts for multiple join test
loc.andy.update(favouritePostId=1, leastFavouritePostId=2);
</cfscript>
