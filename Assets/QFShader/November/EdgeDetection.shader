Shader "Unlit/LBShader4November/EdgeDetection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 边缘检测的精细度
        _EdgeFactor("EdgeFactor",Range(0,0.25)) = 0.003

        // 边缘颜色
        _EdgeColor("EdgeColor",Color) = (0,0,0,1)

        // 背景颜色
        _BgColor("BgColor",Color) = (1,1,1,1)

        // 显示背景还是贴图
        _BgFactor("BgFactor",Range(0,1)) = 0.5
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
            
            float _EdgeFactor;
            float4 _BgColor;
            float4 _EdgeColor;
            float _BgFactor;
            
            // 亮度
            fixed l(fixed4 color)
            {
                return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 水平卷积核、竖直卷积核
                float offset = _EdgeFactor;

                // 左上
                half edgeX = l(tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y - offset))) * -1;
                // 上
                edgeX += l(tex2D(_MainTex,float2(i.uv.x,i.uv.y - offset))) * 0;
                // 右上
                edgeX += l(tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y - offset))) * -1;
                // 左
                edgeX += l(tex2D(_MainTex,float2(i.uv.x - offset,i.uv.y))) * -2;
                // 中
                edgeX += l(tex2D(_MainTex,float2(i.uv.x,i.uv.y))) * 0;
                // 右
                edgeX += l(tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y))) * 2;
                // 左下
                edgeX += l(tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y + offset))) * 1;
                // 下
                edgeX += l(tex2D(_MainTex,float2(i.uv.x,i.uv.y + offset))) * 0;
                // 右下
                edgeX += l(tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y + offset))) * 1;


                // 左上
                half edgeY = l(tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y - offset))) * -1;
                // 上
                edgeY += l(tex2D(_MainTex,float2(i.uv.x,i.uv.y - offset))) * -2;
                // 右上
                edgeY += l(tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y - offset))) * -1;
                // 左
                edgeY += l(tex2D(_MainTex,float2(i.uv.x - offset,i.uv.y))) * 0;
                // 中
                edgeY += l(tex2D(_MainTex,float2(i.uv.x,i.uv.y))) * 0;
                // 右
                edgeY += l(tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y))) * 0;
                // 左下
                edgeY += l(tex2D (_MainTex, float2(i.uv.x - offset,i.uv.y + offset))) * 1;
                // 下
                edgeY += l(tex2D(_MainTex,float2(i.uv.x,i.uv.y + offset))) * 2;
                // 右下
                edgeY += l(tex2D(_MainTex,float2(i.uv.x + offset,i.uv.y + offset))) * 1;

                half edge = abs(edgeX) + abs(edgeY);

                float4 texColor = tex2D(_MainTex,i.uv);

                float4 bgColor = lerp(texColor,_BgColor,_BgFactor);

                return lerp(bgColor,_EdgeColor,edge);
            }
            ENDCG
        }
    }
}
