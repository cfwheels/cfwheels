<!--- reset all tables --->
<cfloop list="user,photogallery,photogalleryphoto,author,post,city,shop,profile" index="loc.i">
	<cfset model(loc.i).deleteAll(instantiate=false, softDelete=false, includeSoftDeletes=true)>
</cfloop>

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

<cfset loc.users = model("user").findAll()>

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

<cfset loc.posts = model("post").findAll()>

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