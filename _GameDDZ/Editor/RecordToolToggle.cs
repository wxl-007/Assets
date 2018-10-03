using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class RecordToolToggle {

	[MenuItem("Tools/Enable PC record", false, 11)]
	public static void enablePCRecord()
	{
		string originalDir = Application.dataPath.Replace("Assets","");
		string targetDir = Application.dataPath+ "/_GameDDZ/PCRecordPlugins/recordermp4/";
		if(Directory.Exists(originalDir+"/PCRecordPlugins")){
			Directory.Move(originalDir+"/PCRecordPlugins", Application.dataPath+"/_GameDDZ/PCRecordPlugins");
		}
//		if(Directory.Exists(targetDir+"ToSAFolder")){
//			Directory.Move(targetDir+"ToSAFolder", targetDir+"StreamingAssets");
//		}
//		if(Directory.Exists(targetDir+"res")){
//			Directory.Move(targetDir+"res", targetDir+"Resources");
//		}
//		if(Directory.Exists(targetDir+"pluginDisable")){
//			Directory.Move(targetDir+"pluginDisable", targetDir+"plugin");
//		}

		string[] allCode = File.ReadAllLines(Application.dataPath+"/_GameDDZ/scripts/GameDDZ.cs");
		string targetCode = allCode[0];
		if( targetCode.IndexOf("//#define PC_RECORD") != -1){
			allCode[0] = "#define PC_RECORD";
		}
		File.WriteAllLines(Application.dataPath+"/_GameDDZ/scripts/GameDDZ.cs", allCode);
		//Resources
		AssetDatabase.Refresh();
	}

	[MenuItem("Tools/Disable PC record", false, 12)]
	public static void disablePCRecord()
	{
		string originalDir = Application.dataPath.Replace("Assets","");
		if(Directory.Exists(Application.dataPath+ "/_GameDDZ/PCRecordPlugins")){
			Directory.Move(Application.dataPath+ "/_GameDDZ/PCRecordPlugins", originalDir+"/PCRecordPlugins");
		}
//		string targetDir = Application.dataPath+ "/_GameDDZ/PCRecordPlugins/recordermp4/";
//		if(Directory.Exists(targetDir+"StreamingAssets")){
//			Directory.Move(targetDir+"StreamingAssets", targetDir+"ToSAFolder");
//		}
//		if(Directory.Exists(targetDir+"Resources")){
//			Directory.Move(targetDir+"Resources", targetDir+"res");
//		}
//		if(Directory.Exists(targetDir+"plugin")){
//			Directory.Move(targetDir+"plugin", targetDir+"pluginDisable");
//		}

		string[] allCode = File.ReadAllLines(Application.dataPath+"/_GameDDZ/scripts/GameDDZ.cs");
		string targetCode = allCode[0];
		if( targetCode.IndexOf("#define PC_RECORD") != -1){
			allCode[0] = "//#define PC_RECORD";
		}
		File.WriteAllLines(Application.dataPath+"/_GameDDZ/scripts/GameDDZ.cs", allCode);
		//Resources
		AssetDatabase.Refresh();
	}
}
