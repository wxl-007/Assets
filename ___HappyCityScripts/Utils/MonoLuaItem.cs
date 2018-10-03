using UnityEngine;
using System.Collections;
using System;
[System.Serializable]
public class MonoLuaUIOutData
{ 
  public GameObject uiGameObj;
  public MonoBehaviour uiComponent;
  public string exportName;
}
[DisallowMultipleComponent]
public class MonoLuaItem : MonoBehaviour
{
  [SerializeField]
  public MonoLuaUIOutData[] outDatas;

}
