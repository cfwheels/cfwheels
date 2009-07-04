<cfset $wheels.klass = getmetadata(this).name>
<cfloop collection="#application.wheels.plugins#" item="$wheels.plugin">
	<!--- grab meta data of the plugin --->
	<cfset $wheels.pluginMeta = getmetadata(application.wheels.plugins[$wheels.plugin])>
	<!--- by default and for backwards compatability, we inject all methods into all objects --->
	<cfset $wheels.pluginMixins = "global">
	<!--- if the component has a default mixin value, assign that value --->
	<cfif structkeyexists($wheels.pluginMeta, "mixin")>
		<cfset $wheels.pluginMixins = $wheels.pluginMeta["mixin"]>
	</cfif>
	<!--- if a plugin is marked as "none" then it is a standalone app and doesn't get mixedin --->
	<cfif $wheels.pluginMixins neq "none">
		<!--- loop through each method in the plugin --->
		<cfloop collection="#application.wheels.plugins[$wheels.plugin]#" item="$wheels.method">
			<!--- only inspect methods and make sure we exclude the init method --->
			<cfif isCustomFunction(application.wheels.plugins[$wheels.plugin][$wheels.method]) and $wheels.method neq "init" and $wheels.method neq "$init">
				<cfset $wheels.methodMeta = getmetadata(application.wheels.plugins[$wheels.plugin][$wheels.method])>
				<cfset $wheels.methodMixins = $wheels.pluginMixins>
				<cfif structkeyexists($wheels.methodMeta, "mixin")>
					<cfset $wheels.methodMixins = $wheels.methodMeta["mixin"]>
				</cfif>
				<!--- methods marked as none do not get mixed in --->
				<cfif $wheels.methodMixins neq "none">
					<cfif $wheels.klass eq "wheels.test">
						<cfdump var="#$wheels.methodMixins#|#$wheels.klass#"><cfabort>
					</cfif>
					<cfloop list="#$wheels.methodMixins#" index="$wheels.methodMixin">
						<cfif
							$wheels.methodMixin eq "global"
							OR reverse(left(reverse($wheels.klass), len($wheels.methodMixin))) eq $wheels.methodMixin
							OR (structkeyexists($wheels.methodMeta, "extends") and structfindvalue($wheels.methodMeta.extends, $wheels.methodMixin))>
							<cfif structkeyexists(variables, $wheels.method)>
								<cfset variables.core[$wheels.method] = variables[$wheels.method]>
							</cfif>
							<cfset variables[$wheels.method] = application.wheels.plugins[$wheels.plugin][$wheels.method]>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>