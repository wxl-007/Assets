using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class IPTest_Login : Login
{
    public UIInput _WebURL_Input;
    public UIInput _GameURL_Input;
    public UIInput _SocketLobbyURL_Input;
    public static string _WebURL;
    public static string _GameURL;
    public static string _SocketLobbyURL;

    public UILabel _IsSocketLobby_label;

    //// Use this for initialization
    void Start()
    {
        base.Start();
        
        SetInputValue(_WebURL_Input, _WebURL);
        SetInputValue(_GameURL_Input, _GameURL);
        SetInputValue(_SocketLobbyURL_Input, _SocketLobbyURL);
        if(_IsSocketLobby_label) _IsSocketLobby_label.text = "" + PlatformGameDefine.playform.IsSocketLobby;
    }

    private static void SetInputValue(UIInput input, string text)
    {
        if (input && !string.IsNullOrEmpty(text)) input.value = text;
    }

    //// Update is called once per frame
    //void Update () {

    //}

    public void OnToggle_game597(bool isToggle)
    {
        if (isToggle == false || PlatformGameDefine.playform is PlatformGame1977) return;
        UnityEngine.Debug.Log("CK : ------------------------------ 597 = " + isToggle );
        SwitchPlatform(new PlatformGame1977());
    }

    public void OnToggle_game131(bool isToggle)
    {
        if (isToggle == false || PlatformGameDefine.playform is PlatformGame407) return;
        UnityEngine.Debug.Log("CK : ------------------------------ 131 = " + isToggle);
        SwitchPlatform(new PlatformGame407());
    }

    public void OnToggle_game7997(bool isToggle)
    {
        if (isToggle == false || PlatformGameDefine.playform is PlatformGame7997) return;
        UnityEngine.Debug.Log("CK : ------------------------------ 7997 = " + isToggle);
        SwitchPlatform(new PlatformGame7997());
    }

    public void SwitchPlatform(PlatformEntity platform)
    {
        PlatformGameDefine.playform = platform;

        StartCoroutine(DoSwitchPlatform());
    }

    IEnumerator DoSwitchPlatform()
    {
        EginProgressHUD.Instance.ShowWaitHUD("正在切换平台");
        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 0);

        yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig());

        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 1);
        string gfname = PlayerPrefs.GetString("GFname" + PlatformGameDefine.playform.PlatformName);
        string wfname = PlayerPrefs.GetString("WFname" + PlatformGameDefine.playform.PlatformName);
        PlatformGameDefine.playform.UpdateGFnameURL(gfname);
        PlatformGameDefine.playform.UpdateWFnameURL(wfname);

        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 2);

        yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig_game_hostArr());
        yield return StartCoroutine(PlatformGameDefine.playform.LoadConfig_web_hostArr());

        UnityEngine.Debug.Log("CK : ------------------------------ loading = " + 3);
        EginProgressHUD.Instance.HideHUD();
    }

    public void OnInput_web(string text)
    {
        _WebURL = text;
    }

    public void OnInput_game(string text)
    {
        _GameURL = text;
    }

    public void OnInput_socketLobby(string text)
    {
        _SocketLobbyURL = text;
    }

    public void OnClick_ChangeIP()
    {
        if (_WebURL_Input) _WebURL = DefaultInputValueCheck(_WebURL_Input.value);
        if(_GameURL_Input) _GameURL = DefaultInputValueCheck(_GameURL_Input.value);
        if(_SocketLobbyURL_Input) _SocketLobbyURL = DefaultInputValueCheck(_SocketLobbyURL_Input.value);

        ConnectDefine.updateConfig();
        EginProgressHUD.Instance.ShowPromptHUD("切换ip 完成",0.5f);
    }

    /// <summary>
    /// 如果是UIInput 的默认值,那么就去掉, 或者说如果该url 没有 带 . 就不使用该string
    /// </summary>
    /// <param name="url"></param>
    /// <returns></returns>
    private string DefaultInputValueCheck(string url)
    {
        if (url!= null && url.Contains(".")) return url;
        return string.Empty;
    }
}
