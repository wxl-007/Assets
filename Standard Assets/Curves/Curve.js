#pragma strict
#pragma downcast
@HideInInspector var points:Transform[];
@HideInInspector var isCircle:boolean;
@HideInInspector var m_nCurveLength:float = -1.0f;
@HideInInspector var points_vec:Vector3[];
@HideInInspector var initPos:Vector3;

@script AddComponentMenu("Cutscene/Curve")

@script ExecuteInEditMode()

#if UNITY_EDITOR
function Update() {
    UpdatePoints();
}
#else
function Start() {
	m_nCurveLength = -1.0f;
    UpdatePoints();
    GetLength();
}
#endif

function Awake(){
    initPos = transform.position;
}

@CutsceneEventExclude()
function UpdatePoints() {
    if ( Application.isPlaying )
    {
        if(points_vec.length > 0)
        {
            checkCircle();
            return;
        }
    }
	if (transform.childCount <= 0) {
		var newObject:GameObject = GameObject("Point0");
		newObject.AddComponent(CurvePoint);
		newObject.transform.parent = transform;
		newObject.transform.localPosition = Vector3(0,0,0);
	}
	var tmpArray:Array = new Array();
	var vecArray:Array = new Array();
	//var transforms:Transform[] = gameObject.GetComponentsInChildren(Transform);
	for (var t:Transform in transform) {
		tmpArray.Add(t);
        vecArray.Add(t.position);
		break;
	}
	for (var t:Transform in transform) {
		tmpArray.Add(t);
        vecArray.Add(t.position);
	}
	tmpArray.Add(tmpArray[tmpArray.length-1]);
	vecArray.Add(vecArray[vecArray.length-1]);
	var i:int = 0;
	for (var t:Transform in tmpArray) {
		if (i == 0) {
			i++;
			continue;
	}
		if (i == tmpArray.length-1) {
			i++;
			continue;
	}
		if (t == gameObject.transform) {
			i++;
			continue;
	}
		var newName:String = "Point"+i;
		var currentName:String = t.gameObject.name;
		if (currentName != newName) {
			t.gameObject.name = newName;
	}
		i++;
	}
	var tmpPoints:Transform[] = tmpArray.ToBuiltin(Transform);
	if (tmpPoints != points) {
		points = tmpPoints;
	}
    
    points_vec = vecArray.ToBuiltin(Vector3);
    checkCircle();
}

function checkCircle()
{
    if(points_vec.length>3 && points_vec[0]==points_vec[points_vec.length-1])
	{
        isCircle = true;
	}
	else
	{
        isCircle = false;
	}
} 

#if UNITY_EDITOR
@HideInInspector var mColor:Color = Color(0.0,0.25,0.4,0.75);
@CutsceneEventExclude()
function SetPathColor(color:Color)
{
    mColor = color;
}
#endif
@CutsceneEventExclude()
function OnDrawGizmos() {
	if (!points_vec || Application.isPlaying) return;
	if (points_vec.length < 3) return;
	var lastPos:Vector3 = transform.position;
	var isFirst:boolean = true;
	lastPos = points_vec[0];
#if UNITY_EDITOR
    Gizmos.color = mColor;
#else
	Gizmos.color = Color(0.0,0.25,0.4,0.75);
#endif
	for (var i:int = 0.0; i < points_vec.length*8.0; i++) {
		//var p:Transform = points_vec[i/8.0];
		//if (p == transform) continue;
		var ratio:float = i/(points_vec.length*8.0);
		var pos:Vector3 = GetPosition(ratio);
		if (!isFirst) {
			Gizmos.DrawLine(lastPos,pos);
		}
		lastPos = pos;
		isFirst = false;
	}
}

@CutsceneEventExclude()
function GetForwardNormal(p:float, sampleDist:float):Vector3 {
	var curveLength:float = GetLength();
	var pos:Vector3 = GetPosition(p);
	var frontPos:Vector3 = GetPosition(p+(sampleDist/curveLength));
	var backPos:Vector3 = GetPosition(p-(sampleDist/curveLength));
	var frontNormal:Vector3 = (frontPos-pos).normalized;
	var backNormal:Vector3 = (backPos-pos).normalized;
	var normal:Vector3 = Vector3.Slerp(frontNormal,-backNormal, 0.5);
	normal.Normalize();
	return normal;
}

@CutsceneEventExclude()
function GetForwardNormal(p:float, pos:Vector3, sampleDist:float):Vector3 {
    var curveLength:float = GetLength();
    var frontPos:Vector3 = GetPosition(p+(sampleDist/curveLength));
    var backPos:Vector3 = GetPosition(p-(sampleDist/curveLength));
    var frontNormal:Vector3 = (frontPos-pos).normalized;
    var backNormal:Vector3 = (backPos-pos).normalized;
    var normal:Vector3 = Vector3.Slerp(frontNormal,-backNormal, 0.5);
    normal.Normalize();
    return normal;
}

function GetPosition(pos:float):Vector3 {
	return GetPosition(pos,true);
}

@CutsceneEventExclude()
function GetPosition(pos:float,clamp:boolean):Vector3 {
	if (clamp) {
		pos = Mathf.Clamp(pos,0.0,1.0);
	}
	try {
		var numSections:int = points_vec.Length - 3;
		if (numSections <= 0) return points_vec[0];
		var currPt:int = Mathf.Min(Mathf.FloorToInt(pos * numSections), numSections - 1);
		var u:float = pos*numSections - currPt;
	    var a:Vector3 = points_vec[currPt];
	    var b:Vector3 = points_vec[currPt+1];
	    var c:Vector3 = points_vec[currPt+2];
	    var d:Vector3 = points_vec[currPt+3];
		if(isCircle)
		{
		    if(currPt==0) a = points_vec[numSections];
		    if(currPt+1==numSections) d = points_vec[2];
		}
		if(Application.isPlaying)
		    return 0.5*((-a+3.0*b-3.0*c+d)*(u*u*u)+(2.0*a-5.0*b+4.0*c-d)*(u*u)+(-a+c)*u+2.0*b)+(transform.position - initPos);
		else
		    return 0.5*((-a+3.0*b-3.0*c+d)*(u*u*u)+(2.0*a-5.0*b+4.0*c-d)*(u*u)+(-a+c)*u+2.0*b);
	}
	catch(err) {
		return Vector3(0,0,0);
	}
}

@CutsceneEventExclude()
function GetLength():float {
    if(points_vec == null) UpdatePoints();
    if (points_vec.length < 3) return 0.0f;
#if UNITY_EDITOR
#else
    if(m_nCurveLength>=0.0f) return m_nCurveLength;
#endif
    m_nCurveLength = 0.0f;
	for (var i:int = 1; i < points_vec.length-2; i++) {
		if (points_vec[i] == null || points_vec[i+1] == null) return;
		m_nCurveLength += Vector3.Distance(points_vec[i],points_vec[i+1]);
	}
    return m_nCurveLength;
}

//Statics
@CutsceneEventExclude()
static function Interpolate(p:Vector3[],pos:float):Vector3 {
	var numSections:int = p.Length - 3;
	if (numSections <= 0) return Vector3(0,0,0);
	var currPt:int = Mathf.Min(Mathf.FloorToInt(pos * numSections), numSections - 1);
	var u:float = pos*numSections - currPt;
	var a:Vector3 = p[currPt];
	var b:Vector3 = p[currPt+1];
	var c:Vector3 = p[currPt+2];
	var d:Vector3 = p[currPt+3];
	return 0.5*((-a+3.0*b-3.0*c+d)*(u*u*u)+(2.0*a-5.0*b+4.0*c-d)*(u*u)+(-a+c)*u+2.0*b);
}
