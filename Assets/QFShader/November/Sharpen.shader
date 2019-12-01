Shader "Unlit/LBShader4November/Sharpen"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 锐化线的宽度
        _LineWidth ("LineWidth",Range(0,0.25)) = 0.01
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
            float _LineWidth;

            fixed4 frag (v2f i) : SV_Target
            {
                float offset = _LineWidth;

                // 左上
                fixed4 color = tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y - offset)) * -1;
                // 上
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y - offset)) * -1;
                // 右上
                color += tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y + offset)) * -1;
                // 左
                color += tex2D(_MainTex,float2(i.uv.x - offset,i.uv.y)) * -1;
                // 中
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y)) * 9;
                // 右
                color += tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y)) * -1;
                // 左下
                color += tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y + offset)) * -1;
                // 下
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y + offset)) * -1;
                // 右下
                color += tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y + offset)) * -1;

                return color;
            }
            ENDCG
        }
    }
}
