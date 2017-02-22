component extends="wheels.Controller" {
	user = model("user").findOne(where="lastname = 'Petruzzi'");
}
