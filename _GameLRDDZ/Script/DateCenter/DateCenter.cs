using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DateCenter
{
    private static DateCenter instance;
    //public List<GameOverDate> Date = new List<GameOverDate>();//游戏分数记录信息
    public int[][] PAI=new int[4][];//各家手牌
    public bool[] huED;//是否胡过
    public bool[] TingED;//是否听牌
    public int huEDNo;
    public ArrayList[] GANGList = new ArrayList[4], PENGList = new ArrayList[4], flowerList = new ArrayList[4], ANGANGList = new ArrayList[4], EatList = new ArrayList[4];//各家状态记录
    public int[] player_que=new int[4];//各家定缺
    private DateCenter()
    {
        for (int i = 0; i < 4;i++ )
        {
            PAI[i] = new int[46];
            GANGList[i] = new ArrayList();
            PENGList[i] = new ArrayList();
            flowerList[i] = new ArrayList();
            ANGANGList[i] = new ArrayList();
            EatList[i] = new ArrayList(); 
            player_que[i] = 5;
        }
        huED = new bool[4] { false, false, false, false };
        huEDNo=0;
    }
    public static DateCenter getInstance()
    {
        if (instance == null)
        {
            instance = new DateCenter();
        }
        return instance;
    }
    public static DateCenter reset()
    {
        instance = new DateCenter();
        return instance;
    }

    public void newPAI(int playerNo, int[] PAI1)
    {
        PAI1.CopyTo(PAI[playerNo], 0);
    }
    

}
public enum tishier
{
    onTime = 1,
    tishi = 2
}