#pragma strict
class CutsceneEventExcludeAttribute extends System.Attribute {
	var exclude:boolean = true;

	function CutsceneEventExcludeAttribute() {
		this.exclude = true;
	}
}

