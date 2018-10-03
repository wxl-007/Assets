using UnityEngine;
using Umeng;
using System.Collections.Generic;


public class UmengUtil  {
        ///* 加入友盟插件 */
        public static void initUmeng(string pKey,string pAgentId,bool pIsDebug)
        {
            GA.StartWithAppKeyAndChannelId(pKey, pAgentId);
            GA.SetLogEnabled(pIsDebug);
        }
}



