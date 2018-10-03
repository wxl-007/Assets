using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using System.Xml;
using SimpleFramework;
using LuaInterface;

public class XMLResource : MonoBehaviour {
	private static readonly string FILENAME="res";
	private static XMLResource _instance;
	public static XMLResource Instance
	{
		get
		{
			if(!_instance)
			{
				init();
			}
			return _instance;
		}
	}
	private static void init()
	{
		_instance=GameObject.FindObjectOfType(typeof(XMLResource)) as XMLResource;
		if(!_instance)
		{
			GameObject container=new GameObject();
			container.name="XMLResourceContainer";
			_instance=container.AddComponent<XMLResource>();
			_instance.initResource();
		}
	}
	
	private void initResource()
	{
		Stream stream=null;
		string localName=CultureInfo.CurrentCulture.Name;
		string fileName=FILENAME+"."+localName;
		TextAsset textAsset =Resources.Load(fileName) as TextAsset;
		if(textAsset==null)
		{
			textAsset=Resources.Load(FILENAME) as TextAsset;
		}
		if(textAsset!=null)
		{
			stream=new MemoryStream(textAsset.bytes);
			mStrings=new Dictionary<string, string>();
			mArrays=new Dictionary<string, string[]>();
			initXMLRes(stream);
		}
		
	}
	private void initXMLRes(Stream input)
	{
		XmlReader read=XmlReader.Create(input);
		List<string> list=new List<string>();
		string elementName=null;
		string attributeName=null;
			
			
		while(read.Read())
		{
			string _value=string.Copy( Regex.Unescape(read.Value));
			if(read.NodeType==XmlNodeType.Element){
				elementName=read.Name;
				if("string-array".Equals(elementName)){
					list=new List<string>();
				}
				if(!"item".Equals(elementName)){
					attributeName=read.GetAttribute("name");
				}
			}else if(read.NodeType==XmlNodeType.Text&&_value.Trim().Length>0){
				if("string".Equals(elementName))
				{
					mStrings.Add(attributeName,_value);
				}else if("item".Equals(elementName)){
					list.Add(_value);
				}
			}else if(read.NodeType==XmlNodeType.EndElement){
				if("string-array".Equals(read.Name))
				{
					mArrays.Add(attributeName,list.ToArray());
				}
				elementName=null;
			}
		}
	}
	
	private Dictionary<string,string> mStrings=null;
	private Dictionary<string,string[]> mArrays=null;
	
	
	public string Str(string index)
	{
       // object[] tObjList = Util.CallMethod("XMLResource", "StringC",index);
       // string tResult = tObjList[0].ToString(); //BaseCallLua.GetMessage(index);
      // tResult;
        
		if(mStrings!=null){
			return String.Copy(mStrings[index]);
		}else{
			return null;
		}
	}
	public string[] Arr(string index)
	{
        //object[] tObjList = Util.CallMethod("XMLResource", "StringC", index);
        //LuaTable tResult = tObjList[0] as LuaTable;
        // tResult.ToArray<string>();  
        // BaseCallLua.GetMessageList(index);
         
		if(mArrays!=null){
			string[] tmp=mArrays[index];
			string[] ren=new string[tmp.Length];
			Array.Copy(tmp,ren,tmp.Length);
			tmp=null;
		
			return ren;
		}else{
			return null;
		}
	}
	
	void Start () {
		if(mStrings==null ||mArrays==null)
		{
			init();
		}
	}
	void Update () {
	}
}
