/**
 * Build process for CFWheels Core and Base Template
 */
component {

	/**
	 * Constructor
	 */
	function init() {
		// Setup Pathing
		variables.cwd = getCWD().reReplace("\.$", "");
		variables.artifactsDir = cwd & "/.artifacts";
		variables.coreDir = artifactsDir & "/core";
		variables.baseDir = artifactsDir & "/base";

		// Cleanup + Init Directories
		[variables.coreDir, variables.baseDir, variables.artifactsDir].each(function(item) {
			if (DirectoryExists(item)) {
				DirectoryDelete(item, true);
			}
			// Create directories
			DirectoryCreate(item, true, false);
		});

		return this;
	}

	/**
	 * Run the build process: test, build core, build base template, checksums
	 *
	 * @projectName The project name used for resources and slugs
	 * @version The version you are building
	 * @buldID The build identifier
	 * @branch The branch you are building
	 */
	function run(required projectName, version = "1.0.0", buildID = CreateUUID(), branch = "develop") {
		// Create project mapping
		fileSystemUtil.createMapping(arguments.projectName, variables.cwd);

		// Build the source
		// buildSource( argumentCollection=arguments );

		// Build Docs
		// arguments.outputDir = variables.buildDir & "/apidocs";
		// docs( argumentCollection=arguments );

		// checksums
		// buildChecksums();

		// Build latest changelog
		// latestChangelog();

		// Finalize Message
		print
			.line()
			.boldMagentaLine("Build Process is done! Enjoy your build!")
			.toConsole();
	}

	/**
	 * Run the test suites
	 */
	function runTests() {
		// Tests First, if they fail then exit
		print.blueLine("Testing the package, please wait...").toConsole();

		command('testbox run')
			.params(runner = variables.testRunner, verbose = true, outputFile = "build/results.json")
			.run();

		// Check Exit Code?
		if (shell.getExitCode()) {
			return error("Cannot continue building, tests failed!");
		}
	}

	/**
	 * Build the source
	 *
	 * @projectName The project name used for resources and slugs
	 * @version The version you are building
	 * @buldID The build identifier
	 * @branch The branch you are building
	 */
	function buildSource(required projectName, version = "1.0.0", buildID = CreateUUID(), branch = "develop") {
		// Build Notice ID
		print
			.line()
			.boldMagentaLine(
				"Building #arguments.projectName# v#arguments.version#+#arguments.buildID# from #cwd# using the #arguments.branch# branch."
			)
			.toConsole();

		// Copy source
		/*		print.blueLine( "Copying source wheels folder to core folder..." ).toConsole();
		// Source Excludes Not Added to final binary
		variables.excludes      = [
			".gitignore",
			".travis.yml",
			".artifacts",
			".tmp",
			"build",
			"test-harness",
			".DS_Store",
			".git"
		];
		copy( variables.cwd & "/wheels", variables.coreDir );
*/
		print.blueLine("Copying source template folders to base folder...").toConsole();
		variables.excludes = [
			".gitignore",
			".travis.yml",
			".artifacts",
			".tmp",
			"build",
			"test-harness",
			".DS_Store",
			".git"
		];
		copy(variables.cwd, variables.baseDir);

		/*
		// Create build ID
		fileWrite( "#variables.projectBuildDir#/#projectName#-#version#+#buildID#", "Built with love on #dateTimeFormat( now(), "full")#" );

		// Updating Placeholders
		print.greenLine( "Updating version identifier to #arguments.version#" ).toConsole();
		command( 'tokenReplace' )
				.params(
						path = "/#variables.projectBuildDir#/**",
						token = "@build.version@",
						replacement = arguments.version
				)
				.run();

		print.greenLine( "Updating build identifier to #arguments.buildID#" ).toConsole();
		command( 'tokenReplace' )
				.params(
						path = "/#variables.projectBuildDir#/**",
						token = ( arguments.branch == "maim" ? "@build.number@" : "+@build.number@" ),
						replacement = ( arguments.branch == "main" ? arguments.buildID : "-snapshot" )
				)
				.run();

			// zip up source
			var destination = "#variables.exportsDir#/#projectName#-#version#.zip";
			print.greenLine( "Zipping code to #destination#" ).toConsole();
			cfzip(
					action="zip",
					file="#destination#",
					source="#variables.projectBuildDir#",
					overwrite=true,
					recurse=true
			);

			// Copy box.json for convenience
			fileCopy( "#variables.projectBuildDir#/box.json", variables.exportsDir );
	*/
	}

	/**
	 * Produce the API Docs
	 */
	function docs(required projectName, version = "1.0.0", outputDir = ".tmp/apidocs") {
		// Generate Docs
		print.greenLine("Generating API Docs, please wait...").toConsole();
		DirectoryCreate(arguments.outputDir, true, true);

		command('docbox generate')
			.params(
				"source" = "models",
				"mapping" = "models",
				"strategy-projectTitle" = "#arguments.projectName# v#arguments.version#",
				"strategy-outputDir" = arguments.outputDir
			)
			.run();

		print.greenLine("API Docs produced at #arguments.outputDir#").toConsole();

		var destination = "#variables.exportsDir#/#projectName#-docs-#version#.zip";
		print.greenLine("Zipping apidocs to #destination#").toConsole();
		cfzip(action = "zip", file = "#destination#", source = "#arguments.outputDir#", overwrite = true, recurse = true);
	}

	/**
	 * Build the latest changelog file: changelog-latest.md
	 */
	function latestChangelog() {
		print.blueLine("Building latest changelog...").toConsole();

		if (!FileExists(variables.cwd & "CHANGELOG.md")) {
			return error("Cannot continue building, CHANGELOG.md file doesn't exist!");
		}

		FileWrite(
			variables.cwd & "CHANGELOG-LATEST.md",
			FileRead(variables.cwd & 'CHANGELOG.md').split('----')[2].trim() & Chr(13) & Chr(10)
		);

		print
			.greenLine("Latest changelog file created at `CHANGELOG-LATEST.md`")
			.line()
			.line(FileRead(variables.cwd & "CHANGELOG-LATEST.md"));
	}

	/********************************************* PRIVATE HELPERS *********************************************/

	/**
	 * Build Checksums
	 */
	private function buildChecksums() {
		print.greenLine("Building checksums").toConsole();
		command('checksum')
			.params(path = '#variables.exportsDir#/*.zip', algorithm = 'SHA-512', extension = "sha512", write = true)
			.run();
		command('checksum')
			.params(path = '#variables.exportsDir#/*.zip', algorithm = 'md5', extension = "md5", write = true)
			.run();
	}

	/**
	 * DirectoryCopy is broken in lucee
	 */
	private function copy(src, target, recurse = true) {
		// process paths with excludes
		DirectoryList(
			src,
			false,
			"path",
			function(path) {
				var isExcluded = false;
				variables.excludes.each(function(item) {
					if (path.replaceNoCase(variables.cwd, "", "all").findNoCase(item)) {
						isExcluded = true;
					}
				});
				return !isExcluded;
			}
		).each(function(item) {
			// Copy to target
			if (FileExists(item)) {
				print.blueLine("Copying #item#").toConsole();
				FileCopy(item, target);
			} else {
				print.greenLine("Copying directory #item#").toConsole();
				DirectoryCopy(item, target & "/" & item.replace(src, ""), true, "", true);
			}
		});
	}

	/**
	 * Gets the last Exit code to be used
	 **/
	private function getExitCode() {
		return (CreateObject('java', 'java.lang.System').getProperty('cfml.cli.exitCode') ?: 0);
	}

}
