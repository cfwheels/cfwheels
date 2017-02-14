<cfoutput>

  <cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#">



  <cfif NOT isStruct(testResults)>

  	<p style="margin-bottom: 50px;">Sorry, no tests were found.</p>

  <cfelse>

    <div class="row">

      <div class="column">
        <h1>Test Results</h1>
      </div>

      <div class="column">
        <p class="float-right">
          <a class="button button-outline" href="#URLFor(action="wheels", controller="wheels", params="view=tests&type=#params.type#")#">Run All Tests</a>
          <a class="button button-outline" href="#URLFor(action="wheels", controller="wheels", params="view=tests&type=#params.type#&reload=true")#">Reload Test Data</a>
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
  					<cfloop from="1" to="#c#" index="i"><a href="#linkParams#&package=#ArrayToList(b.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">#a[i]#</a><cfif i neq c>.</cfif></cfloop>
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
  				<td><a href="#linkParams#&package=#result.packageName#">#result.cleanTestCase#</a></td>
  				<td><a href="#linkParams#&package=#result.packageName#&test=#result.testName#">#result.cleanTestName#</a></td>
  				<td class="n">#result.time#</td>
  				<td class="<cfif result.status eq 'Success'>success<cfelse>failed</cfif>">#result.status#</td>
  			</tr>
  			<cfif result.status neq "Success">
  				<tr class="errRow"><td colspan="4" class="failed">#replace(result.message, chr(10), "<br/>", "ALL")#</td></tr>
  			</cfif>
  			<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], result.testName)>
  				<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][result.testName]#" index="i">
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
</script>
