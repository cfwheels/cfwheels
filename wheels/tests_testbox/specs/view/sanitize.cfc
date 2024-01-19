component extends="testbox.system.BaseSpec" {

	function run() {

		describe("Tests that striplinks", () => {

			it("should strip all links", () => {
				_controller = application.wo.controller(name = "dummy")
				args = {}
				args.html = 'this <a href="http://www.google.com" title="google">is</a> a <a href="mailto:someone@example.com" title="invalid email">test</a> to <a name="anchortag">see</a> if this works or not.'

				e = _controller.striplinks(argumentcollection = args)
				r = "this is a test to see if this works or not."

				expect(e).toBe(r)
			})
		})

		describe("Tests that striptags", () => {

			it("should strip all tags", () => {
				_controller = application.wo.controller(name = "dummy")
				args = {}
				args.html = '<h1>this</h1><p><a href="http://www.google.com" title="google">is</a></p><p>a <a href="mailto:someone@example.com" title="invalid email">test</a> to<br><a name="anchortag">see</a> if this works or not.</p>'

				e = _controller.stripTags(argumentcollection = args);
				r = "thisisa test tosee if this works or not.";
				
				expect(e).toBe(r)
			})
		})
	}
}