using UnityEngine;
using System.Collections;

public interface SocketListener {
	
	void SocketReceiveMessage (string message);
	
    /// <summary>
    /// 不再用于 重连,重连相关的内容不要在这里调用
    /// </summary>
    /// <param name="disconnectInfo"></param>
	void SocketDisconnect (string disconnectInfo);

    /// <summary>
    /// 添加OnSocketManagerDisconnect 后,功能有所修改.(改后的功能为 当前正在使用的 socketconnect 断开时 回调)
    /// 1.这里不再进行 ip 切换.
    /// 2.这里不需要调用重连方法 connect, 也不需要把 socketListener 置为空
    /// 
    /// 这个函数会在同一个ip 不同 SocketConnect断开时调用, 内部会自动判断是否切换到下一个 socketConnect 还是 切换下一个ip
    /// </summary>
    /// <param name="disconnectInfo">最后一条断开连接的消息</param>
    void OnSocketDisconnect(string disconnectInfo);

    /// <summary>
    /// 当 当前的 ip 多次重连失败后,判断当前ip 无效时 回调(主要用于切换ip)
    /// </summary>
    /// <param name="errMsg"></param>
    //void OnSocketManagerDisconnect(string errMsg);//由于这里的更能较为单一,直接在底层实现了. 不对外回调

    /// <summary>
    /// socketmanager 长时间无响应时回调(连接 30秒(时间可以调整) 没有连接上,(同一个ip 多次重连, 多个ip 多次切换 都无法在 30秒 连接上的情况下))
    /// </summary>
    void OnSocketManagerTimeOut(string errMsg);
}
