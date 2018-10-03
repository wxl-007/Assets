using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TBTWPlayerCtrl : MonoBehaviour
{


    [HideInInspector]
    public GlobalVar.PlayerPosition position;

    /// <summary>
    /// 提示字“准备”
    /// </summary>
    public GameObject readyObj;

    /// <summary>
    ///  提示字"摊牌"
    /// </summary>
    public GameObject showObj;

    /// <summary>
    ///  提示字"等待中"
    /// </summary>
    public GameObject waitObj;

    /// <summary>
    /// 比牌结果
    /// </summary>
    public Transform cardTypeTrans;

    /// <summary>
    /// 玩家头像
    /// </summary>
    public UISprite userAvatar;

    /// <summary>
    /// 玩家昵称
    /// </summary>
    public UILabel userNickname;

    /// <summary>
    /// 玩家带入金额
    /// </summary>
    public UILabel userIntomoney;

    /// <summary>
    /// 玩家的扑克牌(排序后)
    /// </summary>
    public UISprite[] cardsArray;

    /// <summary>
    /// 扑克牌的父物体
    /// </summary>
    public Transform cardsTrans;

    /// <summary>
    /// 玩家得分
    /// </summary>
    public GameObject cardScoreObj;
    public UISprite cardScoreBg;

    public AudioClip soundSend;

    public GameObject jettonPrefab;

    public GameObject infoDetail;
    public UILabel kDetailNickname;
    public UILabel kDetailLevel;
    public UILabel kDetailBagmoney;

    //扑克牌父物体的位置
    private float parentX = 0;
    private float parentY = 30;
    private float parentZ = 0;

    /// <summary>
    /// 牌间距
    /// </summary>
    private const float _cardInterval = 115;
    //修改牌面前缀
    private const string _cardPre = "own_";

    private const float _timeInterval = 3;
    private float _timeLasted;

    Vector3 cardScoreP;
    Vector3 cardTypeP;
    Vector3 showP;
    Vector3 infoDetailP;

    /// <summary>
    /// 提示信息
    /// </summary>
    public UILabel promptMessage;

    //声音文件

    public AudioClip[] myaudio;


    //骰子动画

    public GameObject bosonA;
    void Awake()
    {
        //		parentX = cardsTrans.localPosition.x ;
        parentY = cardsTrans.localPosition.y;
        parentZ = cardsTrans.localPosition.z;
    }
    void Start()
    {

        if (!cardScoreBg) {
            UISprite[] sprites = cardScoreObj.GetComponentsInChildren<UISprite>(); 
            foreach (UISprite sprite in sprites)
            {
                
                  Destroy(sprite.gameObject);
                
            }
        }
        UpdateSkinColor();
        if (cardScoreObj != null && cardTypeTrans != null && showObj != null && infoDetail != null)
        {
            cardScoreP = cardScoreObj.transform.localPosition;
            cardTypeP = cardTypeTrans.localPosition;
            showP = showObj.transform.localPosition;
            infoDetailP = infoDetail.transform.localPosition;
        }

        UIAnchor anchor = this.gameObject.GetComponent<UIAnchor>();
        if (anchor.side == UIAnchor.Side.BottomRight)
        {
            //cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);
            cardScoreObj.transform.localPosition = new Vector3(-cardScoreP.x, cardScoreP.y + 5, cardScoreP.z);
            cardTypeTrans.localPosition = new Vector3(-cardTypeP.x, cardTypeP.y, cardTypeP.z);
            showObj.transform.localPosition = new Vector3(-showP.x, showP.y, showP.z);
            infoDetail.transform.localPosition = new Vector3(-infoDetailP.x, infoDetailP.y, infoDetailP.z);
            bosonA.gameObject.transform.localPosition = new Vector3(-155, 0, 0);
        }
        else if (anchor.side == UIAnchor.Side.TopRight)
        {
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);
            cardScoreObj.transform.localPosition = new Vector3(-cardScoreP.x, cardScoreP.y, cardScoreP.z);
            cardTypeTrans.localPosition = new Vector3(-cardTypeP.x, cardTypeP.y, cardTypeP.z);
            showObj.transform.localPosition = new Vector3(-showP.x, showP.y, showP.z);
            infoDetail.transform.localPosition = new Vector3(-infoDetailP.x, infoDetailP.y, infoDetailP.z);
            bosonA.gameObject.transform.localPosition = new Vector3(-155, 0, 0);
        }
        else if (anchor.side == UIAnchor.Side.Top)
        {
            //cardScoreObj.transform.localPosition = new Vector3(65, -160, 0);
            int height = transform.root.GetComponent<UIRoot>().manualHeight;
            cardScoreObj.transform.localPosition = new Vector3(-transform.localPosition.x, (.22f * height - 40) - transform.localPosition.y, 0);
            parentX = 180;
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);
            bosonA.gameObject.transform.localPosition = new Vector3(170, 0, 0);
        }
        else if (anchor.side == UIAnchor.Side.TopLeft)
        {
            parentX = 180;
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);
            bosonA.gameObject.transform.localPosition = new Vector3(170, 0, 0);
        }
        else if (anchor.side == UIAnchor.Side.BottomLeft)
        {
            parentX = 180;
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);
            cardScoreObj.transform.localPosition = new Vector3(cardScoreP.x, cardScoreP.y + 5, cardScoreP.z);
            bosonA.gameObject.transform.localPosition = new Vector3(170, 0, 0);
        }

      
    }

    /// <summary>
    /// 动态发牌时用
    /// </summary>
    public void SetLate(List<JSONObject> cards)
    {
        //bosonA.SetActive(true);

        //cardsTrans.gameObject.SetActive(true);
        for (int i = 0; i < cardsArray.Length; i++)
        {
            //cardsArray[i].gameObject.SetActive(true);
            if (cards != null && cards.Count > 0)
            {
                cardsArray[i].spriteName = _cardPre + cards[i].ToString();
            }
        }
    }
    public void SetLateEnd()
    {
        cardsTrans.gameObject.SetActive(true);
        bosonA.SetActive(false);
        
    }
    /// <summary>
    /// 换肤时更新扑克牌
    /// </summary>
    void UpdateSkinColor()
    {
        foreach (UISprite sprite in cardsArray)
        {
            sprite.spriteName = "poke_big";
            //sprite.spriteName = _cardPre + GlobalVar.SKIN_COLOR;
        }
    } 

    public void SetPlayerInfo(int avatar, string nickname, string intomoney, string level)
    {
        userAvatar.spriteName = "avatar_" + avatar;
        userNickname.text = nickname;
        userIntomoney.text = "¥ " + EginTools.NumberAddComma(intomoney);

        kDetailNickname.text = nickname;
        kDetailLevel.text = level;
        kDetailBagmoney.text = intomoney;
    }

    public void OnClickInfoDetail()
    {
        if (infoDetail.activeSelf)
        {
            infoDetail.SetActive(false);
            _timeLasted = 0;
        }
        else
        {
            infoDetail.SetActive(true);
        }
    }

    void Update()
    {
        if (infoDetail != null && infoDetail.activeSelf)
        {
            _timeLasted += Time.deltaTime;
            if (_timeLasted >= _timeInterval)
            {
                infoDetail.SetActive(false);
                _timeLasted = 0;
            }
        }
    }

    public void UpdateIntoMoney(string intomoney)
    {
        if (userIntomoney == null)
        {
            GameObject.Find("Label_Bagmoney").GetComponent<UILabel>().text =
                EginTools.NumberAddComma(intomoney);
        }
        else
        {
            userIntomoney.text = "¥ " + EginTools.NumberAddComma(intomoney);
        }
        //		userIntomoney = userIntomoney == null ? GameObject.Find ("Label_Bagmoney").GetComponent<UILabel>() : userIntomoney;
        //		userIntomoney.text = "¥ " + EginTools.NumberAddComma(intomoney);
    }

    /// <summary>
    /// 发牌（带动画效果,需要在编辑器里将扑克牌的Active设为false）
    /// </summary>
    /// <returns>The deal.</returns>
    /// <param name="toShow">If set to <c>true</c> to show.</param>
    /// <param name="infos">Infos.</param>
    public void SetDeal(bool toShow, List<JSONObject> infos)
    {
        if (!toShow)
        {
            cardsTrans.gameObject.SetActive(false);
            
        }
        else
        {

            //bosonA.SetActive(true);
            float x = parentX + 2 * _cardInterval;
            //cardsTrans.gameObject.SetActive(true);

            for (int i = 0; i < cardsArray.Length; i++)
            {
                if (null != soundSend) EginTools.PlayEffect(soundSend);
               // cardsTrans.localPosition = new Vector3(x - _cardInterval / 2 * i, parentY, parentZ);
                //cardsArray[i].gameObject.SetActive(true);

                if (null != infos && infos.Count > 0)
                {
                    cardsArray[i].spriteName = _cardPre + infos[i].ToString();
        
                }
                //yield return new WaitForSeconds(.2f);

            }
        }
    }

    /// <summary>
    /// 主玩家的比牌情况
    /// </summary>
    /// <param name="cardsList">Cards list.</param>
    /// <param name="cardType">Card type.</param>
    /// <param name="tryMoveRight">If set to <c>true</c> try move right.</param>
    public void SetCardTypeUser(List<JSONObject> cardsList, int cardType)
    {
        if (null == cardsList)
        {
            //后两张牌移回原位并且显示牌背面
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[4 - i].transform.localPosition = new Vector3(-300 + i * _cardInterval, 10, 0);
            }
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);

            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
            if (cardTypeSprite)
                cardTypeSprite.depth = 10;
            cardTypeTrans.gameObject.SetActive(false);
        }
        else {

            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].spriteName = _cardPre + cardsList[cardsArray.Length-1-i].ToString();
            }
            bosonA.SetActive(false);
            cardTypeTrans.gameObject.SetActive(true);

            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
            if (cardTypeSprite)
                cardTypeSprite.depth = 10;
            cardTypeSprite.spriteName = "type_" + cardType.ToString();
            switch (cardType)
            {
                case 0:
                    break;
                case 1:
                    cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                    break;
                case 2:
                    cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                    break;
                case 3:
                    cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                    break;
                case 4:
                    cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                    break;
                case 5:
                    cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                    break;
                case 6:
                    cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                    cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                    break;
                case 7:
                    cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                    cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                    break;
            }
        }
        /*
        if (null == cardsList)
        {
            //后两张牌移回原位并且显示牌背面
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[4-i].transform.localPosition = new Vector3(-100 + i * _cardInterval, -20, 0);
            }
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);

            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
            if(cardTypeSprite)
            cardTypeSprite.depth = 10;
            cardTypeTrans.gameObject.SetActive(false);
        }
        else
        {
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].spriteName = _cardPre + cardsList[i].ToString();
            }

            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
            //显示牌型和牛几

            cardTypeTrans.gameObject.SetActive(true);
            if (cardTypeSprite)
            {
                if (cardType == 0)
                {
                    cardTypeSprite.spriteName = "type_0";
                    cardTypeSprite.depth = 18;
                }
                else if (cardType > 0)
                {

                    cardTypeSprite.spriteName = "type_" + cardType.ToString();

                    if (EginUser.Instance.sex == false)
                    {
                        if (null != myaudio[cardType + 10])
                            EginTools.PlayEffect(myaudio[cardType + 10]);
                        
                    }
                    else
                    {
                        if (null != myaudio[cardType])
                            EginTools.PlayEffect(myaudio[cardType]);
                    }
                    cardTypeSprite.depth = 18;
                    switch (cardType)
                    {
                        case 0:
                            break;
                        case 1:
                            cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                            break;
                        case 2:
                            cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                            break;
                        case 3:
                            cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                            break;
                        case 4:
                            cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                            break;
                        case 5:
                            cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                            break;
                        case 6:
                            cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                            break;
                        case 7:
                            cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(-15, 20, 0);
                            break;
                        case 8:
                            cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                            break;
                        case 9:
                            cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                            cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                            break;
                    }
                }
            }
        }
            */
    }

    /// <summary>
    /// 其他玩家的比牌情况
    /// </summary>
    /// <param name="cardsList">Cards list.</param>
    /// <param name="cardType">Card type.</param>
    public void SetCardTypeOther(List<JSONObject> cardsList, int cardType)
    {
        if (cardsList == null)
        {
            //后两张牌移回原位并且显示牌背面
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].transform.localPosition = new Vector3((i - 2) * _cardInterval + 20, 0, 0);
            }
           // cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);

            UpdateSkinColor();
            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
            if (cardTypeSprite)
                cardTypeSprite.depth = 10;

            cardTypeTrans.gameObject.SetActive(false);
        }else{
            cardTypeTrans.gameObject.SetActive(true);
            cardsTrans.gameObject.SetActive(true);
            bosonA.SetActive(false);
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].gameObject.SetActive(true);
                cardsArray[i].spriteName = _cardPre + cardsList[i].ToString();
            }
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].transform.localPosition = new Vector3((i - 2) * _cardInterval + 20, 0, 0);
            }
            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();

            if (cardType >= 0)
            {
               
                if (parentX > 0)
                {

                    cardsTrans.localPosition = new Vector3(240, -15, 0);
                    cardTypeTrans.localPosition = new Vector3(262, -94, 0);
                }
                else
                {
                    cardsTrans.localPosition = new Vector3(-262, -15, 0);
                    cardTypeTrans.localPosition = new Vector3(-238, -94, 0);
                }

                cardTypeSprite.spriteName = "type_" + cardType.ToString();
                cardTypeSprite.depth = 18;
                switch (cardType)
                {
                    case 0:
                        break;
                    case 1:
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 2:
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 3:
                        cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 4:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                    case 5:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                    case 6:
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 7:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                }
            }
        }
        /*
        if (cardsList == null)
        {
            //后两张牌移回原位并且显示牌背面
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].transform.localPosition = new Vector3((i - 2) * _cardInterval+20, 0, 0);
            }
            cardsTrans.localPosition = new Vector3(parentX, parentY, parentZ);

            UpdateSkinColor();
            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
            if (cardTypeSprite)
            cardTypeSprite.depth = 10;

            cardTypeTrans.gameObject.SetActive(false);
        }
        else
        {
            cardTypeTrans.gameObject.SetActive(true);
            cardsTrans.gameObject.SetActive(true);
            for (int i = 0; i < cardsArray.Length; i++)
            {
                cardsArray[i].gameObject.SetActive(true);
                cardsArray[i].spriteName = _cardPre + cardsList[cardsArray.Length - 1 - i].ToString();
            }

            UISprite cardTypeSprite = cardTypeTrans.GetComponentInChildren<UISprite>();
           
            if (cardType >= 0)
            {
                for (int i = 0; i < cardsArray.Length; i++)
                {

                    cardsArray[i].transform.localPosition = new Vector3((i - 2) * _cardInterval, 0, 0);
                }
                
                if (parentX > 0)
                {
                    cardsTrans.localPosition = new Vector3(195, -15, 0);
                    cardTypeTrans.localPosition = new Vector3(195, -50, 0);
                }
                else
                {
                    cardsTrans.localPosition = new Vector3(-182, -15, 0);
                    cardTypeTrans.localPosition = new Vector3(-182, -50, 0);
                }

                cardTypeSprite.spriteName = "type_" + cardType.ToString();
                cardTypeSprite.depth = 18;
                switch (cardType)
                {
                    case 0:
                        break;
                    case 1:
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 2:
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 3:
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 4:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                    case 5:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                    case 6:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                    case 7:
                        cardsArray[0].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(-15, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(-15, 20, 0);
                        break;
                    case 8:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                    case 9:
                        cardsArray[0].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[1].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[2].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[3].transform.localPosition += new Vector3(0, 20, 0);
                        cardsArray[4].transform.localPosition += new Vector3(0, 20, 0);
                        break;
                }
            }
        }
         * */
    }

    public int UserChip = 100;
    public void SetUserChip(int TheChip) {

        UserChip = TheChip;
        SetScore(-1);
    }
    public void SetScore(int score)
    {
        UISprite[] sprites = cardScoreObj.GetComponentsInChildren<UISprite>();
        if (cardScoreBg)
        {
            cardScoreBg.width = 557;
        }
        else { 
            foreach (UISprite sprite in sprites)
            {
                Destroy(sprite.gameObject);
            }
        }
        if (sprites.Length > 1)
        {
            foreach (UISprite sprite in sprites)
            {
                if (cardScoreBg)
                {
                    if (sprite.gameObject != cardScoreBg.gameObject)
                    {
                        Destroy(sprite.gameObject);
                    }
                }
                else {
                    Destroy(sprite.gameObject);
                }
            }
        }
        if (cardScoreBg)
        {
            if (score == -1)
            {
                //cardScoreObj.SetActive(false);
                cardScoreBg.spriteName = "score_board";
                EginTools.AddNumberSpritesCenter(jettonPrefab, cardScoreObj.transform, UserChip.ToString(), "plus_", .8f);

            }
            else
            {
                //cardScoreObj.SetActive(true);

                if (score >= 1000000 || score <= -1000000)
                {
                    cardScoreBg.width = 557;
                }
                if (score >= 0)
                {
                    cardScoreBg.spriteName = "benjia";
                    EginTools.AddNumberSpritesCenter(jettonPrefab, cardScoreObj.transform, "+" + score, "plus_", .8f);
                }
                else if (score < 0)
                {
                    cardScoreBg.spriteName = "benjia_minus";
                    EginTools.AddNumberSpritesCenter(jettonPrefab, cardScoreObj.transform, score.ToString(), "minus_", .8f);
                }
            }
        }
    }

    public void SetBet(int jetton)
    {
        //UISprite[] sprites = cardScoreObj.GetComponentsInChildren<UISprite>();
        //if (sprites.Length > 1)
        //{
        //    foreach (UISprite sprite in sprites)
        //    {
        //        if (!sprite.gameObject.name.Equals("Sprite_bg"))
        //        {
        //            Destroy(sprite.gameObject);
        //        }
        //    }
        //}
        //if (jetton == 0)
        //{
        //    cardScoreObj.SetActive(false);
        //}
        //else
        //{
        //    cardScoreObj.SetActive(true);
        //    EginTools.AddNumberSpritesCenter(jettonPrefab, cardScoreObj.transform, jetton.ToString(), "plus_", .8f);
        //}
    }

    public void SetReady(bool toShow)
    {
        if (toShow && !readyObj.activeSelf)
        {
            readyObj.SetActive(true);
        }
        else
        {
            readyObj.SetActive(false);
        }
    }

    public void SetShow(bool toShow)
    {
        if (showObj != null)
        {
            if (toShow && !showObj.activeSelf)
            {
                showObj.SetActive(true);
            }
            else
            {
                showObj.SetActive(false);
            }
        }
    }

    public void SetWait(bool toShow)
    {
        if (waitObj != null)
        {
            if (toShow && !waitObj.activeSelf)
            {
                waitObj.SetActive(true);
            }
            else
            {
                waitObj.SetActive(false);
            }
        }
    }
    public void AnimationPlay() { 
    
    }
}
