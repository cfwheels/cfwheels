# setCacheSettings()

## Description
Updates the settings for a cache category. Use this method in your settings files. You may also add specific arguments that you would like to pass to the storage component.

## Function Syntax
	setCacheSettings( category, storage, [ strategy, timeout, cullPercentage, cullInterval, maximumItems ] )


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
			<td>category</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
		<tr>
			<td>storage</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Could be memory, ehcache, or memcached.</td>
		</tr>
		
		<tr>
			<td>strategy</td>
			<td>string</td>
			<td>false</td>
			<td>age</td>
			<td></td>
		</tr>
		
		<tr>
			<td>timeout</td>
			<td>numeric</td>
			<td>false</td>
			<td>3600</td>
			<td>in seconds. default is 1 hour or 3600 seconds</td>
		</tr>
		
		<tr>
			<td>cullPercentage</td>
			<td>numeric</td>
			<td>false</td>
			<td>10</td>
			<td></td>
		</tr>
		
		<tr>
			<td>cullInterval</td>
			<td>numeric</td>
			<td>false</td>
			<td>300</td>
			<td>in seconds. default is 5 minutes or 300 seconds</td>
		</tr>
		
		<tr>
			<td>maximumItems</td>
			<td>numeric</td>
			<td>false</td>
			<td>5000</td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- in config/settings.cfm, set the caching for partials to use ehcache --->
		<cfset setCacheSettings(category="partials", storage="ehcache") />
