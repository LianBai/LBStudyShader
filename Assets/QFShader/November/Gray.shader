Shader "Unlit/LBShader4November/Gray"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // 声明属性，值的范围 0 到 1，默认值为 1
        _GrayFactor("GrayFactor",Range(0,1)) = 1
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
            float _GrayFactor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                float grayValue = color.r * 0.299 + color.g * 0.587 + color.b * 0.114;

                float4 grayColor = float4(grayValue,grayValue,grayValue,1.0);

                color = lerp(color,grayColor, _GrayFactor);

                return color;
            }
            ENDCG
        }
    }
}
