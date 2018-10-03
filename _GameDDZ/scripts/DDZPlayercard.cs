using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DDZPlayercard : MonoBehaviour {

	public DDZPokerData pokerD;
    public DDZPlayerCtrl myfather;
	public int index;
	private bool _isSelected=false;
	public bool _preSel = false;
	public bool isSelected{
		get{
			return _isSelected;
		}
	}

	public void resizeCollider(bool isREdge, bool  isBanker=false)
	{
//		gameObject.GetComponent<BoxCollider>().center = Vector3.zero;
//		gameObject.GetComponent<BoxCollider>().size = new Vector3(134,176,1);
//		if(isREdge){
//			gameObject.GetComponent<BoxCollider>().center = Vector3.zero;
//			gameObject.GetComponent<BoxCollider>().size = new Vector3(134,176,1);
//		}else{
//			if(isBanker){
//				gameObject.GetComponent<BoxCollider>().center = new Vector3(-39.95767f, 0, 0);
//				gameObject.GetComponent<BoxCollider>().size = new Vector3(54.08497f,176,1);
//			}else{
//				gameObject.GetComponent<BoxCollider>().center = new Vector3(-33.90771f, 0, 0);
//				gameObject.GetComponent<BoxCollider>().size = new Vector3(66.18483f,176,1);
//			}
//
//		}
		//66.18483
	}

	public void resetState()
	{
		if (_isSelected)
		{
			Vector3 vc3 = this.gameObject.transform.localPosition;
			vc3.y = 0;
			this.gameObject.transform.localPosition = vc3;
//			myfather.readycard(this.gameObject);
		}
		_isSelected = false;
	}

	public void selectCard()
	{
		if (!myfather.myDDZ.btnGroup.isManaged)
//		if (myfather.myDDZ.GetComponent<GameDDZ>().beginplay)
		{
			Vector3 vc3 = this.gameObject.transform.localPosition;
			vc3.y = 30;
			this.gameObject.transform.localPosition = vc3;
			_isSelected = true;
		}
	}

	public void preSelectCard()
	{
		if (!myfather.myDDZ.btnGroup.isManaged)
//		if (myfather.myDDZ.GetComponent<GameDDZ>().beginplay && !myfather.myDDZ.btnGroup.isManaged)
		{
			if(_preSel == false){
				GetComponent<UISprite>().color = new Color(0.8f, 0.8f, 1.0f);
			}
			_preSel = true;
		}
	}
	public void clearPreSelectCard()
	{
		GetComponent<UISprite>().color = new Color(1.0f, 1.0f, 1.0f);
		_preSel = false;
	}

	public void toggleWithoutCheck()
	{
		if (!myfather.myDDZ.btnGroup.isManaged)
		{
			_isSelected = !_isSelected;
			if (_isSelected)
			{
				Vector3 vc3 = this.gameObject.transform.localPosition;
				vc3.y= 30;
				this.gameObject.transform.localPosition = vc3;
			}
			else
			{
				Vector3 vc3_1 = this.gameObject.transform.localPosition;
				vc3_1.y= 0;
				this.gameObject.transform.localPosition = vc3_1;
			}
			clearPreSelectCard();
		}
	}

    public void Buttonc() {
		if(myfather.myDDZ.isObserver)return;
		if (!myfather.myDDZ.btnGroup.isManaged)
//		if (myfather.myDDZ.GetComponent<GameDDZ>().beginplay && !myfather.myDDZ.btnGroup.isManaged)
        {
			_isSelected = !_isSelected;
			if (_isSelected)
            {
				Vector3 vc3 = this.gameObject.transform.localPosition;
				vc3.y= 30;
				this.gameObject.transform.localPosition = vc3;
            }
            else
            {
				Vector3 vc3_1 = this.gameObject.transform.localPosition;
				vc3_1.y= 0;
				this.gameObject.transform.localPosition = vc3_1;
            }
			myfather.selCardHandle();
			clearPreSelectCard();
			myfather.sendSelectCardToServer();
        }
    }
}
