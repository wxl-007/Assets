using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(MonoUILuaItemExport))]
public class MonoUILuaItemExportInspector :Editor {
  public override void OnInspectorGUI()
  {
    base.OnInspectorGUI();
    MonoUILuaItemExport tMonoUIExport = target as MonoUILuaItemExport;
    NGUIEditorTools.DrawSeparator();
    EditorGUILayout.BeginHorizontal();
    {
      if (GUILayout.Button("Export Script", GUILayout.MinWidth(30.0f)))
      {
        if (!tMonoUIExport.Export())
          EditorUtility.DisplayDialog("Error", "失败！", "OK");
        else
          EditorUtility.DisplayDialog("Success", "成功！", "OK");
        AssetDatabase.Refresh();
      }
    }
    EditorGUILayout.EndHorizontal();
  }

}
