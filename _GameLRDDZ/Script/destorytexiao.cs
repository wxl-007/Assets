using UnityEngine;
using System.Collections;
/// <summary>
/// 特效播放完毕删除
/// </summary>
public class destorytexiao : MonoBehaviour {
    public GameObject[] particleList;
    void Start()
    {
        Invoke("destorys",1.5f);
       
    }
    void destorys()
    {
        //GM.instance.closeWait();
        Destroy(this.gameObject);
    }

}
