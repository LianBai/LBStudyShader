Shader "Unlit/LBShader4November/BlackHole"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        _Speed("Speed",float) = 5
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
                float sinX = sin(_Speed * _Time);
                float cosX = cos(_Speed * _Time);

                float2x2 rotationMatrix = float2x2(cosX,-sinX,sinX,cosX);

                float2 uv = i.uv;

                uv.xy = uv - float2(0.5,0.5);
                uv.xy = mul(uv,rotationMatrix) + float2(0.5,0.5);


                // 内边缘
                float innerEdge = smoothstep(0, 0.15,length(float2(0.5,0.5) - uv));

                // 外边缘
                float outerEdge = 1.0 - smoothstep(0.25,0.5,length(float2(0.5,0.5) - uv));

                fixed4 color = vortex(_MainTex,uv);

                // 根据内边缘的值，调暗颜色
                color.rgb *= innerEdge;

                // 根据外边缘的值，作用于颜色的透明度
                color.a *= outerEdge * innerEdge;

                return color;
            }
            ENDCG
        }
    }
}
