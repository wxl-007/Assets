using UnityEngine;
using System.Collections;

public class RAnimation : MonoBehaviour {
    private int movecont;
    public UISprite Tcover;
    public TBTWPlayerCtrl myCtrl;
	// Use this for initialization
    public void OnAnimationPlay()
    {
        Tcover.gameObject.transform.localPosition = new Vector3(0, -9.54f, 0);
        iTween.PunchRotation(this.gameObject, iTween.Hash("amount", new Vector3(0, 0, 30), "time", 1.1f, "easetype", iTween.EaseType.easeOutBounce, "loopType", iTween.LoopType.none, "oncomplete", "Tmove"));

    }
    void OnEnable()
    {
        Tcover.gameObject.transform.localPosition = new Vector3(0, -9.54f, 0);
        //iTween.RotateBy(this.gameObject, iTween.Hash("amount", new Vector3(0, 0, -1), "time", 1f, "easetype", iTween.EaseType.linear, "loopType", iTween.LoopType.loop));
        //iTween.PunchPosition(this.gameObject, iTween.Hash("amount", new Vector3(0.15f, 0, 0), "time", 0.5f, "easetype", iTween.EaseType.punch, "loopType", iTween.LoopType.pingPong));
        //iTween.PunchRotation(this.gameObject, iTween.Hash("amount", new Vector3(0, 0, 30), "time", 0.5f, "easetype", iTween.EaseType.easeInBounce, "loopType", iTween.LoopType.pingPong));
        /*
         Tcover.gameObject.transform.localPosition = new Vector3(0, -9.54f, 0);
         movecont = 0;
         iTween.PunchRotation(this.gameObject, iTween.Hash("amount", new Vector3(0, 0, 30), "time", 1.1f, "easetype", iTween.EaseType.easeOutBounce, "loopType", iTween.LoopType.none, "oncomplete", "Tmove"));
        
        
         StartCoroutine(moveEnd());
        
         */
        //PunchPosition
        //PunchRotation
	}
	
    void Tmove()
    {
      /*  movecont++;
        if (movecont <= 1)
        {
            iTween.PunchRotation(this.gameObject, iTween.Hash("amount", new Vector3(0, 0, 30), "time", .8f, "easetype", iTween.EaseType.easeOutBounce, "loopType", iTween.LoopType.none, "oncomplete", "Tmove"));
        }
        else {
        */
        iTween.MoveBy(Tcover.gameObject, iTween.Hash("amount", new Vector3(0, 0.1f, 0), "time", 0.5f, "easetype", iTween.EaseType.linear, "loopType", iTween.LoopType.none, "oncomplete", "moveEnd"));

        StartCoroutine(moveEnd());
        //}
    }
    IEnumerator moveEnd()
    {

        yield return new WaitForSeconds(1.2f);
        myCtrl.SetLateEnd();
    }
}
