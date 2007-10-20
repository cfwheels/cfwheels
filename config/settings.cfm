<cfset application.settings.dsn = application.applicationname>
<cfset application.settings.username = "">
<cfset application.settings.password = "">
<cfset application.settings.perform_caching = false>
<cfset application.settings.default_cache_time = 3600>
<cfset application.settings.maximum_items_to_cache = 1000>
<cfset application.settings.cache_cull_percentage = 10>
<cfset application.settings.cache_cull_interval = 300>
<cfset application.settings.default_controller = "sample">
<cfset application.settings.default_action = "index">
<cfset application.settings.obfuscate_urls = false>
<cfset application.settings.send_email_on_error = false>
<cfset application.settings.error_email_address = "">
<cfset application.settings.error_mail_server = "">
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