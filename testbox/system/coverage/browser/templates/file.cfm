<cfoutput>
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8">
			<title>#fileData.relativeFilePath#</title>

			<link rel="stylesheet" href="#relPathToRoot#assets/css/syntaxhighlighter.css">
			<link rel="stylesheet" href="#relPathToRoot#assets/css/main.css">
			<script src="#relPathToRoot#assets/js/jquery-3.3.1.min.js"></script>
			<script src="#relPathToRoot#assets/js/popper.min.js"></script>
			<script src="#relPathToRoot#assets/js/bootstrap.min.js"></script>
			<script src="#relPathToRoot#assets/js/stupidtable.min.js"></script>
			<script src="#relPathToRoot#assets/js/syntaxhighlighter.js"></script>
			<script src="#relPathToRoot#assets/js/fontawesome.js"></script>
			
			<script>
				$( document ).ready( function(){
					var lineNumbersBGColorsJSON = #lineNumbersBGColorsJSON#;
					$.each( lineNumbersBGColorsJSON, function( key, value ) {
						$( `td.gutter > div.line.number${key}` ).addClass( `text-light bg-${value}` );
					});
				});
			</script>

		</head>
		<body>
			<div class="container-fluid my-3">
				<table class="table-borderless mx-auto">
					<thead>
						<tr>
							<th class="h2 text-right pr-3">
								#fileData.relativeFilePath#
							</th>
							<th style="width: 300px">
								<div class="progress position-relative" style="line-height: 2.5rem;font-size: 1.5rem; height:40px;">
									<div class="progress-bar bg-#percentToContextualClass( percentage )#" role="progressbar" style="width: #percentage#%" aria-valuenow="#percentage#" aria-valuemin="0" aria-valuemax="100"></div>
									<div class="progress-bar bg-secondary" role="progressbar" style="width: #100-percentage#%" aria-valuenow="#100-percentage#" aria-valuemin="0" aria-valuemax="100"></div>
									<span class="justify-content-center text-light d-flex position-absolute w-100">#percentage#% coverage</span>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								<a href="javascript:history.back()"><button type="button" class="btn btn-secondary btn-sm my-1"><i class="fas fa-angle-double-left"></i> Back</button></a>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</tbody>
				</table>
				<hr width="100%">

<script type="text/syntaxhighlighter" class="brush: #brush#"><![CDATA[
#fileContents#
]]></script>
		</div>
	</body>
</html>
</cfoutput>