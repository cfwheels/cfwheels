# flashIsEmpty()

## Description
Returns whether or not the Flash is empty.

## Function Syntax
	flashIsEmpty(  )



## Examples
	
		<cfif not flashIsEmpty()>
			<div id="messages">
				<cfset allFlash = flash()>
				<cfloop list="#StructKeyList(allFlash)#" index="flashItem">
					<p class="#flashItem#">
						#flash(flashItem)#
					</p>
				</cfloop>
			</div>
		</cfif>
