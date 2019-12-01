Shader "LianBai/12-Rock"
{
	Properties
	{
		//_DiffuseColor("MyDiffuseColor",Color) = (1,1,1,1)
		_TexColor("MyTexColor",Color) = (1,1,1,1)
		_MainTex("MyMainTex",2D) = "white"{}
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
			//float4 _DiffuseColor;
			fixed4 _TexColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;		//固定的，必须是：纹理的名字_ST

			struct a2v
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float4 texcoord :TEXCOORD0;		//得到纹理坐标
			};
			struct v2f
			{
				float4 svPos : SV_POSITION;
				float3 worldnormal : TEXCOORD0;
				float4 worldvertex : TEXCOORD1;
				float2 uv:TEXCOORD2;
			};
			v2f vert(a2v v)
			{
				v2f f;
				f.svPos = UnityObjectToClipPos(v.vertex);
				f.worldnormal = UnityObjectToWorldNormal(v.normal);
				f.worldvertex = mul(v.vertex, unity_WorldToObject);
				f.uv = v.texcoord.xy *_MainTex_ST.xy + _MainTex_ST.zw;	//xy是缩放，zw是偏移
				return f;
			}
			fixed4 frag(v2f f) : SV_Target
			{
				fixed3 normalDir = normalize(f.worldnormal);
				fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldvertex));


				fixed3 texColor = tex2D(_MainTex, f.uv.xy) * _TexColor;	//的到纹理上的颜色tex()

				fixed3 diffuse = _LightColor0.rgb * texColor * max(0,dot(normalDir,lightDir));

				fixed3 tempcolor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;
				return fixed4(tempcolor,1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
