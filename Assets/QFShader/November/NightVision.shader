﻿Shader "Unlit/LBShader4November/NightVision"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            
            half4 _MainTex_ST;

            // 减少颜色之间的梯度
            float4 gradient(float i)
            {
                // clamp(value,min,max): 获取三个值中，中间大小的值
                // 比如 clamp(2,1,3) 得到 2
                // 比如 clamp(5,1,2) 得到 2
                // 比如 clamp(1,2,3) 得到 2
                // 此时的 i 是 2倍的颜色
                i = clamp(i, 0.0, 1.0) * 2.0;
            
                if (i < 1.0) 
                {
                    // 淡绿 和 亮绿 之间插值
                    return lerp(float4(0.0, 0.1, 0.0, 1.0),float4(0.2, 0.5, 0.1, 1.0),i);
                } 
                else {
                    i -= 1.0;
                    // 亮绿 和 深绿 之间插值
                    return lerp(float4(0.2, 0.5, 0.1, 1.0),float4(0.9, 1.0, 0.6, 1.0),i);
                }
            }
            
            float random (float2 uv) 
            {
                return frac(sin(dot(uv,float2(12.9898,78.233))) * 43758.5453123);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvst = UnityStereoScreenSpaceUVAdjust(i.uv, _MainTex_ST);

                float4 color = tex2D(_MainTex,uvst);
            
                // 与计算灰度值的算法一样
                float greenValue = color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
            
                // 增加
                float4 greenColor = gradient(greenValue);
                
                // 简单的噪声
                float simpleNoise = lerp(1,random(uvst),0.3f);
            
                return greenColor * simpleNoise;
            }
            ENDCG
        }
    }
}
