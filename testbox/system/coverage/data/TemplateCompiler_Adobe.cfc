/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * I contain the logic to force a compilation on Adobe ColdFusion.
 */
component accessors=true {

	function init(){
		return this;
	}

	/**
	 * Call me to force a .cfm or .cfc to be compiled and the class loaded into memory
	 */
	function compileAndLoad( required filePath ){
		// I'm so lonely... please implement me!
	}

}
