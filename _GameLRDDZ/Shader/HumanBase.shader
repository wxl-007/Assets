// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/HumanBase"
{
	Properties
	{
		_Color ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "Queue" = "Geometry+10" "IGNOREPROJECTOR"="true" "RenderType"="Opaque" }
		Lighting Off
		Cull off
		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

		    struct vertexInput {  
                float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
            };  
            struct vertexOutput {  
                float4 pos : SV_POSITION;
				float2 uv_MainTex : TEXCOORD0;
            };  
            
			sampler2D _MainTex;
			float4 _Color;
            vertexOutput vert(vertexInput input) {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
				output.uv_MainTex = input.texcoord;
                return output;
            }

			float4 frag(vertexOutput IN) : COLOR
			{
				/// 贴图颜色
				float4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				return color;
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}


/*
Shader "Custom/HumanBase"
{
	Properties
	{
		_Color ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Texture", 2D) = "white" {}
		_EdgeColor ("Edge Color", Color) = (0.5,0.5,0.5,0.5)
		_Pow ("Pow Factor", Float) = 1.0
	}

	SubShader
	{
		Tags { "Queue" = "Geometry+10" "IGNOREPROJECTOR"="true" "RenderType"="Opaque" }
		Lighting Off

		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

		    struct vertexInput {  
                float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
            };  
            struct vertexOutput {  
                float4 pos : SV_POSITION;
				float2 uv_MainTex : TEXCOORD0;
				float4 lightParameter : TEXCOORD1;
            };  
            
			sampler2D _MainTex;
			float4 _Color;
			float4 _EdgeColor;
			float _Pow;
            vertexOutput vert(vertexInput input) {
                vertexOutput output;
                output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
				output.uv_MainTex = input.texcoord;
                float3 worldNormal =  normalize(mul((float3x3)_Object2World, input.normal));
				float3 viewDir = normalize(WorldSpaceViewDir(input.vertex));
				half intensity = 1.0 - saturate(dot(viewDir, worldNormal));
				intensity = pow(intensity, _Pow);
				output.lightParameter = float4(_EdgeColor.rgb * intensity, 0);
                return output;
            }

			float4 frag(vertexOutput IN) : COLOR
			{
				/// 贴图颜色
				float4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;

				/// 边缘发光颜色
				color.rgb += IN.lightParameter.rgb;

				return color;
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}
*/
