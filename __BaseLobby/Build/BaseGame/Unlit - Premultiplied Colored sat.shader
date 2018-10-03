// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Modify by xiaoyong  for change saturation
Shader "Unlit/Premultiplied Colored Sat"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_Saturation("Saturation", Range(0,2.0)) = 1.0
	}

	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			AlphaTest Off
			Fog { Mode Off }
			Offset -1, -1
			ColorMask RGB
			Blend One OneMinusSrcAlpha
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Saturation;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				half4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				half4 color : COLOR;
			};
			
			//add by xiaoyong for change saturation
			//change saturation formula
			fixed3 ContrastSaturation (fixed3 m_color, float sat) {  
		        fixed3 conColor = m_color;
		        float3 satConst = float3(0.299, 0.587, 0.114);
		        fixed p = sqrt(conColor.r*conColor.r*satConst.x+conColor.g*conColor.g*satConst.y+ conColor.b*conColor.b*satConst.z);
		        conColor.r = max(0, p+ (conColor.r - p)*sat);
		        conColor.g = max(0,p+ (conColor.g - p)*sat);
		        conColor.b = max(0,p+ (conColor.b - p)*sat);
		        return conColor;
		    }  
		    
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}
			
	    	
			
//			half4 frag (v2f IN) : COLOR
//			{
//				half4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
//				return col;
//			}
			
			fixed4 frag(v2f IN) : COLOR {
				fixed4 renderTex = tex2D(_MainTex, IN.texcoord) * IN.color;  
      
    			//Apply the brightness, saturation, contrast operations  
    			renderTex.rgb = ContrastSaturation (renderTex.rgb,_Saturation);
      
    			return renderTex;  
			}
			ENDCG
		}
	}
	
	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			AlphaTest Off
			Fog { Mode Off }
			Offset -1, -1
			ColorMask RGB
			Blend One OneMinusSrcAlpha 
			ColorMaterial AmbientAndDiffuse
			
			SetTexture [_MainTex]
			{
				Combine Texture * Primary
			}
		}
	}
}
