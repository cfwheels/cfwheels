<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function errorMessagesFor(
		required string objectName,
		string class,
		boolean showDuplicates
	) {
		var loc = {};
		$args(name="errorMessagesFor", args=arguments);
		loc.object = $getObject(arguments.objectName);
		if (get("showErrorInformation") && !IsObject(loc.object)) {
			$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
		}
		loc.errors = loc.object.allErrors();
		loc.rv = "";
		if (!ArrayIsEmpty(loc.errors)) {
			loc.used = "";
			loc.listItems = "";
			loc.iEnd = ArrayLen(loc.errors);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
				loc.msg = loc.errors[loc.i].message;
				if (arguments.showDuplicates) {
					loc.listItems &= $element(name="li", content=loc.msg);
				} else {
					if (!ListFind(loc.used, loc.msg, Chr(7))) {
						loc.listItems &= $element(name="li", content=loc.msg);
						loc.used = ListAppend(loc.used, loc.msg, Chr(7));
					}
				}
			}
			loc.rv = $element(name="ul", skip="objectName,showDuplicates", content=loc.listItems, attributes=arguments);
		}
		return loc.rv;
	}

	public string function errorMessageOn(
		required string objectName,
		required string property,
		string prependText,
		string appendText,
		string wrapperElement,
		string class
	) {
		var loc = {};
		$args(name="errorMessageOn", args=arguments);
		loc.object = $getObject(arguments.objectName);
		if (get("showErrorInformation") && !IsObject(loc.object)) {
			$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
		}
		loc.error = loc.object.errorsOn(arguments.property);
		loc.rv = "";
		if (!ArrayIsEmpty(loc.error)) {
			loc.content = arguments.prependText & loc.error[1].message & arguments.appendText;
			loc.rv = $element(name=arguments.wrapperElement, skip="objectName,property,prependText,appendText,wrapperElement", content=loc.content, attributes=arguments);
		}
		return loc.rv;
	}
</cfscript>
