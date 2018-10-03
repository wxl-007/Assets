
 local this = LuaObject:New()
 ConnectDefine = this

	this.HostURL = PlatformGameDefine.playform.HostURL;
	-- Login
	this.LOGIN_URL = this.HostURL .. "/client_unity/login/";
	this.GUEST_LOGIN_URL = this.HostURL .. "/client_unity/guestlogin/";
	-- Register
	this.REGISTER_VERIFY_CODE_URL = this.HostURL .. "/client_unity/captcha/";
	this.REGISTER_VERIFY_CODE_PREFIX_URL = this.HostURL;
	--	this.REGISTER_URL = this.HostURL .. "/unity/register/"; 	-- shawn.debug
	this.REGISTER_MOBILE_URL = this.HostURL .. "/client_unity/register_mobile/";--"/mobile/register/";
    this.REGISTER_WEIXIN_URL = this.HostURL .. "/account/openid/wechat_oauth/";--微信登录

    this.REGISTER_MOBILE_PHONE_URL = this.HostURL .. "/mobile/regphone/";
	this.GUEST_PHONE_REGIST_URL = this.HostURL .. "/mobile/guestphonereg/";
	this.GUEST_RESGISTER_URL = this.HostURL .. "/client_unity/guestregister/";
	-- Userinfo
	this.USERINFO_AVATAR_URL = this.HostURL .. "/client_unity/modifyavatar/";
	this.USERINFO_PASSWORD_URL = this.HostURL .. "/client_unity/changepass/";
	this.USERINFO_BANK_PASSWORD_URL = this.HostURL .. "/client_unity/changebankpass/";
	-- Convert
	this.GOLDINGOT_COIN_URL = this.HostURL .. "/client_unity/dollar2money/";
	this.GOLDINGOT_GOLDCOIN_URL = this.HostURL .. "/client_unity/dollar2gold/";
	this.GOLDCOIN_COIN_URL = this.HostURL .. "/client_unity/gold2money/";
	this.GOLDCOIN_HAPPYCARD_URL = this.HostURL .. "/client_unity/gold2happy/";
	this.HAPPYCARD_COIN_SUIT_URL = this.HostURL .. "/client_unity/happy2moneysuit/";
	this.HAPPYCARD_COIN_URL = this.HostURL .. "/client_unity/happy2money/";
	-- Bank
	this.BANK_SAVE_URL = this.HostURL .. "/client_unity/bag2bank/";
	this.BANK_GET_URL = this.HostURL .. "/client_unity/bank2bag/";
	this.BANK_RECORD_URL = this.HostURL .. "/client_unity/bank_record_json/";
	-- GameRecord
	this.GAME_RECORD_URL = this.HostURL .. "/client_unity/game_record/";
	-- Backpack
	this.BACKPACK_LIST_URL = this.HostURL .. "/client_unity/bag_list/";
	-- Mail
	this.MAIL_COUNT_URL = this.HostURL .. "/client_unity/mail/mailcount/";
	this.MAIL_LIST_URL = this.HostURL .. "/client_unity/mail/maillist/";
	this.MAIL_DETAIL_URL = this.HostURL .. "/client_unity/mail/";
	this.MAIL_DELETE_URL = this.HostURL .. "/client_unity/mail/maildel/";
	this.MAIL_SEND_URL = this.HostURL .. "/client_unity/mail/mailwrite/";
	-- Link
	this.FORGET_PASSWORD_URL = this.HostURL .. "/account/pwd_reset/";
	this.HOME_URL = this.HostURL;
	this.SERVICE_URL = this.HostURL .. "/us/online.html";
	this.RECHARGE_URL = this.HostURL .. "/account/payment/";
	this.GUIDE_URL = this.HostURL .. "/help/center.html";
	this.SECURITY_URL = this.HostURL .. "/client_home/security/";
	this.SUGGEST_URL = this.HostURL .. "/us/suggest.html";
	this.BACKPACK_PROP_URL = this.HostURL .. "/client_home/props/";
	this.REGISTER_AGREEMENT_URL = this.HostURL .. "/terms.html";
	-- Other
	this.FEEDBACK_URL = this.HostURL .. "/open/bug/";
	this.UPDATE_USERINFO_URL = this.HostURL .. "/client_unity/userinfo/";
	this.ROOM_LIST_URL = this.HostURL .. "/client_unity/gamerooms/";
	
	-- ------ hh.cc mobile ------ */
	-- Safe
	this.SAFE_VALIDATE_TYPE_URL = this.HostURL .. "/client_unity/safe_validate/";
	this.SAFE_SEND_PHONECODE_URL = this.HostURL .. "/client_unity/send_phone_code/";
	this.SAFE_VALIDATE_LOGIN_URL = this.HostURL .. "/client_unity/bank_login/";
	-- Award
	this.AWARD_CHECK_URL = this.HostURL .. "/client_unity/device/reward/";
	this.AWARD_GET_URL = this.HostURL .. "/client_unity/device/reward/";
	-- Gift
	this.GIFT_DELIVER_URL = this.HostURL .. "/client_unity/deliver_money/";
	this.GIFT_NICKNAME_URL = this.HostURL .. "/client_unity/nickname_by_uid/";
	this.GIFT_RECORD_URL = this.HostURL .. "/client_unity/deliver_record_json/";
	-- Recharge
	this.RECHARGE_CARD_SUIT_URL = this.HostURL .. "/client_unity/yeepaysuit/";
	this.RECHARGE_OFFICIAL_CARD_URL = this.HostURL .. "/client_unity/cardpay/";
	this.RECHARGE_CARD_URL = this.HostURL .. "/client_unity/yeepayexchange/";
	
	--UPDATE
	--	this.VERSION_CHECK_URL = this.HostURL .. "/unity/config/";
	
	-- bank 
	this.BANK_RECHARGE_URL = this.HostURL .. "/client_unity/pay/";
    --微信支付请求后台地址
	this.BANK_RECHARGE_WX_URL = this.HostURL .. "/client_unity/payment_confirm/";--
    --微信支付完成后查询支付结果地址
	this.BANK_RECHARGE_WX_Confirm_URL = this.HostURL .. "/client_unity/wechatmobile/orderquery/";--
	  
    --支付宝支付请求后台地址
	this.BANK_RECHARGE_Ali_URL = this.HostURL .. "/unity/payment_confirm/";--
    --支付宝支付完成后查询支付结果地址
	this.BANK_RECHARGE_Ali_Confirm_URL = this.HostURL .. "/account/alipayappreturn/";--

    -- TIAN XIA FU
    this.TXF_RECHARGE_URL = this.HostURL .. "/client_unity/tianxiapay/";
	
	-- bank bili
	this.BANK_BILI_URL = this.HostURL .. "/client_unity/payrateshengpay/";--
	
	-- ZFB bili
	this.ZFB_BILI_URL = this.HostURL .. "/client_unity/payratealipay/";--
	
	-- ka  bili
	this.CARD_BILI_URL = this.HostURL .. "/client_unity/payratecardsuit/";--
	--verify
	this.VERIFY_CODE_URL = this.HostURL .. "/client_home/safe_device/";
	
	--change agent
	this.CHANGE_AGENT_URL = this.HostURL .. "/client_home/change_agent/";
	
	--yanzheng
	this.YAN_ZHENG_URL = this.HostURL .. "/client_unity/captcha/";
	
	function this:updateConfig()
	 	-- print('========update config ========'..this.HostURL)
		this.HostURL =   PlatformGameDefine.playform.HostURL
		-- Login
		this.LOGIN_URL = this.HostURL .. "/client_unity/login/";
		this.GUEST_LOGIN_URL = this.HostURL .. "/client_unity/guestlogin/";
		-- Register
		this.REGISTER_VERIFY_CODE_URL = this.HostURL .. "/client_unity/captcha/";
		this.REGISTER_VERIFY_CODE_PREFIX_URL = this.HostURL;
		this.REGISTER_MOBILE_URL = this.HostURL .. "/client_unity/register_mobile/";--"/mobile/register/";
		
		this.REGISTER_MOBILE_PHONE_URL = this.HostURL .. "/mobile/regphone/";
		this.GUEST_PHONE_REGIST_URL = this.HostURL .. "/mobile/guestphonereg/";
		this.GUEST_RESGISTER_URL = this.HostURL .. "/client_unity/guestregister/";
		-- Userinfo
		this.USERINFO_AVATAR_URL = this.HostURL .. "/client_unity/modifyavatar/";
		this.USERINFO_PASSWORD_URL = this.HostURL .. "/client_unity/changepass/";
		this.USERINFO_BANK_PASSWORD_URL = this.HostURL .. "/client_unity/changebankpass/";
		-- Convert
		this.GOLDINGOT_COIN_URL = this.HostURL .. "/client_unity/dollar2money/";
		this.GOLDINGOT_GOLDCOIN_URL = this.HostURL .. "/client_unity/dollar2gold/";
		this.GOLDCOIN_COIN_URL = this.HostURL .. "/client_unity/gold2money/";
		this.GOLDCOIN_HAPPYCARD_URL = this.HostURL .. "/client_unity/gold2happy/";
		this.HAPPYCARD_COIN_SUIT_URL = this.HostURL .. "/client_unity/happy2moneysuit/";
		this.HAPPYCARD_COIN_URL = this.HostURL .. "/client_unity/happy2money/";
		-- Bank
		this.BANK_SAVE_URL = this.HostURL .. "/client_unity/bag2bank/";
		this.BANK_GET_URL = this.HostURL .. "/client_unity/bank2bag/";
		this.BANK_RECORD_URL = this.HostURL .. "/client_unity/bank_record_json/";
		-- GameRecord
		this.GAME_RECORD_URL = this.HostURL .. "/client_unity/game_record/";
		-- Backpack
		this.BACKPACK_LIST_URL = this.HostURL .. "/client_unity/bag_list/";
		-- Mail
		this.MAIL_COUNT_URL = this.HostURL .. "/client_unity/mail/mailcount/";
		this.MAIL_LIST_URL = this.HostURL .. "/client_unity/mail/maillist/";
		this.MAIL_DETAIL_URL = this.HostURL .. "/client_unity/mail/";
		this.MAIL_DELETE_URL = this.HostURL .. "/client_unity/mail/maildel/";
		this.MAIL_SEND_URL = this.HostURL .. "/client_unity/mail/mailwrite/";
		-- Link
		this.FORGET_PASSWORD_URL = this.HostURL .. "/account/pwd_reset/";
		this.HOME_URL = this.HostURL;
		this.SERVICE_URL = this.HostURL .. "/us/online.html";
		this.RECHARGE_URL = this.HostURL .. "/account/payment/";
		this.GUIDE_URL = this.HostURL .. "/help/center.html";
		this.SECURITY_URL = this.HostURL .. "/client_home/security/";
		this.SUGGEST_URL = this.HostURL .. "/us/suggest.html";
		this.BACKPACK_PROP_URL = this.HostURL .. "/client_home/props/";
		this.REGISTER_AGREEMENT_URL = this.HostURL .. "/terms.html";
		-- Other
		this.FEEDBACK_URL = this.HostURL .. "/open/bug/";
		this.UPDATE_USERINFO_URL = this.HostURL .. "/client_unity/userinfo/";
		this.ROOM_LIST_URL = this.HostURL .. "/client_unity/gamerooms/";
		
		-------- hh.cc mobile ------ */
		-- Safe
		this.SAFE_VALIDATE_TYPE_URL = this.HostURL .. "/client_unity/safe_validate/";
		this.SAFE_SEND_PHONECODE_URL = this.HostURL .. "/client_unity/send_phone_code/";
		this.SAFE_VALIDATE_LOGIN_URL = this.HostURL .. "/client_unity/bank_login/";
		-- Award
		this.AWARD_CHECK_URL = this.HostURL .. "/client_unity/device/reward/";
		this.AWARD_GET_URL = this.HostURL .. "/client_unity/device/reward/";
		-- Gift
		this.GIFT_DELIVER_URL = this.HostURL .. "/client_unity/deliver_money/";
		this.GIFT_NICKNAME_URL = this.HostURL .. "/client_unity/nickname_by_uid/";
		this.GIFT_RECORD_URL = this.HostURL .. "/client_unity/deliver_record_json/";
		-- Recharge
		this.RECHARGE_CARD_SUIT_URL = this.HostURL .. "/client_unity/yeepaysuit/";
		this.RECHARGE_OFFICIAL_CARD_URL = this.HostURL .. "/client_unity/cardpay/";
		this.RECHARGE_CARD_URL = this.HostURL .. "/client_unity/yeepayexchange/";
		
		--UPDATE
		--	 this.VERSION_CHECK_URL = this.HostURL .. "/unity/config/";
		
		-- bank 
		this.BANK_RECHARGE_URL = this.HostURL .. "/client_unity/pay/";

        --微信支付请求后台地址
        this.BANK_RECHARGE_WX_URL = this.HostURL .. "/client_unity/payment_confirm/";
        --微信支付完成后查询支付结果地址
        this.BANK_RECHARGE_WX_Confirm_URL = this.HostURL .. "/client_unity/wechatmobile/orderquery/";

        -- TIAN XIA FU
        this.TXF_RECHARGE_URL = this.HostURL .. "/client_unity/tianxiapay/";
		
		-- bank bili
		this.BANK_BILI_URL = this.HostURL .. "/client_unity/payrateshengpay/";
		
		-- ZFB bili
		this.ZFB_BILI_URL = this.HostURL .. "/client_unity/payratealipay/";
		
		-- ka  bili
		this.CARD_BILI_URL = this.HostURL .. "/client_unity/payratecardsuit/";
		--verify
		this.VERIFY_CODE_URL = this.HostURL .. "/client_home/safe_device/";
		
		--change agent
		this.CHANGE_AGENT_URL = this.HostURL .. "/client_home/change_agent/";
		
		--yanzheng
		this.YAN_ZHENG_URL = this.HostURL .. "/client_unity/captcha/";
	end
	
