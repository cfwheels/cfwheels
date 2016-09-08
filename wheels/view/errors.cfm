<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function errorMessagesFor(
		required string objectName,
		string class,
		boolean showDuplicates
	) {
		$args(name="errorMessagesFor", args=arguments);
		local.object = $getObject(arguments.objectName);
		if (get("showErrorInformation") && !IsObject(local.object)) {
			$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
		}
		local.errors = local.object.allErrors();
		local.rv = "";
		if (!ArrayIsEmpty(local.errors)) {
			local.used = "";
			local.listItems = "";
			local.iEnd = ArrayLen(local.errors);
			for (local.i=1; local.i <= local.iEnd; local.i++) {
				local.msg = local.errors[local.i].message;
				if (arguments.showDuplicates) {
					local.listItems &= $element(name="li", content=local.msg);
				} else {
					if (!ListFind(local.used, local.msg, Chr(7))) {
						local.listItems &= $element(name="li", content=local.msg);
						local.used = ListAppend(local.used, local.msg, Chr(7));
					}
				}
			}
			local.rv = $element(name="ul", skip="objectName,showDuplicates", content=local.listItems, attributes=arguments);
		}
		return local.rv;
	}

	public string function errorMessageOn(
		required string objectName,
		required string property,
		string prependText,
		string appendText,
		string wrapperElement,
		string class
	) {
		$args(name="errorMessageOn", args=arguments);
		local.object = $getObject(arguments.objectName);
		if (get("showErrorInformation") && !IsObject(local.object)) {
			$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
		}
		local.error = local.object.errorsOn(arguments.property);
		local.rv = "";
		if (!ArrayIsEmpty(local.error)) {
			local.content = arguments.prependText & local.error[1].message & arguments.appendText;
			local.rv = $element(name=arguments.wrapperElement, skip="objectName,property,prependText,appendText,wrapperElement", content=local.content, attributes=arguments);
		}
		return local.rv;
	}
</cfscript>
