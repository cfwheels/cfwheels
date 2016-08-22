<cfscript>
db = {};
// get the database engine we're running against
try {
	db.info = $dbinfo(datasource=application.wheels.dataSourceName, type="version");
} catch(any e) {
	$throw(message="Datasource not found?", detail="The CFDBINFO call appears to have failed when looking for #application.wheels.dataSourceName#");
}

db.engine = LCase(Replace(db.info.database_productname, " ", "", "all"));

// handle differences in database for identity inserts, column types etc
db.storageEngine = "";
db.dateTimeColumnType = "datetime";
db.dateTimeDefault = "'2000-01-01 18:26:08.490'";
db.binaryColumnType = "blob";
db.textColumnType = "text";
db.intColumnType = "int";
db.floatColumnType = "float";
db.identityColumnType = "";
db.bitColumnType = "bit";
db.bitColumnDefault = 0;

if (db.engine IS "microsoftsqlserver") {
	db.identityColumnType = "int NOT NULL IDENTITY(1,1)";
	db.binaryColumnType = "image";
} else if (db.engine IS "mysql" or db.engine IS "mariadb") {
	db.identityColumnType = "int NOT NULL AUTO_INCREMENT";
	db.storageEngine = "ENGINE=InnoDB";
} else if (db.engine IS "h2") {
	db.identityColumnType = "int NOT NULL IDENTITY";
} else if (db.engine IS "postgresql") {
	db.identityColumnType = "SERIAL NOT NULL";
	db.dateTimeColumnType = "timestamp";
	db.binaryColumnType = "bytea";
	db.bitColumnType = "boolean";
	db.bitColumnDefault = "false";
} else if (db.engine IS "oracle") {
	db.identityColumnType = "number(38,0) NOT NULL";
	db.dateTimeColumnType = "timestamp";
	db.textColumnType = "varchar2(4000)";
	db.intColumnType = "number(38,0)";
	db.floatColumnType = "number(38,2)";
	db.dateTimeDefault = "to_timestamp(#db.dateTimeDefault#,'yyyy-dd-mm hh24:mi:ss.FF')";
	db.bitColumnType = "number(1)";
}

// get a listing of all the tables and view in the database
db.tableQuery = $dbinfo(datasource=application.wheels.dataSourceName, type="tables");
db.tableList = ValueList(db.tableQuery.table_name, Chr(7));

// drop tables
db.tables = "authors,cities,classifications,comments,galleries,photos,posts,profiles,shops,tags,users,collisiontests,combikeys,tblusers,sqltypes";
for (db.i in db.tables) {
	if (ListFindNoCase(db.tableList, db.i, Chr(7))) {
		try {
			db.query = $query(datasource=application.wheels.dataSourceName, sql="DROP TABLE #db.i#");
		} catch(any e) {
		}
	}
};

// drop views
db.views = "userphotos";
for (db.i in db.views) {
	if (ListFindNoCase(db.tableList, db.i, Chr(7))) {
		try {
			db.query = $query(datasource=application.wheels.dataSourceName, sql="DROP VIEW #db.i#");
		} catch(any e) {
		}
	}
};

// create tables
$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE authors
		(
			id #db.identityColumnType#
			,firstname varchar(100) NOT NULL
			,lastname varchar(100) NOT NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE cities
		(
			countyid char(4) NOT NULL
			,citycode #db.intColumnType# NOT NULL
			,name varchar(50) NOT NULL
			,PRIMARY KEY(countyid,citycode)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE classifications
		(
			id #db.identityColumnType#
			,postid #db.intColumnType# NOT NULL
			,tagid #db.intColumnType# NOT NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE collisiontests
		(
			id #db.identityColumnType#
			,method varchar(100) NOT NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
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
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE comments
		(
			id #db.identityColumnType#
			,postid #db.intColumnType# NOT NULL
			,body #db.textColumnType# NOT NULL
			,name varchar(100) NOT NULL
			,url varchar(100) NULL
			,email varchar(100) NULL
			,createdat #db.datetimeColumnType# NOT NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE galleries
		(
			id #db.identityColumnType#
			,userid #db.intColumnType# NOT NULL
			,title varchar(255) NOT NULL
			,description #db.textColumnType# NOT NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE photos
		(
			id #db.identityColumnType#
			,galleryid #db.intColumnType# NOT NULL
			,filename varchar(255) NOT NULL
			,description varchar(255) NOT NULL
			,filedata #db.binaryColumnType# NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE posts
		(
			id #db.identityColumnType#
			,authorid #db.intColumnType# NULL
			,title varchar(250) NOT NULL
			,body #db.textColumnType# NOT NULL
			,createdat #db.datetimeColumnType# NOT NULL
			,updatedat #db.datetimeColumnType# NOT NULL
			,deletedat #db.datetimeColumnType# NULL
			,views #db.intColumnType# DEFAULT 0 NOT NULL
			,averagerating #db.floatColumnType# NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE profiles
		(
			id #db.identityColumnType#
			,authorid #db.intColumnType# NULL
			,dateofbirth #db.datetimeColumnType# NOT NULL
			,bio #db.textColumnType# NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE shops
		(
			shopid char(9) NOT NULL
			,citycode #db.intColumnType# NULL
			,name varchar(80) NOT NULL
			,PRIMARY KEY(shopid)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE sqltypes
		(
			id #db.identityColumnType#
			,booleanType #db.bitColumnType# DEFAULT #db.bitColumnDefault# NOT NULL
			,binaryType #db.binaryColumnType# NULL
			,dateTimeType #db.datetimeColumnType# DEFAULT #PreserveSingleQuotes(db.dateTimeDefault)# NOT NULL
			,floatType #db.floatColumnType# DEFAULT 1.25 NULL
			,intType #db.intColumnType# DEFAULT 1 NOT NULL
			,stringType char(4) DEFAULT 'blah' NOT NULL
			,stringVariableType varchar(80) NOT NULL
			,textType #db.textColumnType# NOT NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE tags
		(
			id #db.identityColumnType#
			,parentid #db.intColumnType# NULL
			,name varchar(50) NULL
			,description varchar(50) NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE tblusers
		(
			id #db.identityColumnType#
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
			,birthday #db.datetimeColumnType# NULL
			,birthdaymonth #db.intColumnType# NULL
			,birthdayyear #db.intColumnType# NULL
			,birthtime #db.datetimeColumnType# DEFAULT #PreserveSingleQuotes(db.dateTimeDefault)# NULL
			,isactive #db.intColumnType# NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE TABLE users
		(
			id #db.identityColumnType#
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
			,birthday #db.datetimeColumnType# NULL
			,birthdaymonth #db.intColumnType# NULL
			,birthdayyear #db.intColumnType# NULL
			,birthtime #db.datetimeColumnType# DEFAULT #PreserveSingleQuotes(db.dateTimeDefault)# NULL
			,isactive #db.intColumnType# NULL
			,PRIMARY KEY(id)
		) #db.storageEngine#
	"
);

// create oracle sequences
if (db.engine eq "oracle") {
	for (db.i in db.tables) {
		if (!ListFindNoCase("cities,shops,combikeys", db.i)) {
			if (db.i eq "photogalleries") {
				local.col = "photogalleryid";
			} else if (db.i eq "photogalleryphotos") {
				local.col = "photogalleryphotoid";
			} else {
				local.col = "id";
			}
			db.seq = "#db.i#_seq";
			try {
				$query(
					datasource=application.wheels.dataSourceName,
					sql="DROP SEQUENCE #db.seq#"
				);
			} catch(any e) {
			}
			$query(
				datasource=application.wheels.dataSourceName,
				sql="CREATE SEQUENCE #db.seq# START WITH 1 INCREMENT BY 1"
			);
			$query(
				datasource=application.wheels.dataSourceName,
				sql="CREATE TRIGGER bi_#db.i# BEFORE INSERT ON #db.i# FOR EACH ROW BEGIN SELECT #db.seq#.nextval INTO :NEW.#local.col# FROM dual; END;"
			);
		}
	};
}

// create views
$query(
	datasource=application.wheels.dataSourceName,
	sql="
		CREATE VIEW userphotos AS
		SELECT u.id AS userid, u.username AS username, u.firstname AS firstname, u.lastname AS lastname, g.title AS title, g.id AS galleryid
		FROM users u INNER JOIN galleries g ON u.id = g.userid
	"
);

// populate with data
db.user = model("user").create(
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
db.user = model("user").create(
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
db.user = model("user").create(
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
db.user = model("user").create(
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
db.user = model("user").create(
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

db.per = model("author").create(firstName="Per", lastName="Djurner");
db.per.createProfile(dateOfBirth="20/02/1975", bio="ColdFusion Developer");
db.per.createPost(title="Title for first test post", body="Text for first test post", views=5);
db.per.createPost(title="Title for second test post", body="Text for second test post", views=5, averageRating="3.6");
db.per.createPost(title="Title for third test post", body="Text for third test post", averageRating="3.2");
db.tony = model("author").create(firstName="Tony", lastName="Petruzzi");
db.tony.createPost(title="Title for fourth test post", body="Text for fourth test post", views=3, averageRating="3.6");
db.tony.createPost(title="Title for fifth test post", body="Text for fifth test post", views=2, averageRating="3.6");
db.chris = model("author").create(firstName="Chris", lastName="Peters");
db.peter = model("author").create(firstName="Peter", lastName="Amiri");
db.james = model("author").create(firstName="James", lastName="Gibson");
db.raul = model("author").create(firstName="Raul", lastName="Riera");
db.andy = model("author").create(firstName="Andy", lastName="Bellenie");
db.tom = model("author").create(firstName="Tom", lastName="King");
db.adam = model("author").create(firstName="Adam", lastName="Chapman");
db.users = model("user").findAll(order="id");

for (db.user in db.users) {
	for (db.i in [1,2,3,4,5]) {
		db.gallery = model("gallery").create(
			userid="#db.user.id#"
			,title="#db.user.firstname# Test Galllery #db.i#"
			,description="test gallery #db.i# for #db.user.firstname#"
		);
		for (db.j in [1,2,3,4,5,6,7,8,9,10]) {
			db.photo = model("photo").create(
				galleryid="#db.gallery.id#"
				,filename="Gallery #db.gallery.id# Photo Test #db.j#"
				,description1="test photo #db.j# for gallery #db.gallery.id#"
			);
		};
	};
};

model("user2").create(username="Chris", password="x", firstName="x", lastName="x");
model("user2").create(username="Tim", password="x", firstName="x", lastName="x");
model("user2").create(username="Tom", password="x", firstName="x", lastName="x");
// create a profile with an author
model("profile").create(dateOfBirth="1/1/1970", bio="Unknown Author");

db.posts = model("post").findAll(order="id");
for (db.post in db.posts) {
	for (db.i in [1,2,3]) {
		db.comment = model("comment").create(
			postid=db.post.id
			,body="This is comment #db.i#"
			,name="some commenter #db.i#"
			,url="http://#db.i#.somecommenter.com"
			,email="#db.i#@#db.i#.com"
		);
	};
};

// cities and shops
for (db.i in [1,2,3,4,5]) {
	model("city").create(id=3, citycode=db.i, name="county #db.i#");
	model("shop").create(shopid="shop#db.i#", citycode=db.i, name="shop #db.i#");
};
model("shop").create(shopid=" shop6", citycode=0, name="x");

// tags
db.releases = model("tag").create(name="releases",description="testdesc");
model("tag").create(name="minor", description="a minor release", parentid=3);
model("tag").create(name="major", description="a major release");
model("tag").create(name="point", description="a point release", parentid=2);

db.fruit = model("tag").create(name="fruit", description="something to eat");
model("tag").create(name="apple", description="ummmmmm good", parentid=db.fruit.id);
model("tag").create(name="pear", description="rhymes with Per", parentid=db.fruit.id);
model("tag").create(name="banana", description="peel it", parentid=db.fruit.id);

// classifications
model("classification").create(postid=1, tagid=7);

// collisiontests
model("collisiontest").create(method="test");
for (db.i in [1,2,3,4,5]) {
	for (db.a in [1,2,3,4,5]) {
		model("CombiKey").create(id1=db.i, id2=db.a, userId=db.a);
	};
};

// sqltype
model("sqltype").create(stringVariableType="tony", textType="blah blah blah blah");

// assign posts for multiple join test
db.andy.update(favouritePostId=1, leastFavouritePostId=2);
</cfscript>
