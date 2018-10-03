using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;
public class close : MonoBehaviour {
    public GameObject closed;
    public void closes()
    {
        closed.SetActive(false);
    }
    public void Bcakcloses()
    {
        if (closed.activeSelf == false) SceneManager.LoadScene("Room");
        else
        closed.SetActive(false);
    }
}
