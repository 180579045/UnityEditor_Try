using UnityEngine;
using System.Collections;
using UnityEditor;
using YamlDotNet.RepresentationModel;
using System.IO;
using System;
using System.Globalization;
using System.Collections.Generic;

public class AssetChcekerControllor{

    static EditorRoot s_root = null;

    [MenuItem("GL/资源检查工具2")]
    static void Init()
    {
        //一个单例模式，UI框架只允许同时实例化一个同名UI;
        EditorRoot root = EditorManager.GetInstance().FindEditor("资源检查工具2");
        if (root == null)
        {
            root = EditorManager.GetInstance().CreateEditor("资源检查工具2", false, InitControls);
        }
    }

    public static void InitControls(EditorRoot root)
    {
        
    }
}
