<cfset $pluginInjection()>
<cffunction name="$pluginInjection">
	<cfset var loc = {}>
	<cfset loc.klass = getmetadata(this).name>
	<cfloop collection="#application.wheels.plugins#" item="loc.plugin">
		<!--- grab meta data of the plugin --->
		<cfset loc.pluginMeta = getmetadata(application.wheels.plugins[loc.plugin])>
		<!--- by default and for backwards compatability, we inject all methods into all objects --->
		<cfset loc.pluginMixins = "global">
		<!--- if the component has a default mixin value, assign that value --->
		<cfif structkeyexists(loc.pluginMeta, "mixin")>
			<cfset loc.pluginMixins = loc.pluginMeta["mixin"]>
		</cfif>
		<!--- loop through each method in the plugin --->
		<cfloop collection="#application.wheels.plugins[loc.plugin]#" item="loc.method">
			<!--- only inspect methods and make sure we exclude the init method --->
			<cfif isCustomFunction(application.wheels.plugins[loc.plugin][loc.method]) and loc.method neq "init" and loc.method neq "$init">
				<cfset loc.methodMeta = getmetadata(application.wheels.plugins[loc.plugin][loc.method])>
				<cfset loc.methodMixins = loc.pluginMixins>
				<cfif structkeyexists(loc.methodMeta, "mixin")>
					<cfset loc.methodMixins = loc.methodMeta["mixin"]>
				</cfif>
				<!--- methods marked as none do not get mixed in --->
				<cfif loc.methodMixins neq "none">
					<cfloop list="#loc.methodMixins#" index="loc.methodMixin">
						<cfif
							loc.methodMixin eq "global"
							OR reverse(left(reverse(loc.klass), len(loc.methodMixin))) eq loc.methodMixin>
							<cfif structkeyexists(variables, loc.method)>
								<cfset variables.core[loc.method] = variables[loc.method]>
							</cfif>
							<cfset this[loc.method] = application.wheels.plugins[loc.plugin][loc.method]>
							<cfset variables[loc.method] = this[loc.method]>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>
</cffunction>