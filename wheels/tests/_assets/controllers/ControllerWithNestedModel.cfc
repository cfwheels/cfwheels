component extends="wheels.Controller" {
	author = model("author").findOne(where="lastname = 'Djurner'", include="profile");
	author.posts = author.posts(include="comments", returnAs="objects");
}
