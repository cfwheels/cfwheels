<cfcomponent>

	<cffunction name="init">
		<cfset this.version = "99.9.9">
		<cfreturn this>
	</cffunction>

	<cffunction name="$MixinForControllers" mixin="wheels.Controller" returntype="void">
	</cffunction>

	<cffunction name="$MixinForModels" mixin="wheels.Model" returntype="void">
	</cffunction>

	<cffunction name="$MixinForModelsAndContollers" mixin="wheels.Model,wheels.Controller" returntype="void">
	</cffunction>

	<cffunction name="$MixinForDispatch" mixin="wheels.Dispatch" returntype="void">
	</cffunction>

	<cffunction name="$MixinForTest" mixin="wheels.Test" returntype="void">
	</cffunction>
	
	<cffunction name="$MixinForWheelsControllerOnly" mixin="controllers.wheels" returntype="void">
	</cffunction>
	
	<cffunction name="congratulations" mixin="controllers.Wheels">
		<cfreturn structkeyexists(core, "congratulations")>
	</cffunction>

</cfcomponent>