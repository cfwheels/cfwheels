component extends=testbox.system.BaseSpec {

    function beforeAll() {
        fail("fail")
    }

    function run() {
        describe("a test", function() {
            it("is a test", function() {
                expect(true).toBeTrue()
            });

			it("is another test", function() {
                expect(true).toBeTrue()
            });
        })

    }

}