using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LB.LBShader
{
    //非运行时也触发效果
    [ExecuteInEditMode]
    //屏幕后处理特效一般都需要绑定在摄像机上
    [RequireComponent(typeof(Camera))] 
    public class PostFx : MonoBehaviour
    {
        //Inspector面板上直接拖入
        public  Shader   Shader    = null;

        [SerializeField]
        private Material mMaterial = null;
        
        public Material Material
        {
            get
            {
                if (mMaterial == null)
                    mMaterial = GenerateMaterial(Shader);
                return mMaterial;
            }
        }
        //根据shader创建用于屏幕特效的材质
        protected Material GenerateMaterial(Shader shader)
        {
            if (shader == null)
                return null;

            //需要判断shader是否支持
            if (shader.isSupported == false)
                return null;

            Material material = new Material(shader) {hideFlags = HideFlags.DontSave};

            return material ? material : null;
        }
        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            //仅仅当有材质的时候才进行后处理，如果_Material为空，不进行后处理
            if (Material)
            {
                //使用Material处理Texture，dest不一定是屏幕，后处理效果可以叠加的
                Graphics.Blit(src, dest, Material);
            }
            else
            {
                //直接绘制
                Graphics.Blit(src, dest);
            }
        }
    }
}

