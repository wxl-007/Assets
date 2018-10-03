using UnityEngine;
using System.Collections;

public class ModuleBase : BaseScene {
	
	public virtual void OnClickBack () {
		EginLoadLevel("Hall");
	}
}
