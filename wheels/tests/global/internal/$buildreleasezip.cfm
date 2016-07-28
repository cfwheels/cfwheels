// TOOD: get running on cf10.. no queryExecute!

component extends="wheels.tests.Test" {

	function packageSetup() {
		loc.path = $buildReleaseZip(version="6.6.6");
		$zip(action="list", name="loc.list", file=loc.path);
	}

	function packageTeardown() {
		if (FileExists(loc.path)) {
			fileDelete(loc.path);
		}
	}

	function test_$buildreleasezip_contains_config_directory() {
		loc.actual = $filesInDirectory("config");
		debug("loc.actual", false);
		debug("loc.list", false);
		assert("loc.actual.recordCount eq 9");
	}

	function test_$buildreleasezip_contains_controllers_directory() {
		loc.actual = $filesInDirectory("controllers");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 2");
	}

	function test_$buildreleasezip_contains_events_directory() {
		loc.actual = $filesInDirectory("events");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 10");
	}

	function test_$buildreleasezip_contains_files_directory() {
		loc.actual = $filesInDirectory("files");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 1");
	}

	function test_$buildreleasezip_contains_images_directory() {
		loc.actual = $filesInDirectory("images");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 1");
	}

	function test_$buildreleasezip_contains_javascripts_directory() {
		loc.actual = $filesInDirectory("javascripts");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 1");
	}

	function test_$buildreleasezip_contains_miscellaneous_directory() {
		loc.actual = $filesInDirectory("miscellaneous");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 1");
	}

	function test_$buildreleasezip_contains_models_directory() {
		loc.actual = $filesInDirectory("models");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 2");
	}

	function test_$buildreleasezip_contains_plugins_directory() {
		loc.actual = $filesInDirectory("plugins");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 1");
	}

	function test_$buildreleasezip_contains_stylesheets_directory() {
		loc.actual = $filesInDirectory("stylesheets");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 1");
	}

	function test_$buildreleasezip_contains_tests_directory() {
		loc.actual = $filesInDirectory("tests");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 6");
	}

	function test_$buildreleasezip_contains_views_directory() {
		loc.actual = $filesInDirectory("views");
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 4");
	}

	function test_$buildreleasezip_contains_wheels_directory() {
		loc.actual = $filesInDirectory("wheels");
		debug("loc.actual", false);
		// TODO: how best to evaluate the wheels dir?
		assert("loc.actual.recordCount gt 90");
	}

	function test_$buildreleasezip_contains_commandbox_server_files() {
		loc.actual = queryExecute("
	      SELECT *
	      FROM loc.list
	      WHERE name LIKE 'server-%' AND name LIKE '%.json'
      ",
      [],
      {dbtype = "query"}
    );
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 5");
	}

	function test_$buildreleasezip_contains_files_in_root() {
		loc.actual = queryExecute("
	      SELECT *
	      FROM loc.list
	      WHERE name IN (
					'web.config',
					'urlrewrite.xml',
					'root.cfm',
					'rewrite.cfm',
					'README.md',
					'IsapiRewrite4.ini',
					'index.cfm',
					'Application.cfc',
					'.htaccess'
				)
      ",
      [],
      {dbtype = "query"}
    );
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 9");
	}

	function test_$buildreleasezip_contains_no_additional_file_in_root() {
		loc.actual = queryExecute("
	      SELECT *
	      FROM loc.list
	      WHERE directory = ''
      ",
      [],
      {dbtype = "query"}
    );
		debug("loc.actual", false);
		assert("loc.actual.recordCount eq 14");
	}

	private query function $filesInDirectory(required string directory) {
		return queryExecute("
	      SELECT *
	      FROM loc.list
	      WHERE directory LIKE '#arguments.directory#%'
      ",
      [],
      {dbtype = "query"}
    );
	}
}
