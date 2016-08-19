<cfscript>
  function getAttr(element, attr) {
    local.tag = arguments.element;
    local.tag = Replace(local.tag, ">", "/>");
    local.tag = Replace(local.tag, "//", "/");
    local.tag = Replace(local.tag, "/ /", "/");
    local.xml = xmlParse(local.tag);
    if (StructKeyExists(local.xml.XmlRoot.XmlAttributes, arguments.attr)) {
      return local.xml.XmlRoot.XmlAttributes[arguments.attr];
    }
    return "undefined";
  }

  cr = Chr(13) & Chr(10);
  script = "";
  tags = "";
  if (! StructIsEmpty(form)) {

    tags = form.tags;
    // function attrs
    f = {};
    f.tag = REMatchNoCase('<cffunction(.+?)>', tags)[1];
    f.name = getAttr(f.tag, "name");
    f.access = getAttr(f.tag, "access");
    f.returntype = getAttr(f.tag, "returntype");
    f.hint = getAttr(f.tag, "hint");

    // hint
    if (f.hint != "undefined") {
      savecontent variable="hint" {
        echo("/**
    * #f.hint#
    */");
      }
      script &= hint & cr;
    }

    // args
    f.args = REMatchNoCase('<cfargument(.+?)>', tags);
    argArray = [];
    for (arg in f.args) {
      a = {};
      a.name = getAttr(arg, "name");
      a.required = getAttr(arg, "required");
      a.type = getAttr(arg, "type");
      a.default = getAttr(arg, "default");

      rt = [];
      if (!(a.required == "false" or a.required == "undefined")) {
        rt.Append("required");
      }

      if ((a.type == "" or a.type == "undefined")) {
        rt.Append("any");
      } else {
        rt.Append(a.type);
      }

      if ((a.default == "undefined")) {
        rt.Append(a.name);
      } else {
        rt.Append('#a.name#="#a.default#"');
      }

      argArray.Append(ArrayToList(rt, " "));

    };

    // function open
    script &= ("#f.access == "undefined" ? "public" : f.access# #f.returntype# function #f.name#(");

    // args
    if (ArrayLen(argArray) gt 2) {
      argArray = argArray.map(function(i){
        return "  #i#";
      });
      script &= (cr & ArrayToList(argArray, ",#cr#") & cr);
    } else {
      script &= (ArrayToList(argArray, ", "));
    }

    script &= (") {" & cr);

    // body
    scriptBody = REMatchNoCase('<cfscript>(.+?)</cfscript>', tags)[1];
    scriptBody = ReplaceNoCase(scriptBody, "<cfscript>", "", "all");
    scriptBody = ReplaceNoCase(scriptBody, "</cfscript>", "", "all");
    script &= (scriptBody & cr);

    // return
    returnTag = REMatchNoCase('<cfreturn (.+?)>', tags);
    if (ArrayLen(returnTag)) {
      ret = REReplaceNoCase(returnTag[1], '<cfreturn (.+?)>', 'return \1;', "all");
      script &= (ret & cr);
    }

    // function close
    script &= "}";

    // replace set
    script = REReplaceNoCase(script, '<cfset (.+?)>', '\1;', "all");
    // replace loc
    script = ReplaceNoCase(script, "var loc = {};", "", "all");
    script = ReplaceNoCase(script, "loc.", "local.", "all");
    script = ReplaceNoCase(script, "loc,", "local,", "all");
    script = ReplaceNoCase(script, "loc[", "local[", "all");
    // comments
    script = REReplaceNoCase(script, '<!---(.+?)--->', '/*\1*/', "all");
     // leftover closing slashes
    script = Replace(script, " /;", ";", "all");
    script = Replace(script, "/;", ";", "all");
  }
</cfscript>
<cfoutput>
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8">
      <title>Scriptify!</title>
    </head>
    <body onload="document.getElementById('cfscript').select();">
      <form action="#cgi.script_name#" method="post" id="myForm">
        <textarea rows='20' cols='100' name="tags" onClick="this.select();" onpaste="setTimeout(function(){ document.getElementById('myForm').submit(); }, 100);">#tags#</textarea>
        <br>
        <input type="submit" value="Scriptify!">
        <hr>
        <textarea rows='40' cols='100' id="cfscript" onclick="this.select();">#script#</textarea>
      </form>
    </body>
  </html>
</cfoutput>