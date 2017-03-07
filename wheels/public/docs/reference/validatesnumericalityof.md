```coldfusion
// Make sure that the score is a number with no decimals but only when a score is supplied. (Tetting `allowBlank` to `true` means that objects are allowed to be saved without scores, typically resulting in `NULL` values being inserted in the database table)
validatesNumericalityOf(property="score", onlyInteger=true, allowBlank=true, message="Please enter a correct score.");
```