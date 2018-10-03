using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;
public class LRDDZ_Loading : MonoBehaviour {
    /*
    public GameObject loadingIcon;
    public UILabel percenttext;
    AsyncOperation async;
    float time=0;
    float progress;
    public GameObject pannel;
    public static string sceneName = "Game";

    public static LRDDZ_Loading instance = new LRDDZ_Loading();
    void Start () {        
        
        //适配屏幕
        float standard_width = 1920;
        float standard_height = 1080;
        float device_width = 0;
        float device_height = 0;
        float adjustor = 0;
        device_width = Screen.width;
        device_height = Screen.height;
        if ((device_width / device_height) != (standard_width / standard_height))
        {
            adjustor = (device_height * 1920) / (device_width * 1080);
            pannel.transform.localScale = new Vector3(adjustor, adjustor, 1);
        }
        sceneName = Global.instance.sScene;

        //异步加载
        if (Global.instance.sScene != "")
            StartCoroutine(LoadScene());
    }
	
	// Update is called once per frame
	void Update () {
        
	}

    IEnumerator LoadScene()
    {
        pannel.SetActive(true);
        async = SceneManager.LoadSceneAsync(sceneName);
        while (!async.isDone)
        {
            percenttext.text = Mathf.RoundToInt(async.progress * 100) + "%";
            yield return new WaitForEndOfFrame();
        }
        yield return null;
    }
    */
}
