# imageTag()

## Description
Returns an `img` tag. If the image is stored in the local `images` folder, the tag will also set the `width`, `height`, and `alt` attributes for you. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	imageTag( source )


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
			<td>source</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The file name of the image if it's availabe in the local file system (i.e. ColdFusion will be able to access it). Provide the full URL if the image is on a remote server.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Outputs an `img` tag for `images/logo.png` --->
		#imageTag("logo.png")#
		
		<!--- Outputs an `img` tag for `http://cfwheels.org/images/logo.png` --->
		#imageTag("http://cfwheels.org/images/logo.png", alt="ColdFusion on Wheels")#
		
		<!--- Outputs an `img` tag with the `class` attribute set --->
		#imageTag(source="logo.png", class="logo")#
