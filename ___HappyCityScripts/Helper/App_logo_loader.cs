using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class App_logo_loader : MonoBehaviour {

    private UITexture m_UITexture;

    void Awake()
    {
        m_UITexture = GetComponent<UITexture>();
        if (m_UITexture)
        {
            m_UITexture.mainTexture = Resources.Load<ResHolder>("ResHolder")._App_Logo;
            m_UITexture.MakePixelPerfect();
        }
    }

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
