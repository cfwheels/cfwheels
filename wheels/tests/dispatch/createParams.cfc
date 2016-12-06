component extends="wheels.tests.Test" {

	function setup() {
		dispatch = createobject("component", "wheelsMapping.Dispatch");
		args = {};
		args.path = "home";
		args.format = "" ;
		args.route = {
			pattern="/",
			controller="wheels",
			action="wheels",
			regex="^\/?$",
			variables="",
			on="",
			module="",
			methods="get",
			name="root"
		};
		args.formScope = {};
		args.urlScope = {};
	}

	function test_default_day_to_1() {
		args.formScope["obj[published]($month)"] = 2;
		args.formScope["obj[published]($year)"] = 2000;
		_params = dispatch.$createParams(argumentCollection=args);
		e = _params.obj.published;
		r = CreateDateTime(2000, 2, 1, 0, 0, 0);
		assert('datecompare(r, e) eq 0');
	}

	function test_default_month_to_1() {
		args.formScope["obj[published]($day)"] = 30;
		args.formScope["obj[published]($year)"] = 2000;
		_params = dispatch.$createParams(argumentCollection=args);
		e = _params.obj.published;
		r = CreateDateTime(2000, 1, 30, 0, 0, 0);
		assert('datecompare(r, e) eq 0');
	}

	function test_default_year_to_1899() {
		args.formScope["obj[published]($year)"] = 1899;
		_params = dispatch.$createParams(argumentCollection=args);
		e = _params.obj.published;
		r = CreateDateTime(1899, 1, 1, 0, 0, 0);
		assert('datecompare(r, e) eq 0');
	}

	function test_url_and_form_scope_map_the_same() {
		structinsert(args.urlScope, "user[email]", "tpetruzzi@gmail.com", true);
		structinsert(args.urlScope, "user[name]", "tony petruzzi", true);
		structinsert(args.urlScope, "user[password]", "secret", true);
		args.formScope = {};
		url_params = dispatch.$createParams(argumentCollection=args);
		args.formScope = duplicate(args.urlScope);
		args.urlScope = {};
		form_params = dispatch.$createParams(argumentCollection=args);
		assert('url_params.toString() eq form_params.toString()');
	}

	function test_url_overrides_form() {
		structinsert(args.urlScope, "user[email]", "per.djurner@gmail.com", true);
		structinsert(args.formScope, "user[email]", "tpetruzzi@gmail.com", true);
		structinsert(args.formScope, "user[name]", "tony petruzzi", true);
		structinsert(args.formScope, "user[password]", "secret", true);
		_params = dispatch.$createParams(argumentCollection=args);
		e = {};
		e.email = "per.djurner@gmail.com";
		e.name = "tony petruzzi";
		e.password = "secret";
		for (i in _params.user) {
			exists = structkeyexists(e, i);
			actual = _params.user[i];
			expected = e[i];
			assert('exists');
			assert('actual eq expected');
		};
	}

	function test_form_scope_not_overwritten() {
		args.formScope["obj[published]($month)"] = 2;
		_params = dispatch.$createParams(argumentCollection=args);
		exists = StructKeyExists(args.formScope, "obj[published]($month)") ;
		assert('exists eq true');
	}

	function test_url_scope_not_overwritten() {
		StructInsert(args.urlScope, "user[email]", "tpetruzzi@gmail.com", true);
		_params = dispatch.$createParams(argumentCollection=args);
		exists = StructKeyExists(args.urlScope, "user[email]") ;
		assert('exists eq true');
	}

	function test_multiple_objects_with_checkbox() {
		StructInsert(args.urlScope, "user[1][isActive]($checkbox)", "0", true);
		StructInsert(args.urlScope, "user[1][isActive]", "1", true);
		StructInsert(args.urlScope, "user[2][isActive]($checkbox)", "0", true);
		_params = dispatch.$createParams(argumentCollection=args);
		assert('_params.user["1"].isActive eq 1') ;
		assert('_params.user["2"].isActive eq 0') ;
	}

	function test_multiple_objects_in_objects() {

			args.formScope["user"]["1"]["config"]["1"]["isValid"] = true;
			args.formScope["user"]["1"]["config"]["2"]["isValid"] = false;
			_params = dispatch.$createParams(argumentCollection=args);
			assert('IsStruct(_params.user) eq true');
			assert('IsStruct(_params.user[1]) eq true');
			assert('IsStruct(_params.user[1].config) eq true');
			assert('IsStruct(_params.user[1].config[1]) eq true');
			assert('IsStruct(_params.user[1].config[2]) eq true');
			assert('IsBoolean(_params.user[1].config[1].isValid) eq true');
			assert('IsBoolean(_params.user[1].config[2].isValid) eq true');
			assert('_params.user[1].config[1].isValid eq true');
			assert('_params.user[1].config[2].isValid eq false');

	}

	function test_dates_not_combined() {
		args.formScope["obj[published-day]"] = 30;
		args.formScope["obj[published-year]"] = 2000;
		_params = dispatch.$createParams(argumentCollection=args);
		debug('_params', false);
		assert('structkeyexists(_params.obj, "published-day")');
		assert('structkeyexists(_params.obj, "published-year")');
		assert('_params.obj["published-day"] eq 30');
		assert('_params.obj["published-year"] eq 2000');
	}

	function test_controller_in_upper_camel_case() {
		args.formScope["controller"] = "wheels-test";
		_params = dispatch.$createParams(argumentCollection=args);
		assert('Compare(_params.controller, "WheelsTest") eq 0');
		args.formScope["controller"] = "wheels";
		_params = dispatch.$createParams(argumentCollection=args);
		assert('Compare(_params.controller, "Wheels") eq 0');
	}

	function test_sanitize_controller_and_action_params() {
		args.formScope["controller"] = "../../../wheels%00";
		args.formScope["action"] = "../../../test*^&%()%00";
		_params = dispatch.$createParams(argumentCollection=args);
		assert('Compare(_params.controller, "......Wheels00") eq 0');
		assert('Compare(_params.action, "......test00") eq 0');
	}

}
