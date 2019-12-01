Shader "LianBai/14-Rock Alpha"
{
	Properties
	{
		//_DiffuseColor("MyDiffuseColor",Color) = (1,1,1,1)
		_TexColor("MyTexColor",Color) = (1,1,1,1)
		_MainTex("MyMainTex",2D) = "white"{}
		_NorMap("MyNormap",2D) = "bump"{}
		_BumpScle("MyBumpScle",Float) = 1
		_AlphaScle("MyAlphaScle",Float) = 1
	}
		SubShader
		{
			//IngnoreProjector是否忽略投影
		Tags{"Queue" = "Transparent" "IngnoreProjector" = "True" "RenderType" = "Transparent"}
		Pass
		{
			ZWrite Off	//深度写入关闭
			Blend SrcAlpha OneMinusSrcAlpha

			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
#include "Lighting.cginc"
#pragma vertex vert
#pragma fragment frag
			//float4 _DiffuseColor;
			fixed4 _TexColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;		//固定的，必须是：纹理的名字_ST
			sampler2D _NorMap;
			float4 _NorMap_ST;
			float _BumpScle;
			float _AlphaScle;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;			//切线空间的确定是通过(存储到模型里面的)法线和(存储到模型里面的)切线确定的
				float4 tangent : TANGENT;		//tangent.w是用来确定切线空间中坐标轴方向的
				float4 texcoord :TEXCOORD0;		//得到纹理坐标
			};
			struct v2f
			{
				float4 svPos : SV_POSITION;
				//float3 worldnormal : TEXCOORD0;
				float3 lightDir : TEXCOORD0;	//切线空间下平行光的方向
				float4 worldvertex : TEXCOORD1;
				float4 uv : TEXCOORD2;			//xy用来存储maintex zw用来存储法线贴图的纹理
			};
			v2f vert(a2v v)
			{
				v2f f;
				f.svPos = UnityObjectToClipPos(v.vertex);
				//f.worldnormal = UnityObjectToWorldNormal(v.normal);
				f.worldvertex = mul(v.vertex, unity_WorldToObject);
				f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;	//xy是缩放，zw是偏移
				f.uv.zw = v.texcoord.xy * _NorMap_ST.xy + _NorMap_ST.zw;

				TANGENT_SPACE_ROTATION;	//调用这个宏之后会得到一个矩阵 rotation 用来把模型空间下的方向转换成切线空间下
				/*float3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
				float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);*/

				//ObjSpaceLightDir(v.vertex);	//得到模型空间下的平行光的方向
				f.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));
				return f;
			}
			//把所有跟法线方向有关的运算都放在切线空间下
			//因为从法线贴图里面取得的法线方向是在切线空间下的
			fixed4 frag(v2f f) : SV_Target
			{
				//fixed3 normalDir = normalize(f.worldnormal);
				fixed4 normalcolor = tex2D(_NorMap,f.uv.zw);
				//fixed3 tangentNormal = normalize(normalcolor.xyz * 2 - 1);
				fixed3 tangentNormal = UnpackNormal(normalcolor);
				tangentNormal = normalize(tangentNormal);
				tangentNormal.xy = tangentNormal.xy * _BumpScle;

				fixed3 lightDir = normalize(f.lightDir);

				fixed4 texColor = tex2D(_MainTex, f.uv.xy) * _TexColor;	//的到纹理上的颜色tex()

				fixed3 diffuse = _LightColor0.rgb * texColor.rgb * max(0,dot(tangentNormal,lightDir));

				fixed3 tempcolor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;
				//return fixed4(tempcolor, texColor.a);
				//return fixed4(tempcolor, _AlphaScle);
				return fixed4(tempcolor, _AlphaScle * texColor.a);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
