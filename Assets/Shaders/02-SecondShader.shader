// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LianBai/02-SencondShader"
{
    SubShader
    {
		
		Pass
		{
			CGPROGRAM
			//顶点函数 函数名vert 这里只是声明了顶点函数的函数名
			//基本作用是 完成顶点坐标从模型空间到剪裁空间的转换（从游戏环境转换到视野相机屏幕上）
#pragma vertex vert
			//片元函数 
			//基本作用是 返回模型对应的屏幕上的每一个像素的颜色值
#pragma fragment frag
		//返回值和参数都可以不固定 
		//通过语义告诉系统: POSITION标明要把顶点值传进v、SV_POSITION标明函数返回值是剪裁空间下的顶点坐标
			float4 vert(float4 v : POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(v);	//把模型空间坐标转换到剪裁空间坐标,UNITY_MATRIX_MVP(4x4矩阵)
			}
			float4 frag(): SV_Target
			{
				return fixed4(0.5,0.5,1,1);
			}

			ENDCG

		}
        
    }
    FallBack "Diffuse"
}
