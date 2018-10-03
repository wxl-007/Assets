using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ScalingStyleHelper : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        UIRoot uiroot = this.GetComponent<UIRoot>();
        if (uiroot)
        {
#if UNITY_STANDALONE
            uiroot.scalingStyle = UIRoot.Scaling.Constrained;
#else
                uiroot.scalingStyle = UIRoot.Scaling.ConstrainedOnMobiles;
#endif
        }
    }

    // Update is called once per frame
    void Update()
    {

    }
}
