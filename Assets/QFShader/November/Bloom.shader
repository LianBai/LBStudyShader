Shader "Unlit/LBShader4November/Bloom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 发光程度
        _Glow ("Glow", Range(0.0, 20.0)) = 2.5

        // 屏幕分辨率
        _ScreenResolution("ScreenResolution",Vector) = (512,512,0,0)
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
            float _Glow;           

            half4 _MainTex_ST;
            float4 _ScreenResolution;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvst = UnityStereoScreenSpaceUVAdjust(i.uv, _MainTex_ST);    //为了支持VR设备

                float4 color = tex2D(_MainTex,uvst.xy);

                // 卷积核
                float3x3 kernel = float3x3(
                    1.0,    2.0,    1.0,
                    2.0,    4.0,    2.0,
                    1.0,    2.0,    1.0);

                float4 result = 0;

                float stepU = (1.0 / _ScreenResolution.x);
                float stepV = (1.0 / _ScreenResolution.y);

                // 卷积操作
                for(int u = 0;u < 3;u++) 
                {
                    for(int j = 0;j < 3;j++) 
                    {
                        float2 texCoord = uvst.xy + float2( float(u-1) * stepU, float(j-1) * stepV );
                        result += kernel[u][j] * tex2D(_MainTex,texCoord);
                    }
                }

                // result 是 16(1x4+2x4+4) 倍的像素值
                // 除以 8 会比原来的颜色“亮”
                result /= 8;

                // 插值计算
                result.rgb = lerp (color.rgb,result.rgb, _Glow);

                return result;
            }
            ENDCG
        }
    }
}
