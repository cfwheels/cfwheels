# semanticVersioning()

## Description
allows a developer to specify versions in an semantic way.

## Function Syntax
	semanticVersioning( versioning, version )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>versioning</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
		<tr>
			<td>version</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		Valid syantax is:

		[operator] [version]

		The following operators are supported:

		=  Equals version
		!= Not equal to version
		>  Greater than version
		<  Less than version
		>= Greater than or equal to
		<= Less than or equal to
		~> Approximately greater than

		The first six operators are self explanitory. The Approximate operator `~>` can be thought
		of as a `between` operator. For example, if the developer wanted their plugin to support a
		wheels version that was between 1.1 and 1.2, they could do:

		<cffunction name="init">
			<cfset this.version = "~> 1.1">
			<cfreturn this>
		</cffunction>

		To use, you pass in the version and versioning strings:

		<cfset loc.passed = semanticVersioning(this.version, application.wheels.version)>

		NOTE: to mentally perform the comparision swap the arguments.

		<cfset loc.passed = semanticVersioning("> 1.3", "1.2.5")>

		reads: is "1.2.5" greater or equal to "1.3"
