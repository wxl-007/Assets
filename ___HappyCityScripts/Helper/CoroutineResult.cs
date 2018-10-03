using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CoroutineResult {

    public string error;
    public bool _BoolResult;
    public string _StringResult;
    public int _IntResult;
    public WWW _wwwResult;
    public AssetBundle _AssetBundleResult;
    public object _objectResult;

    public static implicit operator bool (CoroutineResult result)
    {
        return result != null;
    }
}
