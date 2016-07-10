/**
  RocketUnit 2.0

	The smallest, easiest and most approachable unit testing framework for CFML.

	(c) 2008-2015 RocketBoots Pty Ltd

	This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

 **/

component {

  BIG_NUM =                     9999;
  JUNIT_URL_KEY =               "junit";
  REFRESH_URL_KEY =             "refresh";
  TEST_PREFIX =                 "test";
  FAIL_ERRCODE =                "__FAIL__";
  DUMMY_ERRCODE =               "__DUMMY__";
  CANT_LOCATE_LINE_ERRCODE =    "CANT_LOCATE_LINE";
  CANT_LOCATE_SOURCE_ERRCODE =  "CANT_LOCATE_SOURCE";
  INVALID_TOKEN_VALUE =         "__INVALID__";
  SUCCESS_STATUS =              "Success";
  FAIL_STATUS =                 "Failure";
  ERR_STATUS =                  "Error";
  TITLE_PASSED_STATUS =         "Passed";
  TITLE_FAILED_STATUS =         "Failed";
  TITLE_EXCEPTION_STATUS =      "Exception";
  SETUP_FN_NAME =               "setup";
  TEARDOWN_FN_NAME =            "teardown";
  ALL =                         "all";
  NEWLINE =                     chr(10) & chr(13);
  WRAP_WIDTH =                  80;


  resultsKey = "a";


  /**
    Allow results key to be overridden, mainly so that we don't
    go mad running Rocketunit's own tests - but this would also
    allow you to run multiple sets of tests at once if you
    really needed to for some reason.

    @overrideResultsKey test results are stored under this key
                        in request scope.
   **/
  public function init(string overrideResultsKey="__ROCKETUNIT__") {
    resultsKey = overrideResultsKey;
    return this;
  }


  /**
    Recursively run all test components under a specified mapping.
    Test components are CFCs that :

    - Have names that start with "Test"
    - Extend this component

    Other CFCs and scripts will be ignored.

  	@param testPackage	CF mapping to root package containing tests
		@returns			      True if no failures or errors occurred.
	 **/
  public boolean function runTestPackage(string testPackage) {
    var packageDirectory = "/#replace(testPackage, ".", "/", ALL)#";
    var packageStartOffset = len(expandPath(packageDirectory)) + 1;
    var qDirectoryListing = 0;
    var instance = 0;
    var result = 0;
    var componentMetadata = 0;

    setupResults();

    directory action="list"
              directory="#packageDirectory#"
              name="qDirectoryListing"
              recurse="true"
              filter="*.cfc"
              type="file";

    each(qDirectoryListing, function(file) {
      if (not listContainsNoCase("Application.cfc,Test.cfc", file.name)) {
        componentName = testPackage
                        & replace(mid(file.directory,
                            packageStartOffset, BIG_NUM), "/", ".")
                        & "." & listFirst(file.name, ".");

        componentMetadata = getComponentMetadata(componentName);

        if (listLast(componentMetadata.extends.name, ".") eq TEST_PREFIX
            and left(listLast(componentMetadata.name, "."), 4) eq TEST_PREFIX) {
          instance = createObject("component", componentName).init(resultsKey);
          result += instance.runTests();
        }
      }
    });
    return result eq 0;
  }


  /**
		Run all the tests in a component. Tests are methods whose names
		start with 'test'. If they are defined each test will be wrapped
		with a call to the setup() and teardown() methods.

		Results are added to the request.test structure.

		@returns true if no errors
	 **/
  public function runTests() {
    var metadata = getMetadata(this);
    var testCase = metadata.name;
    var time = 0;
    var message = 0;
    var status = 0;
    var context = 0;
    var hasSetup = false;
    var hasTeardown = false;
    var numTests = 0;             // totals for this test case
    var numTestFailures = 0;
    var numTestErrors = 0;
    var results = setupResults(); // totals for all test cases

    // If there are no functions, it doesn't create key at all...
    if (not structKeyExists(metadata, "functions")) {
      metadata.functions = [];
    }

    metadata.functions.map(function(fn){

      // get test function names
      if (fn.name eq SETUP_FN_NAME)
        hasSetup = true;
      else if (fn.name eq TEARDOWN_FN_NAME)
        hasTeardown = true;
      return fn.name;

    }).filter(function(testName) {

      // filter out functions without test prefix
      return left(testName, 4) eq TEST_PREFIX;

    }).filter(function(testName) {

      // run a specific test (hacked for cfwheels)
      return isNull(url.test) or testName eq url.test;

    }).each(function (testName) {

      // count another test
      numTests++;
      results.numTests++;

      try {

        // Execute setup(), test()
        message = "";
        if (hasSetup) invoke(this, SETUP_FN_NAME);
        time = getTickCount();
        invoke(this, testName);
        time = getTickCount() - time;
        status = SUCCESS_STATUS;
        results.numSuccesses++;

      } catch (any) {

        time = getTickCount() - time;
        message = cfcatch.message;

        if (cfcatch.errorcode eq FAIL_ERRCODE) {

          // A fail or assert
          status = FAIL_STATUS;
          results.ok = false;
          numTestFailures++;
          results.numFailures++;

        } else {
          // general exception
          status = ERR_STATUS;
          message &= cfcatch.detail & NEWLINE
          for (context in cfcatch.tagContext) {
            message &= NEWLINE
                    & context.template
                    & " line "
                    & context.line
          };

          results.ok = false;
          numTestErrors++;
          results.numErrors++;
        }
      }

      // ALWAYS run teardown()
      if (hasTeardown) invoke(this, TEARDOWN_FN_NAME);

      // Results for this test
      results.tests.append({
        testCase = testCase,
        testName = testName,
        time = time,
        status = status,
        message = message
      });

    }) // each testName


    // Summary results for the test case
    results.cases.append({
      testCase = testCase,
      numTests = numTests,
      numFailures = numTestFailures,
      numErrors = numTestErrors
		});

    results.numCases++;
    results.end = now();
 }


  /***
    Cause a test to fail.

    @param message  Message to record in results next to failure
   **/
  public void function fail(string message = "No failure message provided") {
    throw(errorCode=FAIL_ERRCODE, message=message);
  }


  /**
    Assert that an expression is true, and record
    useful information about the values of expression
    components if it is not.

    Note that if the expression contains function calls
    they should NOT have side-effects, that is if we call
    them multiple times they should not change their
    return values or the return values of any other functions
    in the test.

    If functions do have side effects, save their results in
    meaningfully named variables and make assertions about the
    variables instead.

    Assert will try to detect side effects and report them, but
    it is not possible (like np-hard) to guarantee
    that they will be found.

    @param expression A boolean expression. Note that assert actually
                      looks up the source code of the expression to help
                      provide supporting details for a failed assert.
                      Expressions can be spread across up to three lines,
                      but comments of any kind in the expression will
                      confuse assert and cause unpredictable behaviour.
   **/
  public void function assert(expression) {
    var source = 0;           // Source code string
    var lineNumber = 0;       // Line number of assert reported in tagContext
    var startLineNumber = 0;  // Line number of "assert(..." in multiline expression
    var message = "";         // Message string for a failed assert
    var evaluatedTokens = {}; // Record parts of expression source we have already eval'ed
    var match = {pos:[]};     // RE search result structure

    if (not expression) {

      // Locate and parse the expression source code
      // TODO: Test across other CFML engines, probably Lucee 4.5 / Railo 4.2 specific
      try {
        throw(errorCode=DUMMY_ERRCODE);
      } catch(any) {
        // assert is one stack frame up from this function [1], therefore [2]
        source = cfcatch.tagContext[2].codePrintPlain;
        startLineNumber = lineNumber = cfcatch.tagContext[2].line;
      }

      if (lineNumber eq 0) {
        message ="assert failed: could not locate line number of assert";
      } else {
        while (arrayLen(match.pos) neq 2 and startLineNumber gt 0)
          match = refind("#startLineNumber--#:[\s]+assert\((.+?)\);", source, 1, true);

        if (match.pos.len() neq 2) {
          message = "assert failed: could not locate entire source of assert expression "
                  & "ending on line #lineNumber#. Usually this is because the expression is "
                  & "spread over too many lines: #htmlCodeFormat(wrap(source, WRAP_WIDTH))#";
        } else {
          // Strip line numbers and leading white space from expression source string
          source = reReplace(mid(source, match.pos[2], match.len[2]),
             "\n[0-9]+:[\s]+",
             " ",
             ALL);
        }
      }

      // Default failure message prefix
      if (message eq "")
        message = "assert failed: #htmlCodeFormat(wrap(source, WRAP_WIDTH))#";

      // Double pass of expressions with different delimiters so that for expression "a(b) or c[d]",
      // "a(b)", "c[d]", "b" and "d" are evaluated.
      // TODO: Treat string literals as single token so that we don't treat contents as tokens
      "#expression# #reReplace(expression, "[([\])]", " ")#".listToArray(" +=-*/%##").each(
        function(token) {
          var tokenValue = INVALID_TOKEN_VALUE;

          if (not structKeyExists(evaluatedTokens, token)) {
            evaluatedTokens[token] = true;

            // If it's not a simple value try to evaluate
            if (not (isNumeric(token)
                  or isBoolean(token)
                  or left(token, 1) eq '"'
                  or left(token, 1) eq "'")) {
              try {
                // Evaluate twice to try to detect side-effects
                tokenValue = [evaluate(token), evaluate(token)];

                if (tokenValue[1] eq tokenValue[2]) {
                  tokenValue = tokenValue[1];

                } else {
                  tokenValue = "Could not determine value due to side effects. "
                             & "If possible, save this part of the expression "
                             & "in a variable before the assert and use the "
                             & "variable in its place.";
                }
              } catch(expression) {
                // Already INVALID_TOKEN_VALUE
              }

              // Don't bother showing these, makes output confusing
              if (isCustomFunction(tokenValue)) {
                tokenValue = INVALID_TOKEN_VALUE;
              }

              if (tokenValue neq INVALID_TOKEN_VALUE) {

                if (isArray(tokenValue)) {
                  tokenValue = "array of #arrayLen(tokenValue)# items";
                } else if (isStruct(tokenValue)) {
                  tokenValue = "struct with #structCount(tokenValue)# keys";
                }

                message = message & NEWLINE
                          & htmlCodeFormat("#token# = #tokenValue#");

              } // not invalid tokenValue
            } // not a simple token
          } // token not evaluated
        } // function(token)
      ); // each token
      fail(message);
    } // not expression
  }


  /**
    HTMLFormatTestResults
   **/
  public string function HTMLFormatTestResults(struct results, string id="results") {
    return tag("div", {id=id}, [
      tag("table", {class="pure-table pure-table-horizontal"}, [
        tag("thead", [
          tag("tr", ["Status", "Begin", "End", "Cases", "Tests", "Failures", "Errors"].map(
            function(title) {return tag("th", [title])})
          )
        ]),
        tag("tbody", [
          tag("tr", [
            tag("td", [function() {
                         if (results.ok)
                           return "Passed";
                         else
                           return "Failed";
            }]),
            tag("td", [timeFormat(results.begin, "HH:mm:ss L")]),
            tag("td", [timeFormat(results.end, "HH:mm:ss L")]),
            tag("td", {align="right"}, [results.numCases]),
            tag("td", {align="right"}, [results.numTests]),
            tag("td", {align="right"}, [results.numFailures]),
            tag("td", {align="right"}, [results.numErrors])
          ])
        ])
      ]),
      tag("br"),
      tag("table", {class="pure-table pure-table-horizontal"}, [
        tag("thead", [
          tag("tr", ["Test Case", "Tests", "Failures", "Errors"].map(
            function(title) {return tag("th", [title])})
          )
        ]),
        tag("tbody",
          results.cases.map(function(case) {
            if (case.numTests gt 0) {
              return tag("tr", [
                tag("td", [case.testCase]),
                tag("td", {align="right"}, [case.numTests]),
                tag("td", {align="right"}, [case.numFailures]),
                tag("td", {align="right"}, [case.numErrors])
              ])
            } else {
              return "";
            }
          })
        )
      ]),
      tag("br"),
      tag("table", {class="pure-table pure-table-horizontal"}, [
        function() {
          if (results.tests.filter(function(test) {return test.status neq SUCCESS_STATUS}).len() gt 0) {
            return tag("thead",
              tag("tr", ["Test Case", "Test Name", "Time", "Status", "Message"].map(
                function(title) {return tag("th", [title])})
               )
            )
          } else {
            return "";
          }
        },
        tag("tbody", results.tests.map(function(test) {
          if (test.status neq SUCCESS_STATUS) {
            return tag("tr", {valign="top"}, [
              tag("td", [listLast(test.testCase, ".")]),
              tag("td", [test.testName]),
              tag("td", [test.time]),
              tag("td", [test.status]),
              tag("td", [test.message])
            ])
          } else {
            return "";
          }
        })
        )
      ])
    ]);
  }


  /**
    JUnitFormatTestResults
   **/
  public string function JUnitFormatTestResults(struct results) {
    return arrayToList([
      '<?xml version="1.0" encoding="UTF-8"?>',
      tag("testsuites", [
        tag("testsuite", {
          tests=results.numTests,
          failures=results.numFailures,
          errors=results.numErrors},
          results.tests.map(function(test){
            return tag("testcase", {
              classname=test.testCase,
              name=test.testName
            },
            [function() {
              switch (test.status) {
                case "Failure":
                  return tag("failure", [test.message]);
                  break;
                case "Error":
                  return tag("error", [test.message]);
                  break;
                default:
                  return "";
              }
            }])
          })  // results.tests.map
        )     // testSuite
      ])      // testSuites
    ], "");   // arrayToList
  }


  /**
    onRequest()

    Convenience function - Let an Application.cfc extend Test and have
    test handle the HTML or JUnit response.

    The HTML response includes an automatic refresh toggle button and
    imports a stylesheet. The tests and rendering are sequenced so that if
    there is a major exception the refresh still works.

    @param url.junit    If it exists, render JUnit XML output instead of HTML
    @param url.refresh  If it exists, refresh HTML page every 7 seconds
   **/
  public function onRequest() {
    var chunks = 0;
    var titleStatus = 0;
    var body = 0;
    var results = 0;

    setting requestTimeout = 3600; // 1 hour
    init();

    try {
      runTests();
      runTestPackage("test");
      results = request[resultsKey];
      body = HTMLFormatTestResults(results);

      if (results.ok) {
        titleStatus = TITLE_PASSED_STATUS;
      } else  {
        titleStatus = TITLE_FAILED_STATUS;
      }

    } catch (any) {
      titleStatus = TITLE_EXCEPTION_STATUS;
      body = tag("div", [cfcatch.message,
                        "<br/><br/>",
                        cfcatch.tagContext.map(function(context) {
        return [
          tag("hr"),
          tag("p", [context.template]),
          tag("pre", [context.codeprintHTML])
        ]
      })]);
    }

    if  (structKeyExists(url, JUNIT_URL_KEY)) {
      content reset=true;
      writeOutput(JUnitFormatTestResults(results));

    } else {
      content reset=true;
      writeOutput(tag("html", [
        tag("head", [
          tag("link", {
            rel="stylesheet",
            href="http://yui.yahooapis.com/pure/0.6.0/pure-min.css"}),
          tag("link", {
            rel="stylesheet",
            href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css"}),
          function() {
            if (structKeyExists(url, REFRESH_URL_KEY)) {
              return tag("meta", {"http-equiv"="refresh", content=7})
            } else {
              return "";
            }
          },
          tag("title",["#application.applicationName# - #titleStatus#"])
        ]),
        tag("body", {style="padding: 1em"}, [
          tag("div", {style="padding-bottom: 1em"}, [
            function() {
              if (structKeyExists(url, REFRESH_URL_KEY)) {
                return tag("a", {
                  class="pure-button pure-button-primary",
                  href=cgi.script_name}, [
                    tag("i", {class="fa fa-pause"}, [""])
                ])
              } else {
                return tag("a", {
                  class="pure-button",
                  href="#cgi.script_name#?#REFRESH_URL_KEY#"}, [
                    tag("i", {class="fa fa-play"}, [""])
                ])
              }   // url.refresh
            }
          ]),     // div
          body
        ])        // body
      ]));        // writeOutput html
    }             // url.junit
  }


  /**
    Setup results structure in request scope
   **/
  private struct function setupResults() {
    if (not structKeyExists(request, resultsKey)) {
      request[resultsKey] = {
        begin =         now(),
        ok =            true,
        numCases =      0,
        numTests =      0,
        numSuccesses =  0,
        numFailures =   0,
        numErrors =     0,
        cases =         [],
        tests =         []
      };
    }

    return request[resultsKey];
  }


  /**
    Helper method to render HTML tags
    TODO flatten -> writeOutput at last possible moment
   **/
  private string function tag(name = "p") {
    var name = arguments[1];
    var out = ["<#name#"];
    var attributes = {};
    var children = [];

    if (arguments.len() gt 1) {
     if (isStruct(arguments[2])) {
        attributes = arguments[2];
        if (arguments.len() eq 3) {
          children = arguments[3];
        }
      } else {
        children = arguments[2];
      }
    }

    attributes = expand(attributes);

    attributes.each(function(attribute) {
        out.append(' #attribute.lCase()#="#attributes[attribute]#"');
      });

    children = flatten(expand(children));

    if (children.len() gt 0) {
      out.append(">"
        & arrayToList(children, "")
        & "</#name#>");
    } else {
      out.append("/>");
    }

    return arrayToList(out, "");
  }


  /**
   Helper method to expand functions

   @item arbitrary value containing functions, which will be
         replaced by their return values when called with
         no arguments
   **/
  private function expand(item) {
    var expanded = {};

    if (isArray(item)) {
      return item.map(expand);

    } else if (isStruct(item)) {
      structKeyArray(item).each(function(key) {
        expanded[key] = expand(item[key]);
      });
      return expanded;

    } else if (isClosure(item)) {
      try {
        expanded = item();
        return expanded;
      } catch (any) {
        return cfcatch.message & cfcatch.detail & cfcatch.extendedInfo;
      }
    }
    return item;
  }


  /**
    Helper method to flatten an array

    @nested Array potentially containing nested arrays, which will
            be recursively replaced with their elements, preserving order
   **/
  private array function flatten(nested) {
    var flattened = [];
    var appender = function(elem) {
      if  (isArray(elem))
        elem.each(appender);
      else
        flattened.append(elem);
    };

    appender(nested);
    return flattened;
  }


  // Functions to enable running RocketUnit from CFWheels
  include template="wheels.cfm";

}
