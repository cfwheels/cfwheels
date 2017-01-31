component extends="wheels.tests.Test" {

	function test_findOneOrCreateBy() {
		transaction {
			author = model("author").findOrCreateByFirstName(firstName="Per", lastName="Djurner");
			assert('IsObject(author)');
			assert('author.lastname eq "Djurner"');
			assert('author.firstname eq "Per"');
			transaction action="rollback";
		}
	}

}
