<cfscript>
param name="request.wheels.params.migrationName";
param name="request.wheels.params.templateName";

migrator = application.wheels.migrator;

if (StructKeyExists(request.wheels.params, "migrationPrefix") && Len(request.wheels.params.migrationPrefix)) {
	message = migrator.createMigration(
		request.wheels.params.migrationName,
		request.wheels.params.templateName,
		request.wheels.params.migrationPrefix
	);
} else {
	message = migrator.createMigration(request.wheels.params.migrationName, request.wheels.params.templateName);
}
</cfscript>
<cfoutput>
	<div class="ui info message">
		<div class="header">Result</div>
		#message#
	</div>
</cfoutput>
