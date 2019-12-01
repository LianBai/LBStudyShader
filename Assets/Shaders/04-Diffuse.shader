﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "LianBai/04-Diffuse"
{
	properties
	{
		_DiffuseColor("MyDiffuseColor",Color) = (1,1,1,1)
	}
	SubShader
	{

		Pass
		{
			

			Tags{"LightMode" = "ForwardBase"}	//只有定义了正确的LightMode才能得到一些Unity的内置光照变量
			CGPROGRAM
#include "Lighting.cginc"		//引入定义好的命名空间内的变量
			//顶点函数 函数名vert 这里只是声明了顶点函数的函数名
			//基本作用是 完成顶点坐标从模型空间到剪裁空间的转换（从游戏环境转换到视野相机屏幕上）
#pragma vertex vert
			//片元函数 
			//基本作用是 返回模型对应的屏幕上的每一个像素的颜色值
#pragma fragment frag
		//返回值和参数都可以不固定 
		//通过语义告诉系统: POSITION标明要把顶点值传进v、SV_POSITION标明函数返回值是剪裁空间下的顶点坐标

			fixed4 _DiffuseColor;
			//application to wertex
			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 position : SV_POSITION;
				fixed3 color : COLOR0;
			};
			v2f vert(a2v v)
			{
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);	//把模型空间坐标转换到剪裁空间坐标,UNITY_MATRIX_MVP(4x4矩阵)

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;	//得到系统的环境光

				//在Lighting.cginc命名空间下 _LightColor0取得第一个直射光的颜色 _WorldSpaceLightPos0第一个直射光的位置
				//dot用于计算点乘  normalize用来把一个向量单位化 _World2Object这个矩阵用来把一个方向从世界空间转换到模型空间
				float3 normalDir = normalize(mul(v.normal, (float3x3)unity_WorldToObject));	//变量位置交换，就是从模型空间转换到世界空间 float3x3强制把矩阵变成3*3的矩阵
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz); //对于每一个点来说光的位置就是光的方向，因为光是平行光
				fixed3 diffuse = _LightColor0.rgb * max(0, dot(normalDir, lightDir)) * _DiffuseColor.rgb; //取得漫反射的颜色
				f.color = diffuse + ambient;
				return f;
			}
			float4 frag(v2f f) : SV_Target
			{
				return fixed4(f.color,1);
			}

			ENDCG

		}

	}
		FallBack "Diffuse"
}
