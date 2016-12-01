<cfscript>

string function csrfMetaTags() {
  local.metaTags  = $tag(name="meta", attributes={ name="csrf-param", content="authenticityToken" }, close=true);
  local.metaTags &= $tag(name="meta", attributes={ name="csrf-token", content=$generateAuthenticityToken() }, close=true);

  return local.metaTags;
}

string function authenticityTokenField() {
  // Store a new authenticity token.
  local.authenticityToken = $generateAuthenticityToken();

  // Return hidden field containing new authenticity token.
  return hiddenFieldTag(name="authenticityToken", value=local.authenticityToken);
}
  
</cfscript>
