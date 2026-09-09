component extends="wheels.WheelsTest" {

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

			it("encodes HTML in errorMessageOn when encode=true", () => {
				_controller = application.wo.controller(name = "ControllerWithModelErrors")
				args = {
					objectName = "user",
					property = "lastname",
					encode = true
				}
				e = _controller.errorMessageOn(argumentcollection = args)
				r = '<span class="error-message">lastname error with &lt;strong&gt;bold&lt;&##x2f;strong&gt;</span>'

				expect(e).toBe(r)
			})

			it("does not encode HTML in errorMessageOn when encode=false", () => {
				_controller = application.wo.controller(name = "ControllerWithModelErrors")
				args = {
					objectName = "user",
					property = "lastname",
					wrapperElement = "span",
					encode = false
				}
				e = _controller.errorMessageOn(argumentcollection = args)
				r = '<span class="error-message">lastname error with <strong>bold</strong></span>'

				expect(e).toBe(r)
			})

		})

		describe("field helpers nest the per-property error in the field block", () => {

			it("appends errorMessageOn inside the errorElement wrapper (##3549/##3550)", () => {
				_controller = application.wo.controller(name = "ControllerWithModelErrors")
				result = _controller.textField(objectName = "user", property = "firstname")
				// The errorElement wrapper still marks the field...
				expect(result).toInclude('class="field-with-errors"')
				// ...and the inline message is now rendered with the control, after
				// the field's input element.
				expect(result).toInclude('<span class="error-message">firstname error1</span>')
				expect(find('<span class="error-message">', result)).toBeGT(find("<input", result))
			})

			it("renders no inline message when the property has no errors", () => {
				_controller = application.wo.controller(name = "ControllerWithModelErrors")
				result = _controller.textField(objectName = "user", property = "username")
				expect(result).notToInclude("error-message")
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
				r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>firstname error2</li><li>lastname error with &lt;strong&gt;bold&lt;&##x2f;strong&gt;</li></ul>'

				expect(e).toBe(r)
			})

			it("does not show duplicate errors", () => {
				args.showDuplicates = false
				e = _controller.errorMessagesFor(argumentcollection = args)
				r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>lastname error with &lt;strong&gt;bold&lt;&##x2f;strong&gt;</li></ul>'

				expect(e).toBe(r)
			})

			it("shows association errors", () => {
				_nestedController = application.wo.controller(name = "ControllerWithNestedModelErrors")
				args.showDuplicates = false
				args.includeAssociations = true
				actual = _nestedController.errorMessagesFor(argumentcollection = args)
				expected = '<ul class="errors-found"><li>firstname error1</li><li>lastname error1</li><li>age error1</li></ul>'

				expect(actual).toBe(expected)
			})

			it("encodes HTML in errorMessagesFor when encode=true", () => {
				args.encode = true
				args.showDuplicates = false
				e = _controller.errorMessagesFor(argumentcollection = args)

				r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>lastname error with &lt;strong&gt;bold&lt;&##x2f;strong&gt;</li></ul>'
				
				expect(e).toBe(r)
			})

			it("does not encode HTML in errorMessagesFor when encode=false", () => {
				args.encode = false
				args.showDuplicates = false
				e = _controller.errorMessagesFor(argumentcollection = args)
				r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>lastname error with <strong>bold</strong></li></ul>'

				expect(e).toBe(r)
			})
		})
	}
}