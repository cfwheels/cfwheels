<!--- miscellaneous --->
<cfset application.settings.default_controller = "sample">
<cfset application.settings.default_action = "index">
<cfset application.settings.obfuscate_urls = false>
<cfset application.settings.reload_password = "">
<cfset application.settings.query_timeout = 20>

<!--- validation --->
<cfset application.settings.validates_confirmation_of.message = "[field_name] should match confirmation">
<cfset application.settings.validates_exclusion_of.message = "[field_name] is reserved">
<cfset application.settings.validates_format_of.message = "[field_name] is invalid">
<cfset application.settings.validates_inclusion_of.message = "[field_name] is not included in the list">
<cfset application.settings.validates_length_of.message = "[field_name] is the wrong length">
<cfset application.settings.validates_numericality_of.message = "[field_name] is not a number">
<cfset application.settings.validates_presence_of.message = "[field_name] can't be empty">
<cfset application.settings.validates_uniqueness_of.message = "[field_name] has already been taken">

<!--- caching --->
<cfset application.settings.maximum_items_to_cache = 1000>
<cfset application.settings.cache_cull_percentage = 10>
<cfset application.settings.cache_cull_interval = 300>
<cfset application.settings.caching.actions = 600>
<cfset application.settings.caching.pages = 600>
<cfset application.settings.caching.partials = 600>
<cfset application.settings.caching.queries = 600>

<!--- paths --->
<cfset application.settings.paths.images = "images">
<cfset application.settings.paths.javascripts = "javascripts">
<cfset application.settings.paths.stylesheets = "stylesheets">
<cfset application.settings.paths.files = "files">