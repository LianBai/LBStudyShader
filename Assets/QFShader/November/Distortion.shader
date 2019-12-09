Shader "Unlit/LBShader4November/Distortion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        _Speed("Speed",float) = 100
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
            float _Speed;

            // vortex:中文 旋涡
            float4 vortex(sampler2D tex, float2 uv)
            {
                // 定义旋涡半径
                float radius = 0.5;
                // 中心点
                float2 center = float2(0.5,0.5);
                // 当前 uv 相对中心的坐标
                float2 xyFromCenter = uv - center;
                // 取半径
                float curRadius = length(xyFromCenter);

                if (curRadius < radius)
                {
                    // 获取到当前半径在旋涡半径内的占比
                    float percent = (radius - curRadius) / radius;

                    // 计算出来一个弧度（大概值，半径越小值越大）
                    float theta = percent * percent * 16;

                    float sinX = sin(theta);
                    float cosX = cos(theta);

                    float2x2 rotationMatrix = float2x2(cosX,-sinX,sinX,cosX);

                    // 进行旋转
                    xyFromCenter =  mul(xyFromCenter,rotationMatrix);
                }

                xyFromCenter += center;

                float4 color = tex2D(tex, xyFromCenter);
                return color;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                // 速度
                float speed = _Time * _Speed;

                uv.x = uv.x + sin(uv.y * 10  + speed) * 0.3 * 0.05;
                uv.y = uv.y + cos(uv.x * 10  + speed) * 0.3 * 0.05;

                float4 color = tex2D(_MainTex,uv);
                
                return color;
            }
            ENDCG
        }
    }
}
