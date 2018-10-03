using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;
 using System.Security.Cryptography; 
 
public class EginTools {

	/* ------------ Author: shawn.zp ------------ */

	public static long localBeiJingTime = 0;//北京时间和本地时间差

	/// <summary>
	/// Logs message to the Unity Console.
	/// Author: shawn.zp
	/// </summary>
	public static void Log (string info) {
//		Debug.Log("Egin: " + info);
	}


	public static long nowMinis(){
 
		System.DateTime nowDate = System.DateTime.Now;
		System.DateTime d1 = new System.DateTime(1970, 1, 1);
		System.DateTime d2 = nowDate.ToUniversalTime();
		
		System.TimeSpan ts = new System.TimeSpan(d2.Ticks - d1.Ticks);
		long ms=(long)ts.TotalMilliseconds;   //返回 1970 年 1 月 1 日至今的毫秒数

		return ms;
	}


	public static string encrypTime (string plaintext_data) {
 		int text_len = plaintext_data.Length;
		if(text_len<16){
			plaintext_data +="   ";
		}
		 
		byte[] keyBytes = Encoding.UTF8.GetBytes("ysNzMwk7A9jxZakH");
 		string kString = "";
 		for(int k=0;k<16;k++){
 			int mth = UnityEngine.Random.Range(0,10);//Math.random()*10;
			kString += mth;
		}
		byte[] iv = Encoding.UTF8.GetBytes(kString);

		RijndaelManaged rijalg = new RijndaelManaged();
		rijalg.BlockSize = 128;  
		rijalg.KeySize = 128;  
		rijalg.FeedbackSize = 128;  
		rijalg.Padding = PaddingMode.None;  
		rijalg.Mode = CipherMode.CBC;  
 		rijalg.Key = keyBytes;
		rijalg.IV = iv;
  		  
		ICryptoTransform encryptor = rijalg.CreateEncryptor(rijalg.Key, rijalg.IV);

		byte[] plaintextA = new byte[16];//Encoding.UTF8.GetBytes(plaintext_data);//new byte[plaintext_data.Length](plaintext_data);
 		
		//Debug.Log (plaintext_data[0]+":=:"+plaintext_data[13]+"plaintextA:"+plaintext_data.Length);

		for(int k1=0;k1<16;k1++){
			plaintextA[k1] = (byte)(plaintext_data[k1]);
		}



		byte[] src;

		using (System.IO.MemoryStream msEncrypt = new System.IO.MemoryStream())
		{
			using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
			{
				//Write all data to the stream.
				csEncrypt.Write(plaintextA, 0, plaintextA.Length);
				csEncrypt.FlushFinalBlock();
				
				src = msEncrypt.ToArray();
			}
		}

		//byte[] src = decryptor.TransformFinalBlock(plaintextA, 0, plaintextA.Length);
	 
		int ivLeng = iv.Length;
		int bleng =  ivLeng + src.Length;
		byte[] reByteArr = new byte[bleng];
		for(int k=0;k<bleng;k++){
			if(k<ivLeng){
				reByteArr[k] = iv[k];
			}else{
				reByteArr[k] = src[k-ivLeng];
			}
 		}

		string restr = System.Convert.ToBase64String(reByteArr);
  		return restr;
	}

	/// <summary>
	/// Clear all children in [Transform].
	/// Author: shawn.zp
	/// </summary>
	public static void ClearChildren (Transform transform) {
		foreach(Transform child in transform){
			Object.Destroy(child.gameObject);
		}
	}
	
	/// <summary>
	/// Return MD5 coding.
	/// Author: shawn.zp
	/// </summary>
	public static string MD5Coding (string input) {
		System.Text.UTF8Encoding ue = new System.Text.UTF8Encoding();
		byte[] bytes = ue.GetBytes(input);
 
		// encrypt bytes
		System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
		byte[] hashBytes = md5.ComputeHash(bytes);
	 
		// Convert the encrypted bytes back to a string (base 16)
		string hashString = "";
		for (int i = 0; i < hashBytes.Length; i++) {
			hashString += System.Convert.ToString(hashBytes[i], 16).PadLeft(2, '0');
		}
	 
		return hashString.PadLeft(32, '0');
	}


	/* ------------ Author: FanGaoZheng ------------ */

	public static void AddNumberSpritesSize (GameObject numberPrefab, Transform parent, int number, string prefix, float paddingSize) {
		string numberStr = ""+number;
		Vector3 position = numberPrefab.transform.localPosition;
		float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
		float size = paddingSize > 0 ? paddingSize : 1;
		for (int i=0; i<numberStr.Length; i++) {
			string n = numberStr.Substring(i, 1);
			GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
			numberObj.transform.parent = parent;
			numberObj.transform.localScale = new Vector3(1, 1, 1);
			position.x = (numberPrefab.transform.localPosition.x +i*paddingWidth)*size;
			numberObj.transform.localPosition = position;			
			
			UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
			if (numberSprite) { numberSprite.spriteName = prefix+n; }
		}
	}



    public static Vector3 AddNumberSpritesCenter(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

	//2016.1.19  make DD or DDD to center.
	public static Vector3 AddNumberSpritesCenterAdjust(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
	{
		Vector3 position = numberPrefab.transform.localPosition;
		float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
		float adjustValue = numberStr.Length%2 == 0? paddingWidth/2 : 0;
		int half = -(int)(numberStr.Length / 2);
		for (int i = 0; i < numberStr.Length; i++)
		{
			string n = numberStr.Substring(i, 1);
			GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
			numberObj.transform.parent = parent;
			numberObj.transform.localScale = new Vector3(1, 1, 1);
			position.x = (half + i) * paddingWidth + adjustValue;
			
			if (size > 0 && size <= 1)
			{
				position = position * size;
			}

			numberObj.transform.localPosition = position;
			
			UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
			if (numberSprite) { numberSprite.spriteName = prefix + n; }
		}
		
		return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
	}

    //捕鱼下注
    public static Vector3 AddNumberSpritesCenter_buyu(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth + 35;
            position.y = 33;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    /// <summary>
    /// SRPS
    /// </summary>
    /// <param name="numberPrefab"></param>
    /// <param name="parent"></param>
    /// <param name="numberStr"></param>
    /// <param name="prefix"></param>
    /// <param name="size"></param>
    /// <returns></returns>
    public static Vector3 AddNumberSpritesCenter_Srps(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * (paddingWidth);
            position.y = 0;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    public static Vector3 AddNumberSprites_closing(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * (paddingWidth);
            position.y = 0;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    

    public static Vector3 AddNumberSpritesCenter_1(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth + 35;
            position.y = 65;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }


    public static Vector3 AddNumberSpritesCenter_2(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth +10;
            position.y = -29;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    public static Vector3 AddNumberSpritesCenter_3(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth + 47;
            position.y = -26;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    public static Vector3 AddNumberSpritesCenter_4(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth + 30;
            position.y = 37;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    public static Vector3 AddNumberSpritesCenter_5(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * paddingWidth -7;
            position.y = 35;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    public static Vector3 AddNumberSpritesCenter_6(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * (paddingWidth+2) +10;
            position.y = -4920;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }

    public static Vector3 AddNumberSpritesCenter_7(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * (paddingWidth + 2) + 5;
            position.y = -3565;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }


    public static Vector3 AddNumberSpritesCenter_8(GameObject numberPrefab, Transform parent, string numberStr, string prefix, float size)
    {
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        int half = -(int)(numberStr.Length / 2);
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (half + i) * (paddingWidth + 5) + 535;
            position.y = 95;

            if (size > 0 && size <= 1)
            {
                position = position * size;
            }
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
        }

        return new Vector3((half - 1.5f) * paddingWidth, position.y, position.z);
    }
	/// <summary>
	/// 把数字字符串每3位加逗号。eg：1001 --> 1,001
	/// </summary>
	/// <returns>The with comma.</returns>
	/// <param name="numStr">Number string.</param>
	public static string NumberAddComma(string numStr) {
		long num = long.Parse (numStr);
		string numR = "";
		while(num>=10000) {
			string remainder = num%10000 + "";
			if(1 == remainder.Length) {
				remainder = "000" + remainder;
			}else if(2 == remainder.Length){
				remainder = "00" + remainder;
			}else if(3 == remainder.Length){
				remainder = "0" + remainder;
			}
			numR = "," + remainder + numR;
			num = num/10000;
		}
		return num + numR;
	}

	public static void PlayEffect(AudioClip effectSound) {
		float volume = SettingInfo.Instance.effectVolume;
		if(volume > 0) {
			NGUITools.PlaySound(effectSound, volume);
		}
	}
   
	public static string miao2TimeStr(float miao, bool ignoreUnit = false, bool addDecimal = false) {
 		float tG = (float)24 * 60 * 60;
		float sG = (float)60 * 60;
		float fG = (float)60;
		
		int tNum = Mathf.FloorToInt(miao / tG);
		
		int sNum = Mathf.FloorToInt((miao-tNum*tG)/sG);
		
		int fNum = Mathf.FloorToInt((miao-tNum*tG-sNum*sG)/fG);
		
		int mNum = Mathf.FloorToInt(miao-tNum*tG-sNum*sG-fNum*fG);
		
		string timeStr = "";
		if(tNum>0){
			string tNumStr = tNum +"";
			if(addDecimal){
				tNumStr = tNum.ToString("D2");
			}
			if(ignoreUnit){
				timeStr = timeStr+tNumStr+":";
			}else{
				timeStr = timeStr+tNumStr+"\u65e5";
			}
		} 
		if(sNum>0 || addDecimal){
			string sNumStr = sNum + "";
			if(addDecimal){
				sNumStr = sNum.ToString("D2");
			}
			if(ignoreUnit){
				timeStr = timeStr+sNumStr+":";
			}else{
				timeStr = timeStr+sNumStr+"\u65f6";
			}
		}
		if(fNum>0 || addDecimal){
			string fNumStr = fNum + "";
			if(addDecimal){
				fNumStr = fNum.ToString("D2");
			}
			if(ignoreUnit){
				timeStr = timeStr+fNumStr+":";
			}else{
				timeStr = timeStr+fNumStr+"\u5206";
			}
		}
		string mNumStr = mNum + "";
		if(addDecimal){
			mNumStr = mNum.ToString("D2");
		}
		if(ignoreUnit){
			timeStr = timeStr+mNumStr+"";
		}else{
			timeStr = timeStr+mNumStr+"\u79d2";
		}
		
		return timeStr ;
	}

	//add by xiaoyong 2016.5.3
	#region 阿拉伯数字转中文大写
	private static string[] intStr = new string[] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };
	private static string[] numStr = new string[] { "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" };
	private static string[] moneyDigits = new string[] { "", "拾", "佰", "仟", "万", "亿" };
	public static string numToCnNum(string money)
	{
		string str = "";
		for (int i = 0; i < money.Length; i++)
		{
			for (int j = 0; j < intStr.Length; j++)
			{
				if (money.Substring(i,1).Equals(intStr[j]))
				{
					str += numStr[j];
				}
			}
		}
		//addDigits
		string fixDigitsStr = "";
		for (int i = 0; i < str.Length; i++)
		{
			if ((str.Length - i) % 4 == 0)
			{
				fixDigitsStr += str[i] + moneyDigits[3];
			}
			else if ((str.Length - i) % 4 == 2)
			{
				fixDigitsStr += str[i] + moneyDigits[1];
			}
			else if ((str.Length - i) % 4 == 3)
			{
				fixDigitsStr += str[i] + moneyDigits[2];
			}
			else if ((str.Length - i) % 5 == 0)
			{
				fixDigitsStr += str[i] + moneyDigits[4];
			}
			else if ((str.Length-i)%9==0)
			{
				fixDigitsStr += str[i] + moneyDigits[5];
			}
			else
			{
				fixDigitsStr += str[i];
			}
		}
		//fix same number.
		while (fixDigitsStr.Contains("零拾"))
		{
			fixDigitsStr=fixDigitsStr.Replace("零拾","零");
		}
		while (fixDigitsStr.Contains("零佰"))
		{
			fixDigitsStr = fixDigitsStr.Replace("零佰", "零");
		}
		while (fixDigitsStr.Contains("零仟"))
		{
			fixDigitsStr = fixDigitsStr.Replace("零仟", "零");
		}
		while (fixDigitsStr.Contains("零万"))
		{
			fixDigitsStr = fixDigitsStr.Replace("零万","万");
		}
		while (fixDigitsStr.Contains("零亿"))
		{
			fixDigitsStr = fixDigitsStr.Replace("零亿", "亿");
		}
		while (fixDigitsStr.Contains("亿万"))
		{
			fixDigitsStr = fixDigitsStr.Replace("亿万", "亿");
		}
		while (fixDigitsStr.Contains("零零"))
		{
			fixDigitsStr = fixDigitsStr.Replace("零零", "零");
		}
		if(fixDigitsStr[fixDigitsStr.Length-1] == '零'){
			fixDigitsStr = fixDigitsStr.Substring(0, fixDigitsStr.Length-1);
		}
		return fixDigitsStr;
	}
	#endregion
}