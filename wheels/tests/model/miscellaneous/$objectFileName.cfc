<cfscript>
component extends="wheels.Test" {

	function test_$objectFileName_returns_model_class_name_in_same_case_as_file() {
		loc.objectPath = Expandpath("wheels/tests/_assets/models");
		loc.actual = $objectFileName(name="PHOTOGALLERY", objectPath=loc.objectPath, type="model");
		loc.expected = "PhotoGallery";
		debug("loc.actual", false);
		debug("loc.expected", false);
		// assert("Compare(loc.actual, loc.expected) eq 0", "loc.actual", "loc.expected");
	}
}
</cfscript>
