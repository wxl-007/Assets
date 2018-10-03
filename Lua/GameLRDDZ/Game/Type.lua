
--角色类型
CharacterType = {
	Library=0,
	Player=1,
    Computer =2,
    OtherComputer = 3,
}

--花色
Suits = {
    None = "None",
	--方块
	Diamond = "Diamond",
    --梅花
    Club = "Club",
    --红桃
    Heart = "Heart",
    --黑桃
    Spade = "Spade",
    --癞子
    LaiZi = "LaiZi",

}
SuitsColor = {
    None = "",
    Diamond = "[C80A02]",
    Club = "[191F23]",
    Heart = "[C80A02]",
    Spade = "[191F23]",
    LaiZi = "[F06502]",
}
--权值
Weight = {
    None  = 0,
    Three = 1,
    Four  = 2,
	Five  = 3,
    Six   = 4,
    Seven = 5,
    Eight = 6,
    Nine  = 7,
    Ten   = 8,
    Jack  = 9,
    Queen = 10,
    King  = 11,
    One   = 12,
    Two   = 13,
    SJoker= 14,
    LJoker= 15,
}

WeightString = {
    [0] = "",
    [1] = "Three",
    [2] = "Four",
    [3] = "Five",
    [4] = "Six",
    [5] = "Seven",
    [6]  = "Eight",
    [7]  = "Nine",
    [8]  = "Ten",
    [9]  = "Jack",
    [10]  = "Queen",
    [11]  = "King",
    [12]  = "One",
    [13]  = "Two",
    [14]  = "SJoker",
    [15]  = "LJoker",
}
WeightText = {
    [1] = "3",
    [2] = "4",
    [3] = "5",
    [4] = "6",
    [5] = "7",
    [6]  = "8",
    [7]  = "9",
    [8]  = "10",
    [9]  = "J",
    [10]  = "Q",
    [11]  = "K",
    [12]  = "A",
    [13]  = "2",
    [14]  = "",
    [15]  = "",
}
--身份
Identity = {
	--农民
	Farmer = "Farmer",
    --地主
    Landlord = "Landlord",
}

--出牌类型
CardsType = {
    --未知类型（原来是1到16）
    None = 15,
    --王炸
    JokerBoom = 13,
    --炸弹
    Boom = 12,
    --三个不带
    OnlyThree = 2,
    --三个带一
    ThreeAndOne = 3,
    --三个带二
    ThreeAndTwo = 4,
    --顺子 五张或更多的连续单牌
    Straight = 5,
    --双顺 三对或更多的连续对牌
    DoubleStraight = 6,
    --三顺 二个或更多的连续三张牌
    TripleStraight = 7,
    --飞机带单翅膀
    TripleStraightAndSingle = 8,
    --飞机带双翅膀
    TripleStraightAndDouble = 9,
    --4带2单
    FourAndSingle = 10,
    --4带2对
    FourAndDouble = 14,
    --对子
    Double = 1,
    --单个
    Single = 0,
}

--
GameState = {
	Before = 0, --准备阶段
	GradLord = 1, --抢地主
    Double = 2,
	Play = 3, --打牌
	End = 4, --结束
}


GameEvent = {
    --GamePanel的事件
    ShowCallBtn = "ShowCallBtn",
    ShowLetNum = "ShowLetNum",
    ShowGardLord = "ShowGardLord",
    ShowBottomCards = "ShowBottomCards",-- 显示底牌
    ShowPlay = "ShowPlay",
    ReSetInfo = "ResetInfo",
    ShowGameText = "ShowGameText",
    NoteCard = "NoteCard",
    NotBigCard = "NotBigCard",
    ShowYaobuqi = "ShowYaobuqi",
    --
    ShowPlayerHandCards = "ShowPlayerHandCards",
    --
    ShowComputerHandCards = "ShowComputerHandCards",

    ShowOtherComputerHandCards = "ShowOtherComputerHandCards",
}
PlatformType = {
    --平台
    PlatformPC = 1,             -- pc 131 597 等平台
    PlatformMoble,          -- 手机 597
}
DDZGameType = {
    Two = 1,--两人
    Three = 2,--三人
    JDThree = 3,--三人京东赛
}
DDZGameMatchType = {
    None = 1, --不是比赛
    FiveMinute = 2, --5分钟赛
    ThreeMatch = 3,--三人体验赛
    JDMatch = 4,--场均分 京东赛
    LZMatch = 5,--癞子赛
}
