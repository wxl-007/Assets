using UnityEngine;
using System.Collections;

public class PlatformTest : PlatformEntity {
	
	// ------ Platform_Test 测试平台 ------
	public PlatformTest () {
		platformName = "test";
		hostURL = "http://120.26.49.247";
		downloadURL = "http://download.hxdgame.com/download/unity/test/";
		rechargeURL = "";
		feedbackContent = "客服咨询免费电话: 400-181-1819 \n\n客服企业QQ: 4001811819";
		unityMoney = "嘿豆";
	}
}
