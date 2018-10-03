using UnityEngine;
using System.Collections;
using System;
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Interface)]
public class DefaultClassAttribute : System.Attribute {
    public System.Type implementType;//实现该接口或抽象类(基类)的实现类的类型
    public System.Type[] paramTypes;
    public DefaultClassAttribute(System.Type implementType)
    {
        this.implementType = implementType;
    }
}
