using System;
using System.Collections.Generic;

public static class LuaBinder
{
	public static List<string> wrapList = new List<string>();
	public static void Bind(IntPtr L, string type = null)
	{
        if (type == null || wrapList.Contains(type)) return;
        wrapList.Add(type); type += "Wrap";

        Type wrapType = Type.GetType(type);
        System.Reflection.MethodInfo register_methodInfo = wrapType == null ? null : wrapType.GetMethod("Register");
        if(register_methodInfo != null) register_methodInfo.Invoke(null, new object[] { L });
    }
}
