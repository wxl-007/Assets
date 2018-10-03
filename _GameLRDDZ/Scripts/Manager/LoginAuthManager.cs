using UnityEngine;
using System.Collections;
using System.IO;
using System.Net.Sockets;
using System.Net;
using System.Text;
using System;
using System.Threading;
using LuaInterface;

enum AuthStatus
{
    NotAuth,
    NeedAuth,
    Authing,
}

namespace SimpleFramework.Manager
{
    public class LoginAuthManager : View
    {
        private Socket _client = null;

        private string _ipAddress = null;
        private int _port = 0;
        private string _account = null;
        private string _password = null;
        private string tokenText = "{0}@{1}:{2}";


        private int _readPos = 0;
        private int _writePos = 1;
        public static int MaxPackageSize = 8192;
        private byte[] _readData = new byte[8192 + 1];

        public byte[] challenge = null;
        public byte[] clientkey = null;
        public byte[] secret = null;
        public byte[] hmac = null;

        private Thread _authThread = null;
        //private bool _isAuthing = false;
        private AuthStatus _authStatus = AuthStatus.NotAuth;

        private bool _authFinish = false;
        private string _retNum = null;
        private string _retText = null;


        /// <summary>
        /// 执行Lua方法
        /// </summary>
        public object[] CallMethod(string func, params object[] args)
        {
            return Util.CallMethod("LoginAuth", func, args);
        }

        void Update()
        {
            if (_authStatus == AuthStatus.NeedAuth)
            {
                _authStatus = AuthStatus.Authing;
                if (_authThread != null)
                {
                    if (_authThread.IsAlive)
                    {
                        _authThread.Abort();
                    }
                    _authThread = null;
                }

                _authThread = new Thread(new ThreadStart(startAuth));
                _authThread.Start();

            }


            if (_authFinish && _retNum != null && _retText != null)
            {
                _authFinish = false;

                Debug.Log(_retNum);
                Debug.Log(_retText);

                if (_retNum != "200")
                {
                    //UIManager.getInstance().ShowMessage(_retText, 2.0f);
                    CallMethod("OnLoginAuthFail", _retText);
                }
                else
                {
                    //开始连接游戏服务器
                    int posOne = _retText.IndexOf("@");
                    int posTwo = _retText.IndexOf(":");
                    int posThree = _retText.IndexOf("#");
                    int posFour = _retText.IndexOf("&");

                    string subId = _retText.Substring(0, posOne);
                    string address = _retText.Substring(posOne + 1, posTwo - posOne - 1);
                    int port = int.Parse(_retText.Substring(posTwo + 1, posThree - posTwo - 1));
                    string serverName = _retText.Substring(posThree + 1, posFour - posThree - 1);
                    string uid = _retText.Substring(posFour + 1);

                    //开始连接游戏服务器
                    Debug.Log("修改");
                    //AppFacade.Instance.GetManager<NetworkManager>(ManagerName.Network).finishAuth(address, port, serverName, subId, uid, AppConst.Platform, secret);
                    //NetWorkManager.getInstance().finishAuth(address, port, serverName, subId, uid, Global.getInstance().Platform, secret);

                    CallMethod("OnLoginAuthSuccess", address, port, serverName, subId, uid, secret);
                }

                _retNum = null;
                _retText = null;
            }
        }

        public void reentryConnect(string ipAddress, int port, string inputAccount, string inputPassword)
        {
            _ipAddress = ipAddress;
            _port = port;
            _account = inputAccount;
            _password = inputPassword;

            if (_authStatus != AuthStatus.NotAuth)
            {
                return;
            }
            _authStatus = AuthStatus.NeedAuth;

        }

        private void startAuth()
        {
            if (_ipAddress == null)
            {
                Debug.LogError("IpAddress is null");

                return;
            }
            if (_port == 0)
            {
                Debug.LogError("host port error");

                return;
            }
            if (_client != null)
            {
                closed();
                Debug.LogError("_client not close");
                return;
            }

            _client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            IPEndPoint address = new IPEndPoint(IPAddress.Parse(_ipAddress), _port);

            try
            {
                _client.Connect(address);
                Debug.Log("Connect to host:" + _ipAddress + ",port:" + _port + " success");

                beginAuth();
                closed();
            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
                closed();
            }

        }

        private void beginAuth()
        {
            _readPos = 0;
            _writePos = 1;

            challenge = Crypt.base64decode(readLine());

            clientkey = Crypt.randomkey();

            writeline(Crypt.base64encode(Crypt.dhexchange(clientkey)));

            secret = Crypt.dhsecret(Crypt.base64decode(readLine()), clientkey);

            hmac = Crypt.hmac64(challenge, secret);
            writeline(Crypt.base64encode(hmac));

            string tokenStr = String.Format(tokenText, Crypt.base64encode("PC"), Crypt.base64encode(_account), Crypt.base64encode(_password));
            byte[] tokenByte = System.Text.Encoding.UTF8.GetBytes(tokenStr);

            writeline(Crypt.base64encode(Crypt.desencode(secret, tokenByte)));

            string result = System.Text.Encoding.UTF8.GetString(readLine());

            _retNum = result.Substring(0, 3);
            _retText = result.Substring(4);
            _authFinish = true;

            if (_retNum == "200")
            {
                _retText = Crypt.base64decode(_retText);
            }
        }

        private byte[] checkReadData()
        {
            int packLen = 0;
            int startPos = _readPos + 1;
            for (int i = startPos; i < _writePos; i++)
            {
                if (_readData[i] == 10)
                {
                    //string line = System.Text.Encoding.UTF8.GetString(_readData, startPos, packLen);
                    byte[] newbuffer = new byte[packLen];
                    Array.Copy(_readData, startPos, newbuffer, 0, packLen);

                    //重新设置
                    _readPos = i;

                    //Array.Copy(_readData, _readPos, _readData, 0, (_writePos - _readPos));
                    //_readPos = 0;
                    //_writePos = 1;

                    return newbuffer;
                }
                packLen += 1;
            }
            return null;
        }

        private byte[] readLine()
        {
            if (_client == null)
            {
                closed();
                return null;
            }
            if (!_client.Connected)
            {
                closed();
                return null;
            }

            try
            {
                while (true)
                {
                    byte[] data = null;
                    data = checkReadData();
                    if (data != null)
                    {
                        return data;
                    }
                    Array.Copy(_readData, _readPos, _readData, 0, (_writePos - _readPos));
                    _readPos = 0;
                    _writePos = 1;

                    int recv = _client.Receive(_readData, _writePos, MaxPackageSize, SocketFlags.None);
                    //Debug.Log("sssaaaaaa recv");
                    //Debug.Log(recv);
                    if (recv > 0)
                    {
                        _writePos += recv;

                        data = checkReadData();

                        if (data != null)
                        {
                            return data;
                        }

                        //int packLen = 0;
                        //int startPos = _readPos + 1;
                        //for (int i = startPos; i < _writePos; i++)
                        //{
                        //    if ( _readData[i] == 10)
                        //    {
                        //        string line = System.Text.Encoding.UTF8.GetString(_readData, startPos, packLen);

                        //        //重新设置
                        //        _readPos = i;

                        //        return line;
                        //    }
                        //    packLen += 1;
                        //}
                    }
                    else
                    {
                        break;
                    }
                    System.Threading.Thread.Sleep(200);

                }

            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
                closed();
                return null;
            }

            return null;
        }

        private void writeline(byte[] text)
        {
            if (_client == null)
            {
                closed();
                return;
            }
            if (!_client.Connected)
            {
                closed();
                return;
            }

            byte[] newText = new byte[text.Length + 1];
            text.CopyTo(newText, 0);
            newText[text.Length] = 10;
            //text = text + "\n";
            //byte[] textBuffer = System.Text.Encoding.UTF8.GetBytes(text);

            try
            {
                _client.Send(newText);
            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
                closed();
                return;
            }
        }

        private void closed()
        {
            if (_client != null && _client.Connected)
            {
                Debug.Log(string.Format("disconnect from auth server! host:{0} , port:{1}", _ipAddress, _port));

                _client.Shutdown(SocketShutdown.Both);
                _client.Close();
            }

            _client = null;
            _authStatus = AuthStatus.NotAuth;

            if (_authThread != null)
            {
                Thread temp = _authThread;
                _authThread = null;
                if (temp.IsAlive)
                {
                    temp.Abort();
                }

            }

        }

    }
}
