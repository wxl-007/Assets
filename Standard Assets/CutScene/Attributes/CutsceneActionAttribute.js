#pragma strict

//#if !UNITY_FLASH
class CutsceneActionAttribute extends System.Attribute {
	var attributeName:String;

	function CutsceneActionAttribute(n:String) {
		this.attributeName = n;
	}
}
//#endif
