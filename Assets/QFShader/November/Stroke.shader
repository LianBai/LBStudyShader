Shader "Unlit/LBShader4November/Stroke"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        _Color("Tint", Color) = (1,0,0,1)
		_ShearX("ShaerX",Range(0,1)) = 0.5
		_ShearY("ShaerY", Range(0,1)) = 0.5
		_ShearTail("ShaerTail",Range(0,1)) = 0
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
            
            float _Color;
			float _ShearX;
			float _ShearY;
			float _ShearTail;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv) * smoothstep(_ShearTail, _ShearX, i.uv.x) * smoothstep(_ShearTail, _ShearY, i.uv.y);
                
                return color;
            }
            ENDCG
        }
    }
}
