component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		args = {};
		args.text = "Lobortis, erat feugiat jus autem

vel obruo dolor luptatum, os in interdico ex. Sit typicus

conventio consequat aptent huic dolore in, tego,
sagacitertedistineo tristique nonummy diam. Qui, nostrud
cogo vero exputo, wisi indoles duis suscipit veniam populus
te gilvus vel quia. Luptatum regula tego imputo nonummy blandit
luptatum valetudo ne, venio vero regula letalis valde vicis.

Utrum blandit bene refero ut eum eligo cogo duis bene aptent distineo duis quis.
Hendrerit nostrud abigo vicis
augue validus cui lucidus.";
	}

	function test_text_should_format() {
		e = _controller.simpleFormat(argumentcollection=args);
		debug(expression='e', display=false, format="text");
		r = "<p>Lobortis, erat feugiat jus autem</p>

<p>vel obruo dolor luptatum, os in interdico ex. Sit typicus</p>

<p>conventio consequat aptent huic dolore in, tego,<br />
sagacitertedistineo tristique nonummy diam. Qui, nostrud<br />
cogo vero exputo, wisi indoles duis suscipit veniam populus<br />
te gilvus vel quia. Luptatum regula tego imputo nonummy blandit<br />
luptatum valetudo ne, venio vero regula letalis valde vicis.</p>

<p>Utrum blandit bene refero ut eum eligo cogo duis bene aptent distineo duis quis.<br />
Hendrerit nostrud abigo vicis<br />
augue validus cui lucidus.</p>";
		r = Replace(r, "#Chr(13)#", "", "all");
		assert("htmleditformat(e) eq htmleditformat(r)");
	}

}
