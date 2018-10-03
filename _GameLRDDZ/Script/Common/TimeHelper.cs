using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;

public class TimeHelper
{

    /* ------------ Author: shawn.zp ------------ */

    public static long localBeiJingTime = 0;//北京时间和本地时间差

    public static long nowMinis()
    {

        System.DateTime nowDate = System.DateTime.Now;
        System.DateTime d1 = new System.DateTime(1970, 1, 1);
        System.DateTime d2 = nowDate.ToUniversalTime();

        System.TimeSpan ts = new System.TimeSpan(d2.Ticks - d1.Ticks);
        long ms = (long)ts.TotalMilliseconds;   //返回 1970 年 1 月 1 日至今的毫秒数

        return ms;
    }


    public static string encrypTime(string plaintext_data)
    {
        int text_len = plaintext_data.Length;
        if (text_len < 16)
        {
            plaintext_data += "   ";
        }

        byte[] keyBytes = Encoding.UTF8.GetBytes("ysNzMwk7A9jxZakH");
        string kString = "";
        for (int k = 0; k < 16; k++)
        {
            int mth = UnityEngine.Random.Range(0, 10);//Math.random()*10;
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

        //Debuger.Log (plaintext_data[0]+":=:"+plaintext_data[13]+"plaintextA:"+plaintext_data.Length);

        for (int k1 = 0; k1 < 16; k1++)
        {
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
        int bleng = ivLeng + src.Length;
        byte[] reByteArr = new byte[bleng];
        for (int k = 0; k < bleng; k++)
        {
            if (k < ivLeng)
            {
                reByteArr[k] = iv[k];
            }
            else
            {
                reByteArr[k] = src[k - ivLeng];
            }
        }

        string restr = System.Convert.ToBase64String(reByteArr);
        return restr;
    }

    /// <summary>
    /// Clear all children in [Transform].
    /// Author: shawn.zp
    /// </summary>
    public static void ClearChildren(Transform transform)
    {
        foreach (Transform child in transform)
        {
            Object.Destroy(child.gameObject);
        }
    }

    /// <summary>
    /// Return MD5 coding.
    /// Author: shawn.zp
    /// </summary>
    public static string MD5Coding(string input)
    {
        System.Text.UTF8Encoding ue = new System.Text.UTF8Encoding();
        byte[] bytes = ue.GetBytes(input);

        // encrypt bytes
        System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
        byte[] hashBytes = md5.ComputeHash(bytes);

        // Convert the encrypted bytes back to a string (base 16)
        string hashString = "";
        for (int i = 0; i < hashBytes.Length; i++)
        {
            hashString += System.Convert.ToString(hashBytes[i], 16).PadLeft(2, '0');
        }

        return hashString.PadLeft(32, '0');
    }


    /* ------------ Author: FanGaoZheng ------------ */

    public static void AddNumberSpritesSize(GameObject numberPrefab, Transform parent, int number, string prefix, float paddingSize)
    {
        string numberStr = "" + number;
        Vector3 position = numberPrefab.transform.localPosition;
        float paddingWidth = numberPrefab.GetComponent<UISprite>().width;
        float size = paddingSize > 0 ? paddingSize : 1;
        for (int i = 0; i < numberStr.Length; i++)
        {
            string n = numberStr.Substring(i, 1);
            GameObject numberObj = (GameObject)Object.Instantiate(numberPrefab);
            numberObj.transform.parent = parent;
            numberObj.transform.localScale = new Vector3(1, 1, 1);
            position.x = (numberPrefab.transform.localPosition.x + i * paddingWidth) * size;
            numberObj.transform.localPosition = position;

            UISprite numberSprite = (UISprite)numberObj.GetComponent(typeof(UISprite));
            if (numberSprite) { numberSprite.spriteName = prefix + n; }
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

    /// <summary>
    /// 把数字字符串每3位加逗号。eg：1001 --> 1,001
    /// </summary>
    /// <returns>The with comma.</returns>
    /// <param name="numStr">Number string.</param>
    public static string NumberAddComma(string numStr)
    {
        long num = long.Parse(numStr);
        string numR = "";
        while (num >= 10000)
        {
            string remainder = num % 10000 + "";
            if (1 == remainder.Length)
            {
                remainder = "000" + remainder;
            }
            else if (2 == remainder.Length)
            {
                remainder = "00" + remainder;
            }
            else if (3 == remainder.Length)
            {
                remainder = "0" + remainder;
            }
            numR = "," + remainder + numR;
            num = num / 10000;
        }
        return num + numR;
    }

    public static string miao2TimeStr(float miao)
    {
        float tG = (float)24 * 60 * 60;
        float sG = (float)60 * 60;
        float fG = (float)60;

        int tNum = Mathf.FloorToInt(miao / tG);

        int sNum = Mathf.FloorToInt((miao - tNum * tG) / sG);

        int fNum = Mathf.FloorToInt((miao - tNum * tG - sNum * sG) / fG);

        int mNum = Mathf.FloorToInt(miao - tNum * tG - sNum * sG - fNum * fG);

        string timeStr = "";
        if (tNum > 0)
        {
            timeStr = timeStr + tNum + "\u65e5";
        }
        if (sNum > 0)
        {
            timeStr = timeStr + sNum + "\u65f6";
        }
        if (fNum > 0)
        {
            timeStr = timeStr + fNum + "\u5206";
        }
        timeStr = timeStr + mNum + "\u79d2";

        return timeStr;
    }
}