component extends="testbox.system.BaseSpec" {

	function run() {

		d = new Wheels.Dispatch();
		prepareMock(d);
		makePublic(d, "$createParams");
		makePublic(d, "$createNestedParamStruct");
		makePublic(d, "$findMatchingRoute");
		makePublic(d, "$getPathFromRequest");
		makePublic(d, "$mergeUrlAndFormScopes");
		makePublic(d, "$parseJsonBody");
		makePublic(d, "$mergeRoutePattern");
		// makePublic(d, "$deobfuscateParams");
		makePublic(d, "$translateBlankCheckBoxSubmissions");
		makePublic(d, "$translateDatePartSubmissions");
		makePublic(d, "$ensureControllerAndAction");
		// makePublic(d, "$addRouteFormat");
		makePublic(d, "$addRouteName");
		makePublic(d, "$getRequestMethod");


		describe("Initialise Dispatch",	function() {

			it("is a valid instance", function() {
				expect(d).toBeInstanceOf('wheels.Dispatch');
			});
		});

		describe("createParams Creates Params", function() {

			beforeEach(function( currentSpec ) {
				args = {};
				args.path = "home";
				args.format = "";
				args.route = {
					pattern = "/",
					controller = "wheels",
					action = "wheels",
					regex = "^\/?$",
					variables = "",
					on = "",
					package = "",
					methods = "get",
					name = "root"
				};
				args.formScope = {};
				args.urlScope = {};
		   });

		   afterEach(function( currentSpec ) {
				structDelete(variables, "args");
		   });

			it("checks URL & form scope map the same", function() {
				mockStruct = {
					"user[email]" = "tpetruzzi@gmail.com",
					"user[name]" = "tony petruzzi",
					"user[password]" = "secret"
				}
				args.UrlScope = duplicate(mockStruct);
				r1  = d.$createParams(argumentCollection = args);
				args.UrlScope = {};
				args.FormScope = duplicate(mockStruct);
				r2  = d.$createParams(argumentCollection = args);
				expect(r1).toBe(r2);
			});
			it("legacy test url overrides form", function() {
				args.UrlScope.controller = "override1";
				args.FormScope.controller = "override2";
				r  = d.$createParams(argumentCollection = args);
			 	expect(r).toBeStruct();
				expect(r.controller).toBe("override1");
				expect(r.controller).notToBe("override2");
			});
			// Not sure how this legacy test ever worked?
			// it("Form scope not overwritten", function() {
			// 	// args.formScope["obj[published]($month)"] = 2;
			// 	// _params = dispatch.$$createParams(argumentCollection = args);
			// 	// exists = StructKeyExists(args.formScope, "obj[published]($month)");
			// 	// assert('exists eq true');
			// });
			// it("legacy test_url_scope_not_overwritten", function() {
			// 	StructInsert(
			// 		args.urlScope,
			// 		"user[email]",
			// 		"tpetruzzi@gmail.com",
			// 		true
			// 	);
			// 	_params = dispatch.$$createParams(argumentCollection = args);
			// 	exists = StructKeyExists(args.urlScope, "user[email]");
			// 	assert('exists eq true');
			// });
			it("Multiple objects with Checkbox", function() {
				args.formScope["user[1][isActive]($checkbox)"] = 0;
				args.formScope["user[1][isActive]"] = 1;
				args.formScope["user[2][isActive]($checkbox)"] = 0;
				r  = d.$createParams(argumentCollection=args);
				expect(r.user["1"].isActive).toBe(1);
				expect(r.user["2"].isActive).toBe(0);
			});
			it("Multiple objects in Objects", function() {
				args.formScope["user"]["1"]["config"]["1"]["isValid"] = true;
				args.formScope["user"]["1"]["config"]["2"]["isValid"] = false;
				r  = d.$createParams(argumentCollection=args);
				expect(r.user).toBeStruct();
				expect(r.user[1]).toBeStruct();
				expect(r.user[1].config).toBeStruct();
				expect(r.user[1].config[1]).toBeStruct();
				expect(isBoolean(r.user[1].config[1].isValid)).toBeTrue();
				expect(isBoolean(r.user[1].config[2].isValid)).toBeTrue();
				expect(r.user[1].config[1].isValid).toBeTrue();
				expect(r.user[1].config[2].isValid).toBeFalse();
			});
			it("dates not combined", function() {
				args.formScope["obj[published-day]"] = 30;
				args.formScope["obj[published-year]"] = 2000;
				r  = d.$createParams(argumentCollection=args);
				expect(r.obj).toHaveKey("published-day");
				expect(r.obj).toHaveKey("published-year");
				expect(r.obj["published-day"]).toBe(30);
				expect(r.obj["published-year"]).toBe(2000);
			});
			it("controller in upper camel case", function() {
				args.formScope["controller"] = "wheels-test";
				r = d.$createParams(argumentCollection = args);
				expect(r.controller).toBeWithCase("WheelsTest");
				args.formScope["controller"] = "wheels";
				r = d.$createParams(argumentCollection = args);
				expect(r.controller).toBeWithCase("Wheels");
			});
			it("sanitize controller and action params", function() {
				args.formScope["controller"] = "../../../wheels%00";
				args.formScope["action"] = "../../../test*^&%()%00";
				r = d.$createParams(argumentCollection = args);
				expect(r.controller).toBeWithCase("......Wheels00");
				expect(r.action).toBeWithCase("......test00");
			});

		});

		describe("createNestedParamStruct Creates Nested Params Struct", function() {

			afterEach(function( currentSpec ) {
				 structDelete(variables, "result");
				 structDelete(variables, "mockParams");
			});

		    it("Doesn't affect standard fields", function() {
				result  = d.$createNestedParamStruct({
					foo = 1,
					bar = { foo = 1 }
				});
				expect(result.foo).toBe(1);
				expect(result.bar.foo).toBe(1);
			});
		    it("Nests a single level", function() {
				result  = d.$createNestedParamStruct({
					"foo[bar]" = 1
				});
				expect(result.foo.bar).toBe(1);
			});
		    it("Nests multiple level", function() {
				result  = d.$createNestedParamStruct({
					"foo[bar][baz]" = 1
				});
				expect(result.foo.bar.baz).toBe(1);
			});
		    it("Concats multiple rows into single struct", function() {
				result  = d.$createNestedParamStruct({
					"foo[bar][1][baz]" = 1,
					"foo[bar][2][baz]" = 2
				});
				// Check whether this is correct
				// expect(result.foo.bar).toBeTypeOf('array');
				expect(result.foo.bar[1].baz).toBe(1);
				expect(result.foo.bar[2].baz).toBe(2);
			});
		    it("Deletes original key", function() {
				result  = d.$createNestedParamStruct({
					"foo[bar]" = 1
				});
				expect(result).notToHaveKey('foo[bar]');
			});
		});

		describe("findMatchingRoute Finds a route", function() {
			beforeEach(function( currentSpec ) {
                m = new wheels.Mapper();
				prepareMock(m);
				makePublic(m, "$match");
				r = {};
		    });

		    afterEach(function( currentSpec ) {
				structDelete(variables, "m");
				structDelete(variables, "routes");
				structDelete(variables, "r");
		    });

			it("Tests empty_route", function() {
				m.$draw().root(to = "pages##index").end();
				routes = m.getRoutes();
				r = d.$findMatchingRoute(path = "", format = "", routes=routes, mapper=m);
				expect(r).toBeStruct();
				expect(r.controller).toBe("pages");
				expect(r.action).toBe("index");
			});

			it("Tests controller_only", function() {
				m.$draw().$match(pattern = "pages", to = "pages##index").end();
				routes = m.getRoutes();
				r = d.$findMatchingRoute(path = "pages", format = "", routes=routes, mapper=m);
				expect(r).toBeStruct();
				expect(r.controller).toBe("pages");
				expect(r.action).toBe("index");
			});

			it("Tests controller_and_action_required", function() {
				m.$draw().$match(pattern = "pages/blah", to = "pages##index").end();
				routes = m.getRoutes();
				expect(
					function(){
						d.$findMatchingRoute(path = "/pages", format = "", routes=routes, mapper=m)
					}
				).toThrow(type="Wheels.RouteNotFound", message="Could not find a route that matched this request.");
			});

			it("Tests extra_variables_passed", function() {
				m.$draw().$match(pattern = "pages/blah/[firstname]/[lastname]", to = "pages##index").end();
				routes = m.getRoutes();
				r = d.$findMatchingRoute(path = "pages/blah/tony/petruzzi", format = "", routes=routes, mapper=m);
				expect(r).toBeStruct();
				expect(r.controller).toBe("pages");
				expect(r.action).toBe("index");
				expect(r.foundVariables).toBe("firstname,lastname");
			});

			it("Tests wildcard_route", function() {
				m.$draw().$match(pattern = "*", to = "pages##index").end();
				routes = m.getRoutes();
				r = d.$findMatchingRoute(path = "thisismyroute/therearemanylikeit/butthisoneismine", format = "", routes=routes, mapper=m);
				expect(r).toBeStruct();
				expect(r.controller).toBe("pages");
				expect(r.action).toBe("index");
			});

			it("mergeRoutePattern identifies the variable markers within the pattern", function() {
				m.$draw().$match(pattern = "pages/[mysesurl]", to = "pages##index").end();
				routes = m.getRoutes();
				debug(routes);
				r = d.$mergeRoutePattern(
					params = { }, route = routes[1], path = "pages/blah"
				);
				expect(r).toBeStruct();
				expect(r.mysesurl).toBe("blah");
			});
			describe("findMatchingRoute Legacy Tests", function() {

				beforeEach(function( currentSpec ) {
					m = new wheels.Mapper();
					m.$draw()
						.namespace("admin")
							.resources("users")
							.root(to = "dashboard##index")
						.end()
						.resources("users")
						.resource("profile")
						.root(to = "dashboard##index")
						.end();
					routes = m.getRoutes();
				});

				afterEach(function( currentSpec ) {
					structDelete(variables, "m");
					structDelete(variables, "routes");
					structDelete(variables, "r");
				});

				it("error_raised_when_route_not_found", function() {
					expect(
						function(){
							d.$findMatchingRoute(path = "/scouts", routes=routes, mapper=m);
						}
					).toThrow(type="Wheels.RouteNotFound", message="Could not find a route that matched this request.");
				});

				it("find_get_collection_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("users");
					expect(r.methods).toBe("GET");
				});

				it("find_get_collection_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users.csv",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("users");
					expect(r.methods).toBe("GET");
				});

				it("find_post_collection_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users",  requestMethod="POST", routes=routes, mapper=m);
					expect(r.name).toBe("users");
					expect(r.methods).toBe("POST");
				});

				it("find_post_collection_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users.json",  requestMethod="POST", routes=routes, mapper=m);
					expect(r.name).toBe("users");
					expect(r.methods).toBe("POST");
				});

				it("find_get_member_new_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users/new",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("newUser");
					expect(r.methods).toBe("GET");
				});

				it("find_get_member_new_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users/new.json",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("newUser");
					expect(r.methods).toBe("GET");
				});

				it("find_get_member_edit_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users/1/edit",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("editUser");
					expect(r.methods).toBe("GET");
				});

				it("find_get_member_edit_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users/1/edit.json",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("editUser");
					expect(r.methods).toBe("GET");
				});

				it("find_get_member_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users/1",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("user");
					expect(r.methods).toBe("GET");
				});

				it("find_get_member_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users/1.json",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("user");
					expect(r.methods).toBe("GET");
				});

				it("find_put_member_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users/1",  requestMethod="PUT", routes=routes, mapper=m);
					expect(r.name).toBe("user");
					expect(r.methods).toBe("PUT");
				});

				it("find_put_member_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users/1.json",  requestMethod="PUT", routes=routes, mapper=m);
					expect(r.name).toBe("user");
					expect(r.methods).toBe("PUT");
				});

				it("find_delete_member_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "users/1",  requestMethod="DELETE", routes=routes, mapper=m);
					expect(r.name).toBe("user");
					expect(r.methods).toBe("DELETE");
				});

				it("find_delete_member_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "users/1.json",  requestMethod="DELETE", routes=routes, mapper=m);
					expect(r.name).toBe("user");
					expect(r.methods).toBe("DELETE");
				});

				// nested route tests

				it("find_nested_get_collection_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("adminUsers");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_get_collection_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users.csv",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("adminUsers");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_post_collection_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users",  requestMethod="POST", routes=routes, mapper=m);
					expect(r.name).toBe("adminUsers");
					expect(r.methods).toBe("POST");
				});

				it("find_nested_post_collection_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users.json",  requestMethod="POST", routes=routes, mapper=m);
					expect(r.name).toBe("adminUsers");
					expect(r.methods).toBe("POST");
				});

				it("find_nested_get_member_new_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users/new",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("newAdminUser");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_get_member_new_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users/new.json",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("newAdminUser");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_get_member_edit_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users/1/edit",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("editAdminUser");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_get_member_edit_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users/1/edit.json",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("editAdminUser");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_get_member_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users/1",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("adminUser");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_get_member_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users/1.json",  requestMethod="GET", routes=routes, mapper=m);
					expect(r.name).toBe("adminUser");
					expect(r.methods).toBe("GET");
				});

				it("find_nested_put_member_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users/1",  requestMethod="PUT", routes=routes, mapper=m);
					expect(r.name).toBe("adminUser");
					expect(r.methods).toBe("PUT");
				});

				it("find_nested_put_member_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users/1.json",  requestMethod="PUT", routes=routes, mapper=m);
					expect(r.name).toBe("adminUser");
					expect(r.methods).toBe("PUT");
				});

				it("find_nested_delete_member_route_that_exists", function() {
					r = d.$findMatchingRoute(path = "admin/users/1",  requestMethod="DELETE", routes=routes, mapper=m);
					expect(r.name).toBe("adminUser");
					expect(r.methods).toBe("DELETE");
				});

				it("find_nested_delete_member_route_that_exists_with_format", function() {
					r = d.$findMatchingRoute(path = "admin/users/1.json",  requestMethod="DELETE", routes=routes, mapper=m);
					expect(r.name).toBe("adminUser");
					expect(r.methods).toBe("DELETE");
				});

				it("head_request_aliases_get", function() {
					r = d.$findMatchingRoute(path = "users",  requestMethod="HEAD", routes=routes, mapper=m);
					expect(r.name).toBe("users");
					expect(r.methods).toBe("GET");
				});
			});

		});

		describe("getPathFromRequest Parses the main request path for the router", function() {

			it("Return '' if pathInfo == scriptName", function() {
				expect(d.$getPathFromRequest("/", "/")).toBe("");
			});
			it("Return '' if pathInfo == /", function() {
				expect(d.$getPathFromRequest("/", "/index.cfm")).toBe("");
			});
			it("Return '' if pathInfo has no length", function() {
				expect(d.$getPathFromRequest("", "/index.cfm")).toBe("");
			});
			it("Return without leading slash", function() {
				expect(d.$getPathFromRequest("/index.cfm/foo", "/index.cfm")).toBe("index.cfm/foo");
			});
		});

		describe("mergeUrlAndFormScopes merges Url And Form Scopes", function() {

			afterEach(function( currentSpec ) {
				 structDelete(variables, "result");
				 structDelete(variables, "mockStruct");
				 structDelete(variables, "mockArgs");
			});

			it("merges Url And Form Scopes into Params", function() {
				mockArgs.params = {route = "foo", controller = "bar", action = "baz"};
				mockArgs.UrlScope = { "exampleField1" = 1 };
				mockArgs.FormScope = { "exampleField2" = 1 };
				result  = d.$mergeUrlAndFormScopes(argumentCollection = mockArgs);
				expect(result).toBeStruct();
				expect(result.route).toBe("foo");
				expect(result.controller).toBe("bar");
				expect(result.action).toBe("baz");
				expect(result.exampleField1).toBe(1);
				expect(result.exampleField2).toBe(1);
			});

			it("checks URL scope has precedence", function() {
				mockArgs.params = {};
				mockArgs.UrlScope.controller = "override1";
				mockArgs.FormScope.controller = "override2";
				result  = d.$mergeUrlAndFormScopes(argumentCollection = mockArgs);
			 	expect(result).toBeStruct();
				expect(result.controller).toBe("override1");
				expect(result.controller).notToBe("override2");
			});

			it("checks URL & form scope map the same", function() {
				mockStruct = {
					"user[email]" ="tpetruzzi@gmail.com",
					"user[name]" ="tony petruzzi",
					"user[password]" ="secret"
				}
				mockArgs.params = {};
				mockArgs.UrlScope = duplicate(mockStruct);
				mockArgs.FormScope = duplicate(mockStruct);
				result  = d.$mergeUrlAndFormScopes(argumentCollection = mockArgs);
				expect(structCount(result)).toBe(3);
			});
		});

		describe("parseJsonBody Parses JSON Body", function() {

		   beforeEach(function( currentSpec ) {
				mockJsonStruct = SerializeJSON({
					test1 = 'foo'
				});
				mockJsonArray = SerializeJSON([
					'alpha',
					'beta',
					'gamma'
				]);

				mockArgs = {
					params = {},
					httpRequestData = {
						headers = {
							"Content-Type" = "application/json; utf8;"
						},
						content = mockJsonStruct
					}
				};
		   });

		   afterEach(function( currentSpec ) {
				structDelete(variables, "result");
				structDelete(variables, "mockStruct");
				structDelete(variables, "mockArgs");
		   });

		    it("Parses JSON Body with application/json; utf8", function() {
				result  = d.$parseJsonBody(argumentCollection=mockArgs);
				expect(result.test1).toBe("foo");
			});
			it("Parses JSON Body with application/json", function() {
				mockArgs.httpRequestData.headers["Content-Type"] = "application/json";
				result  = d.$parseJsonBody(argumentCollection=mockArgs);
				expect(result.test1).toBe("foo");
			});
			it("Parses JSON Body with application/vnd.api+json; utf8", function() {
				mockArgs.httpRequestData.headers["Content-Type"] = "application/vnd.api+json; utf8";
				result  = d.$parseJsonBody(argumentCollection=mockArgs);
				expect(result.test1).toBe("foo");
			});
			// TO DO - not simulating binary here properly?
			//it("TODO Parses JSON Body which is Binary (ACF)", function() {
			// mockArgs.httpRequestData.content=ToBinary(mockJsonStruct);
			// result  = d.$parseJsonBody(argumentCollection=mockArgs);
			// expect(result.test1).toBe("foo");
			// });
			it("Parses JSON Body array into params._json", function() {
				mockArgs.httpRequestData.content=mockJsonArray;
				result  = d.$parseJsonBody(argumentCollection=mockArgs);
				expect(result).toBeStruct();
				expect(result['_json']).toBeArray();
				expect(result['_json'][1]).toBe('alpha');
				expect(result['_json'][3]).toBe('gamma');
			});
			it("Doesn't Parse JSON Body if wrong application type", function() {
				mockArgs.httpRequestData.headers["Content-Type"] = "text/html; charset=utf-8";
				result = d.$parseJsonBody(argumentCollection=mockArgs);
			 	expect(result).toBeStruct().toBeEmpty();
			});
		});


		describe("TODO De-obfuscates Params if Required: TODOFIRST Move to utils", function() {
			// TODO
			// makePublic(d, "deobfuscateParams");
		});

		describe("translateDatePartSubmissions Combines date parts from forms into a single value", function() {

			afterEach(function( currentSpec ) {
				structDelete(variables, "args");
				structDelete(variables, "result");
		    });

			it("Returns Combined date parts from forms into a single datetime value when given all", function() {
				args = {
					"foo($year)" = 2021,
					"foo($month)" = 01,
					"foo($day)" = 01,
					"foo($hour)" = 01,
					"foo($minute)" = 01,
					"foo($second)" = 01,
					"foo($ampm)" = "am"
				}
				result = d.$translateDatePartSubmissions(args);
				expect(result.foo).toBeTypeOf("date");
				expect(year(result.foo)).toBe(2021);
				expect(month(result.foo)).toBe(01);
				expect(hour(result.foo)).toBe(01);
				expect(minute(result.foo)).toBe(01);
				expect(second(result.foo)).toBe(01);
				expect(day(result.foo)).toBe(01);
			});
			it("Defaults Day to 1 if not provided", function() {
				args = {
					"foo($year)" = 2021,
					"foo($month)" = 01
				}
				result = d.$translateDatePartSubmissions(args);
				expect(result.foo).toBeTypeOf("date");
				expect(day(result.foo)).toBe(01);
			});
			it("Defaults Month to 1 if not provided", function() {
				args = {
					"foo($year)" = 2021,
					"foo($day)" = 01
				}
				result = d.$translateDatePartSubmissions(args);
				expect(result.foo).toBeTypeOf("date");
				expect(month(result.foo)).toBe(01);
			});
			it("Defaults Year to 1899 if not provided", function() {
				args = {
					"foo($month)" = 01,
					"foo($day)" = 01
				}
				result = d.$translateDatePartSubmissions(args);
				expect(result.foo).toBeTypeOf("date");
				expect(year(result.foo)).toBe(1899);
			});

		});

		describe("translateBlankCheckBoxSubmissions Translates Blank Check Box Submissions", function() {

			afterEach(function( currentSpec ) {
				structDelete(variables, "args");
				structDelete(variables, "result");
		    });

			it("Looks for $(checkbox) submissions", function() {
				args = {
					"user[1][isActive]($checkbox)" = 1,
					"user[2][isActive]($checkbox)" = 0
				}
				result = d.$translateBlankCheckBoxSubmissions(args);
				expect(result["user[1][isActive]"]).toBe(1);
				expect(result["user[2][isActive]"]).toBe(0);
			});
		});

		describe("ensureControllerAndAction Ensures Controller and Action are legit", function() {


			afterEach(function( currentSpec ) {
				structDelete(variables, "result");
		   });

			// Note: this always assumes controller + action appear in the route
			it("Assigns controller and action from route if not in params", function() {
				result = d.$ensureControllerAndAction({}, {
					controller = "test1",
					action = "test2"
				 });
				expect(result).toBeStruct();
				expect(result.controller).toBe('test1');
				expect(result.action).toBe('test2');
			});

			it("Allows for dot notation in controller path", function() {
				result = d.$ensureControllerAndAction({}, {
					controller = "foo.bar",
					action = "test"
				})
				expect(result.controller).toBe('foo.bar');
			});
			it("Filters out illegal characters from the controller and action arguments", function() {
				result = d.$ensureControllerAndAction({}, {
					controller = "foobar",
					action = "test3"
				 });
				expect(result.controller).toBe('Foobar');
			});
			it("Converts controller to upperCamelCase", function() {
				result = d.$ensureControllerAndAction({}, {
					controller = "foobar",
					action = "test3"
				 });
				expect(result.controller).toBe('Foobar');
			});
			it("Converts Action to normal camelCase", function() {
				result = d.$ensureControllerAndAction({}, {
					controller = "foo*bar",
					action = "FooBar"
				 });
				expect(result.action).toBe('fooBar');
			});
		});

		describe("addRouteName Adds in the name variable from the route if it exists", function() {

			it("Add route name to params struct", function() {
				result = d.$addRouteName({}, { name = 'test' });
				expect(result).toBeStruct();
				expect(result.route).toBe('test');
			});
		});

		describe("CHECK THIS? Adds in the format variable from the route if it exists.", function() {
			// makePublic(d, "addRouteFormat");
			// it("Add format to params struct", function() {
			// 	result = d.addRouteFormat({}, { formatVariable: 'test' });
			// 	expect(result).toBeStruct();
			// 	expect(result.route).toBe('test');
			// });
		});

		describe("getRequestMethod Switches HTTP verb used in request if using _method override", function() {

			it("Listens for form _method in POST", function() {
				expect(d.$getRequestMethod("post", { "_method" = 'PUT' })).toBe("PUT");
			});
			it("Doesn't respond for _method in GET", function() {
				expect(d.$getRequestMethod("get", { "_method" = 'PUT' })).notToBe("PUT");
			});
			it("Requires form scope + _method to work", function() {
				expect(d.$getRequestMethod("post", {   })).toBe("post");
			});
			it("Only allows switching to valid verbs", function() {
				expect(d.$getRequestMethod("post", {  "_method" = 'PUT' })).toBe("PUT");
				expect(d.$getRequestMethod("post", {  "_method" = 'PATCH' })).toBe("PATCH");
				expect(d.$getRequestMethod("post", {  "_method" = 'DELETE' })).toBe("DELETE");
				expect(d.$getRequestMethod("post", {  "_method" = 'INVALiD' })).toBe("POST");
			});
		});

	}

}
