```coldfusion
hasManyCheckBox(objectName, association, keys [, label, labelPlacement, prepend, append, prependToLabel, appendToLabel, errorElement, errorClass ])
```
```coldfusion
// Show check boxes for associating authors with the current book 
<cfloop query="authors">
    #hasManyCheckBox(
        label=authors.fullName,
        objectName="book",
        association="bookAuthors",
        keys="#book.key()#,#authors.id#"
    )#
</cfloop>
```
