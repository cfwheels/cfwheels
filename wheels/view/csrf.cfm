<cfscript>

string function csrfMetaTags() {
  var loc = {};

  loc.metaTags  = $tag(name="meta", attributes={ name="csrf-param", content="authenticityToken" }, close=true);
  loc.metaTags &= $tag(name="meta", attributes={ name="csrf-token", content=$generateAuthenticityToken() }, close=true);

  return loc.metaTags;
}

string function authenticityTokenField() {
  var loc = {};

  // Store a new authenticity token.
  loc.authenticityToken = $generateAuthenticityToken();

  // Return hidden field containing new authenticity token.
  return hiddenFieldTag(name="authenticityToken", value=loc.authenticityToken);
}
  
</cfscript>
