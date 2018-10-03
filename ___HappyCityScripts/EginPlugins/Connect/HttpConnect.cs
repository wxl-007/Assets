using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class HttpConnect {
	
	private static HttpConnect _instance;
	public static HttpConnect Instance {
		get {
			if(_instance == null) {
				_instance = new HttpConnect();
			}
			return _instance;
		}
	}

	public WWW HttpRequestAli (string url) {
		EginTools.Log(url);		

		WWW www = new WWW (url);
		return www;
	}
	
	public WWW HttpRequest (string url, WWWForm form) {	
		EginTools.Log(url);	

		if (form == null) { form = new WWWForm(); }

		if(form != null){
			long ms=EginTools.nowMinis() ;
			long mms = ms + EginTools.localBeiJingTime;
			string ccode = EginTools.encrypTime (mms.ToString());
 			form.AddField("client_code", ccode);
		}

		
		WWW www = (form == null) ? new WWW(url) : new WWW(url, form);
		return www;
	}
	public WWW HttpRequestWithSession (string url, WWWForm form) {	
		EginTools.Log(url);	
		
		string cookie = (EginUser.Instance.session != null)?EginUser.Instance.session:"";
    	Hashtable requestHeaders = new Hashtable();
    	requestHeaders.Add( "Cookie", cookie);


        Dictionary<string, string> headers = new Dictionary<string, string>();
        headers.Add("Cookie", cookie);
		
		if (form == null) { form = new WWWForm(); }
		form.AddField("Cookie", cookie);
	
		if(form != null){
			long ms=EginTools.nowMinis() ;
			long mms = ms + EginTools.localBeiJingTime;
			string ccode = EginTools.encrypTime (mms.ToString());
			
			form.AddField("client_code", ccode);
		}

        WWW www = new WWW(url, form.data, headers);
		return www;
	}

    public HttpResult BaseResult(WWW www)
    {
        return BaseResult(www,true);
    }

    public HttpResult BaseResult (WWW www, bool isSwitchUrl) {
		HttpResult result = new HttpResult();

		if(www.error != null) {
 			EginTools.Log("Http Failed: " + www.error); //UnityEngine.Debug.Log("CK : ------------------------------ error = " + www.error);
            if (isSwitchUrl)
            {
                PlatformGameDefine.playform.swithWebHostUrl();//切换网页IP
                result.isSwitchHost = true;
            }
		}else {
            string tempResultStr = www.text.Trim(); //
			UnityEngine.Debug.Log("CK : ------------------------------ text = " + tempResultStr);

            EginTools.Log("base:::"+tempResultStr);
			
			JSONObject resultObj = new JSONObject(tempResultStr);
			if (resultObj.type == JSONObject.Type.NULL) {

                if (isSwitchUrl)
                {
                    PlatformGameDefine.playform.swithWebHostUrl();//切换网页IP
                    result.isSwitchHost = true;
                }
				result.resultObject = ZPLocalization.Instance.Get("HttpConnectError");
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
							result.resultObject = Regex.Unescape(resultObj["body"].str);
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
	
	/* ------ Register ------ */
	public HttpResult RegisterResult (WWW www) {
		HttpResult result = new HttpResult();
		if(www.error != null) {
			EginTools.Log("Http Failed: " + www.error);
		}else {
			string tempResultStr = www.text.Trim();
			EginTools.Log(tempResultStr);
			
			if ("ok".Equals(tempResultStr)) {
				result.resultType = HttpResult.ResultType.Sucess;
			}else if(tempResultStr.Length > 0) {
				JSONObject resultObj = new JSONObject(tempResultStr);
				if (resultObj.type == JSONObject.Type.NULL) {
					result.resultObject = Regex.Unescape(tempResultStr);
				}else {
					result.resultObject = Regex.Unescape(resultObj["error"].str);
				}
			}else {
				result.resultObject = ZPLocalization.Instance.Get("HttpConnectError");
			}
		}
		return result;
	}
	
	/* ------ Login ------ */
	public HttpResult UserLoginResult (WWW www) {
		HttpResult result = BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType) {
			string session = "";
			if(www.responseHeaders.ContainsKey("SET-COOKIE")) {
				session = www.responseHeaders["SET-COOKIE"];
			}
			Dictionary<string, string> resultDict = ((JSONObject)result.resultObject).ToDictionary();
			
			EginUser.Instance.InitUserWithDict(resultDict, session);
			EginUser.Instance.isGuest = false;
		}
		return result;
	}
	
	public HttpResult GuestLoginResult (WWW www) {
		HttpResult result = BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType) {
			string session = "";
			if(www.responseHeaders.ContainsKey("SET-COOKIE")) {
				session = www.responseHeaders["SET-COOKIE"];
			}
			Dictionary<string, string> resultDict = ((JSONObject)result.resultObject).ToDictionary();
			
			EginUser.Instance.InitGuestWithDict(resultDict, session);
			EginUser.Instance.isGuest = true;
		}
		return result;
	}
	
	/* ------ Other ------ */
	public HttpResult UpdateUserinfoResult (WWW www) {
		HttpResult result = BaseResult(www);
		
		if(HttpResult.ResultType.Sucess == result.resultType) {
			JSONObject resultObj = (JSONObject)result.resultObject;
			EginUser.Instance.UpdateUserWithDict(resultObj.ToDictionary());
		}
		return result;
	}
	
	public HttpResult RoomListResult (WWW www) {
		HttpResult result = BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType) {
			JSONObject resultObject = (JSONObject)result.resultObject;
			List<GameRoom> roomlist = new List<GameRoom>();
			foreach (JSONObject roomInfo in resultObject.list) {
				GameRoom room = new GameRoom(roomInfo.ToDictionary());
				roomlist.Add(room);
			}
			result.resultObject = roomlist;
		}
		return result;
	}

	/* ------ Gift ------ */
	public HttpResult GiftNicknameResult (WWW www) {
		HttpResult result = BaseResult(www);
		if(HttpResult.ResultType.Sucess == result.resultType) {
			result.resultObject = Regex.Unescape(result.resultObject.ToString());
		}
		return result;
	}


	public HttpResult BaseResultSocket (WWW www) {
			HttpResult result = new HttpResult ();
		
			if (www.error != null) {
					EginTools.Log ("Http Failed: " + www.error);
					PlatformGameDefine.playform.swithGameHostUrl ();//切换游戏IP
			} else {
					string tempResultStr = www.text.Trim ();
					EginTools.Log ("base socket:::" + tempResultStr);
		
					JSONObject resultObj = new JSONObject (tempResultStr);
					 
					if (resultObj) {
 						result.resultObject = resultObj;
						result.resultType = HttpResult.ResultType.Sucess;
							 
					} else {
							Debug.Log ("解析出错了---HttpConnect.cs -- 60");
					}
			
 			}
			return result;
	}

	public HttpResult BaseResultSocket2 (WWW www) {
		HttpResult result = new HttpResult ();
		
		if (www.error != null) {
			EginTools.Log ("Http Failed: " + www.error);
			PlatformGameDefine.playform.swithGameHostUrl ();//切换游戏IP
		} else {
			string tempResultStr = www.text.Trim();
			EginTools.Log(tempResultStr);
			
			if ("ok".Equals(tempResultStr)) {
				result.resultType = HttpResult.ResultType.Sucess;
			}else {
				result.resultObject = ZPLocalization.Instance.Get("HttpConnectError");
			}
			
 		}
		return result;
	}
	
	
}