<cfsetting enablecfoutputonly="true">
<cfscript>
	include "../dbmigrate/basefunctions.cfm";

	//explicitly set url to avoid odd issue when ses urls enabled
	selfUrl = "?controller=wheels&action=wheels&view=migrate";

	// Actions:
	if(isDefined("form.version")){
		flashInsert(dbmigrateFeedback=application.wheels.dbmigrate.migrateTo(Form.version));
		location url="#selfUrl#" addtoken="false";
	} else if(isDefined("Form.migrationName")){
		param name="form.templateName" default="";
		param name="form.migrationPrefix" default="";
		flashInsert(dbmigrateFeedback2=application.wheels.dbmigrate.createMigration(Form.migrationName,Form.templateName,Form.migrationPrefix));
		location url="#selfUrl#" addtoken="false";
	} else if(isDefined("url.migrateToVersion") && Len(Trim(url.migrateToVersion)) GT 0 && IsNumeric(url.migrateToVersion)){
		if(isDefined("url.password") && Trim(url.password) EQ application.wheels.reloadPassword){
			flashInsert(dbmigrateFeedback=application.wheels.dbmigrate.migrateTo(url.migrateToVersion));
			location url="#selfUrl#" addtoken="false";
		}
	}

	// Get current database version
	currentVersion = application.wheels.dbmigrate.getCurrentMigrationVersion();

	//  Get database type
	databaseType = $getDBType();

	// Get current list of migrations
	migrations = application.wheels.dbmigrate.getAvailableMigrations();
	if(ArrayLen(migrations)){
		 lastVersion = migrations[ArrayLen(migrations)].version;
	} else {
		 lastVersion = 0;
	}
</cfscript>

<cfoutput>

<h1>Database Migrations</h1>
<p>Database Migrations are an easy way to build and alter your database structure using cfscript.</p>


<cfif flashKeyExists("dbmigrateFeedback")>
	<div class="box">
	<h3>Migration result</h3>
	<pre><code>#flash("dbmigrateFeedback")#</code></pre>
	</div>
</cfif>

	<table class="table">
		<thead>
		<tr>
			<th>Database Type</th>
			<th>Datasource</th>
			<th>Database Version</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>#databaseType#</td>
			<td>#application.wheels.dataSourceName#</td>
			<td>#currentVersion#</td>
		</tr>
	</tbody>
	</table>

<cfif flashKeyExists("dbmigrateFeedback2")>
	<pre><code>#flash("dbmigrateFeedback2")#</code></pre>
</cfif>

	<form action="#CGI.script_name & '?' & CGI.query_string#" method="post">
		<fieldset>
			<h5>Create new migration file from template</h5>
			<cfif ArrayLen(migrations) eq 0>
					<label for="migrationPrefix">Migration prefix:</label>
					<select name="migrationPrefix">
						<option value="timestamp">Timestamp (e.g. #dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#)  <-- Recommended</option>
						<option value="numeric">Numeric (e.g. 001)</option>
					</select>
			</cfif>
			<div class="row">
				<div class="column">
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

				<div class="column">
					<label for="migrationName">Migration description:</label>
					<input name="migrationName" type="text" class="" placeholder=" (eg. 'creates member table')">
				</div>
			</div>




					<input type="submit" value="Create" class="button button-outline">

		</fieldset>
	</form>

<cfif ArrayLen(migrations) gt 0>
	<hr />
		<form action="#CGI.script_name & '?' & CGI.query_string#&requesttimeout=99999" method="post">
			<fieldset>
				<h5>Migrate</h5>
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

						<input type="submit" value="Get Migrating!" class="button button-outline">

			</fieldset>
		</form>
		<hr />
		<h5>Available Migrations:</h5>
		<table class="table">
			<thead>
			<tr>
				<th>Version</th>
				<th>Details</th>
			</tr>
		</thead>
		<tbody>
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
			</tbody>
		</table>
</cfif>

</cfoutput>

<cfsetting enablecfoutputonly="false">