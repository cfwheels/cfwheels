# verificationChain()

## Description
Returns an array of all the verifications set on this controller in the order in which they will be executed.

## Function Syntax
	verificationChain(  )



## Examples
	
		<!--- Get verification chain, remove the first item, and set it back --->
		<cfset myVerificationChain = verificationChain()>
		<cfset ArrayDeleteAt(myVerificationChain, 1)>
		<cfset setVerificationChain(myVerificationChain)>
