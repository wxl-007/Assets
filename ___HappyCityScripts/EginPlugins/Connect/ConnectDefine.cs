using UnityEngine;
using System.Collections;

public class ConnectDefine {
    //510k合并入
    public static WWW Connectwww;

	public static string HostURL = PlatformGameDefine.playform.HostURL;

	// Login
	public static string LOGIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/login/";
	public static string GUEST_LOGIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/guestlogin/";
	// Register
	public static string REGISTER_VERIFY_CODE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/captcha/";
	public static string REGISTER_VERIFY_CODE_PREFIX_URL = PlatformGameDefine.playform.HostURL;
	//	public static string REGISTER_URL = PlatformGameDefine.playform.HostURL + "/unity/register/"; 	// shawn.debug
	public static string REGISTER_MOBILE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/register_mobile/";//"/mobile/register/";
    public static string REGISTER_WEIXIN_URL = PlatformGameDefine.playform.HostURL + "/account/openid/wechat_oauth/";//微信登录

    public static string REGISTER_MOBILE_PHONE_URL = PlatformGameDefine.playform.HostURL + "/mobile/regphone/";
	public static string GUEST_PHONE_REGIST_URL = PlatformGameDefine.playform.HostURL + "/mobile/guestphonereg/";
	public static string GUEST_RESGISTER_URL = PlatformGameDefine.playform.HostURL + "/client_unity/guestregister/";
	// Userinfo
	public static string USERINFO_AVATAR_URL = PlatformGameDefine.playform.HostURL + "/client_unity/modifyavatar/";
	public static string USERINFO_PASSWORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/changepass/";
	public static string USERINFO_BANK_PASSWORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/changebankpass/";
	// Convert
	public static string GOLDINGOT_COIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/dollar2money/";
	public static string GOLDINGOT_GOLDCOIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/dollar2gold/";
	public static string GOLDCOIN_COIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/gold2money/";
	public static string GOLDCOIN_HAPPYCARD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/gold2happy/";
	public static string HAPPYCARD_COIN_SUIT_URL = PlatformGameDefine.playform.HostURL + "/client_unity/happy2moneysuit/";
	public static string HAPPYCARD_COIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/happy2money/";

    // Bank510k
    public static string BANK_LOGON_URL = PlatformGameDefine.playform.HostURL + "/home/bank_logon_flash/";
    public static string BANK_LOGOUT_URL = PlatformGameDefine.playform.HostURL + "/home/bank_logout_flash/";
    public static string BANK_LOGONRECORD_URL = PlatformGameDefine.playform.HostURL + "/home/bank_logon_record_json/";
    public static string BANK_CHECKPWD_URL = PlatformGameDefine.playform.HostURL + "/home/bank_check_pwd_flash/";
    public static string BANK_VALIDATE_URL = PlatformGameDefine.playform.HostURL + "/home/logon_validate_flash/";
    public static string BANK_WELCOME_URL = PlatformGameDefine.playform.HostURL + "/home/bank_welcome_flash/";

	// Bank
	public static string BANK_SAVE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bag2bank/";
	public static string BANK_GET_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bank2bag/";
	public static string BANK_RECORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bank_record_json/";
	// GameRecord
	public static string GAME_RECORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/game_record/";
	// Backpack
	public static string BACKPACK_LIST_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bag_list/";
	// Mail
	public static string MAIL_COUNT_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/mailcount/";
	public static string MAIL_LIST_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/maillist/";
	public static string MAIL_DETAIL_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/";
	public static string MAIL_DELETE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/maildel/";
	public static string MAIL_SEND_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/mailwrite/";
	// Link
	public static string FORGET_PASSWORD_URL = PlatformGameDefine.playform.HostURL + "/account/pwd_reset/";
	public static string HOME_URL = PlatformGameDefine.playform.HostURL;
	public static string SERVICE_URL = PlatformGameDefine.playform.HostURL + "/us/online.html";
	public static string RECHARGE_URL = PlatformGameDefine.playform.HostURL + "/account/payment/";
	public static string GUIDE_URL = PlatformGameDefine.playform.HostURL + "/help/center.html";
	public static string SECURITY_URL = PlatformGameDefine.playform.HostURL + "/client_home/security/";
	public static string SUGGEST_URL = PlatformGameDefine.playform.HostURL + "/us/suggest.html";
	public static string BACKPACK_PROP_URL = PlatformGameDefine.playform.HostURL + "/client_home/props/";
	public static string REGISTER_AGREEMENT_URL = PlatformGameDefine.playform.HostURL + "/terms.html";
	// Other
	public static string FEEDBACK_URL = PlatformGameDefine.playform.HostURL + "/open/bug/";
	public static string UPDATE_USERINFO_URL = PlatformGameDefine.playform.HostURL + "/client_unity/userinfo/";
	public static string ROOM_LIST_URL = PlatformGameDefine.playform.HostURL + "/client_unity/gamerooms/";
	
	/* ------ hh.cc mobile ------ */
	// Safe
	public static string SAFE_VALIDATE_TYPE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/safe_validate/";
	public static string SAFE_SEND_PHONECODE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/send_phone_code/";
	public static string SAFE_VALIDATE_LOGIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bank_login/";
	// Award
	public static string AWARD_CHECK_URL = PlatformGameDefine.playform.HostURL + "/client_unity/device/reward/";
	public static string AWARD_GET_URL = PlatformGameDefine.playform.HostURL + "/client_unity/device/reward/";
	// Gift
	public static string GIFT_DELIVER_URL = PlatformGameDefine.playform.HostURL + "/client_unity/deliver_money/";
	public static string GIFT_NICKNAME_URL = PlatformGameDefine.playform.HostURL + "/client_unity/nickname_by_uid/";
	public static string GIFT_RECORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/deliver_record_json/";
	// Recharge
	public static string RECHARGE_CARD_SUIT_URL = PlatformGameDefine.playform.HostURL + "/client_unity/yeepaysuit/";
	public static string RECHARGE_OFFICIAL_CARD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/cardpay/";
	public static string RECHARGE_CARD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/yeepayexchange/";
	
	//UPDATE
	//	public static string VERSION_CHECK_URL = PlatformGameDefine.playform.HostURL + "/unity/config/";
	
	// bank 
	public static string BANK_RECHARGE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/pay/";
    //微信支付请求后台地址
	public static string BANK_RECHARGE_WX_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payment_confirm/";//
    //微信支付完成后查询支付结果地址
	public static string BANK_RECHARGE_WX_Confirm_URL = PlatformGameDefine.playform.HostURL + "/client_unity/wechatmobile/orderquery/";//

    // TIAN XIA FU
    public static string TXF_RECHARGE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/tianxiapay/";
	
	// bank bili
	public static string BANK_BILI_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payrateshengpay/";//
	
	/// ZFB bili
	public static string ZFB_BILI_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payratealipay/";//
	
	// ka  bili
	public static string CARD_BILI_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payratecardsuit/";//
	//verify
	public static string VERIFY_CODE_URL = PlatformGameDefine.playform.HostURL + "/client_home/safe_device/";
	
	//change agent
	public static string CHANGE_AGENT_URL = PlatformGameDefine.playform.HostURL + "/client_home/change_agent/";
	
	//yanzheng
	public static string YAN_ZHENG_URL = PlatformGameDefine.playform.HostURL + "/client_unity/captcha/";
    public static string CONNECTHOST = PlatformGameDefine.playform.HostURL;

	public static void updateConfig(){
		HostURL = PlatformGameDefine.playform.HostURL;
		// Login
		LOGIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/login/";
		GUEST_LOGIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/guestlogin/";
		// Register
		REGISTER_VERIFY_CODE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/captcha/";
		REGISTER_VERIFY_CODE_PREFIX_URL = PlatformGameDefine.playform.HostURL;
		REGISTER_MOBILE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/register_mobile/";//"/mobile/register/";
		
		REGISTER_MOBILE_PHONE_URL = PlatformGameDefine.playform.HostURL + "/mobile/regphone/";
		GUEST_PHONE_REGIST_URL = PlatformGameDefine.playform.HostURL + "/mobile/guestphonereg/";
		GUEST_RESGISTER_URL = PlatformGameDefine.playform.HostURL + "/client_unity/guestregister/";
		// Userinfo
		USERINFO_AVATAR_URL = PlatformGameDefine.playform.HostURL + "/client_unity/modifyavatar/";
		USERINFO_PASSWORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/changepass/";
		USERINFO_BANK_PASSWORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/changebankpass/";
		// Convert
		GOLDINGOT_COIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/dollar2money/";
		GOLDINGOT_GOLDCOIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/dollar2gold/";
		GOLDCOIN_COIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/gold2money/";
		GOLDCOIN_HAPPYCARD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/gold2happy/";
		HAPPYCARD_COIN_SUIT_URL = PlatformGameDefine.playform.HostURL + "/client_unity/happy2moneysuit/";
		HAPPYCARD_COIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/happy2money/";
		// Bank
		BANK_SAVE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bag2bank/";
		BANK_GET_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bank2bag/";
		BANK_RECORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bank_record_json/";
		// GameRecord
		GAME_RECORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/game_record/";
		// Backpack
		BACKPACK_LIST_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bag_list/";
		// Mail
		MAIL_COUNT_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/mailcount/";
		MAIL_LIST_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/maillist/";
		MAIL_DETAIL_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/";
		MAIL_DELETE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/maildel/";
		MAIL_SEND_URL = PlatformGameDefine.playform.HostURL + "/client_unity/mail/mailwrite/";
		// Link
		FORGET_PASSWORD_URL = PlatformGameDefine.playform.HostURL + "/account/pwd_reset/";
		HOME_URL = PlatformGameDefine.playform.HostURL;
		SERVICE_URL = PlatformGameDefine.playform.HostURL + "/us/online.html";
		RECHARGE_URL = PlatformGameDefine.playform.HostURL + "/account/payment/";
		GUIDE_URL = PlatformGameDefine.playform.HostURL + "/help/center.html";
		SECURITY_URL = PlatformGameDefine.playform.HostURL + "/client_home/security/";
		SUGGEST_URL = PlatformGameDefine.playform.HostURL + "/us/suggest.html";
		BACKPACK_PROP_URL = PlatformGameDefine.playform.HostURL + "/client_home/props/";
		REGISTER_AGREEMENT_URL = PlatformGameDefine.playform.HostURL + "/terms.html";
		// Other
		FEEDBACK_URL = PlatformGameDefine.playform.HostURL + "/open/bug/";
		UPDATE_USERINFO_URL = PlatformGameDefine.playform.HostURL + "/client_unity/userinfo/";
		ROOM_LIST_URL = PlatformGameDefine.playform.HostURL + "/client_unity/gamerooms/";
		
		/* ------ hh.cc mobile ------ */
		// Safe
		SAFE_VALIDATE_TYPE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/safe_validate/";
		SAFE_SEND_PHONECODE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/send_phone_code/";
		SAFE_VALIDATE_LOGIN_URL = PlatformGameDefine.playform.HostURL + "/client_unity/bank_login/";
		// Award
		AWARD_CHECK_URL = PlatformGameDefine.playform.HostURL + "/client_unity/device/reward/";
		AWARD_GET_URL = PlatformGameDefine.playform.HostURL + "/client_unity/device/reward/";
		// Gift
		GIFT_DELIVER_URL = PlatformGameDefine.playform.HostURL + "/client_unity/deliver_money/";
		GIFT_NICKNAME_URL = PlatformGameDefine.playform.HostURL + "/client_unity/nickname_by_uid/";
		GIFT_RECORD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/deliver_record_json/";
		// Recharge
		RECHARGE_CARD_SUIT_URL = PlatformGameDefine.playform.HostURL + "/client_unity/yeepaysuit/";
		RECHARGE_OFFICIAL_CARD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/cardpay/";
		RECHARGE_CARD_URL = PlatformGameDefine.playform.HostURL + "/client_unity/yeepayexchange/";
		
		//UPDATE
		//	 VERSION_CHECK_URL = PlatformGameDefine.playform.HostURL + "/unity/config/";
		
		// bank 
		BANK_RECHARGE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/pay/";

        //微信支付请求后台地址
        BANK_RECHARGE_WX_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payment_confirm/";
        //微信支付完成后查询支付结果地址
        BANK_RECHARGE_WX_Confirm_URL = PlatformGameDefine.playform.HostURL + "/client_unity/wechatmobile/orderquery/";

        // TIAN XIA FU
        TXF_RECHARGE_URL = PlatformGameDefine.playform.HostURL + "/client_unity/tianxiapay/";
		
		// bank bili
		BANK_BILI_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payrateshengpay/";
		
		/// ZFB bili
		ZFB_BILI_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payratealipay/";
		
		// ka  bili
		CARD_BILI_URL = PlatformGameDefine.playform.HostURL + "/client_unity/payratecardsuit/";
		//verify
		VERIFY_CODE_URL = PlatformGameDefine.playform.HostURL + "/client_home/safe_device/";
		
		//change agent
		CHANGE_AGENT_URL = PlatformGameDefine.playform.HostURL + "/client_home/change_agent/";
		
		//yanzheng
		YAN_ZHENG_URL = PlatformGameDefine.playform.HostURL + "/client_unity/captcha/";
	}
	
}
