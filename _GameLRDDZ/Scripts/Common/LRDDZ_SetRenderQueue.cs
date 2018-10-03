using UnityEngine;
using System.Collections;

public class LRDDZ_SetRenderQueue : MonoBehaviour {

    public int renderQueue = 4000;
    // Use this for initialization
    void Awake ()
    {
        SetQueue(transform);
    }
    public void SetQueue(Transform currentTransform)
    {
        
        if (currentTransform.GetComponent<Renderer>() != null && currentTransform.GetComponent<Renderer>().material != null)
        {
            for (int i = 0; i < currentTransform.GetComponent<Renderer>().materials.Length; ++i)
            {
                currentTransform.GetComponent<Renderer>().materials[i].renderQueue = renderQueue;
            }
        }
        if (currentTransform.childCount != 0)
        {
            foreach (Transform child in currentTransform)
            {
                SetQueue(child);
            }
        }
    }
}
