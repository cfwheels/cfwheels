```coldfusion
// Do not allow "PHP" or "Fortran" to be saved to the database as a cool language
validatesExclusionOf(property="coolLanguage", list="php,fortran", message="Haha, you can not be serious. Try again, please.");
```