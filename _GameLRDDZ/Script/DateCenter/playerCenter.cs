using UnityEngine;
using System.Collections;

public class playerCenter{
    private static playerCenter instance;
    private string playerName;
    private int money, diamond;
    private playerCenter()
    {
        playerName = "未知";
        money =0;
        diamond = 0;
    }
    public static playerCenter getInstance()
    {
        if (instance == null)
        {
            instance = new playerCenter();
        }
        return instance;
    }
    public void updateplayerCenter()
    {

    }
}
