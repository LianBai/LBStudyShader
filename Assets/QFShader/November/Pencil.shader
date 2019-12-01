Shader "Unlit/LBShader4November/Pencil"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 铅笔效果
        _PencilFactor("PencilFactor",Range(0,0.25)) = 0.001
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
            
            float _PencilFactor;
            fixed g(fixed4 color)
            {
                return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                // 水平卷积核、竖直卷积核
                float offset = _PencilFactor;

                // 左上
                fixed4 edgeX = g(tex2D (_MainTex, float2(uv.x - offset,uv.y - offset))) * -1;
                // 上
                edgeX += g(tex2D(_MainTex,float2(uv.x,uv.y - offset))) * 0;
                // 右上
                edgeX += g(tex2D(_MainTex,float2(uv.x + offset,uv.y - offset))) * -1;
                // 左
                edgeX += g(tex2D(_MainTex,float2(uv.x - offset,uv.y))) * -2;
                // 中
                edgeX += g(tex2D(_MainTex,float2(uv.x,uv.y))) * 0;
                // 右
                edgeX += g(tex2D(_MainTex,float2(uv.x + offset,uv.y))) * 2;
                // 左下
                edgeX += g(tex2D (_MainTex, float2(uv.x - offset,uv.y + offset))) * 1;
                // 下
                edgeX += g(tex2D(_MainTex,float2(uv.x,uv.y + offset))) * 0;
                // 右下
                edgeX += g(tex2D(_MainTex,float2(uv.x + offset,uv.y - offset))) * 1;

                // 左上
                half edgeY = g(tex2D (_MainTex, float2(uv.x - offset,uv.y - offset))) * -1;
                // 上
                edgeY += g(tex2D(_MainTex,float2(uv.x,uv.y - offset))) * -2;
                // 右上
                edgeY += g(tex2D(_MainTex,float2(uv.x + offset,uv.y - offset))) * -1;
                // 左
                edgeY += g(tex2D(_MainTex,float2(uv.x - offset,uv.y))) * 0;
                // 中
                edgeY += g(tex2D(_MainTex,float2(uv.x,uv.y))) * 0;
                // 右
                edgeY += g(tex2D(_MainTex,float2(uv.x + offset,uv.y))) * 0;
                // 左下
                edgeY += g(tex2D(_MainTex, float2(uv.x - offset,uv.y + offset))) * 1;
                // 下
                edgeY += g(tex2D(_MainTex,float2(uv.x,uv.y + offset))) * 2;
                // 右下
                edgeY += g(tex2D(_MainTex,float2(uv.x + offset,uv.y - offset))) * 1;

                half edge = 1- abs(edgeX) - abs(edgeY);

                fixed4 texColor = tex2D(_MainTex,uv);
                // 乘以一个 alpha 是为了裁减掉透明度为零的部分
                return fixed4(edge,edge,edge,1) * texColor.a;
            }
            ENDCG
        }
    }
}
