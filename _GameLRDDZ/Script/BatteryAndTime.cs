using System.Collections;
using System;
using UnityEngine;

public class BatteryAndTime : MonoBehaviour
{
    string _time = string.Empty;
    string _battery = string.Empty;
    public GameObject Time_ui;

    void Start()
    {
        StartCoroutine("UpdataTime");
        //StartCoroutine("UpdataBattery");
    }
    IEnumerator UpdataTime()
    {
        DateTime now = DateTime.Now;
        _time = string.Format("{0:00}:{1:00}", now.Hour, now.Minute);
        yield return new WaitForSeconds(60f - now.Second);
        while (true)
        {
            now = DateTime.Now;
            _time = string.Format("{0:00}:{1:00}", now.Hour, now.Minute);
            yield return new WaitForSeconds(60f);
        }
    }

    IEnumerator UpdataBattery()
    {
        while (true)
        {
            _battery = GetBatteryLevel().ToString();
            yield return new WaitForSeconds(300f);
        }
    }

    int GetBatteryLevel()
    {
        try
        {
#if UNITY_ANDROID
            string CapacityString= System.IO.File.ReadAllText("/sys/class/power_supply/battery/capacity");
#else
            string CapacityString = null;
#endif
            
            return int.Parse(CapacityString);
        }
        catch (Exception e)
        {
            //Debug.Log("Failed to read battery power; " + e.Message);
        }
        return -1;
    }
    void FixedUpdate()
    {
        Time_ui.GetComponent<UILabel>().text = _time;
      
    }
}
