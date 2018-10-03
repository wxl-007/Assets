using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;
using System.Security.Cryptography;  
using System.Text;
using System;
using System.Threading;
using LuaInterface;
using SimpleFramework;

public class PlatformEntityLua : PlatformEntity
{

    #region  Lua调用相关
    private LuaScriptMgr m_LuaMgr;
    private LuaScriptMgr LuaManager
    {
        get
        {
            if (m_LuaMgr == null)
            {
                m_LuaMgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
            }
            return m_LuaMgr;
        }
    }
    public LuaTable LuaSelf;    //本类的Lua实例对象
    /// <summary>
    /// 调用Lua函数
    /// </summary>
    /// <param name="func">函数名</param>
    /// <param name="args">传入的属性</param>
    /// <returns>返回的属性</returns>
    protected object[] CallMethod(string func, params object[] args)
    {
        object[] more = new object[args.Length + 1];
        more[0] = LuaSelf;
        Array.Copy(args, 0, more, 1, args.Length);
        return LuaSelf.RawGetFunc(func).Call(more);
    }
    /// <summary>
    /// 赋值Lua属性
    /// </summary>
    /// <param name="_name">属性名称</param>
    /// <param name="args">属性值</param>
    protected void SetLuaProperty(string _name, object args)
    {
        LuaSelf[_name] = args;
    }
    /// <summary>
    /// 获取Lua属性
    /// </summary>
    /// <param name="_name">属性名称</param>
    /// <returns>属性值</returns>
    protected object GetLuaProperty(string _name)
    {
        return LuaSelf[_name];
    }
    /// <summary>
    /// 在C#中开启Lua协程
    /// </summary>
    /// <param name="_f">Lua函数名</param>
    /// <param name="args">函数的参数</param>
    /// <returns></returns>
    public IEnumerator LuaCoroutine(string _f, params object[] args)
    {
        object[] more = new object[args.Length + 3];
        more[0] = LuaSelf;
        more[1] = LuaSelf.RawGetFunc(_f);
        more[2] = _f;
        Array.Copy(args, 0, more, 3, args.Length);
        LuaSelf.RawGetFunc("StartLuaCoroutine").Call(more);

        while ((bool)CallMethod("GetDoneCoroutineCTOLua", _f)[0])
        {
            yield return new WaitForSeconds(0.1f);
        }
        yield return 0;
    }


    /// <summary>
    /// 将Action和LuaFunction关联调用
    /// </summary>
    /// <param name="onComplete">要调用的Action</param>
    /// <returns></returns>
    public LuaFunction LuaFunctionToAction(System.Action onComplete = null)
    {
        if (onComplete != null)
        {
            return (LuaFunction)CallMethod("LuaFunctionToAction", onComplete)[0];
        }
        else
        {
            return null;
        }
    }

    //Lua调用测试函数和属性
    public string testName { get { return (string)GetLuaProperty("testName"); } set { SetLuaProperty("testName", value); } }
    public string testCall(string _name)
    {
        return (string)CallMethod("testCall", _name)[0];
    }
    public IEnumerator testCoroutine()
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("testCoroutine", "属性1", "属性2"));
    }
    public void testOnComplete(System.Action onComplete = null)
    {
        CallMethod("testOnComplete", LuaFunctionToAction(onComplete));
    }
    #endregion Lua调用相关
   
 
    public override string PlatformName { get { return (string)GetLuaProperty("PlatformName"); } }

    public override string HostURL { get { return (string)GetLuaProperty("HostURL"); } }
    public override string DownloadURL { get { return (string)GetLuaProperty("DownloadURL"); } }
    public override string RechargeURL { get { return (string)GetLuaProperty("RechargeURL"); } }
    public override string FeedbackContent { get { return (string)GetLuaProperty("FeedbackContent"); } }
    public override string UnityMoney { get { return (string)GetLuaProperty("UnityMoney"); } }
    public override bool IOSPayFlag { get { return (bool)GetLuaProperty("IOSPayFlag"); } }
    public override bool IsPool { get { return (bool)GetLuaProperty("IsPool"); } }
    public override bool IsYan { get { return (bool)GetLuaProperty("IsYan"); } }

    public override int VersionCode { get { 
        return Convert.ToInt32(GetLuaProperty("VersionCode")); 
    } }
    public override string Register_url { get { return (string)GetLuaProperty("Register_url"); } }

    public override string gameUrl { get { return (string)GetLuaProperty("gameUrl"); } }
    public override string webUrl { get { return (string)GetLuaProperty("webUrl"); } }

    public override string SocketLobbyUrl { get {  return (string)GetLuaProperty("SocketLobbyUrl"); } }

    public override bool IsSocketLobby { get { return (bool)GetLuaProperty("IsSocketLobby"); } }

	public override string AliAppId { get { return (string)GetLuaProperty("AliAppId"); } }
    public override string WXAppId { get { return (string)GetLuaProperty("WXAppId"); } } 
    public override string WxAppSecret { get { return (string)GetLuaProperty("WxAppSecret"); } }

	public override string WXPayAppId { get { return (string)GetLuaProperty("WXPayAppId"); } }
	public override string WXPayAppSecret { get { return (string)GetLuaProperty("WXPayAppSecret"); } }
    //public override string WXPayURL { get { return (string)GetLuaProperty("WXPayURL"); } }
    public override string WXShareUrl { get { return (string)GetLuaProperty("WXShareUrl"); } }
    public override string WXShareDescription { get { return (string)GetLuaProperty("WXShareDescription"); } }

    //510k 
    public override string HallHomeInfos { get { return (string)GetLuaProperty("HallHomeInfos"); } }

   
    public override bool IsInstantUpdate { get { return (bool)GetLuaProperty("IsInstantUpdate"); } }
    public override string InstantUpdateUrl {get {  return (string)GetLuaProperty("InstantUpdateUrl");}}

  
     

    /// <summary>
    /// 检测用户是否是测试人员(上一次登录成功是否是测试人员)
    /// </summary>
    /// <returns></returns>
    public override bool IsTester()
    {  
        return (bool)CallMethod("IsTester")[0];
    }

    public override string ConfigURL() 
    {
        return (string)CallMethod("ConfigURL")[0];
	}

    public override string GameNoticeURL()
    {
        return (string)CallMethod("GameNoticeURL")[0];
	}
    public override void LoadURL(string game, string web) 
    { 
        CallMethod("LoadURL", game, web);
    }


    //-----------------------------------------缓存相关------------------------
    public override bool IsCache_UserIp { get { return (bool)GetLuaProperty("IsCache_UserIp"); } }
    public override bool IsCache_config { get { return (bool)GetLuaProperty("IsCache_config"); } }
    //----------------------SocketManager配置信息------------------------------------
    public override string SocketManager_config_str { get { return (string)GetLuaProperty("SocketManager_config_str"); } }

 
    #region 加载总配置文件
    public override IEnumerator LoadLocalConfig()
    { 
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadLocalConfig"));//重新加载config文件
    }
    public override IEnumerator LoadConfig()
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadConfig")); 
    }

     
    #endregion 加载总配置文件

    #region ip地址不通是,切换ip
    //切换游戏IP
    public override void swithGameHostUrl(System.Action onComplete = null)
    { 
        CallMethod("swithGameHostUrl",LuaFunctionToAction(onComplete));
    }
     

    //切换网页IP
    /// <summary>
    /// 
    /// </summary>
    /// <param name="isHttp">由于加了socket大厅后这里有http请求和 socket 大厅请求的切换,因此用 itHttp 来判断是否是http地址. 避免原本为了切换http地址而切换了socket地址</param>
    public override void swithWebHostUrl(bool isHttp = true, System.Action onComplete = null)
    {
        CallMethod("swithWebHostUrl", isHttp, LuaFunctionToAction(onComplete));
    } 
    //切换socket大厅ip, 已弃用
    public override void swithSocketLobbyHostUrl(System.Action onComplete = null)
    {
        CallMethod("swithSocketLobbyHostUrl", LuaFunctionToAction(onComplete));
    }
    #endregion ip地址不通是,切换ip


    //------------------------------------------------------------------------

    #region 获取conf配置文件及ip 相关方法区
    public override IEnumerator LoadConfByUser(string username)
    {

        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadConfByUser", username));
    }

    public override void Start_LoadAndSaveConfigData(System.Action onComplete = null)
    {
        CallMethod("Start_LoadAndSaveConfigData", LuaFunctionToAction(onComplete));
    }
    public override IEnumerator LoadAndSaveConfigData(System.Action onComplete = null, float delayTime = 15f)
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadAndSaveConfigData", LuaFunctionToAction(onComplete), delayTime));
    }
    #endregion 获取conf配置文件及ip 相关方法区


    #region 加载游戏ip相关方法
    /// <summary>
    /// 把所有的conf 的 url 加到一个list中
    /// </summary>
    /// <returns></returns>
    public override IEnumerator LoadConfig_game_hostArr(System.Action onComplete = null, bool isSaveAllConf = false)
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadConfig_game_hostArr", LuaFunctionToAction(onComplete), isSaveAllConf));
    }
    public override IEnumerator LoadConf_game_hostArr(System.Action onComplete = null)
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadConf_game_hostArr", LuaFunctionToAction(onComplete)));
    }
     

    public override bool LoadGameIPs(bool isSaveIP, string tempResultStr, bool isSaveAllConf = false)
    {
        return (bool)CallMethod("LoadGameIPs", isSaveIP, tempResultStr, isSaveAllConf)[0];
    }

    /// <summary>
    /// 通过加密字符串获取ip地址
    /// </summary>
    /// <param name="tempResultStr"></param>
    public override bool LoadGameIPs(string tempResultStr, bool isSaveAllConf = false)
    {
        return (bool)CallMethod("LoadGameIPsT", tempResultStr, isSaveAllConf)[0];
    }

    /// <summary>
    /// 替换游戏配置文件名
    /// </summary>
    /// <param name="game"></param>
    /// <returns></returns>
    public override string UpdateGFnameURL(string game)
    {
        return (string)CallMethod("UpdateGFnameURL", game)[0];
    }
    #endregion 加载游戏ip相关方法

    #region 加载web(大厅)ip 相关方法
    /// <summary>
    /// 把所有的conf 的 url加到一个list中
    /// </summary>
    /// <returns></returns>
    public override IEnumerator LoadConfig_web_hostArr(System.Action onComplete = null, bool isSaveAllConf = false)
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadConfig_web_hostArr", LuaFunctionToAction(onComplete), isSaveAllConf));
    }

    public override IEnumerator LoadConf_web_hostArr(System.Action onComplete = null)
    {
        yield return StaticUtils.GetGameManager().StartCoroutine(LuaCoroutine("LoadConf_web_hostArr", LuaFunctionToAction(onComplete)));
    }

     

    public override bool LoadWebIPs(bool isSaveIP, string tempResultStr, bool isSaveAllConf = false)
    {
        return (bool)CallMethod("LoadWebIPs", isSaveIP, tempResultStr, isSaveAllConf)[0];
    }

    /// <summary>
    /// 从加密字符串中获取web ip地址
    /// </summary>
    /// <param name="tempResultStr"></param>
    public override bool LoadWebIPs(string tempResultStr, bool isSaveAllConf = false)
    {
        return (bool)CallMethod("LoadWebIPsT", tempResultStr, isSaveAllConf)[0];
    }

    /// <summary>
    /// 替换web配置文件名
    /// </summary>
    /// <param name="web"></param>
    /// <returns></returns>
    public override string UpdateWFnameURL(string web)
    {
        return (string)CallMethod("UpdateWFnameURL", web)[0];
    }
    #endregion 加载web(大厅)ip 相关方法

   
    #region 修改不同平台下的config.xml文件名
    protected override void FixConfigUrls(string[] urls)
    {
        CallMethod("FixConfigUrls", urls);
    }
 
    #endregion 修改不同平台下的config文件名


    public override string GetPlatformPrefix()
    { 
        return (string)CallMethod("GetPlatformPrefix")[0];
    }
     
     
} 
//把所有confurl都先拿到加密字符串
