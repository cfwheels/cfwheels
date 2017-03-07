```coldfusion
// Instruct CFWheels to call the `setTime` method after getting objects or records with one of the finder methods
init(){
	afterFind("setTime");
}

function setTime(){
	arguments.fetchedAt = Now();
	return arguments;
}
```
