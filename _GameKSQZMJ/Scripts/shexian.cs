using UnityEngine;
using System.Collections;
using SimpleFramework;

public class shexian : MonoBehaviour {
    public string raycastName = "";
    public string Func = "";
	// Use this for initialization
	void Start () {
	
	}

    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(vc3, Vector3.forward, out hit))
            {
                //Debug.Log("sssssssssssssssssssssssss=========="+args);
                //Debug.Log("hit.gameObject=="+hit.collider.gameObject.name);
               
               
                Util.CallMethod(raycastName, Func, hit.collider.gameObject);
                      
            }
        }
    }
}
