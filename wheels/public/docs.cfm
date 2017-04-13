<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";

	// Example Expected comment
	/**
	* I am the function hint. Backticks replaced with code; tags below get replaced.
	* Tags must appear before Params
	*
	* [section: Doc Section]
	* [category: Doc Category] (optional, but recommended)
	*
	* @paramName Hint for Param. Backticks replaced with code; [doc: AFunctionName] replaced with link
	*/

	include "docs/functions.cfm";
	include "docs/#params.type#.cfm";
</cfscript>
