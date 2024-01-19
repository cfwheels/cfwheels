<cfoutput>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Code Coverage Browser</title>

		<link rel="stylesheet" href="assets/css/main.css">
		<script	src="assets/js/jquery-3.3.1.min.js"></script>
		<script src="assets/js/popper.min.js"></script>
		<script src="assets/js/bootstrap.min.js"></script>
		<script src="assets/js/stupidtable.min.js"></script>
		<script src="assets/js/fontawesome.js"></script>
	</head>
	<body>
		<div class="container-fluid my-3">
			<h2 class="text-center">Code Coverage Browser</h2>

			<table class="table-borderless">
				<tbody>
					<tr class="h4 pr-3">
						<td class="text-right pr-3">
							Total Files Processed:
						</td>
						<td style="width: 30%">
							#stats.numFiles#
						</td>
					</tr>
					<cfset percTotalCoverage = numberFormat( stats.percTotalCoverage * 100, '9.9' )>
					<tr class="h4 pr-3">
						<td class="text-right pr-3">
							Total project coverage:
						</td>
						<td style="width: 300px">
							<div class="progress position-relative" style="line-height: 2.5rem;font-size: 1.5rem; height:40px;">
								<div class="progress-bar bg-#percentToContextualClass( percTotalCoverage )#" role="progressbar" style="width: #percTotalCoverage#%" aria-valuenow="#percTotalCoverage#" aria-valuemin="0" aria-valuemax="100"></div>
								<div class="progress-bar bg-secondary" role="progressbar" style="width: #100-percTotalCoverage#%" aria-valuenow="#100-percTotalCoverage#" aria-valuemin="0" aria-valuemax="100"></div>
								<span class="justify-content-center text-light d-flex position-absolute w-100">#percTotalCoverage#% coverage</span>
							</div>
						</td>
					</tr>
					<tr class="h4 pr-3">
						<td class="text-right pr-3">
							File Filter:
						</td>
						<td style="width: 300px">
							<input class="form-control" type="text" name="fileFilter" id="fileFilter" placeholder="Filter Files..." size="35">
						</td>
					</tr>
				</tbody>
			</table>

			<cfquery name="qryCoverageDataSorted" dbtype="query">
				SELECT filePath, relativeFilePath, numLines, numCoveredLines, numExecutableLines, percCoverage
				from qryCoverageData
				order by percCoverage
			</cfquery>

			<table class="table my-3">
				<thead>
					<tr>
						<th data-sort="string"><span class="btn btn-link">Path</span></th>
						<th data-sort="int" data-sort-onload=yes data-sort-default="asc"><span class="btn btn-link">Coverage <i class="arrow fas fa-arrow-down"></i></span></th>
					</tr>
				<thead>
				<tbody>
					<cfloop query="qryCoverageDataSorted">
					<cfset percentage = numberFormat( percCoverage * 100, '9.9' )>
					<tr class="file">
						<td class="file-name" data-sort-value="#relativeFilePath#"><a href="#relativeFilePath#.html">#relativeFilePath#</a></td>
						<td class="file-coverage" data-sort-value="#percentage#">
							<div class="progress position-relative" style="height: 1.4rem;">
								<div
									class="progress-bar bg-#percentToContextualClass( percentage )#"
									role="progressbar"
									style="width: #percentage#%"
									aria-valuenow="#percentage#"
									aria-valuemin="0"
									aria-valuemax="100">
								</div>
								<div
									class="progress-bar bg-secondary"
									role="progressbar"
									style="width: #100 - percentage#%"
									aria-valuenow="#100 - percentage#"
									aria-valuemin="0"
									aria-valuemax="100">
								</div>
								<span
									class="justify-content-center text-light d-flex position-absolute w-100"
									style="line-height: 1.25rem; font-size: 1.2rem;"
								>
									#percentage#% coverage
								</span>
							</div>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
</cfoutput>
		<script>
			$(document).ready(function() {

				var table = $("table").stupidtable();
				table.bind('aftertablesort', function (event, data) {
					console.log(data.direction);
					if ( data.direction === "asc") {
						$(".arrow").removeClass( "fa-arrow-up" );
						$(".arrow").addClass( "fa-arrow-down" );
					}
					else {
						$(".arrow").removeClass( "fa-arrow-down" );
						$(".arrow").addClass( "fa-arrow-up" );
					}
				});
				
				// Filter Bundles
				$("#fileFilter").keyup(debounce(function() {
					var targetText = $(this).val().toLowerCase();
					$(".file").each(function(index) {
						var file = $(this).find(".file-name a").text().toLowerCase();
						if (file.search(targetText) < 0) {
							// hide it
							$(this).hide();
						} else {
							$(this).show();
						}
					});
				}, 100));
			});
			function debounce(func, wait, immediate) {
				var timeout;
				return function() {
					var context = this,
						args = arguments;
					var later = function() {
						timeout = null;
						if (!immediate) func.apply(context, args);
					};
					var callNow = immediate && !timeout;
					clearTimeout(timeout);
					timeout = setTimeout(later, wait);
					if (callNow) func.apply(context, args);
				};
			};
		</script>
	</body>
</html>