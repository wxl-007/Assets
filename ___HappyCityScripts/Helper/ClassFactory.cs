using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Reflection;

public static class ClassFactory {

    public static T Default<T>(params object[] args)
    {
        DefaultClassAttribute attribute = typeof(T).GetCustomAttribute<DefaultClassAttribute>();
        if (attribute != null && (attribute.implementType.IsSubclassOf(typeof(T)) || attribute.implementType.GetInterface(typeof(T).Name) != null))
        {//存在该 特性, 并且该特性指定的继承类继承了 T 这个基类
            return (T)attribute.implementType.Assembly.CreateInstance(attribute.implementType.Name, false, BindingFlags.CreateInstance, null, args, null, null);
        }
        throw new Exception("the class do not contains DefaultClassAttribute which means attribute == null or attribute.implementType.IsSubclassOf(typeof(T)) is false");
    }

    public static T GetCustomAttribute<T>(this MemberInfo info) where T : System.Attribute
    {
        return (T)System.Attribute.GetCustomAttribute(info, typeof(T));
    }
}
