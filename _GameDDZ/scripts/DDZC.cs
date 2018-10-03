using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;

public class DDZC  {
    public enum PokerNum
    {
        //从0~53, 0是方块3, 1是方块4, ..., 12是方块2, 13是草花4, ..., 51是小毛,52大毛
        P3 = 3,
        P4 = 4,
        P5 = 5,
        P6 = 6,
        P7 = 7,
        P8 = 8,
        P9 = 9,
        P10 = 10,
        J = 11,
        Q = 12,
        K = 13,
        A = 14,
        P2 = 15,
        小王 = 16,
        大王 = 17,
		error = -99
    }
    /// <summary>
    /// 扑克牌的花色
    /// </summary>
    public enum PokerColor
    {
        黑桃 = 4,
        红心 = 3,
        梅花 = 2,
        方块 = 1,
		SKing = 5,
		LKing = 6,
		error = -99
    }

	//Server side post this
	//单张0，对子1，三张2，三带单3，三带对4，单顺5，双顺6，飞机7，飞机带单8，飞机带双9，四带两单10，炸弹12，火箭13

    /// <summary>
    /// 扑克牌的类型,转换为Int后代表该类型的牌组张数
    /// </summary>
    public enum PokerGroupType
    {
        //需要修改枚举类型的值以区别各种牌.
        单张 = 1,
        对子 = 2,
        双王 = 3,
        三张相同 = 4,
        三带一 = 5,
        炸弹 = 6,
        五张顺子 = 7,
        六张顺子 = 8,
        三连对 = 9,
        四带二 = 10,
        二连飞机 = 11,
        七张顺子 = 12,
        四连对 = 13,
        八张顺子 = 14,
        飞机带翅膀 = 15,
        九张顺子 = 16,
        三连飞机 = 17,
        五连对 = 18,
        十张顺子 = 19,
        十一张顺子 = 20,
        十二张顺子 = 21,
        四连飞机 = 22,
        三连飞机带翅膀 = 23,
        六连对 = 24,
        //没有13
        七连对 = 25,
        五连飞机 = 26,
        八连对 = 27,
        四连飞机带翅膀 = 28,
        //没有17
        九连对 = 29,
        六连飞机 = 30,
        //没有19
        十连对 = 31,
        五连飞机带翅膀 = 32
		
    }
}
