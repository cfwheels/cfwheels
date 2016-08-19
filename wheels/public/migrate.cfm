<cfsetting enablecfoutputonly="true">
<cfdump var="#application.wheels.dbmigrate.paths#">
<cfset dbmigrateMeta = {}>
<cfinclude template="../dbmigrate/basefunctions.cfm">
<!--- explicitly set url to avoid odd issue when ses urls enabled --->
<cfset selfUrl = "?controller=wheels&action=wheels&view=migrate">
<cfif isDefined("Form.version")>
	<cfset flashInsert(dbmigrateFeedback=application.wheels.dbmigrate.migrateTo(Form.version))>
	<cflocation url="#selfUrl#" addtoken="false">
<cfelseif isDefined("Form.migrationName")>
	<cfparam name="Form.templateName" default="">
	<cfparam name="Form.migrationPrefix" default="">
	<cfset flashInsert(dbmigrateFeedback2=application.wheels.dbmigrate.createMigration(Form.migrationName,Form.templateName,Form.migrationPrefix))>
	<cflocation url="#selfUrl#" addtoken="false">
<cfelseif isDefined("url.migrateToVersion") And Len(Trim(url.migrateToVersion)) GT 0 And IsNumeric(url.migrateToVersion)>
  <cfif isDefined("url.password") And Trim(url.password) EQ application.wheels.reloadPassword>
  	<cfset flashInsert(dbmigrateFeedback=application.wheels.dbmigrate.migrateTo(url.migrateToVersion))>
  	<cflocation url="#selfUrl#" addtoken="false">
  </cfif>
</cfif>

<!--- Get current database version --->
<cfset currentVersion = application.wheels.dbmigrate.getCurrentMigrationVersion()>

<!--- Get database type --->
<cfset databaseType = #$getDBType()#>

<!--- Get current list of migrations --->
<cfset migrations = application.wheels.dbmigrate.getAvailableMigrations()>
<cfif ArrayLen(migrations)>
	<cfset lastVersion = migrations[ArrayLen(migrations)].version>
<cfelse>
	<cfset lastVersion = 0>
</cfif>

<cfoutput>

<cfinclude template="../dbmigrate/css.cfm">
<div class="row">
	<h1>Database Migrations</h1>
	<p>Database Migrations are an easy way to build and alter your database structure using cfscript.</p>
</div>

<cfif flashKeyExists("dbmigrateFeedback")>
	<div class="row">
		<fieldset>
			<legend>Migration result</legend>
			<pre>#flash("dbmigrateFeedback")#</pre>
		</fieldset>
	</div>
</cfif>

<div class="row">
	<table class="twelve">
		<tr>
			<th>Database Type</th>
			<th>Datasource</th>
			<th>Database Version</th>
		</tr>
		<tr>
			<td>#databaseType#</td>
			<td>#application.wheels.dataSourceName#</td>
			<td>#currentVersion#</td>
		</tr>
	</table>
</div>

<cfif flashKeyExists("dbmigrateFeedback2")>
	<div class="row">
		<pre style="margin-top:10px;" class="alert-box">#flash("dbmigrateFeedback2")#</pre>
	</div>
</cfif>

<div class="row">
	<form action="#CGI.script_name & '?' & CGI.query_string#" method="post">
		<fieldset>
			<legend>Create new migration file from template</legend>
			<cfif ArrayLen(migrations) eq 0>
				<div class="row">
					<label for="migrationPrefix">Migration prefix:</label>
					<select name="migrationPrefix">
						<option value="timestamp">Timestamp (e.g. #dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#)  <-- Recommended</option>
						<option value="numeric">Numeric (e.g. 001)</option>
					</select>
				</div>
			</cfif>
			<div class="row">
				<div class="three columns">
					<label for="templateName">Select template:</label>
					<select name="templateName" class="">
						<option value="blank">Blank migration</option>
						<option value="">-- Table Operations --</option>
						<option value="create-table">Create table</option>
						<option value="change-table">Change table (multi-column)</option>
						<option value="rename-table">Rename table</option>
						<option value="remove-table">Remove table</option>
						<option value="">-- Column Operations --</option>
						<option value="create-column">Create single column</option>
						<option value="change-column">Change single column</option>
						<option value="rename-column">Rename single column</option>
						<option value="remove-column">Remove single column</option>
						<option value="">-- Index Operations --</option>
						<option value="create-index">Create index</option>
						<option value="remove-index">Remove index</option>
						<option value="">-- Record Operations --</option>
						<option value="create-record">Create record</option>
						<option value="update-record">Update record</option>
						<option value="remove-record">Remove record</option>
						<option value="">-- Miscellaneous Operations --</option>
						<option value="announce">Announce operation</option>
						<option value="execute">Execute operation</option>
					</select>
				</div>
				<div class="eight columns">
					<label for="migrationName">Migration description: (eg. 'creates member table')</label>
					<input name="migrationName" type="text" class="">
				</div>
				<div class="one columns">
					<br>
					<input type="submit" value="Create" class="small button">
				</div>
			</div>
		</fieldset>
	</form>
</div>

<cfif ArrayLen(migrations) gt 0>
	<div class="row">
		<form action="#CGI.script_name & '?' & CGI.query_string#&requesttimeout=99999" method="post">
			<fieldset>
				<legend>Migrate</legend>
				<div class="row">
					<div class="ten columns">
						<label for="version">Migrate to version:</label>
						<select name="version" >
							<cfif lastVersion neq 0>
								<option value="#lastVersion#" selected="selected">
									All non-migrated
								</option>
							</cfif>
							<cfif currentVersion neq "0">
								<option value="0">
									0 - empty
								</option>
							</cfif>
							<cfloop array="#migrations#" index="migration">
								<option value="#migration.version#">#migration.version# - #migration.name#
									<cfif migration.status eq "migrated">
										(migrated)
									<cfelse>
										(not migrated)
									</cfif>
								</option>
							</cfloop>
						</select>
					</div>
					<div class="two columns">
						<br>
						<input type="submit" value="Get Migrating!" class="small button">
					</div>
				</div>
			</fieldset>
		</form>
	</div>

	<div class="row">
		<label>Available Migrations:</label>
		<table class="twelve">
			<tr>
				<th>Version</th>
				<th>Details</th>
			</tr>
			<cfloop array="#migrations#" index="migration">
				<cfif migration.status eq "migrated">
					<cfset rowClass = "success label">
				<cfelse>
					<cfset rowClass = "">
				</cfif>
				<tr>
					<td>
						<span class="#rowClass#">#migration.version#</span>
					</td>
					<td>
						Name: #migration.name# <br>
						<cfif migration.details neq "">Details: #migration.details# <br></cfif>
						<cfif migration.loadError neq ""><span class="alert label">Error:</span> #migration.loadError# <br></cfif>
					</td>
				</tr>
			</cfloop>
		</table>
	</div>
</cfif>

</cfoutput>

<cfsetting enablecfoutputonly="false">
