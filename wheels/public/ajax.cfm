<cfscript>
param name="params.type" default="core";
packages = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$listTestPackages", options=params);
linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#&format=json";
// ignore packages before the "tests directory"
if (packages.recordCount) {
	allPackages = ListToArray(packages.package, ".");
	preTest = "";
	for (i in allPackages) {
		preTest = ListAppend(preTest, i, ".");
		if (i eq "tests") {
			break;
		}
	}
}
</cfscript>
<cfoutput>
<p><a href="#linkParams#" target="_blank">Run All Tests</a> | <a href="#linkParams#&reload=true" target="_blank">Reload Test Data</a></p>
<p>Ajax Test: <a href="##" class="start-tests">Start</a> | <a href="##" class="stop-tests">Stop </a> | <a href="?controller=wheels&action=wheels&view=ajax&type=#params.type#&reload=true">Reload</a></p>
<h1>#titleize(params.type)# Test Packages</h1>

<div id="testingsuitetatus">
	<p>Status: <span class="queue-status">Waiting to Start</span><br />
	   Queued: <span class="queued-count" data-value=0>0</span><br />
	   Passed: <span class="passed-count" data-value=0>0</span><br />
	   Failed: <span class="failed-count" data-value=0>0</span><br />
	   Errors: <span class="errors-count" data-value=0>0</span></p>
</div>
<div id="failures"></div>
<cfloop query="packages">
	<div class='test-package' data-currentrow=#currentrow#>
		<cfset testablePackages = ListToArray(ReplaceNoCase(package, "#preTest#.", "", "one"), ".")>
		<cfset packagesLen = arrayLen(testablePackages)>
		<cfloop from="1" to="#packagesLen#" index="i">
			<cfset href = "#linkParams#&package=#ArrayToList(testablePackages.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">
			<cfif i EQ packagesLen>
				<a style="display:none;" data-url="#href#" href="#href#" target="_blank">#testablePackages[i]#</a>
			</cfif>
		</cfloop>
	</div>
</cfloop>

<!---p>Below is listing of all the #params.type# test packages. Click the part of the package to run it individually.</p>
<cfloop query="packages">
	<p class='test-package'>
		<cfset testablePackages = ListToArray(ReplaceNoCase(package, "#preTest#.", "", "one"), ".")>
		<cfset packagesLen = arrayLen(testablePackages)>
		<cfloop from="1" to="#packagesLen#" index="i">
			<cfset href = "#linkParams#&package=#ArrayToList(testablePackages.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">
			<a href="#href#" target="_blank">#testablePackages[i]#</a><cfif i neq packagesLen> .</cfif>
		</cfloop>
	</p>
</cfloop--->

</cfoutput>
<script>
$(document).ready(function() {

	var tests=[],
		failures=$("#failures"),
	 	status=$("#testingsuitetatus");
	var queued=status.find(".queued-count"),
		passed=status.find(".passed-count"),
		errors=status.find(".error-count"),
		failed=status.find(".failed-count");

	$.each($(".test-package"), function(i, val) {
		tests.push({
			"id": $(val).data("currentrow"),
			"status": "Waiting",
			"url": $(val).find("a:last").attr("href"),
			"result": {}
		});
	});

	setStatus(queued, tests.length);

	$(".start-tests").on("click", function(e){
		console.log("Starting Tests");
	    var qInst = $.qjax({
	          timeout: 10000,
	          ajaxSettings: {
	              //Put any $.ajax options you want here, and they'll inherit to each Queue call, unless they're overridden.
	          },
	          onQueueChange: function(length) {
	              if (length == 0) {
	                  //Empty queue
	              }
	          },
	          onStart: function(r) {
				$(status).find(".queue-status").html("Running...");
				failures.html("");
	          },
	          onStop: function(r) {
				$(status).find(".queue-status").html("Finished!");
	          },
	          onError: function(r) {
	             console.log(r);
	             console.log('ERROR');
				 setStatus(errors, 1);
	          }
	      });

          $.each(tests, function(key, value){
	          var req= qInst.Queue({
	          	 	url: value.url,
	          	 	cache: false,
					success: function(r) {
					if(r["OK"]){
						console.log("Passed");
						setStatus(passed, 1);
					} else {
					console.log("Failed");
						setStatus(failed, 1);
						outputFailure(r);
					}
	              }
	          });
		      //Using promise handlers.
		      //Note: These have to be called immediately, just like they're done with the $.ajax call.
		      req.done(function(data, status, request) {
		          //console.log('Do something!');
		      }).then(function(data, status, request) {
		         // console.log('Do something more!');
		      });

		      //To queue a function call...
		      qInst.Queue(function() {
		          //This is going to be called directly after the queued ajax call above completes.
		      });
		  });

		$(".stop-tests").on("click", function(e){
			console.log("Stopping Tests");
			qInst.Clear();
		});
	});


	$(".start-tests, .stop-tests, .load-tests").on("click", function(e){
		e.preventDefault();
	});

	function setStatus(type, value){
		var old= $(type).data("value");
			c=parseInt(old) + parseInt(value);
			$(type).data({"value": c});
			$(type).html(c);
	}

	function outputFailure(results){
		var out="";
		//console.log(results);
		$.each(results["RESULTS"], function(i, result) {
			if(result["STATUS"] != "Success"){
				out="<p class='failure-message'><span class='failure-label'>Package:</span>" + result["PACKAGENAME"] + "<br />"
					+ "<span class='failure-label'>Test Name:</span>" + result["CLEANTESTNAME"] + "<br />"
					+ "<span class='failure-label'>Message:</span><span class='failure-message-item'>" + result["MESSAGE"] + "</span></p>"
					 ;
					failures.append(out);
			}
		});
	}


});
</script>
