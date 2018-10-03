using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TransitionCrossFade : MonoBehaviour {

    private static TransitionCrossFade _instance;
    public static TransitionCrossFade Instance
    {
        get
        {
            if (!_instance)
            {
                _instance = GameObject.FindObjectOfType(typeof(TransitionCrossFade)) as TransitionCrossFade;
                if (!_instance)
                {
                    //GameObject prefab = Resources.Load("Prefabs/ProgressHUD", typeof(GameObject)) as GameObject;
                    GameObject prefab = SimpleFramework.Util.LoadAsset(Utils._hallResourcesName+"/FadeEftPrb", "FadeEftPrb") as GameObject;
                    _instance = (TransitionCrossFade)((GameObject)Instantiate(prefab)).GetComponent(typeof(TransitionCrossFade));

                    DontDestroyOnLoad(_instance.gameObject);
                }
            }
            return _instance;
        }
    }

    private UIPanel fadePanel;
    void fadeInUpdate(float v)
    {
        if (fadePanel != null)
        {
            fadePanel.alpha = v;
        }
    }
    void fadeincomplete()
    {
        if (fadePanel != null && fadePanel.gameObject != null)
        {
            gameObject.SetActive(false);
            //Destroy(fadePanel.gameObject);
        }
        fadePanel = null;
    }

    public void ShowFadeTransition()
    {
        gameObject.SetActive(true);
        //add by xiaoyong 2016.3.16 visual effect: fade in scene
        //GameObject fadeObj = Instantiate(fadePrb) as GameObject;
        if(fadePanel == null) fadePanel = this.GetComponent<UIPanel>();
        iTween.ValueTo(gameObject, iTween.Hash("from", 1.0f, "to", 0, "time", 0.8f, "onupdate", "fadeInUpdate", "onupdatetarget", gameObject,
                                               "oncomplete", "fadeincomplete", "oncompletetarget", gameObject, "easetype", iTween.EaseType.linear));
    }

 //   // Use this for initialization
 //   void Start () {
	
	//}
	
	//// Update is called once per frame
	//void Update () {
	
	//}
}
