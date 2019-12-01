Shader "LianBai/03-UseStruct"
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

			//application to wertex
			struct a2v
			{
				float4 vertex : POSITION;
				//获取法线
				float3 normal : NORMAL;
				//纹理坐标	0代表第一套纹理坐标，纹理坐标一般0~1
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 position : SV_POSITION;
				float3 temp:COLOR0;
			};
			v2f vert(a2v v)
			{
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);	//把模型空间坐标转换到剪裁空间坐标,UNITY_MATRIX_MVP(4x4矩阵)
				f.temp = v.normal;
				return f;
			}
			float4 frag(v2f f) : SV_Target
			{
				return fixed4(f.temp,1);
			}

			ENDCG

		}

	}
		FallBack "Diffuse"
}
