<cfoutput>
<cfinclude template="../layout/_header.cfm">
<div class="ui container">

	#pageHeader(title="Test Results")#

	<cfinclude template="_navigation.cfm">

	<cfif NOT isStruct(testResults)>

		<p style="margin-bottom: 50px;">Sorry, no tests were found.</p>

	<cfelse>

		<h4>Package: #testResults.path#</h4>

		<div class="ui breadcrumb">
			<cfif type EQ "app" OR type EQ "core">
				<a class="section" href="#urlFor(route="wheelsPackages",  type=type)#">#type#</a>
			<cfelse>
			<div class="section">Plugins</div>
			</cfif>

			<cfset prevPath ="">
			<cfloop list="#testResults.path#" delimiters="." index="i">
			<cfif !listFind("wheels,tests,plugins", i)>
				<cfset prevPath= listAppend(prevPath, i, '.')>
				<i class="right angle icon divider"></i>
					<cfif !listLast(testResults.path, '.') EQ i>
				<a class="section"
				href="#urlFor(route="wheelsPackages", params="package=#prevPath#", type=type)#">#listLast(prevPath, '.')#</a>
					<cfelse>
				<a class="section active" href="#urlFor(route="wheelsPackages", params="package=#prevPath#", type=type)#">#listLast(prevPath, '.')#</a>
					</cfif>
			</cfif>
			</cfloop>

		</div>

		#startTable(title="Test Results", colspan=6)#
		<tr class="<cfif testResults.ok>positive<cfelse>error</cfif>">
			<td><strong>Status</strong><br /><cfif testResults.ok><i class='icon check'></i> Passed<cfelse><i class='icon close'></i> Failed</cfif></td>
			<td><strong>Duration</strong><br />#TimeFormat(testResults.end - testResults.begin, "HH:mm:ss")#</td>
			<td><strong>Packages</strong><br />#testResults.numCases#</td>
			<td><strong>Tests</strong><br />#testResults.numTests#</td>
			<td><strong>Failures</strong><br />#testResults.numFailures#</td>
			<td><strong>Errors</strong><br />#testResults.numErrors#</td>
		</tr>
		#endTable()#


			<cfscript>
				failures = [];
				passes = [];
				for(result in testResults.results){
					if(result.status NEQ "Success"){
						arrayAppend(failures, result);
					} else {
						arrayAppend(passes, result);
					}
				}
			</cfscript>

			<div class="ui top attached tabular menu stackable">
				<cfif testResults.ok>
					<a class="item active" data-tab="passed">Passed (#arraylen(passes)#)</a>
					<a class="item" data-tab="failures">Failures (#arraylen(failures)#)</a>
				<cfelse>
					<a class="item active" data-tab="failures">Failures (#arraylen(failures)#)</a>
					<a class="item" data-tab="passed">Passed (#arraylen(passes)#)</a>
				</cfif>
			</div>

			#startTab(tab="failures", active=!testResults.ok)#
				<table class="ui celled table searchable">
					<thead>
					<tr>
						<th>Package</th>
						<th>Test Name</th>
						<th>Time</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arrayLen(failures)#" index="testIndex">
						<cfset result = failures[testIndex]>
						<cfif result.status neq 'Success'>
							<tr class="error">
								<td><a href="?&package=#result.packageName#">#result.cleanTestCase#</a></td>
								<td><a href="?&package=#result.packageName#&test=#result.testName#">#result.cleanTestName#</a></td>
								<td class="n">#result.time#</td>
								<td class="<cfif result.status eq 'Success'>success<cfelse>failed</cfif>">#result.status#</td>
							</tr>
							<tr class="error"><td colspan="4" class="failed">#replace(result.message, chr(10), "<br/>", "ALL")#</td></tr>
							<cfset distinctKey= replace(replace(replace(result.packageName, ".", "_", "all"), "tests_", "", "one"),  "wheels_", "", "one") & '_' & result.testName>
							<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], distinctKey)>
								<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][distinctKey]#" index="i">
								<tr class="error"><td colspan="4">#i#</tr>
								</cfloop>
							</cfif>
						</cfif>
					</cfloop>
					</tbody>
				</table>
			#endTab()#

			#startTab(tab="passed", active=testResults.ok)#
				<table class="ui celled table searchable">
					<thead>
					<tr>
						<th>Package</th>
						<th>Test Name</th>
						<th>Time</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<!--- Put errors at top --->
					<cfloop from="1" to="#arrayLen(passes)#" index="testIndex">
						<cfset result = passes[testIndex]>
						<cfif result.status eq 'Success'>
							<tr class="positive">
								<td><a href="?&package=#result.packageName#">#result.cleanTestCase#</a></td>
								<td><a href="?&package=#result.packageName#&test=#result.testName#">#result.cleanTestName#</a></td>
								<td class="n">#result.time#</td>
								<td class="success">#result.status#</td>
							</tr>
							<cfset distinctKey= replace(replace(replace(result.packageName, ".", "_", "all"), "tests_", "", "one"),  "wheels_", "", "one") & '_' & result.testName>
							<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], distinctKey)>
								<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][distinctKey]#" index="i">
								<tr class="positive"><td colspan="4">#i#</tr>
								</cfloop>
							</cfif>
						</cfif>
					</cfloop>
					</tbody>
				</table>
			#endTab()#

	</cfif>
</div>

<cfinclude template="../layout/_footer.cfm">
</cfoutput>
	<!---cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#request.wheels.params.type#">



	<cfif NOT isStruct(testResults)>

		<p style="margin-bottom: 50px;">Sorry, no tests were found.</p>

	<cfelse>

		<div class="row">

			<div class="column">
				<h1>Test Results</h1>
			</div>

			<div class="column">
				<p class="float-right">
					<a class="button button-outline" href="?type=#request.wheels.params.type#">Run All Tests</a>
					<a class="button button-outline" href="?type=#request.wheels.params.type#&reload=true">Reload Test Data</a>
				<p>
			</div>

		</div>
		<hr />

		<div class="row">
			<div class="column"><p>#get("serverName")# #get("serverVersion")#</p></div>
			<!---div class="column"><p>#application.testenv.db.database_productname# | #application.testenv.db.database_version# | #application.testenv.db.driver_name#</p></div--->
		</div>

		<div class="row">
			<div class="column"><p class="<cfif testResults.ok>success<cfelse>failed</cfif>">Status: <br /><cfif testResults.ok><i class='fa fa-check-circle'></i> Passed<cfelse><i class='fa fa-times-circle'></i> Failed</cfif></p></div>
			<div class="column"><p><strong>Duration</strong><br />#TimeFormat(testResults.end - testResults.begin, "HH:mm:ss")#</p></div>
			<div class="column"><p><strong>Packages</strong><br />#testResults.numCases#</p></div>
			<div class="column"><p><strong>Tests</strong><br />#testResults.numTests#</p></div>
			<div class="column"><p class="<cfif testResults.numFailures neq 0> failed</cfif>"><strong>Failures</strong><br />#testResults.numFailures#</p></div>
			<div class="column"><p class="<cfif testResults.numErrors neq 0> failed</cfif>"><strong>Errors</strong><br />#testResults.numErrors#</p></div>
		</div>
		<cfif !testResults.ok>
		<div class="row">
			<div class="column">
				<p><strong>Show:</strong>
				<a href="##" data-toggle="all" class='button button-outline toggle'>All</a>
				<a href="##" data-toggle="failed" class='button button-outline toggle'>Failed</a>
				<a href="##" data-toggle="passed" class='button button-outline toggle'>Passed</a>
				</p>
			</div>
		</div>
		</cfif>
		<hr />
		<table class="table">
			<tr>
				<th>Package</th>
				<th>Tests</th>
				<th>Failures</th>
				<th>Errors</th>
			</tr>
			<cfloop from="1" to="#ArrayLen(testResults.summary)#" index="testIndex">
				<cfset summary = testResults.summary[testIndex]>
				<tr class="<cfif summary.numFailures + summary.numErrors gt 0>errRow<cfelse>sRow</cfif>">
					<td>
						<cfset a = ListToArray(summary.packageName, ".")>
						<cfset b = CreateObject("java", "java.util.ArrayList").Init(a)>
						<cfset c = ArrayLen(a)>
						<cfloop from="1" to="#c#" index="i"><a href="?&package=#ArrayToList(b.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">#a[i]#</a><cfif i neq c>.</cfif></cfloop>
					</td>
					<td class="n">#summary.numTests#</td>
					<td class="n<cfif summary.numFailures neq 0> failed</cfif>">#summary.numFailures#</td>
					<td class="n<cfif summary.numErrors neq 0> failed</cfif>">#summary.numErrors#</td>
				</tr>
			</cfloop>
		</table>

		<table class="table">
			<tr>
				<th>Package</th>
				<th>Test Name</th>
				<th>Time</th>
				<th>Status</th>
			</tr>
			<cfloop from="1" to="#arrayLen(testResults.results)#" index="testIndex">
				<cfset result = testResults.results[testIndex]>
				<tr class="<cfif result.status neq 'Success'>errRow<cfelse>sRow</cfif>">
					<td><a href="?&package=#result.packageName#">#result.cleanTestCase#</a></td>
					<td><a href="?&package=#result.packageName#&test=#result.testName#">#result.cleanTestName#</a></td>
					<td class="n">#result.time#</td>
					<td class="<cfif result.status eq 'Success'>success<cfelse>failed</cfif>">#result.status#</td>
				</tr>
				<cfif result.status neq "Success">
					<tr class="errRow"><td colspan="4" class="failed">#replace(result.message, chr(10), "<br/>", "ALL")#</td></tr>
				</cfif>
				<cfset distinctKey= replace(replace(replace(result.packageName, ".", "_", "all"), "tests_", "", "one"),  "wheels_", "", "one") & '_' & result.testName>
				<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], distinctKey)>
					<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][distinctKey]#" index="i">
					<tr class="<cfif result.status neq 'Success'>errRow<cfelse>sRow</cfif>"><td colspan="4">#i#</tr>
					</cfloop>
				</cfif>
			</cfloop>
		</table>
	</cfif>
</cfoutput>
<script>
$(".toggle").on("click", function(e){
	var show=$(this).data("toggle");
		switch (show) {
		case 'all':
			$(".errRow").show();
			$(".sRow").show();
			$(".toggle").addClass('button-outline');
			$(this).removeClass('button-outline');
		break;
		case 'failed':
			$(".errRow").show();
			$(".sRow").hide();
			$(".toggle").addClass('button-outline');
			$(this).removeClass('button-outline');
		break;
		case 'passed':
			$(".errRow").hide();
			$(".sRow").show();
			$(".toggle").addClass('button-outline');
			$(this).removeClass('button-outline');
		break;
		}
	e.preventDefault();
});
</script--->
