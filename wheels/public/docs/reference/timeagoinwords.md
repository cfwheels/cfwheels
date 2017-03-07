```coldfusion
timeAgoInWords(fromTime [, includeSeconds, toTime ])
```
```coldfusion
aWhileAgo = Now() - 30>
<cfoutput>#timeAgoInWords(aWhileAgo)#</cfoutput>
```
