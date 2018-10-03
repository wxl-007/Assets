using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZPokerData {

	/// <summary>
	/// 扑克牌的值
	/// </summary>
	private DDZC.PokerNum _pokerNum;
	/// <summary>
	/// 扑克牌的花色
	/// </summary>
	private DDZC.PokerColor _pokerColor;
	
	/// <summary>
	/// 扑克牌的值
	/// </summary>
	public DDZC.PokerNum pokerNum
	{
		get
		{
			return this._pokerNum;
		}
		set
		{
			this._pokerNum = value;
		}
	}
	
	/// <summary>
	/// 扑克牌的花色
	/// </summary>
	public DDZC.PokerColor pokerColor
	{
		get
		{
			return this._pokerColor;
		}
		set
		{
			this._pokerColor = value;
		}
	}

	public int cardID;//0 to 53

//	public DDZPokerData(DDZC.PokerNum pokerNum, DDZC.PokerColor pokerColor)
//	{
//		this.pokerNum = pokerNum;
//		this.pokerColor = pokerColor;
//		if(pokerColor == DDZC.PokerColor.SKing){
//			this.cardID = 52;
//		}else if(pokerColor == DDZC.PokerColor.LKing){
//			this.cardID = 53;
//		}else{
//			this.cardID = cardID + ((int)pokerColor-1)*13;
//		}
//
//	}

	public DDZPokerData(int card_id){
		this.cardID = card_id;
		this.pokerNum = getPokerNum(card_id);
		this.pokerColor = getPokerColor(card_id);
	}

	//DDZTip2.cs use this value
	public int flashValue{
		get{
			if(cardID<54){
				if(cardID == 52){
					return 13;
				}else if(cardID == 53){
					return 14;
				}else if(cardID <52){
					return cardID%13;
				}
			}
			return -1;
		}

	}

	public DDZC.PokerNum getPokerNum(int card_id){
		DDZC.PokerNum pNum;
		if(card_id< 52){
			pNum = (DDZC.PokerNum)(card_id%13 + 3);
		}else if(card_id == 52){
			pNum = DDZC.PokerNum.小王;
		}else if(card_id == 53){
			pNum = DDZC.PokerNum.大王;
		}else{
			pNum = DDZC.PokerNum.error;
			Debug.LogError("!!!!!!!!!cardid < 0 or cardid > 53");
		}
		return pNum;
	}
	public DDZC.PokerColor getPokerColor(int card_id){
		DDZC.PokerColor pColor;
		if(card_id>=0 && card_id<=12){
			pColor = DDZC.PokerColor.方块;
		}else if(card_id>=13 && card_id<=25){
			pColor = DDZC.PokerColor.梅花;
		}else if(card_id>=26 && card_id<=38){
			pColor = DDZC.PokerColor.红心;
		}else if(card_id>=39 && card_id<=51){
			pColor = DDZC.PokerColor.黑桃;
		}else if(card_id == 52){
			pColor = DDZC.PokerColor.SKing;
		}else if(card_id == 53){
			pColor = DDZC.PokerColor.LKing;
		}else{
			pColor = DDZC.PokerColor.error;
			Debug.LogError("!!!!!!!!!cardid < 0 or cardid > 53");
		}
		return pColor;
	}
	
	public static bool operator ==(DDZPokerData LP, DDZPokerData RP)
	{
		if ((object)LP != null && (object)RP != null)
		{
			if (LP.pokerNum == RP.pokerNum)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			if ((object)LP == null && (object)RP != null)
			{
				return false;
			}
			else
			{
				if ((object)LP != null && (object)RP == null)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}
	}
	public static bool operator ==(DDZPokerData LP, DDZC.PokerNum RP)
	{
		if ((object)LP != null)
		{
			if (LP.pokerNum == RP)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	public static bool operator !=(DDZPokerData LP, DDZC.PokerNum RP)
	{
		return !(LP.pokerNum == RP);
	}
	public static bool operator !=(DDZPokerData LP, DDZPokerData RP)
	{
		return !(LP == RP);
	}
	public static bool operator >(DDZPokerData LP, DDZPokerData RP)
	{
		if ((object)LP != null && (object)RP != null)
		{
			if (LP.pokerNum > RP.pokerNum)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return true;
		}
	}
	public static bool operator <(DDZPokerData LP, DDZPokerData RP)
	{
		if (RP > LP)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public override string ToString()
	{
		string Num = this.pokerNum.ToString().Replace("P", "");
		string Color;
		switch (this.pokerColor.ToString())
		{
		case "黑桃":
			Color = "♠";
			break;
		case "方块":
			Color = "♦";
			break;
		case "红心":
			Color = "♥";
			break;
		case "梅花":
			Color = "♣";
			break;
		default:
			Color = "";
			break;
		}
		if ((int)(this.pokerNum) >= 16)
		{
			return Num;
		}
		else
		{
			return Color + Num;
		}
	}
}
