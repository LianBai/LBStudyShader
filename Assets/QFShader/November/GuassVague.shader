Shader "Unlit/LBShader4November/GuassVague"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 模糊程度
        _Blur("Blur",Range(0,1)) = 0.2
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
                float offset = _Blur * 0.0625f;

                // 左上
                fixed4 color = tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y - offset)) * 0.0947416f;
                // 上
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y - offset)) * 0.118318f;
                // 右上
                color += tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y - offset)) * 0.0947416f;
                // 左
                color += tex2D(_MainTex,float2(i.uv.x - offset,i.uv.y)) * 0.118318f;
                // 中
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y)) * 0.147761f;
                // 右
                color += tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y)) * 0.118318f;
                // 左下
                color += tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y + offset)) * 0.0947416f;
                // 下
                color += tex2D(_MainTex,float2(i.uv.x,i.uv.y + offset)) * 0.118318f;
                // 右下
                color += tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y + offset)) * 0.0947416f;

                return color;
            }
            ENDCG
        }
    }
}
