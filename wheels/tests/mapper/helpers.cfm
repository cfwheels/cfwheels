<cfscript>
/**
* HELPERS
*/

public Mapper function $mapper() {
  return $createObjectFromRoot(argumentCollection=arguments);
}

public struct function $inspect() {
  return variables;
}

</cfscript>
