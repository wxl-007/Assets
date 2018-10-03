#pragma strict
class EventParam extends Object {
	var booleanValue:boolean;
	var colorValue:Color;
	var floatValue:float;
	var intValue:int;
	var UInt64Value:float;
	var vector2Value:Vector2;
	var vector3Value:Vector3;
	var vector4Value:Vector4;
	var stringValue:String;
	var objectValue:UnityEngine.Object;
	
	
	var isBoolean:boolean = false;
	var isColor:boolean = false;
	var isFloat:boolean = false;
	var isInt:boolean = false;
	var isUInt64:boolean = false;
	var isVector2:boolean = false;
	var isVector3:boolean = false;
	var isVector4:boolean = false;
	var isString:boolean = false;
	var isObject:boolean = false;
	
	var type:String;
	
	function SetValue(value:System.Object,valueType:System.Type) {
		if (value == null) return;
		DisableAllTypeFlags();
		
		if (valueType.ToString() == "System.Boolean") {
			booleanValue = value cast boolean;
			isBoolean = true;
		}
		else if (valueType.ToString() == "UnityEngine.Color") {
			colorValue = value cast Color;
			isColor = true;
		}
		else if (valueType.ToString() == "System.Single") {
			floatValue = value cast float;
			isFloat = true;
		}
		else if (valueType.ToString() == "System.Int32") {
			intValue = value cast int;
			isInt = true;
		}
		else if (valueType.ToString() == "System.UInt64") {
			UInt64Value = value cast System.UInt64;
			isUInt64 = true;
		}
		else if (valueType.ToString() == "UnityEngine.Vector2") {
			vector2Value = value cast Vector2;
			isVector2 = true;
		}
		else if (valueType.ToString() == "UnityEngine.Vector3") {
			vector3Value = value cast Vector3;
			isVector3 = true;
		}
		else if (valueType.ToString() == "UnityEngine.Vector4") {
			vector4Value = value cast Vector4;
			isVector4 = true;
		}
		else if (valueType.ToString() == "System.String") {
			stringValue = value cast String;
			isString = true;
		}
		else if (valueType.GetType().IsInstanceOfType(UnityEngine.Object)) {
			objectValue = value cast UnityEngine.Object;
			isObject = true;
		}

	}
	function GetValue():System.Object {
		if (isBoolean) {
			return booleanValue;
		}
		if (isColor) {
			return colorValue;
		}
		if (isFloat) {
			return floatValue;
		}
		if (isInt) {
			return intValue;
		}
		if (isUInt64) {
			return UInt64Value;
		}
		if (isVector2) {
			return vector2Value;
		}
		if (isVector3) {
			return vector3Value;
		}
		if (isVector4) {
			return vector4Value;
		}
		if (isString) {
			return stringValue;
		}
		if (isObject) {
			return objectValue;
		}
		return null;
	}
	
	function DisableAllTypeFlags() {
		isBoolean = false;
		isColor = false;
		isFloat = false;
		isInt = false;
		isUInt64 = false;
		isVector2 = false;
		isVector3 = false;
		isVector4 = false;
		isString = false;
		isObject = false;
	}
	
	function GetParamType():System.Type {
		if (isBoolean) {
			return boolean;
		}
		if (isColor) {
			return Color;
		}
		if (isFloat) {
			return float;
		}
		if (isInt) {
			return int;
		}
		if (isUInt64) {
			return float;
		}
		if (isVector2) {
			return Vector2;
		}
		if (isVector3) {
			return Vector3;
		}
		if (isVector4) {
			return Vector4;
		}
		if (isString) {
			return String;
		}
		if (isObject) {
			return objectValue.GetType();
		}
		return null;
	}
	//function GetValue() {
	//	if (type == "float") return floatValue;
	//}
}