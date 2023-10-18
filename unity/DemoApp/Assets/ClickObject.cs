//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using UnityEngine.UI;
//using UnityEngine.EventSystems;

//public class ClickObject : MonoBehaviour
//{
//    public GameObject cube;

//    // Update is called once per frame
//    void Update()
//    {
//        if (Input.touchCount > 0)
//        {
//            Touch touch = Input.GetTouch(0);

//            if (touch.phase == TouchPhase.Began)
//            {
//                Vector3 touchPosition = touch.position;

//                if (cube == GetClickedObject(touchPosition, out RaycastHit hit))
//                {
//                    print("Touched!");
//                }
//            }
//        }
//    }

//    GameObject GetClickedObject(Vector3 touchPosition, out RaycastHit hit)
//    {
//        GameObject target = null;
//        var ray = Camera.main.ScreenPointToRay(touchPosition);
//        if (Physics.Raycast(ray.origin, ray.direction * 10, out hit))
//        {
//            if (!IsPointerOverUIObject(touchPosition)) { target = hit.collider.gameObject; }
//        }
//        return target;
//    }

//    private bool IsPointerOverUIObject(Vector3 touchPosition)
//    {
//        PointerEventData ped = new PointerEventData(EventSystem.current);
//        ped.position = new Vector2(touchPosition.x, touchPosition.y);
//        List<RaycastResult> results = new List<RaycastResult>();
//        EventSystem.current.RaycastAll(ped, results);
//        return results.Count > 0;
//    }
//}

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using FlutterUnityIntegration;
public class ClickObject : MonoBehaviour
{
    public List<GameObject> targetObjects = new List<GameObject>();

    public void MessengerFlutter(string name)
    {
        Debug.Log("send" + name);
            
        UnityMessageManager.Instance.SendMessageToFlutter("_showBottomSheet@"+name);
    }

    //public void NavigateByCurrentScene()
    //{

    //    Scene sceneLoaded = SceneManager.GetActiveScene();
    //    Debug.Log(sceneLoaded.buildIndex + 1);
    //    // loads next level
    //    SceneManager.LoadScene(sceneLoaded.buildIndex + 1);
    //}

    //public void GetSceneId()
    //{

    //    Scene sceneLoaded = SceneManager.GetActiveScene();
    //    Debug.Log(sceneLoaded.buildIndex + 1);
    //    // loads next level
    //}

    //public void ReloadScene()
    //{
    //    Scene scene = SceneManager.GetActiveScene();
    //    SceneManager.LoadScene(scene.name);
    //}

    //public void GoToPreviousScreen()
    //{
    //    Scene currentScene = SceneManager.GetActiveScene();
    //    SceneManager.LoadScene(currentScene.buildIndex - 1);

    //}

    // Update is called once per frame
    void Update()
    {
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);

            if (touch.phase == TouchPhase.Began)
            {
                Vector3 touchPosition = touch.position;

                GameObject clickedObject = GetClickedObject(touchPosition, out RaycastHit hit);
                if (clickedObject != null && targetObjects.Contains(clickedObject))
                {
                    // Do something with the clickedObject
                    MessengerFlutter(clickedObject.name);
                   
                    print("Touched " + clickedObject.name);

                }
            }
        }
    }

    GameObject GetClickedObject(Vector3 touchPosition, out RaycastHit hit)
    {
        GameObject target = null;
        var ray = Camera.main.ScreenPointToRay(touchPosition);
        if (Physics.Raycast(ray.origin, ray.direction * 10, out hit))
        {
            if (!IsPointerOverUIObject(touchPosition)) { target = hit.collider.gameObject; }
        }
        return target;
    }

    private bool IsPointerOverUIObject(Vector3 touchPosition)
    {
        PointerEventData ped = new PointerEventData(EventSystem.current);
        ped.position = new Vector2(touchPosition.x, touchPosition.y);
        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(ped, results);
        return results.Count > 0;
    }
}
