#pragma strict
class CutsceneEventOverrideNameAttribute extends System.Attribute {
	var overrideName:String;

	function CutsceneEventOverrideNameAttribute(n:String) {
		this.overrideName = n;
	}
}

