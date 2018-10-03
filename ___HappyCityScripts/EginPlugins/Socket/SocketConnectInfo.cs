using UnityEngine;
using System.Collections;

public class SocketConnectInfo {

	private static SocketConnectInfo _instance;
	public static SocketConnectInfo Instance {
		get {
			if(_instance == null) {
				_instance = new SocketConnectInfo();
			}
			return _instance;
		}
	}
	
	public string userId = "";
	public string userPassword = "";
	
	public string roomId = "";
	public string roomHost = "";
	public string roomPort = "";
	public string roomDBName = "";
	public bool roomFixseat = true;
	
	public string roomTitle = "";
	public string roomMinMoney = "";

	//add 2016.4.5
	public int entry_fee = 0;
    //add 2016.09.13
    public string roomType;

    public string lobbyUserName = string.Empty;
    public string lobbyPassword = string.Empty;
    
	
	public void Init (EginUser userinfo, GameRoom roominfo) {
		userId = userinfo.uid;
		userPassword = userinfo.password;

		Debug.Log("roominfo-->"+roominfo);
		roomId = roominfo.roomId;
		roomHost = roominfo.host;
		roomPort = roominfo.port;
		roomDBName = roominfo.dbname;
		roomFixseat = roominfo.fixseat;

		roomTitle = roominfo.title;
		roomMinMoney = roominfo.minMoney;

		//add 2016.4.5
		entry_fee = roominfo.entry_fee;
        //add 2016.09.13
        roomType = roominfo.roomType;
    }
	
	public bool ValidInfo () {
		bool valid = false;
		if (userId.Length > 0 && userPassword.Length > 0 
			&& roomId.Length > 0 ) {//&& roomHost.Length > 0 && roomPort.Length > 0) {
			valid = true;
		}
		return valid;
	}
}
