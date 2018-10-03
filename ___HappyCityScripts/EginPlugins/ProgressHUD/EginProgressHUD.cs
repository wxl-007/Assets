using UnityEngine;
using System.Collections;
using SimpleFramework;
using SimpleFramework.Manager;
public class EginProgressHUD : MonoBehaviour
{
    private static EginProgressHUD _instance;
    public static EginProgressHUD Instance
    {
        get
        {
            if (!_instance)
            {
                _instance = GameObject.FindObjectOfType(typeof(EginProgressHUD)) as EginProgressHUD;
                if (!_instance)
                {
                    //GameObject prefab = Resources.Load("Prefabs/ProgressHUD", typeof(GameObject)) as GameObject; 
                    GameObject prefab = SimpleFramework.Util.LoadAsset(Utils._hallResourcesName + "/ProgressHUD", "ProgressHUD") as GameObject;//HappyCity
                    _instance = (EginProgressHUD)((GameObject)Instantiate(prefab)).GetComponent(typeof(EginProgressHUD));
                    object[] tObjList = Util.CallMethod("EginProgressHUD", "Init");
                   // DontDestroyOnLoad(_instance.gameObject);
                }
            }
            return _instance;
        }
    }
    public GameObject background;
    public GameObject gamebackground;
    public GameObject vPromptHUD;
    public UILabel promptMessageLabel;
    public float promptHUDDuration = 2f;

    public GameObject vWaitHUD;
    public UILabel waitMessageLabel;
    //srps游戏提示
    public GameObject SrpsGametishi;
    public UILabel SrpsGameLabel;
    //srps游戏提示2
    public GameObject SrpsGametishi2;
    public UILabel SrpsGameLabel2;
 
    //SRPS
    public GameObject vSrpsWaitHUD;
    public UILabel SrpsMessageLabel;
    //SRPS 快乐卡提示
    public GameObject vTishi;
    //srps纯文字提示
    public GameObject vSrpsTishi;
    public UILabel SrpsTishiLabel;

    // Show promptHUD
    public void ShowPromptHUD(string message)
    {
        ShowPromptHUD(message, null);
    }
    public void ShowPromptHUD(string message, System.Action onComplete)
    {
        ShowPromptHUD(message, promptHUDDuration, onComplete);
    }

    public void ShowPromptHUD(string message, float time)
    {
        ShowPromptHUD(message, time, null);
    }

    public void ShowPromptHUD(string message, float time, System.Action onComplete)
    {
        SrpsGametishi.SetActive(false);
        promptMessageLabel.text = message;
        ShowHUD(vPromptHUD);
		popupEft(vPromptHUD);
        StartCoroutine(HideHUDAfter(time,onComplete));

    }

    // Show waitHUD
    public void ShowWaitHUD(string message, bool isShowLabel = false)
    {
        SrpsGametishi.SetActive(false);
		if(isShowLabel){
			waitMessageLabel.text = message;
		}else{
			waitMessageLabel.text = "";
		}
		//Always showup tip text  2016.5.12
		waitMessageLabel.text = message;
        ShowHUD(vWaitHUD);

    }


    /// <summary>
    /// SRPS
    /// </summary>
    /// <param name="message"></param>
    public void SrpsShowWaitHUD(string message)
    {
        SrpsGametishi.SetActive(false);
        SrpsShowWaitHUD(message, promptHUDDuration);

    }
    public void SrpsShowWaitHUD(string message, float time)
    {
        SrpsGametishi.SetActive(false);
        SrpsMessageLabel.text = message;
        ShowHUD(vSrpsWaitHUD);
        StartCoroutine(HideHUDAfter(time));
    }
    /// <summary>
    /// SRPS文字提示
    /// </summary>
    /// <param name="message"></param>
   
    public void SrpsShowWaitHUD2(string message)
    {
      
        gamebackground.SetActive(false);
        background.SetActive(false);
        gamebackground.SetActive(false);
        background.SetActive(false);
        SrpsGameLabel2.text = message;
        ShowHUD(SrpsGametishi2);

        iTween.Stop(SrpsGameLabel2.gameObject);
        StartCoroutine(intervalAnimation2(6.0f));

    }
    private IEnumerator intervalAnimation2(float time)
    {
        yield return new WaitForSeconds(0.01f);
        SrpsGameLabel2.gameObject.transform.localPosition = new Vector3(0, 0, -0.1f);
        SrpsGameLabel2.alpha = 1.0f;
        iTween.MoveBy(SrpsGameLabel2.gameObject,iTween.Hash("y", 0.6f, "time", time, "easeType", iTween.EaseType.linear) );
        iTween.ValueTo(SrpsGameLabel2.gameObject, iTween.Hash("delay", 5.0f, "from", 1.0f, "to", 0, "time", time - 5.0f, "onupdate", "AnimationUpdata2", "onupdatetarget", gameObject, "oncomplete", "AnimationOver"));
    }
    public void AnimationUpdata2(object obj)
    {
        float per = (float)obj;
        SrpsGameLabel2.alpha = per;

    }
    public void SrpsShowWaitHUD1(string message)
    {
        gamebackground.SetActive(false);
        background.SetActive(false);
        SrpsShowWaitHUD1(message, promptHUDDuration);

    }
    public void SrpsShowWaitHUD1(string message, float time)
    {
        gamebackground.SetActive(false);
        background.SetActive(false);
        SrpsGameLabel.text = message;

        ShowHUD(SrpsGametishi);

        iTween.Stop(SrpsGameLabel.gameObject);
        StartCoroutine(intervalAnimation(time));
    }
    private IEnumerator intervalAnimation(float time)
    {
        yield return new WaitForSeconds(0.01f);
        SrpsGameLabel.gameObject.transform.localPosition = new Vector3(0, 0, -0.1f);
        SrpsGameLabel.alpha = 1.0f;
        iTween.MoveBy(SrpsGameLabel.gameObject, iTween.Hash("delay", 1.0f, "y", 0.1f, "time", time, "easeType", iTween.EaseType.linear));
        iTween.ValueTo(SrpsGameLabel.gameObject, iTween.Hash("delay", 1.0f, "from", 1.0f, "to", 0, "time", time, "onupdate", "AnimationUpdata", "onupdatetarget", gameObject, "oncomplete", "AnimationOver"));
    }
    public void AnimationOver()
    {
        HideHUD();
    }
    public void AnimationUpdata(object obj)
    {
        float per = (float)obj;
        SrpsGameLabel.alpha = per;
        
    }
    /// <summary>
    /// SRPS存文字提示
    /// </summary>
    public void SrpsTishi(string message)
    {
        SrpsTishi(message, promptHUDDuration);
    }
    public void SrpsTishi(string message, float time)
    {
        //background.SetActive(false);
        SrpsTishiLabel.text = message;
        ShowHUD(vSrpsTishi);
        StopCoroutine(HideHUDAfter(time));
    }

    public void SrpsShowTishi()
    {
        SrpsShowTishi(promptHUDDuration);

    }

    public void SrpsShowTishi(float time)
    {
        ShowHUD(vTishi);
        background.SetActive(false);
        StartCoroutine(HideHUDAfter(time));

    }

    private IEnumerator HideHUDAfter(float time, System.Action onComplete = null)
    {
        yield return new WaitForSeconds(time);
        HideHUD();
        if (onComplete != null) onComplete();
    }
    // Show HUD
    private void ShowHUD(GameObject HUD)
    {
        vPromptHUD.SetActive(false);
        vWaitHUD.SetActive(false);
        vSrpsWaitHUD.SetActive(false);
        vTishi.SetActive(false);
        vSrpsTishi.SetActive(false);
        HUD.SetActive(true);
        this.gameObject.SetActive(true);
    }

    // Hide HUD
    public void HideHUD()
    {
        this.gameObject.SetActive(false);
    }

	public void popupEft(GameObject obj)
	{
		obj.transform.localScale = Vector3.one;
		iTween.ScaleFrom(obj, iTween.Hash("scale",new Vector3(0.5f,0.5f,0.5f),"time",0.5f,"easetype",iTween.EaseType.easeOutElastic));
	}
}
