using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using UnityEngine;
using System.Text.RegularExpressions;
#if UNITY_EDITOR
using UnityEditor;
#endif
public class MonoUILuaItemExport : MonoBehaviour
{

    private const string SybolNewLine = "\t\n";
    private string fileName = "";
    public string luaFileName = ""; //相对于lua的位置


    public bool Export()
    {
#if UNITY_EDITOR
        Debug.Log(Application.dataPath + "/Lua/");
        if (string.IsNullOrEmpty(luaFileName))
        {
            fileName = EditorUtility.OpenFilePanel(
              "选择 " + gameObject.name + " ui 导出到哪个ui",
              Application.dataPath + "/lua",
              "lua");
            if (fileName.Length == 0)
            {
                return false;
            }
        }
        else
        {
            fileName = Application.dataPath + "/lua/" + luaFileName + ".lua";
        }

#endif

        // 开始写文件

        MonoLuaItem[] tUIItemArr = gameObject.GetComponentsInChildren<MonoLuaItem>(true);
        string tRepeatStr = checkRepeat(tUIItemArr);
        if (tRepeatStr != "")
        {
#if UNITY_EDITOR
            EditorUtility.DisplayDialog("导出失败", tRepeatStr, "确定");
#endif
            return false;
        }
        Debug.Log("len:" + tUIItemArr.Length);
        if (tUIItemArr.Length > 0)
        {

            StreamReader tSReader = new StreamReader(fileName, Encoding.UTF8);
            string tTemplateStr = "";
            while (tSReader.Peek() >= 0)
            {
                tTemplateStr += tSReader.ReadLine() + SybolNewLine;
            }
            tSReader.Close();
            tTemplateStr += "\r\n";
            Regex tReg = new Regex(@"function " + "this" + @":autoGetUI()([\s\S]*?end)");
            MatchCollection tMatchs = tReg.Matches(tTemplateStr);
            if (tMatchs.Count > 0)
            {
                tTemplateStr = Regex.Replace(tTemplateStr, @"function " + "this" + @":autoGetUI()([\s\S]*?end )", autoSetUI(tUIItemArr));
            }
            else
            {
                tTemplateStr += "\r\n" + autoSetUI(tUIItemArr);
            }
            tReg = new Regex(@"function " + "this" + @":autoClearUI()([\s\S]*?end)");
            tMatchs = tReg.Matches(tTemplateStr);
            if (tMatchs.Count > 0)
            {
                tTemplateStr = Regex.Replace(tTemplateStr, @"function " + "this" + @":autoClearUI()([\s\S]*?end )", autoClearUI(tUIItemArr));
            }
            else
            {
                tTemplateStr += "\r\n" + autoClearUI(tUIItemArr);
            }

            FileStream fs = File.Open(fileName, FileMode.Create);
            byte[] tWriteBytes = Encoding.UTF8.GetBytes(tTemplateStr);
            fs.Write(tWriteBytes, 0, tWriteBytes.Length);
            fs.Flush();
            fs.Close();
        }
        return true;
    }
    string checkRepeat(MonoLuaItem[] pArr)
    {
        Dictionary<string, bool> tKey = new Dictionary<string, bool>();
        for (int tIndex = 0, tLen = pArr.Length; tIndex < tLen; tIndex++)
        {
            MonoLuaItem tMonoLuaItem = pArr[tIndex];

            MonoLuaUIOutData[] tOutDatas = tMonoLuaItem.outDatas;
            for (int tIndexOut = 0, tLenOut = tOutDatas.Length; tIndexOut < tLenOut; tIndexOut++)
            {
                
                MonoLuaUIOutData tOutData = tOutDatas[tIndexOut];
                if(tOutData.uiGameObj==null&&tOutData.uiComponent==null)continue;

                if (tKey.ContainsKey(tOutData.exportName))
                {
                    return getGameObjectPath(tMonoLuaItem.gameObject) + " repeated " + tOutData.exportName;
                }
                tKey.Add(tOutData.exportName, true);
            }
        }
        return "";
    }
    string autoSetUI(MonoLuaItem[] pArr)
    {
        string tResult = "function " + "this" + ":autoGetUI()\r\n";

        string tDisPoseStr = "";
        for (int tIndex = 0, tLen = pArr.Length; tIndex < tLen; tIndex++)
        {
            MonoLuaItem tMonoLuaItem = pArr[tIndex];

            MonoLuaUIOutData[] tOutDatas = tMonoLuaItem.outDatas;
            for (int tIndexOut = 0, tLenOut = tOutDatas.Length; tIndexOut < tLenOut; tIndexOut++)
            {
                MonoLuaUIOutData tOutData = tOutDatas[tIndexOut];
                if (tOutData.uiGameObj == null && tOutData.uiComponent == null) continue;
                if (tOutData.uiGameObj != null)
                {
                    if(tOutData.uiGameObj== gameObject)
                    {
                        tResult += "\t this.ui_" + tOutData.exportName + "=this.gameObject" + SybolNewLine;
                    }
                    else
                    {
                        tResult += "\t this.ui_" + tOutData.exportName + "=this.transform:FindChild(\"" + getGameObjectPath(tOutData.uiGameObj) + "\").gameObject" + SybolNewLine;
                    }
                   
                }
                else
                {
                    string tType = getUIType(tOutData.uiComponent);
                    if(tOutData.uiComponent.gameObject== gameObject)
                    {
                        tResult += "\t this.ui_" + tOutData.exportName + "=this.gameObject:GetComponent(\"" + tType + "\")" + SybolNewLine;
                    }
                    else
                    {
                        tResult += "\t this.ui_" + tOutData.exportName + "=this.transform:FindChild(\"" + getGameObjectPath(tOutData.uiComponent.gameObject) + "\").gameObject:GetComponent(\"" + tType + "\")" + SybolNewLine;
                    }
                   
                }
            }
        }
        tResult += "end ";
        return tResult;
    }
 
    string autoClearUI(MonoLuaItem[] pArr)
    {
        string tResult = "function " + "this" + ":autoClearUI()\r\n";

        string tDisPoseStr = "";
        for (int tIndex = 0, tLen = pArr.Length; tIndex < tLen; tIndex++)
        {
            MonoLuaItem tMonoLuaItem = pArr[tIndex];
            MonoLuaUIOutData[] tOutDatas = tMonoLuaItem.outDatas;
            for (int tIndexOut = 0, tLenOut = tOutDatas.Length; tIndexOut < tLenOut; tIndexOut++)
            {
                MonoLuaUIOutData tOutData = tOutDatas[tIndexOut];
                if (tOutData.uiGameObj == null && tOutData.uiComponent == null) continue;
                if (tOutData.uiComponent == null)
                {
                    tResult += "\t this.ui_" + tOutData.exportName + "= nil" + SybolNewLine;
                }
                else
                {
                    string tType = getUIType(tOutData.uiComponent);
                    tResult += "\t this.ui_" + tOutData.exportName + "=nil" + SybolNewLine;
                }
            }
        }
        tResult += "end ";
        return tResult;
    }
    string getGameObjectPath(GameObject pObj)
    {
        string tResult = pObj.name;
        if(pObj.transform== transform) {
            return "";
        }
        Transform tParent = pObj.transform.parent;
        int tCount = 1;
        while (tParent != transform&&tParent!=null)
        {
            tResult = tParent.name + "/" + tResult;
            tParent = tParent.parent;
            tCount += 1;
            if (tCount > 10)
            {
                break;
            }
        }
        //tResult = transform.name+"/"+tResult;
        return tResult;
    }

    string getUIType(MonoBehaviour pObj)
    {
        string tResult = "";
        if (pObj == null)
        {
            return "GameObject";
        }
        if (pObj is UILabel)
        {
            tResult = "UILabel";
        }
        else if (pObj is UIInput)
        {
            tResult = "UIInput";
        }
        else if (pObj is UISprite)
        {
            tResult = "UISprite";
        }
        else if (pObj is UITexture)
        {
            tResult = "UITexture";// "UITexture";
        }
        else
        {
            return pObj.GetType().ToString();
        }
        return tResult;
    }
}

