Shader "Unlit/LBShader4November/Fire"
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
            
            float random (float2 uv) 
            {
                return frac(sin(dot(uv,float2(12.9898,78.233))) * 43758.5453123);
            }

            float noise (float2 uv) 
            { 
                // 获取 uv 的整数部分       
                float2 i = floor(uv);

                // 获取 uv 的小数部分 
                float2 f = frac(uv);

                // 获取 uv 的相邻坐标 
                float a = random(i); 
                float b = random(i + float2(1.0, 0.0)); 
                float c = random(i + float2(0.0, 1.0)); 
                float d = random(i + float2(1.0, 1.0)); 

                // 对 uv 的小数部分进行 smoothstep
                // 因为是小数部分，所以肯定是小于 1 
                // 所以去掉了对 smoothstep 的 step 操作
                // 只保留了 smooth 的过程 
                float2 u = f * f * (3 - 2 * f);

                // 没搞清楚的一堆操作
                return lerp(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y; 
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float baseSpeed = -_Time.y * 0.1;
                float2 noiseUV1 = (0.2 * uv + baseSpeed * float2(0.0,0.5)) * 80.0;
                float2 noiseUV2 = (0.2 * uv + baseSpeed * float2(0.0,1.0)) * 80.0;

                float noiseColor1 = noise(noiseUV1);
                float noiseColor2 = noise(noiseUV2);

                float noiseColor = noiseColor1 + noiseColor2;

                // 使深色更深
                float fireNoise = pow(noiseColor,5);

                // 拿到 uv 的 y 值
                float y = uv.y;

                // 将 y 的范围控制在 整体图像的下半部分
                fireNoise = (2 + fireNoise * 80 * y) * y;
                fireNoise = 1 - fireNoise;

                float4 texColor = tex2D(_MainTex,uv);

                fireNoise = pow(fireNoise,3);

                float4 fireColor = lerp(float4(1,0,0,1),float4(1,1,0,1),fireNoise);

                float isFireColor = step(0.001,fireNoise);

                float4 resultColor = lerp(texColor,fireColor,isFireColor);



                return resultColor;
            }
            ENDCG
        }
    }
}
