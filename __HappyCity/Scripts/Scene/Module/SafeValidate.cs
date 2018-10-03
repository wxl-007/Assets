using UnityEngine;
using System.Collections;

public class SafeValidate : ModuleBase {

	public enum ValidateType {
		BankPassword = 0, 
		PhoneCode = 1,
	}
	
	private bool mCheckState = false;
	private bool mLoginState = false;
	private ValidateType mValidateType;
	
	/* ------ Button Click ------ */
	public IEnumerator DoCheckValidateType () {
		if (!mCheckState) {
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			
			WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_TYPE_URL, null);
			yield return www;
			
			HttpResult result = HttpConnect.Instance.BaseResult(www);		
			EginProgressHUD.Instance.HideHUD();
			if(HttpResult.ResultType.Sucess == result.resultType) {
				mCheckState = true;
				JSONObject resultObj = (JSONObject)result.resultObject;
				mValidateType = (ValidateType)resultObj["bank_validate"].n;
				bool isLogin = (resultObj["is_login"].n == 1);
				UpdateLoginState(isLogin);
			}else {
				UpdateLoginState(false);
				EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
			}
		}
	}

	IEnumerator OnClickSendPhoneCode () {
		EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
		
		WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.SAFE_SEND_PHONECODE_URL, null);
		yield return www;
		
		HttpResult result = HttpConnect.Instance.BaseResult(www);	
		EginProgressHUD.Instance.HideHUD();
		if(HttpResult.ResultType.Sucess == result.resultType) {
			EginProgressHUD.Instance.ShowPromptHUD(ZPLocalization.Instance.Get("HttpConnectSucess"));
		}else {
			EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
		}
	}
	
	public IEnumerator OnClickValidate (string password) {
		if (!mLoginState) {
			EginProgressHUD.Instance.ShowWaitHUD(ZPLocalization.Instance.Get("HttpConnectWait"));
			WWWForm form = new WWWForm();
			form.AddField("password", password);
			WWW www = HttpConnect.Instance.HttpRequestWithSession(ConnectDefine.SAFE_VALIDATE_LOGIN_URL, form);
			yield return www;
			
			HttpResult result = HttpConnect.Instance.BaseResult(www);	
			EginProgressHUD.Instance.HideHUD();
			if(HttpResult.ResultType.Sucess == result.resultType) {
				UpdateLoginState(true);
			}else {
				UpdateLoginState(false);
				EginProgressHUD.Instance.ShowPromptHUD(result.resultObject as string);
			}
		}
	}
	
	/* ------ Other ------ */
	private void UpdateLoginState (bool loginState) {		
		mLoginState = loginState;
		if (loginState) {
			HideValidateInput();
		}else {
			ShowValidateInput(mValidateType);
		}
	}
	
	public bool LoginState {
		get {
			return mLoginState;
		}
	}
	
	public ValidateType GetValidateType {
		get {
			return mValidateType;
		}
	}
	
	/* ------ Virtual ------ */
	public virtual void ShowValidateInput (ValidateType validateType) {}
	
	public virtual void HideValidateInput () {}
}
