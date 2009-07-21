<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.text = "Lobortis, erat feugiat jus autem

vel obruo dolor luptatum, os in interdico ex. Sit typicus

conventio consequat aptent huic dolore in, tego,
sagacitertedistineo tristique nonummy diam. Qui, nostrud
cogo vero exputo, wisi indoles duis suscipit veniam populus
te gilvus vel quia. Luptatum regula tego imputo nonummy blandit
luptatum valetudo ne, venio vero regula letalis valde vicis.

Utrum blandit bene refero ut eum eligo cogo duis bene aptent distineo duis quis.
Hendrerit nostrud abigo vicis
augue validus cui lucidus.">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_text_should_format">
		<cfset loc.e = global.controller.simpleFormat(argumentcollection=loc.a)>
		<cfset loc.r = "<p>Lobortis, erat feugiat jus autem</p><p>vel obruo dolor luptatum, os in interdico ex. Sit typicus</p><p>conventio consequat aptent huic dolore in, tego,<br />sagacitertedistineo tristique nonummy diam. Qui, nostrud<br />cogo vero exputo, wisi indoles duis suscipit veniam populus<br />te gilvus vel quia. Luptatum regula tego imputo nonummy blandit<br />luptatum valetudo ne, venio vero regula letalis valde vicis.</p><p>Utrum blandit bene refero ut eum eligo cogo duis bene aptent distineo duis quis.<br />Hendrerit nostrud abigo vicis<br />augue validus cui lucidus.</p>">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>