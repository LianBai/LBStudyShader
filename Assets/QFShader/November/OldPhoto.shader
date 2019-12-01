Shader "Unlit/LBShader4November/OldPhoto"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 老照片老的程度 
        _OldFactor ("OldFactor",Range(0,1)) = 1
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
            float _OldFactor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex,i.uv);                                        

                float r = 0.393 * color.r + 0.769 * color.g + 0.189 * color.b;
                float g = 0.349 * color.r + 0.686 * color.g + 0.168 * color.b;
                float b = 0.272 * color.r + 0.535 * color.g + 0.131 * color.b;

                fixed4 oldPhotoColor = fixed4(r,g,b,1);

                color = lerp(color, oldPhotoColor,_OldFactor);

                return color;
            }
            ENDCG
        }
    }
}
