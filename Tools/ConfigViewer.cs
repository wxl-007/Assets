using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.IO;

public class ConfigViewer : MonoBehaviour {

	public UILabel _Result_label;
	public UIInput _OrigineUrls_input;

	protected string _ResultInfo;
	protected string[] config_urls;

	public void ClearCache(){
		PlayerPrefs.DeleteAll ();
	}

	public void Parse () {
//		config_urls = new string[]{ 
//			"http://131.game597.com/131newunity/socket_config999.xml",
//			"http://bb.game131.com/131newunity/socket_config999.xml",
//			"http://bb.game131.cn/131newunity/socket_config999.xml",
//			"http://131.game597.net/131newunity/socket_config999.xml",
//			"http://131.game597.cn/131newunity/socket_config999.xml",
//			"http://131.597game.net/131newunity/socket_config999.xml",
//			"http://dow1.game131.com/131newunity/socket_config999.xml",
//			"http://dow2.game131.com/131newunity/socket_config999.xml",
//			"http://dow3.game131.com/131newunity/socket_config999.xml",
//			"http://dow4.game131.com/131newunity/socket_config999.xml",
//			"http://dow5.game131.com/131newunity/socket_config999.xml",
//			"http://dow6.game131.com/131newunity/socket_config999.xml",
//			"http://dow7.game131.com/131newunity/socket_config999.xml",
//			"http://dow8.game131.com/131newunity/socket_config999.xml",
//			"http://dow9.game131.com/131newunity/socket_config999.xml",
//			"http://dow10.game131.com/131newunity/socket_config999.xml",



//		};

		if (string.IsNullOrEmpty (_OrigineUrls_input.value)) {
			_OrigineUrls_input.value = "请输入有效url地址！";
			return;
		}

		_Result_label.text = "正在解析";

		config_urls = _OrigineUrls_input.value.Split (',');

		StartCoroutine (StartLoadConfig());
	}

	public IEnumerator StartLoadConfig(){
		_ResultInfo = null;
		if (_OrigineUrls_input.value.EndsWith (".conf")) {//conf 解码
			yield return StartCoroutine( ParseConf (new List<string>(this.config_urls)));
		} else {//config 解析
		
			yield return StartCoroutine (LoadConfig());
		}
		_Result_label.text = _ResultInfo+"\r\n－－－－－－－－解析结束－－－－－－－－\r\n\r\n";
		Debug.Log (_ResultInfo);
	}


		
	public IEnumerator LoadConfig()
	{
		string[] config_urls = this.config_urls;

		string config_urls_json_str = PlayerPrefs.GetString("config_urls", "");
		if (!string.IsNullOrEmpty(config_urls_json_str))//从config 文件中保存了config_urls 到 PlayerPrefs 中//如果
		{
			JSONObject json = new JSONObject(config_urls_json_str);
			List<string> configList = new List<string>();
			//config_urls = new string[json.list.Count + this.config_urls.Length];

			foreach (var item in json.list)
			{
				//UnityEngine.Debug.Log("CK : ------------------------------ name = " + item.str );

				if (!configList.Contains(item.ToString())) configList.Add(item.str);
			}

			foreach (var item in this.config_urls)
			{
				if (!configList.Contains(item.ToString())) configList.Add(item);
			}

			config_urls = configList.ToArray();
		}

		JSONObject configObj = null;
		if (config_urls != null && config_urls.Length > 0)
		{
			_ResultInfo += "------------所有的Configs------------------\r\n";
			foreach (var item in config_urls) {
				_ResultInfo += item + "\r\n";
			}

			System.Random ro = new System.Random();
			string tempStr = string.Empty;
			foreach (var item in config_urls)
			{
				tempStr = item + "?" + ro.NextDouble();

				WWW www = new WWW (tempStr);
				yield return www;
				if (www.error == null) {
					HttpResult result = BaseResult (www);
					if (result.resultType == HttpResult.ResultType.Sucess) {
						_ResultInfo += "\r\n当前用的Config：\r\n" + tempStr;
						_ResultInfo += "\r\nConfig text = " + www.text;
						configObj = (JSONObject)result.resultObject;
						break;
					} else {
						_ResultInfo += "\r\nurl: " + tempStr + " 出错了, error = " + result.resultObject;
					}
				} else {
					_ResultInfo += "\r\nurl: " + tempStr + " 出错了, error = " + www.error;
				}
			}
		}

		if (configObj == null)
			_ResultInfo += "\r\n无有效url";

		yield return StartCoroutine(UpdateConfig(configObj));//更新配置文件信息
	}

	public IEnumerator UpdateConfig(JSONObject configObj)
	{
		List<string> web_conf_list = new List<string> ();
		List<string> game_conf_list = new List<string> ();
		if (configObj!= null)
		{
			try
			{
				web_conf_list = ParseArrayOrStringJson(configObj["web_hosts"], web_conf_list);
				game_conf_list = ParseArrayOrStringJson(configObj["game_hosts"], game_conf_list);

				JSONObject config_urlsJson = configObj["config_urls"];
				if (config_urlsJson != null)
				{
					for (int i = 0; i < config_urlsJson.list.Count; i++)
					{
						config_urlsJson.list[i].str = WWW.UnEscapeURL(config_urlsJson.list[i].str);
					}
					SetConfig_urls(config_urlsJson.ToString());
				}
				else
				{
					SetConfig_urls(null);
				}
			}
			catch (System.Exception e)
			{
				Debug.Log ("出错了：" + e);
			}
		}

		_ResultInfo += "\r\n\r\n------------所有的 web conf------------------\r\n";
		foreach (var item in web_conf_list) {
			_ResultInfo += item + "\r\n";
		}

		_ResultInfo += "\r\n------------所有的 game conf------------------\r\n";
		foreach (var item in game_conf_list) {
			_ResultInfo += item + "\r\n";
		}

		UnityEngine.Debug.Log("CK : ------------------------------ web_conf_list = " + web_conf_list.Count + ", game_conf_list = " + game_conf_list.Count);
		_ResultInfo += "\r\n\r\n----------开始解析ip------------";
		yield return StartCoroutine(ParseConf(web_conf_list));
		yield return StartCoroutine( ParseConf (game_conf_list));
	}

	public IEnumerator ParseConf(List<string> list){
		Debug.Log ("ParseConf");
		foreach (var item in list) {
			WWW www = new WWW (item);
			yield return www;
			if (www.error == null) {
				_ResultInfo += "\r\nurl = " + item + "\r\nIps = " + aesDecrypt (www.text);
			} else {
				_ResultInfo += "\r\nurl = " + item + "连接失败，error ＝ " + www.error;
			}
		}
	}







	public HttpResult BaseResult (WWW www) {
		HttpResult result = new HttpResult();

		if(www.error != null) {
			UnityEngine.Debug.Log("CK : ------------------------------ error = " + www.error);

		}else {
			string tempResultStr = www.text.Trim(); 
			UnityEngine.Debug.Log("CK : ------------------------------ text = " + tempResultStr);

			JSONObject resultObj = new JSONObject(tempResultStr);
			if (resultObj.type == JSONObject.Type.NULL) {
				result.resultObject = "连接错误";
			}else {
				if(resultObj){
					string resultType =null ;//= resultObj["result"].str;
					if(resultObj["result"] != null){
						resultType = resultObj["result"].str;
					}
					if ("ok".Equals(resultType)) {
						result.resultObject = resultObj["body"];
						result.resultType = HttpResult.ResultType.Sucess;
					}else {
						if(resultObj["body"] !=null){
							result.resultObject = WWW.UnEscapeURL(resultObj["body"].str);
						}else{
							result.resultObject = null;
						}

					}
				}else{
					Debug.Log("解析出错了---HttpConnect.cs -- 60");
				}

			}
		}
		return result;
	}



	/// <summary>
	/// 用于后台配置config_urls 数据,或者从lua中设置config_urls数据
	/// </summary>
	/// <param name="config_urls"></param>
	public static void SetConfig_urls(string config_urls)
	{
		if(!string.IsNullOrEmpty(config_urls))
		{
			PlayerPrefs.SetString("config_urls", config_urls);
//			PlayerPrefs.SetString("config_urls_version", Utils.version);
		}
		else
		{
			PlayerPrefs.SetString("config_urls", "");
//			PlayerPrefs.SetString("config_urls_version", "");
		}

		PlayerPrefs.Save();
	}


	private List<string> ParseArrayOrStringJson(JSONObject arrayOrStringJson, List<string> result_List = null)
	{
		if (result_List == null) result_List = new List<string>();
		string url = null;
		if (arrayOrStringJson != null)
		{
			if (arrayOrStringJson.type == JSONObject.Type.ARRAY && arrayOrStringJson.list != null)
			{
				for (int i = 0; i < arrayOrStringJson.list.Count; i++)
				{
					url = WWW.UnEscapeURL(arrayOrStringJson.list[i].str);//热更新url地址
					if (!result_List.Contains(url)) result_List.Add(url);
				}
			}
			else if (arrayOrStringJson.type == JSONObject.Type.STRING && !string.IsNullOrEmpty(arrayOrStringJson.str))
			{
				url = WWW.UnEscapeURL(arrayOrStringJson.str);//热更新url地址
				if (!result_List.Contains(url)) result_List.Add(url);
			}
		}

		return result_List;
	}


	protected string aesDecrypt(string encrypted_data)
	{
		byte[] keyBytes = System.Convert.FromBase64String("NjFzM0ZkNzZoVDRrMHNtTA==");

		byte[] encrypted = System.Convert.FromBase64String(encrypted_data);//System.Text.ASCIIEncoding.ASCII.GetBytes(encrypted_data);

		byte[] iv = new byte[16];
		for (int k = 0; k < 16; k++)
		{
			iv[k] = encrypted[k];
		}

		byte[] e_bytes = new byte[encrypted.Length - 16];
		for (int k = 16; k < encrypted.Length; k++)
		{
			e_bytes[k - 16] = encrypted[k];
		}

		RijndaelManaged rijalg = new RijndaelManaged();
		rijalg.BlockSize = 128;
		rijalg.KeySize = 128;
		rijalg.FeedbackSize = 128;
		rijalg.Padding = PaddingMode.None;
		rijalg.Mode = CipherMode.CBC;

		rijalg.Key = keyBytes;//(new SHA256Managed()).ComputeHash(Encoding.ASCII.GetBytes("IHazSekretKey"));  
		rijalg.IV = iv;//System.Text.Encoding.ASCII.GetBytes("1234567890123456");

		string decrypted = "";
		int llen = e_bytes.Length / 16;
		for (int i = 0; i < llen; i++)
		{
			byte[] _bytes = new byte[16];
			for (int k = 0; k < 16; k++)
			{
				_bytes[k] = e_bytes[i * 16 + k];
			}

			ICryptoTransform decryptor = rijalg.CreateDecryptor(rijalg.Key, rijalg.IV);

			string plaintext;
			using (MemoryStream msDecrypt = new MemoryStream(_bytes))
			{
				using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
				{
					using (StreamReader srDecrypt = new StreamReader(csDecrypt))
					{
						plaintext = srDecrypt.ReadToEnd();
					}
				}
			}
			decrypted += plaintext;
		}
		return decrypted;
	}




	public class HttpResult {

		public enum ResultType {
			Failed, 
			Sucess
		}

		private static string ResultUnknowError = "连接失败";

		public ResultType resultType;
		public object resultObject;
		public bool isSwitchHost = false;

		public HttpResult () {
			resultType = ResultType.Failed;
			resultObject = ResultUnknowError;
		}
	}
}
