```coldfusion
// Getting only 5 users and ordering them randomly
fiveRandomUsers = model("user").findAll(maxRows=5, order="random");

// Including an association (which in this case needs to be setup as a `belongsTo` association to `author` on the `article` model first)
articles = model("article").findAll( include="author", where="published=1", order="createdAt DESC" );

// Similar to the above but using the association in the opposite direction (which needs to be setup as a `hasMany` association to `article` on the `author` model)  bobsArticles = model("author").findAll( include="articles", where="firstName='Bob'" );

// Using pagination (getting records 26-50 in this case) and a more complex way to include associations (a song `belongsTo` an album, which in turn `belongsTo` an artist)  songs = model("song").findAll( include="album(artist)", page=2, perPage=25 );

// Using a dynamic finder to get all books released a certain year. Same as calling model("book").findOne(where="releaseYear=#params.year#")
books = model("book").findAllByReleaseYear(params.year);

// Getting all books of a certain type from a specific year by using a dynamic finder. Same as calling  model("book").findAll( where="releaseYear=#params.year# AND type='#params.type#'" )
books = model("book").findAllByReleaseYearAndType( "#params.year#,#params.type#" );

// If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `comments` method below will call `model("comment").findAll(where="postId=#post.id#")` internally)
post = model("post").findByKey(params.postId);
comments = post.comments();
```
