using UnityEngine;
using System.Collections;

public class ZP_UIButtonColor : UIButtonColor {
	
	public bool autoAnimationColor = false;

//	public override void Init ()
//	{
//		if (tweenTarget == null) tweenTarget = gameObject;
//		UIWidget widget = tweenTarget.GetComponent<UIWidget>();
//
//		if (widget != null)
//		{
//			mColor = widget.color;
//		}
//		else
//		{
//			Renderer ren = tweenTarget.renderer;
//
//			if (ren != null)
//			{
//				mColor = ren.material.color;
//			}
//			else
//			{
//				Light lt = tweenTarget.light;
//
//				if (lt != null)
//				{
//					mColor = lt.color;
//				}
//				else
//				{
//					mColor = Color.white;
//				}
//			}
//		}
//		
//		if (autoAnimationColor) {
//			hover = new Color(mColor.r * 0.8f, mColor.g * 0.8f, mColor.b * 0.8f, mColor.a);
//			pressed = new Color(mColor.r * 0.6f, mColor.g * 0.6f, mColor.b * 0.6f, mColor.a);
//		}
//		
//		OnEnable();
//	}
}
