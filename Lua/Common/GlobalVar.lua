
local this = LuaObject:New()
GlobalVar = this 

this.Top = "top";
this.Left = "left";
this.Right = "right";


this.PlayerPosition =  {
	['Down'] = "Down",
	['RightDown'] = 'RightDown',
	['Right'] = 'Right',
	['RightUp'] = 'RightUp',
	['Top'] = 'Top' ,
	['LeftUp'] = 'LeftUp',
	['Left'] = 'Left',
	['LeftDown'] ='LeftDown' ,
}

-- 游戏界面肤色
this.SKIN_COLOR = "green";
this.SKINCARD_COLOR = "blue";