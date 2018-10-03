#pragma strict
class EventClip extends Object {
	var name:String = "event clip";
	var startTime:float = 0.0;
	var target:GameObject;
	var component:Component;
	var targetFunction:String = "";
	var paramVariationIndex:int = 0;
	var params:EventParam[];// = new EventParam[0];
	var guiExpanded:boolean = true;
}
