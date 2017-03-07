```coldfusion
// This "Tag" version of function accepts `name` and `selected` instead of binding to a model object 
<cfoutput>
    ##timeSelectTags(name="timeOfMeeting" selected=params.timeOfMeeting)##
</cfoutput>

// Show fields for `hour` and `minute` only 
<cfoutput>
	##timeSelectTags(name="timeOfMeeting", selected=params.timeOfMeeting, order="hour,minute")##
</cfoutput>
```
