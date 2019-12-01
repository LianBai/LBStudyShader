Shader "Unlit/LBShader4November/ColorFill"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 要填充的颜色
        _FillColor("_FillColor",Color) = (1,0,0,1)
        // 填充的程度
        _FillFactor("_FillFactor",Range(0,1)) = 0.5
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

            sampler2D _MainTex;
            
            fixed4 _FillColor;
            float _FillFactor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex,i.uv);
                fixed4 fillColor = texColor.a * _FillColor;

                return lerp(texColor,fillColor,_FillFactor);
            }
            ENDCG
        }
    }
}
