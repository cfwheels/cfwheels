/**
 * Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A Base reporter class
 */
component {

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Helper method to deal with ACF2016's overload of the page context response, come on Adobe, get your act together!
	 */
	function getPageContextResponse(){
		if ( structKeyExists( server, "lucee" ) ) {
			return getPageContext().getResponse();
		} else {
			return getPageContext().getResponse().getResponse();
		}
	}

	/**
	 * Reset the HTML response
	 */
	function resetHTMLResponse(){
		// reset cfhtmlhead from integration tests
		if ( structKeyExists( server, "lucee" ) ) {
			try {
				getPageContext().getOut().resetHTMLHead();
			} catch ( any e ) {
				// don't care, that lucee version doesn't support it.
				writeDump( var = "resetHTMLHead() not supported #e.message#", output = "console" );
			}
		}
		// reset cfheader from integration tests
		getPageContextResponse().reset();
	}

	/**
	 * Compose a url for opening a file in an editor
	 *
	 * @template The template target
	 * @line     The line number target
	 * @editor   The editor to use: vscode, vscode-insiders, sublime, textmate, emacs, macvim, idea, atom, espresso
	 *
	 * @return The string for the IDE
	 */
	function openInEditorURL(
		required template,
		required line,
		editor = "vscode"
	){
		switch ( arguments.editor ) {
			case "vscode":
				return "vscode://file/#arguments.template#:#arguments.line#";
			case "vscode-insiders":
				return "vscode-insiders://file/#arguments.template#:#arguments.line#";
			case "sublime":
				return "subl://open?url=file://#arguments.template#&line=#arguments.line#";
			case "textmate":
				return "txmt://open?url=file://#arguments.template#&line=#arguments.line#";
			case "emacs":
				return "emacs://open?url=file://#arguments.template#&line=#arguments.line#";
			case "macvim":
				return "mvim://open/?url=file://#arguments.template#&line=#arguments.line#";
			case "idea":
				return "idea://open?file=#arguments.template#&line=#arguments.line#";
			case "atom":
				return "atom://core/open/file?filename=#arguments.template#&line=#arguments.line#";
			case "espresso":
				return "x-espresso://open?filepath=#arguments.template#&lines=#arguments.line#";
			default:
				return "#arguments.template#:#arguments.line#";
		}
	}

}
