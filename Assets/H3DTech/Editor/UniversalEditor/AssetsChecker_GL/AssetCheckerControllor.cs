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
        /*将编辑器分为上下两个区域*/
        HSpliterCtrl Upanddown = new HSpliterCtrl();
        root.RootCtrl = Upanddown;
        Upanddown.layoutConstraint = LayoutConstraint.GetSpliterConstraint(30f);

        #region 编辑器事件回调
        /*编辑器初始化事件*/
        root.onEnable += EditorWindowOnEnable;
        /*编辑器关闭事件*/
        root.onDestroy += EditorWindowOnDestroy;
        #endregion

        #region 编辑器的上边
        /*存放上方资源的容器*/
        HBoxCtrl upspliter = new HBoxCtrl();
        Upanddown.Add(upspliter);

        /*扫描资源按钮*/
        Rect SearchBtnRect = new Rect(0, 0, 160, 20);
        ButtonCtrl SearchBtn = new ButtonCtrl();
        SearchBtn.onClick = SearchBtnClickEvent;
        SearchBtn.Size = SearchBtnRect;
        SearchBtn.Visiable = true;
        SearchBtn.Caption = "扫描资源";
        SearchBtn.Name = "_SearchButton";

        /*下拉菜单，过滤器*/
        Rect ComboxFliterRect = new Rect(0, 0, 120, 20);
        ComboBoxCtrl<int> TypeFliter = new ComboBoxCtrl<int>(0);
        TypeFliter.Size = ComboxFliterRect;
        TypeFliter.Name = "_TypeFliter";
        TypeFliter.onValueChange += FilterOnchange;
        
        for(int i = 0; i <= 3; i++)
        {
            TypeFliter.AddItem(new ComboItem("选项1", 0));
            TypeFliter.AddItem(new ComboItem("选项2", 1));
            TypeFliter.AddItem(new ComboItem("选项3", 2));
            TypeFliter.AddItem(new ComboItem("选项4", 3));
        }

        TypeFliter.CurrValue = 0;

        /*数据库状态显示*/
        LabelCtrl StateLabel = new LabelCtrl();
        StateLabel.Caption = "数据库没有更新，请点击刷新资源数据库";
        StateLabel.Name = "_StateLabel";

        /*将控件放入上方资源*/
        upspliter.Add(SearchBtn);
        upspliter.Add(TypeFliter);
        upspliter.Add(StateLabel);
        #endregion

        #region 编辑器的下边
        /*将下放资源分为左右两个区域*/
        VSpliterCtrl downspliter = new VSpliterCtrl();
        Upanddown.Add(downspliter);
        downspliter.layoutConstraint = LayoutConstraint.GetSpliterConstraint(300f);
        downspliter.Dragable = true;

        /*存放左侧资源列表和无引用资源的容器*/
        VBoxCtrl LeftAssetContainer = new VBoxCtrl();
        downspliter.Add(LeftAssetContainer);

        /*左侧两枚选项卡*/
        TabViewCtrl leftTabView = new TabViewCtrl();
        LeftAssetContainer.Add(leftTabView);

        /*资源列表*/
        TreeViewCtrl AssetsTreeView = new TreeViewCtrl();
        AssetsTreeView.Caption = "资源列表";
        AssetsTreeView.Name = "_AssetList";
        leftTabView.Add(AssetsTreeView);

        /*无用资源列表*/
        ListViewCtrl UseLessAssetsList = new ListViewCtrl();
        UseLessAssetsList.Caption = "无用资源";
        UseLessAssetsList.Name = "_UseLessAssetsList";
        leftTabView.Add(UseLessAssetsList);

        /*存放正向反向资源依赖关系的容器*/
        VBoxCtrl RightAssetDependceContainer = new VBoxCtrl();
        downspliter.Add(RightAssetDependceContainer);

        /*右侧两枚选项卡*/
        TabViewCtrl rightTabView = new TabViewCtrl();
        RightAssetDependceContainer.Add(rightTabView);

        /*资源正向依赖关系列表*/
        ListViewCtrl DependcyAssetsList = new ListViewCtrl();
        DependcyAssetsList.Caption = "正向依赖关系";
        DependcyAssetsList.Name = "_DependAssetsList";
        rightTabView.Add(DependcyAssetsList);

        /*资源反向依赖关系列表*/
        ListViewCtrl DedependcyAssetsList = new ListViewCtrl();
        DedependcyAssetsList.Caption = "反向依赖关系";
        DedependcyAssetsList.Name = "_DedependcyAssetsList";
        rightTabView.Add(DedependcyAssetsList);
        #endregion
    }

    //点击扫描资源按钮事件
    static void SearchBtnClickEvent(EditorControl ec)
    {

    }

    static void EditorWindowOnEnable(EditorRoot er)
    {
        Debug.Log("EditorWindow Enable!");
    }

    static void EditorWindowOnDestroy(EditorRoot er)
    {
        Debug.Log("EditorWindow OnDestroy!");
    }
    static void FilterOnchange(EditorControl Ec, object o)
    {
        //Debug.Log("Filteronchange!" + o);
    }

}
