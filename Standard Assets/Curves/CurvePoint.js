#pragma strict

@script AddComponentMenu("")
function OnDrawGizmos() {
	Gizmos.DrawIcon(transform.position, "Aperture_CurvePoint.tiff");
}
