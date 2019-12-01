Shader "LianBai/10-Diffuse Specular"
{
	Properties
	{
		_DiffuseColor("MyDiffuseColor",Color) = (1,1,1,1)
		_SpecularColor("MySpecularColor",Color) = (1,1,1,1)
		_Gloss("MyGloss",Range(10,200)) = 20
	}
		SubShader
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
#include "Lighting.cginc"
#pragma vertex vert
#pragma fragment frag
			float4 _DiffuseColor;
			float4 _SpecularColor;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};
			struct v2f
			{
				float4 svPos : SV_POSITION;
				float3 worldnormal : TEXCOORD0;
				float4 worldvertex : TEXCOORD1;
			};
			v2f vert(a2v v)
			{
				v2f f;
				f.svPos = UnityObjectToClipPos(v.vertex);
				f.worldnormal = UnityObjectToWorldNormal(v.normal);
				f.worldvertex = mul(v.vertex, unity_WorldToObject);
				return f;
			}
			fixed4 frag(v2f f) : SV_Target
			{
				fixed3 normalDir = normalize(f.worldnormal);
				fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldvertex));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldvertex));
				fixed3 halfDir = normalize(viewDir + lightDir);

				fixed3 diffuse = _LightColor0.rgb * _DiffuseColor.rgb * max(0,dot(normalDir,lightDir));
				fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(normalDir, halfDir)),_Gloss);

				fixed3 tempcolor = diffuse + specular + UNITY_LIGHTMODEL_AMBIENT.rgb;
				return fixed4(tempcolor,1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
