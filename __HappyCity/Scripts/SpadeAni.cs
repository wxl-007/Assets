using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SpadeAni : MonoBehaviour {

	// Use this for initialization
    public UISprite[] m_SpriteList;
	void Start () {
        StartCoroutine(SpadeAnime());
	}

    IEnumerator SpadeAnime() {
        int tI = 12;
        int tJ = 0;
        while (true)
        {
            
            for (int i = 1; i < 64; i++)
            {
                yield return new WaitForSeconds(0.1f);
                m_SpriteList[tJ].width = m_SpriteList[tJ].width + tI;
                if (m_SpriteList[tJ].width >= 64)
                {
                    m_SpriteList[tJ].width = 64;
                    break;
                }
            }
            tJ++;
            if (tJ > 6) {
                tJ = 0;
                for (int i = 0; i < 6; i++) {
                    m_SpriteList[i].width = 0;
                }
            }
        }
    }
	

}
