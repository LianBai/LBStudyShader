Shader "Unlit/LBShader4November/Pixel"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 像素个数
        _Pixels ("Pixels",Range(4,256)) = 64
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
            float _Pixels;

            fixed4 frag (v2f i) : SV_Target
            {
                float offset = _Pixels;

                // 去掉小数点取整
                float2 pixelUV = round(i.uv * offset) / offset;

                return tex2D(_MainTex, pixelUV);
            }
            ENDCG
        }
    }
}
