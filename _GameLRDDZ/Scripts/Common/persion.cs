using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class persion : MonoBehaviour {
    public int type;
    int count=0;
    public int[] type1list ;
    public int[] type2list ;
    float timecount;
    public float delay;
    float delaycount;
    void Start () {
        //type = 1;
        type1list = new int[10];
        type2list = new int[10];
            type1list[0] = 1;
            type1list[1] = 2;
            type1list[2] = 0;
            type1list[3] = 3;
            type1list[4] = 0;
            type1list[5] = 4;
            type1list[6] = 0;
            type1list[7] = 3;
            type1list[8] = 0;
            type1list[9] = 6;

            type2list[0] = 1;
            type2list[1] = 0;
            type2list[2] = 2;
            type2list[3] = 0;
            type2list[4] = 4;
            type2list[5] = 0;
            type2list[6] = 5;
            type2list[7] = 0;
            type2list[8] = 4;
            type2list[9] = 7;
           
    }
	
	void Update () {
        if (count >= 10)
            count = 0;
        delaycount += Time.deltaTime;
        timecount += UnityEngine.Time.deltaTime;
        if (delaycount >= delay)
        {
            if (timecount >= 2)
            {
                timecount = 0;
                if (type == 1)
                {
                    switch (type1list[count])
                    {
                        case 1:
                            gameObject.GetComponent<Animation>().Play("pickup");
                            count++;
                            break;
                        case 2:
                            gameObject.GetComponent<Animation>().Play("rolord");
                            count++;
                            break;
                        case 3:
                            gameObject.GetComponent<Animation>().Play("nodeal");
                            count++;
                            break;
                        case 4:
                            gameObject.GetComponent<Animation>().Play("dealmore");
                            count++;
                            break;
                        case 5:
                            gameObject.GetComponent<Animation>().Play("boom");
                            count++;
                            break;
                        case 6:
                            gameObject.GetComponent<Animation>().Play("lost");
                            count = 0;
                            break;
                        case 7:
                            gameObject.GetComponent<Animation>().Play("win");
                            count = 0;
                            break;
                        case 0:
                            gameObject.GetComponent<Animation>().Play("wait");
                            count++;
                            break;
                    }
                }
                else
                {
                    switch (type2list[count])
                    {
                        case 1:
                            gameObject.GetComponent<Animation>().Play("pickup");
                            count++;
                            break;
                        case 2:
                            gameObject.GetComponent<Animation>().Play("rolord");
                            count++;
                            break;
                        case 3:
                            gameObject.GetComponent<Animation>().Play("nodeal");
                            count++;
                            break;
                        case 4:
                            gameObject.GetComponent<Animation>().Play("dealmore");
                            count++;
                            break;
                        case 5:
                            gameObject.GetComponent<Animation>().Play("boom");
                            count++;
                            break;
                        case 6:
                            gameObject.GetComponent<Animation>().Play("lost");
                            count = 0;
                            break;
                        case 7:
                            gameObject.GetComponent<Animation>().Play("win");
                            count = 0;
                            break;
                        case 0:
                            gameObject.GetComponent<Animation>().Play("wait");
                            count++;
                            break;
                    }
                }
            }
        }
    }
}
