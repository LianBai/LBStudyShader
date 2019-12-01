Shader "Unlit/LBShader4November/Gradual"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // 四个点的颜色设置
        _LeftTopColor("LeftTopColor",Color) = (1,0,0,1)
        _LeftBottomColor("LeftBottomColor",Color) = (0,1,0,1)
        _RightTopColor("RightTopColor",Color) = (0,0,1,1)
        _RightBottomColor("RightBottomColor",Color) = (0.5,0.5,1,1)
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
            float4 _LeftTopColor;
            float4 _LeftBottomColor;
            float4 _RightTopColor;
            float4 _RightBottomColor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                fixed4 topLeft2RightColor = lerp(_LeftTopColor,_RightTopColor,i.uv.x);
                fixed4 bottomLeft2RightColor = lerp(_LeftBottomColor,_RightBottomColor,i.uv.x);
                fixed4 bottom2TopColor = lerp(bottomLeft2RightColor,topLeft2RightColor,i.uv.y);

                color = bottom2TopColor * color;

                return color;
            }
            ENDCG
        }
    }
}
