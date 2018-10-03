using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class AliPayUtil {

	public static string out_trade_noAli = string.Empty;

    #region alipay
    [DllImport ("__Internal")]
	private static extern float _OnAliPay (string jsonMsg);


	public static void OnAliPay(string jsonStr)
	{
		
		if (jsonStr == null) return; 
         
		UnityEngine.Debug.Log("jun : ~~~~~~~~~~~~~~~~ OnAliPay " + jsonStr);

#if UNITY_IOS
		_OnAliPay(jsonStr);
#elif UNITY_ANDROID
		using (AndroidJavaObject jc = new AndroidJavaObject ("com.yanfa.alipay.aliPayUtil")) {
			jc.Call("Pay",jsonStr);
		} 
#endif
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="message">Message.</param>
	void OnAliPayCallback(string message){
		
		Debug.Log ("OnAliPayCallback : message ------------------------------------ = " + message);
	}
	#endregion

}

