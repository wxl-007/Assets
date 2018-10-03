MessageManger = {}
local self = MessageManger

function MessageManger.Init()
	self.MessageList = {}
	self.time = Timer.New(self.ReFunc, 1, -1, true)
	self.time:Start()
end 
function MessageManger.ReFunc()
	for i= #self.MessageList, 1, -1 do 
	 	if self.MessageList[i].Count > 0 then 
	 		self.MessageList[i].Count = self.MessageList[i].Count -1
	 	else 
			destroy(self.MessageList[i].GameObject)
			table.remove(self.MessageList,i)
		end 
	end 
end
function MessageManger.ShowMessage(string)
	LRDDZ_ResourceManager.Instance:CreatePanel('Message','Message', false,function(obj)
			obj.transform:FindChild("MessageBg/Text"):GetComponent("UILabel").text = string
			local messageItem = {}
			messageItem.GameObject = obj
			messageItem.Count = 1
			table.insert(self.MessageList,messageItem)
			local mg = obj.transform:FindChild("MessageBg").gameObject
			iTween.MoveTo(mg, iTween.Hash("position", Vector3.New(0, 0, 0), "time", 0.3, "islocal", true, "easetype", iTween.EaseType.linear));
		end);
end 

function MessageManger.Clear()
	self.MessageList = {}
end 
