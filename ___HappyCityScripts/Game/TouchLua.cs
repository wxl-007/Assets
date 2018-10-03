using UnityEngine;
using System.Collections;
using SimpleFramework;

public class TouchLua : LuaBehaviour
{
    public bool isOpenMove = false;
	private bool isDown=false;
	private bool isMove = false;
	private float tapX = 0;
  
	void Update () { 
		if(Input.GetMouseButtonDown(0)){
			tapX = Input.mousePosition.x;
			Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            isDown = true;  
            CallMethod("TouchDown", vc3);
            /*
            RaycastHit hit;
            if (Physics.Raycast(vc3, Vector3.back, out hit))
            { 
                if (hit.collider.gameObject.transform == this.transform)
                {
                    isDown = true;
                    Debug.Log("按下" + vc3);
                }
            }
             * */
		}else if(Input.GetMouseButtonUp(0)){ 
			isDown = false; 
			isMove = false; 
            Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            CallMethod("TouchUp", vc3);
		}

        if (isOpenMove && isDown)
        {
            if (Mathf.Abs(Input.mousePosition.x - tapX) > 10)
            {
                isMove = true;
                Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                CallMethod("TouchMove", vc3);
                tapX = Input.mousePosition.x;
            } 

            /*
			if(!isMove){
				if(Mathf.Abs(Input.mousePosition.x - tapX)> 10){
					isMove = true;
				}
			}
			if(isMove){
				Vector3 vc3 = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                Debug.Log("移动中" + vc3);

			}
         * 
         */
		}
	}
}
