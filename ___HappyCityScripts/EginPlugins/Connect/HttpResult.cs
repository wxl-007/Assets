using UnityEngine;
using System.Collections;

public class HttpResult {
	
	public enum ResultType {
		Failed, 
		Sucess
	}
	
	private static string ResultUnknowError = ZPLocalization.Instance.Get("HttpConnectFailed");
	
	public ResultType resultType;
	public object resultObject;
    public bool isSwitchHost = false;
	
	public HttpResult () {
		resultType = ResultType.Failed;
		resultObject = ResultUnknowError;
	}
}
