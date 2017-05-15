<cfscript>

/**
 * Include this in your layouts' `head` sections to include meta tags containing the authenticity token for use by JavaScript AJAX requests needing to `POST` data to your application.
 *
 * [section: View Helpers]
 * [category: Miscellaneous Functions]
 *
 * @encode [see:styleSheetLinkTag].
 */
string function csrfMetaTags(boolean encode) {
	$args(name="csrfMetaTags", args=arguments);
  local.metaTags  = $tag(name="meta", attributes={ name="csrf-param", content="authenticityToken" });
  local.metaTags &= $tag(name="meta", attributes={ name="csrf-token", content=$generateAuthenticityToken() }, encode=arguments.encode);

  return local.metaTags;
}

/**
 * Returns a hidden form field containing a new authenticity token.
 *
 * [section: View Helpers]
 * [category: General Form Functions]
 */
string function authenticityTokenField() {
  // Store a new authenticity token.
  local.authenticityToken = $generateAuthenticityToken();

  // Return hidden field containing new authenticity token.
  return hiddenFieldTag(name="authenticityToken", value=local.authenticityToken);
}

</cfscript>
