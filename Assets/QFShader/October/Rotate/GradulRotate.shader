Shader "Hidden/GradulRotate"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)

		_Speed("Speed",float) = 1

		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}

			Cull Off
			Lighting Off
			ZWrite Off
			Blend One OneMinusSrcAlpha

			Pass
			{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile _ PIXELSNAP_ON
				#include "UnityCG.cginc"

				struct appdata_t
				{
					float4 vertex   : POSITION;
					float4 color    : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f
				{
					float4 vertex   : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord  : TEXCOORD0;
				};

				fixed4 _Color;

				v2f vert(appdata_t IN)
				{
					v2f OUT;
					OUT.vertex = UnityObjectToClipPos(IN.vertex);
					OUT.texcoord = IN.texcoord;
					OUT.color = IN.color * _Color;
					#ifdef PIXELSNAP_ON
					OUT.vertex = UnityPixelSnap(OUT.vertex);
					#endif

					return OUT;
				}

				sampler2D _MainTex;
				sampler2D _AlphaTex;
				float _AlphaSplitEnabled;
				float _Speed;

				// vortex:中文 旋涡
				float4 vortex(sampler2D tex, float2 uv)
				{
					// 定义旋涡半径
					float radius = 0.7;
					// 中心点
					float2 center = float2(0.5, 0.5);
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

						float2x2 rotationMatrix = float2x2(cosX, -sinX, sinX, cosX);

						// 进行旋转
						xyFromCenter = mul(xyFromCenter, rotationMatrix);
					}

					xyFromCenter += center;

					float4 color = tex2D(tex, xyFromCenter);
					return color;
				}
				fixed4 SampleSpriteTexture(float2 uv)
				{

					// 旋转速度
					float speed = _Speed;

					float sinX = sin(speed * _Time);
					float cosX = cos(speed * _Time);

					float2x2 rotationMatrix = float2x2(cosX, -sinX, sinX, cosX);

					uv.xy = uv - float2(0.5, 0.5);
					uv.xy = mul(uv, rotationMatrix) + float2(0.5, 0.5);


					// 内边缘
					float innerEdge = smoothstep(0, 0.15, length(float2(0.5, 0.5) - uv));

					// 外边缘
					float outerEdge = 1.0 - smoothstep(0.25, 0.5, length(float2(0.5, 0.5) - uv));

					fixed4 color = vortex(_MainTex, uv);

					// 根据内边缘的值，调暗颜色
					color.rgb *= innerEdge;

					// 根据外边缘的值，作用于颜色的透明度
					color.a *= outerEdge * innerEdge;

	#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
					if (_AlphaSplitEnabled)
						color.a = tex2D(_AlphaTex, uv).r;
	#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED

					return color;
				}


				fixed4 frag(v2f IN) : SV_Target
				{
					fixed4 c = SampleSpriteTexture(IN.texcoord) * IN.color;
					c.rgb *= c.a;
					return c;
				}
			ENDCG
			}
		}
}
