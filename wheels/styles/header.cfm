<cfscript>
wheelsInternalAssetPath=get("webpath") & "wheels/public/assets";
</cfscript>
<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>CFWheels</title>
	<meta charset="utf-8">
	<meta name="robots" content="noindex,nofollow">
	<link rel="stylesheet" href="#wheelsInternalAssetPath#/css/normalize.min.css">
	<link rel="stylesheet" href="#wheelsInternalAssetPath#/css/milligram.min.css">
	<link rel="stylesheet" href="#wheelsInternalAssetPath#/css/font-awesome.min.css">
	<link rel="stylesheet" href="#wheelsInternalAssetPath#/css/cfwheels.css">
	<script src="#wheelsInternalAssetPath#/js/jquery-2.2.4.min.js"></script>
	<script src="#wheelsInternalAssetPath#/js/qjax.min.js"></script>
</head>
<body>
	<header>
		<div id="logo">
			<a href="#get("webpath")#">
				<img src='#wheelsInternalAssetPath#/img/logo.png' alt="CFWheels Logo">
			</a>
		</div>
	</header>
	<div id="content" class="container">
</cfoutput>
