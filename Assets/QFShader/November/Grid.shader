﻿Shader "Unlit/LBShader4November/Grid"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Low("Low",Int) = 4
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Low;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv * _Low;
                uv = frac(uv);
                fixed4 color = tex2D(_MainTex,uv);
                return color;
            }
            ENDCG
        }
    }
}
