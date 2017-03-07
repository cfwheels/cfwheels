```coldfusion
// Controller code
cities = model("city").findAll()>

// View code
<cfoutput>
    #selectTag(name="cityId", options=cities)#
</cfoutput>

// Do this when CFWheels isn''t grabbing the correct values for the `option`s'' values and display texts
<cfoutput>
	#selectTag(name="cityId", options=cities, valueField="id", textField="name")#
</cfoutput>
```
