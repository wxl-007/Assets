using UnityEngine;
using System.Collections;

public class destorythis : MonoBehaviour {
    public void destorythisNOthink()
    {
        Destroy(this.gameObject, 0.6f);
    }
    public void destorythisNow()
    {
        Invoke("waitFalse", 0.5f);
        Invoke("waitEnabled", 0.2f);
        Destroy(this.gameObject,0.6f);
    }
    void waitFalse()
    {
        //GM.instance.closeWait();
    }
    void waitEnabled()
    {
        this.gameObject.GetComponent<UISprite>().enabled = false;
    }
}
