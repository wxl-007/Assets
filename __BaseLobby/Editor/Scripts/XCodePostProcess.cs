#if UNITY_EDITOR && UNITY_IOS
using System.Diagnostics;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditorInternal;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.IO;

using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;

public class XCodePostProcess {
	
	private static string XCodePostProcess_root = "XCodePostProcess/";

	private string m_XCode_Path;
//	private PBXProject m_Project;
	private static string m_TargetGuid;

	[ PostProcessBuild ( 10000 ) ]
	public static void OnPostProcessBuild ( BuildTarget target , string pathToBuiltProject ){
		XCodePostProcess process = new XCodePostProcess ();
		process.DoPostProcessBuild(target, pathToBuiltProject);
	}

	public void DoPostProcessBuild ( BuildTarget target , string pathToBuiltProject ){

		if (target != BuildTarget.iOS) return;
        EditorPrefs.SetString ("xcode_build_path", pathToBuiltProject);
		m_XCode_Path = pathToBuiltProject;

		string pbxPath = PBXProject.GetPBXProjectPath (m_XCode_Path);
		PBXProject m_Project = new PBXProject ();
		m_Project.ReadFromFile (pbxPath);

		string targetName = PBXProject.GetUnityTargetName ();
		m_TargetGuid = m_Project.TargetGuidByName (targetName);

		string[] groupArray = Directory.GetDirectories (XCodePostProcess_root + "Group");
		string[] fileArray = Directory.GetFiles(XCodePostProcess_root + "File","*.*",SearchOption.AllDirectories);// Directory.GetDirectories (XCodePostProcess_root + "File");
		string[] libArray = File.ReadAllLines (XCodePostProcess_root + "Lib.txt");
		string[] buildPropertyArray = File.ReadAllLines (XCodePostProcess_root + "BuildProperty.txt");
		string PlistPropertyText = File.ReadAllText (XCodePostProcess_root + "PlistProperty.txt");

		AddCopyGroup_config (m_Project, groupArray);
		AddFile_config (m_Project, fileArray);
		AddLib_config (m_Project, libArray);
		SetBuildProperty_config (m_Project, buildPropertyArray);

		m_Project.WriteToFile (pbxPath);
        writeCapability(pbxPath);
		//plist 修改
		string plistPath = Path.Combine (m_XCode_Path, "Info.plist");
		string plistText = File.ReadAllText (plistPath);

		plistText = plistText.Insert (plistText.LastIndexOf ("</dict>"),PlistPropertyText);
		plistText = plistText.Replace ("    <key>NSLocationWhenInUseUsageDescription</key>\n    <string></string>", "");
		File.WriteAllText (plistPath,plistText);

		OnPostProcessBuild_ReplaceConfig (target, pathToBuiltProject);

	}
    private string getCapabilityFile()
    {
        string tResult = "";
        string[] libArray = File.ReadAllLines(XCodePostProcess_root + "Capability.txt");
        for (int i=0;i<libArray.Length;i++ )
        {
            tResult += libArray[i] + "\n";
        }
        return tResult;
    }
	private void writeCapability(string fileName)
    {
        StreamReader tSReader = new StreamReader(fileName, Encoding.UTF8);
        string tTemplateStr = "";
        string tTargetId = "";
        while (tSReader.Peek() >= 0)
        {
            string tLineStr = tSReader.ReadLine();
            if (tLineStr.Contains("TestTargetID"))
            {
                tTargetId = tLineStr.Split("=".ToCharArray())[1];
                tTargetId = tTargetId.Trim();
                tTargetId = tTargetId.Replace(";", "");
            }
            tTemplateStr += tLineStr + "\n";
            
        }
        tSReader.Close();
        if(tTargetId!="")
        {
            string tRegStr = @"TargetAttributes = \{([\s\S]*)\}";
            Regex tReg = new Regex(tRegStr);
            MatchCollection tMatchs = tReg.Matches(tTemplateStr);
            if(tMatchs.Count==1)
            {
                string tTargetAttributs = tMatchs[0].Value;
                string tTestTargetIdReg = tTargetId + @" = \{([\s\S]*)\}";
                Regex tSysCapabilityReg = new Regex(tTestTargetIdReg);
                MatchCollection tMatchsCapbility = tSysCapabilityReg.Matches(tTargetAttributs);
                if(tMatchsCapbility.Count==0)
                {
                    string tNewCapability = @"TargetAttributes = {" + "\r\n"; ;
                    tNewCapability += "					" + tTargetId + " = {";
                    tNewCapability += "\r\n"+getCapabilityFile();
                    tNewCapability += "\r\n					};";
                    tTargetAttributs = tTargetAttributs.Replace(@"TargetAttributes = {", tNewCapability);
                }else if(tMatchsCapbility.Count == 1)
                {
                    string tNewCapability = "";
                    tNewCapability += "					" + tTargetId + " = {";
                    tNewCapability += "\r\n" + getCapabilityFile();
                    tNewCapability += "\r\n					};";
                    tTargetAttributs = Regex.Replace(tTargetAttributs, tTestTargetIdReg, tNewCapability);
                }
                tTemplateStr = Regex.Replace(tTemplateStr, tRegStr, tTargetAttributs);

                FileStream fs = File.Open(fileName, FileMode.Create);
                byte[] tWriteBytes = Encoding.Default.GetBytes(tTemplateStr);
                fs.Write(tWriteBytes, 0, tWriteBytes.Length);
                fs.Flush();
                fs.Close();
            }
        }
    }


    private void AddFile_config(PBXProject m_Project, params string[] fileStrArray){
	
		string desPath = string.Empty;
		string desDir = string.Empty;
		foreach (var item in fileStrArray) {
			if (item.ToLower ().Contains (".ds_store") || item.Contains(".DS_Store") || item.ToLower ().Contains (".svn")) continue;

			desPath = item.Replace (XCodePostProcess_root + "File", m_XCode_Path);
			desDir = Path.GetDirectoryName (desPath);

			if (!Directory.Exists (desDir)) Directory.CreateDirectory (desDir);

			File.Copy (item, desPath,true);

			if (File.Exists (desPath)) { }
			else {
				m_Project.AddFile (desPath,desPath.Substring(m_XCode_Path.Length));
			}
		}
	}

	private void SetBuildProperty_config(PBXProject m_Project, params string[] propertyStrArray){
		foreach (var item in propertyStrArray) {
			SetBuildProperty (m_Project,m_TargetGuid, item);
		}
	}

	public void SetBuildProperty(PBXProject project, string targetGuid, string propertyStr){
		string[] propertyStrSplit = propertyStr.Split (new string[]{"="},System.StringSplitOptions.RemoveEmptyEntries);
		if (propertyStrSplit.Length != 2) return;
		string[] vals = propertyStrSplit[1].Split (new string[]{" "},System.StringSplitOptions.RemoveEmptyEntries);
		if (vals.Length > 0) SetBuildProperty (project,targetGuid,propertyStrSplit[0],vals);
	}

	public void SetBuildProperty(PBXProject project, string targetGuid, string key, params string[] vals){
		for (int i = 0; i < vals.Length; i++) {
			if (i == 0)
				project.SetBuildProperty (targetGuid, key, vals [i]);
			else
				project.AddBuildProperty (targetGuid, key, vals [i]);
		}
	}

	private void AddLib_config(PBXProject m_Project, params string[] libStrArray){
	
		foreach (var item in libStrArray) {
			if (item.StartsWith (":"))
				m_Project.RemoveFile (m_Project.FindFileGuidByProjectPath (item.Substring (1)));
			else if (item.EndsWith (".framework"))
				m_Project.AddFrameworkToProject (m_TargetGuid,item,true);
			else AddLib (m_Project,m_TargetGuid,item);
		}
	}

	public void AddLib(PBXProject project, string targetGuid, string libStr){
		project.AddFileToBuild(targetGuid, project.AddFile("usr/lib/" + libStr, "Frameworks/"+libStr, PBXSourceTree.Sdk));
	}

	private void AddCopyGroup_config(PBXProject m_Project, params string[] dirArray){
	
		foreach (var item in dirArray) {
			AddCopyGroup (m_Project, m_TargetGuid, item);
		}
	}
		
	/// <summary>
	/// 把一个项目拷贝到 xcode 项目下，并以group的方式添加到xcode 项目中
	/// </summary>
	/// <param name="project">Project.</param>
	/// <param name="targetGuid">Target GUID.</param>
	/// <param name="srcDir">Source dir.</param>
	/// <param name="desDir">DES dir.</param>
	public void AddCopyGroup(PBXProject project, string targetGuid, string srcDir,string desDir = null){
		if(string.IsNullOrEmpty(desDir)) desDir = Path.Combine (m_XCode_Path, Path.GetFileName (srcDir));
		CopyAndReplaceDirectory (srcDir, desDir);//拷贝到xcode 的目录下
		AddGroup(project,targetGuid, desDir);//添加group
	}

	/// <summary>
	/// 把 xcode 项目的目录下的 一个文件夹以 Group 的方式 添加到 xcode项目中
	/// </summary>
	/// <param name="project">Project.</param>
	/// <param name="targetGuid">Target GUID.</param>
	/// <param name="dir">Dir.</param>
	public void AddGroup(PBXProject project, string targetGuid, string dir){
		if (!Directory.Exists (dir)) return;

		foreach (var item in Directory.GetFiles(dir,"*.*",SearchOption.AllDirectories)) {
			AddGroupFile (project,targetGuid,item, item.Replace(m_XCode_Path,""));
		}
	}

	public void AddGroupFile(PBXProject project, string targetGuid, string src, string des){
		project.AddFileToBuild(targetGuid, project.AddFile(src, des, PBXSourceTree.Absolute));
	}

	internal static void CopyAndReplaceDirectory(string srcPath, string dstPath)
	{
		if (srcPath.ToLower ().Contains (".ds_store") || srcPath.Contains(".DS_Store") || srcPath.ToLower ().Contains (".svn")) return;
		
		if (Directory.Exists(dstPath))
			Directory.Delete(dstPath);
		if (File.Exists(dstPath))
			File.Delete(dstPath);

		Directory.CreateDirectory(dstPath);

		foreach (var file in Directory.GetFiles(srcPath))
			File.Copy(file, Path.Combine(dstPath, Path.GetFileName(file)));

		foreach (var dir in Directory.GetDirectories(srcPath))
			CopyAndReplaceDirectory(dir, Path.Combine(dstPath, Path.GetFileName(dir)));
	}
		
	public void OnPostProcessBuild_ReplaceConfig ( BuildTarget target , string pathToBuiltProject ){
		if (target != BuildTarget.iOS) return;

		Dictionary<string,string> iap_file_dict = new Dictionary<string, string> (){ 
			{"qbq.u.lobby","qbq"},
			{"qbq.u.game597","qbq"},
			{"game407.u.lobby","131"},
			{"wylk.u.lobby","510k"},
			{"wylk.u.game510k","510k"},
			{"fkby.u.game597","fkby"},
			{"fkby.u.lobby","fkby"},
		};

		string bundleId = new GameEntityAll ().BundleId;
		string iap_game = "qbq";
		if(iap_file_dict.ContainsKey(bundleId)) iap_game = iap_file_dict[bundleId];
		//根据包的 bundleid 修改 RechargeViewController
		if(File.Exists(XCodePostProcess_root+"Config/IAP/"+iap_game+"/RechargeViewController.m"))
		    File.Copy (XCodePostProcess_root+"Config/IAP/"+iap_game+"/RechargeViewController.m",pathToBuiltProject+"/IAP/RechargeViewController.m",true);

		string wxappid = PlatformGameDefine.playform.WXAppId; //"wxcd00aad1c9746cfe";
		//修改plist 中的 wxappid
		string plistPath = Path.Combine (m_XCode_Path, "Info.plist");
		string plistText = File.ReadAllText (plistPath);
		plistText = plistText.Replace ("{$wxappid}", wxappid);
		plistText = plistText.Replace ("{$bundleId_urlSchema}", bundleId);

		string wxpayappid = PlatformGameDefine.playform.WXPayAppId;
		//如果存在微信支付的appid就进行配置
		if (!string.IsNullOrEmpty (wxpayappid)) 
		{
			plistText = plistText.Replace ("{$wxpayappid}", wxpayappid); 
		}
		else
		{
			plistText = plistText.Replace ("<dict>\n\t\t<key>CFBundleTypeRole</key>\n\t\t<string>Editor</string>\n\t\t<key>CFBundleURLName</key>\n\t\t<string>weixinpay</string>\n\t\t<key>CFBundleURLSchemes</key>\n\t\t<array>\n\t\t\t<string>{$wxpayappid}</string>\n\t\t</array>\n\t</dict>", "");

		}
		//如果存在微信支付的appid就进行配置
		if (PlatformGameDefine.playform.wxShareAppIds !=  null && PlatformGameDefine.playform.wxShareAppIds.Length > 0) 
		{
			string tempshareid = "";
			foreach (string tempstr in PlatformGameDefine.playform.wxShareAppIds)
			{
				tempshareid = tempshareid + "<string>" + tempstr + "</string>\n\t\t";
			}

			plistText = plistText.Replace ("<string>{$wxshareappid}</string>", tempshareid); 
		}
		else
		{
			plistText = plistText.Replace ("<dict>\n\t\t<key>CFBundleTypeRole</key>\n\t\t<string>Editor</string>\n\t\t<key>CFBundleURLName</key>\n\t\t<string>weixinshare</string>\n\t\t<key>CFBundleURLSchemes</key>\n\t\t<array>\n\t\t\t<string>{$wxshareappid}</string>\n\t\t</array>\n\t</dict>", "");

		}

		File.WriteAllText (plistPath,plistText);
	}
}
#endif