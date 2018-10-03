using UnityEngine;
using System.Collections;

public class GlobalVar {

	public static string Top = "top";
	public static string Left = "left";
	public static string Right = "right";


	public enum PlayerPosition {
		Down,
		RightDown,
		Right,
		RightUp,
		Top,
		LeftUp,
		Left,
		LeftDown,
	}

	/// <summary>
	/// 游戏界面肤色
	/// </summary>
	public static string SKIN_COLOR = "green";
    public static string SKINCARD_COLOR = "blue";
}
