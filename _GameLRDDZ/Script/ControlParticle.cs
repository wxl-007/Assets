using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ControlParticle : MonoBehaviour
{

    public int renderQueue = 30000;
    public bool runOnlyOnce = false;

    void Start()
    {
        Update();
    }

    void Update()
    {
        if (this.GetComponent<Renderer>() != null && this.GetComponent<Renderer>().sharedMaterial != null)
        {
            this.GetComponent<Renderer>().sharedMaterial.renderQueue = renderQueue;
        }
        if (runOnlyOnce && Application.isPlaying)
        {
            this.enabled = false;
        }
    }
}