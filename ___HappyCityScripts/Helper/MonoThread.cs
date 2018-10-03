using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MonoThread
{

    private MonoBehaviour m_Mono;
    private List<System.Action> m_Action_list = new List<System.Action>();
    private List<System.Action> m_Action_temp = new List<System.Action>();
    private List<MonoAction> m_MonoAction_list = new List<MonoAction>();
    private List<MonoAction> m_MonoAction_temp = new List<MonoAction>();

    public MonoThread(MonoBehaviour mono)
    {
        m_Mono = mono;
    }

    public void Start()
    {
        if (m_Mono)
        {
            m_Mono.StartCoroutine(Update());
        }
    }

    public void Stop()
    {
        m_Mono = null;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="action"></param>
    /// <param name="delay">单位秒</param>
    /// <returns></returns>
    public MonoAction Add(System.Action action, float delay = 0, AddEnum addEnum = AddEnum.Cancel)
    {
        if(delay <= 0)
        {
            lock (m_Action_list)
            {
                m_Action_list.Add(action);
            }

            return null;
        }
        else
        {
            MonoAction monoAction = new MonoAction { _Action = action};
            return Add(monoAction,delay, addEnum);
        }
    }

    public MonoAction Add(MonoAction monoAction,float delay, AddEnum addEnum = AddEnum.Cancel)
    {
        if (monoAction == null) return null;

        if (addEnum == AddEnum.Cancel && m_MonoAction_list.Contains(monoAction))
        {
            //不需要操作
        }
        else
        {
            monoAction._DelayedTime = System.DateTime.Now.AddSeconds(delay).Ticks;

            lock (m_MonoAction_list)
            {
                //需要删除
                if (addEnum == AddEnum.Override && m_MonoAction_list.Contains(monoAction))
                    m_MonoAction_list.Remove(monoAction);

                //添加
                m_MonoAction_list.Add(monoAction);
            }
        }

        return monoAction;
    }

    public void Remove(MonoAction monoAction)
    {
        lock (m_MonoAction_list)
        {
            if (m_MonoAction_list.Contains(monoAction))
                m_MonoAction_list.Remove(monoAction);
        }
    }

    public void RemoveAll(System.Predicate<MonoAction> match)
    {
        lock (m_MonoAction_list)
        {
            m_MonoAction_list.RemoveAll(match);
        }
    }

    public void Clear()
    {
        ClearActionList();

        ClearMonoActionList();
    }

    public void ClearMonoActionList()
    {
        lock (m_MonoAction_list)
        {
            m_MonoAction_list.Clear();
        }
    }

    public void ClearActionList()
    {
        lock (m_Action_list)
        {
            m_Action_list.Clear();
        }
    }

    private IEnumerator Update()
    {
        while (m_Mono)
        {
            lock (m_Action_list)
            {
                m_Action_temp.Clear();
                m_Action_temp.AddRange(m_Action_list);
                m_Action_list.Clear();
            }

            foreach (var item in m_Action_temp)
            {
                if(item != null) item();
            }

            lock (m_MonoAction_list)
            {
                m_MonoAction_temp.Clear();
                m_MonoAction_temp.AddRange(m_MonoAction_list.FindAll((a)=>a._DelayedTime < System.DateTime.Now.Ticks));
                foreach (var item in m_MonoAction_temp)
                {
                    m_MonoAction_list.Remove(item);
                }
            }

            foreach (var item in m_MonoAction_temp)
            {
                item._Action();
            }

            yield return 0;
        }
    }
}

public class MonoAction
{
    public long _DelayedTime;
    public System.Action _Action;
}

public enum AddEnum : byte
{
    Cancel,
    KeepBoth,
    Override,
}