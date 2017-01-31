component extends="wheelsMapping.Controller" {
	user = model("user").findOne(where="lastname = 'Petruzzi'");
}
