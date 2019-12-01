Shader "Unlit/LBShader4November/Vague"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 模糊程度
        _Blur("Blur",Range(0,1)) = 0.3
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
            float _Blur;

            fixed4 frag (v2f i) : SV_Target
            {
                // 1 / 16
                float distance = _Blur * 0.0625f;


                fixed4 color = tex2D (_MainTex, i.uv) * 0.5f;

                color += tex2D(_MainTex,float2(i.uv.x - distance,i.uv.y)) * 0.125f;
                color += tex2D(_MainTex,float2(i.uv.x + distance,i.uv.y)) * 0.125f;
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y + distance)) * 0.125f;
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y - distance)) * 0.125f;

                return color;
            }
            ENDCG
        }
    }
}
