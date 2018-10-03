using UnityEngine;
using System.Collections;
/// <summary>
/// 相对backWideget的层次
/// </summary>
//[ExecuteInEditMode]
public class LRDDZ_UISetEffQueue : MonoBehaviour
{
    public UIWidget backWideget;
    public int addDepth = 1;
    void Start()
    {
        //SetRenderQueue(transform);
    }
    bool hasSet = false;
    public void SetRenderQueue(Transform currentTransform)
    {
        int renderQueue = backWideget.drawCall.renderQueue + addDepth;
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
                SetRenderQueue(child);
            }
        }
        hasSet = true;
        
    }
    public void SetReset(int add)
    {
        addDepth = add;
        hasSet = false;
    }
    public void SetReset()
    {
        hasSet = false;
    }
    void Update()
    {
        if (!backWideget)
            backWideget = NGUITools.FindInParents<UIWidget>(gameObject);
        if (backWideget.drawCall&&!hasSet)
        {
            SetRenderQueue(transform);
        }
    }
}
