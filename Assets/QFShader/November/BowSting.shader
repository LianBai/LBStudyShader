Shader "Unlit/LBShader4November/BowSting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}     
        _Color("Tint", Color) = (0,1,0,1)

		_Width("Width",Range(0,1)) = 0.1
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
            float4 _Color;
			float _Width;
            float IsInLine(float x,float y)
            {
                return smoothstep(x - _Width, x, y) -
                     smoothstep(x, x + _Width, y);
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex,i.uv);
            
                float radius = lerp(0, 3.1415926, i.uv.x);
                float fx = sin(radius);
                float fx2 = (cos(radius) + 1) * 0.5;

                color = lerp(color, _Color, IsInLine(fx, i.uv.y)) * lerp(color, _Color, IsInLine(fx2, i.uv.y));

                return color;
            }
            ENDCG
        }
    }
}
