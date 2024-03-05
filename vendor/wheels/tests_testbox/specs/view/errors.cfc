component extends="testbox.system.BaseSpec" {

	function run() {

		describe("Tests that errorMessageOn", () => {

			it("works with all options supplied", () => {
				_controller = application.wo.controller(name = "ControllerWithModelErrors")
				args = {}
				args.objectName = "user"
				args.class = "errors-found"
				args.property = "firstname"
				args.prependText = "prepend "
				args.appendText = " append"
				args.wrapperElement = "div"
				e = _controller.errorMessageOn(argumentcollection = args)
				r = '<div class="errors-found">prepend firstname error1 append</div>'

				expect(e).toBe(r)
			})
		})

		describe("Tests that errorMessagesFor", () => {

			beforeEach(() => {
				_controller = application.wo.controller(name = "ControllerWithModelErrors")
				args = {}
				args.objectName = "user"
				args.class = "errors-found"
			})

			it("shows duplicate errors", () => {
				args.showDuplicates = true
				e = _controller.errorMessagesFor(argumentcollection = args)
				r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>firstname error2</li></ul>'

				expect(e).toBe(r)
			})

			it("does not show duplicate errors", () => {
				args.showDuplicates = false
				e = _controller.errorMessagesFor(argumentcollection = args)
				r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li></ul>'

				expect(e).toBe(r)
			})

			it("shows association errors", () => {
				_nestedController = application.wo.controller(name = "ControllerWithNestedModelErrors")
				args.showDuplicates = false
				args.includeAssociations = true
				actual = _nestedController.errorMessagesFor(argumentcollection = args)
				expected = '<ul class="errors-found"><li>firstname error1</li><li>lastname error1</li><li>age error1</li></ul>'

				expect(e).toBe(r)
			})
		})
	}
}