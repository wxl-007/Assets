#pragma strict

//import System.Reflection;
enum CutsceneClipUpdateMode {Action,DirectVarAccess,Disable};

class CurveClip extends Object {
	var name:String = "curve clip";
	var target:GameObject;
	var extraTargets:GameObject[];
	var targetComponent:Component;
	var targetAction:CutsceneAction;
	var activeCamera:Camera;
	var startTime:float = 0.0;
	var length:float = 1.0;
	var smoothKeys:boolean = false;
	var updateEvent:String = "";
	var expression:String = "";
	var lastValue:float = -Mathf.Infinity;
	var usePreValue:boolean = false;
	var preValue:float = 0.0;
	var usePostValue:boolean = false;
	var postValue:float = 0.0;
	var activeCalculateOnly:boolean = false;
	var updateMode:CutsceneClipUpdateMode = CutsceneClipUpdateMode.Action;
	var colorIndex:int = 0;
	var ignoreTarget:boolean = false;
	var callback : System.Action.<float> = MyEvent;
	
	var customProperties:CurveClipCustomProperty[] = new CurveClipCustomProperty[0];
	
	var animCurve:AnimationCurve = AnimationCurve();
	var loopClip:boolean = false;

	function bindCallback()
	{
	    if(targetAction!=null)
	    {
	        callback = System.Delegate.CreateDelegate(callback.GetType(), targetAction, updateEvent);
	    }
    }
	private function MyEvent(value:float){}

	function CurveClip() {
		
	}
	
	function Init() {
		
	}
	
	function GetValue(pos:float):float {
	    var v:float = animCurve.Evaluate(pos);
	    if(loopClip && v>1.0)
	    {
	        v -= Mathf.Floor(v);
	    }
		return v;
	}
	
	function SetCustomProperty(propName:String,value) {
		for (var i:int = 0; i < customProperties.length; i++) {
			if (customProperties[i].name == propName) {
				customProperties[i].value = value cast UnityEngine.Object;
				return;
			}
		}
		//Not found so add it at the end
		var p:Array = customProperties;
		var newProp:CurveClipCustomProperty = CurveClipCustomProperty();
		newProp.name = propName;
		newProp.value = value cast UnityEngine.Object;
		p.Add(newProp);
		customProperties = p.ToBuiltin(CurveClipCustomProperty) cast CurveClipCustomProperty[];
	}
	
	function GetCustomProperty(propName:String):Object {
		for (var i:int = 0; i < customProperties.length; i++) {
			if (customProperties[i].name == propName) {
				return customProperties[i].value;
			}
		}
		return null;
	}
	
	function ClearCustomProperties() {
		customProperties = new CurveClipCustomProperty[0];
	}

}
