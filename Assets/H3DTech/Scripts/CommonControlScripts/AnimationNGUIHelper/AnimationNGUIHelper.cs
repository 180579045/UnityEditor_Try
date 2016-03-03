using UnityEngine;
using System.Collections;

public class AnimationNGUIHelper : MonoBehaviour {
    Animation animation;
    Animator animator;
    UIPanel panel;
	void Start () {
        animation = GetComponent<Animation>();
        animator = GetComponent<Animator>();
        panel = GetComponent<UIPanel>();
        if(panel == null) panel = UIPanel.Find(transform); 
        if(panel == null) {
            Debug.LogError("AnimationNGUIHelper:No Found UIPanel in " + transform.name);
        }
	}

    bool isDirty = false;
    void Update() {    
        if(panel != null) {
            //如果正在播放动画,则刷新Draw Call
            isDirty = false;
            if(animation != null && animation.isPlaying) {
                isDirty = true;
            } else if(animator != null) {
                var state = animator.GetCurrentAnimatorStateInfo(0);
                if(state.normalizedTime >= 0 && state.normalizedTime <= 1.1f) {
                    isDirty = true;
                }
            }
            if(isDirty) {
                panel.SetDirty();
            }
        }
	}
}
