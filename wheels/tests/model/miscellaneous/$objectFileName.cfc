component extends="wheels.Test" {

	function setup(){
		loc={};
		loc.objectPath="/wheels/tests/_assets/models/";
		loc.name="PHOTOGALLERY";
	}

	function teardown(){
		loc={};
	}

	function test_$fileExistsNoCase_returns_filename(){  
		loc.expected="PhotoGallery.cfc";
		loc.actual = $fileExistsNoCase(expandPath(loc.objectPath) & loc.name & ".cfc");  
		assert("loc.actual EQ loc.expected");
	} 

	function test_$objectFileName_returns_model_class_name_in_same_case_as_file_wo_exandpath() { 
		loc.actual = $objectFileName(name="PhotoGallery", objectPath=loc.objectPath, type="model");
		loc.expected = "PhotoGallery"; 
		assert("Compare(loc.actual, loc.expected) eq 0", "loc.actual", "loc.expected", "loc.objectPath");
	}
}
