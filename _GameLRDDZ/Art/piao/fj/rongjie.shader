// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:Diffuse,lico:1,lgpr:1,nrmq:1,limd:2,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:0,culm:0,dpts:2,wrdp:True,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.1280277,fgcg:0.1953466,fgcb:0.2352941,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:31440,y:32293|diff-195-OUT,emission-110-OUT,custl-10-OUT,clip-90-OUT;n:type:ShaderForge.SFN_NormalVector,id:3,x:33901,y:32467,pt:False;n:type:ShaderForge.SFN_LightVector,id:4,x:33912,y:32641;n:type:ShaderForge.SFN_Dot,id:6,x:33673,y:32485,dt:1|A-3-OUT,B-4-OUT;n:type:ShaderForge.SFN_Multiply,id:7,x:33447,y:32495|A-6-OUT,B-9-OUT;n:type:ShaderForge.SFN_LightAttenuation,id:9,x:33641,y:32672;n:type:ShaderForge.SFN_Multiply,id:10,x:32658,y:32477|A-26-OUT,B-11-RGB;n:type:ShaderForge.SFN_LightColor,id:11,x:32873,y:32556;n:type:ShaderForge.SFN_Color,id:12,x:33598,y:32286,ptlb:DiffuseTint,ptin:_DiffuseTint,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:13,x:33355,y:32343|A-12-RGB,B-7-OUT;n:type:ShaderForge.SFN_ViewReflectionVector,id:19,x:33930,y:33036;n:type:ShaderForge.SFN_Dot,id:20,x:33684,y:33026,dt:1|A-4-OUT,B-19-OUT;n:type:ShaderForge.SFN_Power,id:21,x:33389,y:33013|VAL-20-OUT,EXP-22-OUT;n:type:ShaderForge.SFN_Exp,id:22,x:33411,y:33232,et:1|IN-23-OUT;n:type:ShaderForge.SFN_Slider,id:23,x:33618,y:33260,ptlb:specGlass,ptin:_specGlass,min:1,cur:7.456789,max:11;n:type:ShaderForge.SFN_Multiply,id:24,x:33118,y:32982|A-21-OUT,B-25-OUT;n:type:ShaderForge.SFN_Slider,id:25,x:33067,y:33301,ptlb:Specintensity,ptin:_Specintensity,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Add,id:26,x:33020,y:32518|A-13-OUT,B-24-OUT;n:type:ShaderForge.SFN_Slider,id:32,x:32787,y:33054,ptlb:BlendAmount,ptin:_BlendAmount,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Multiply,id:33,x:32657,y:32733|A-37-R,B-32-OUT;n:type:ShaderForge.SFN_Tex2d,id:37,x:32919,y:32746,ptlb:node_37,ptin:_node_37,tex:e96233d0ffee70f4f997d98a8d5fea98,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:78,x:32412,y:32756|A-33-OUT,B-79-OUT;n:type:ShaderForge.SFN_Vector1,id:79,x:32657,y:32935,v1:4;n:type:ShaderForge.SFN_Add,id:80,x:32234,y:32804|A-78-OUT,B-32-OUT;n:type:ShaderForge.SFN_Power,id:88,x:32028,y:32768|VAL-80-OUT,EXP-89-OUT;n:type:ShaderForge.SFN_Vector1,id:89,x:32147,y:33048,v1:100;n:type:ShaderForge.SFN_ConstantClamp,id:90,x:31793,y:32758,min:0,max:1|IN-88-OUT;n:type:ShaderForge.SFN_If,id:98,x:31952,y:32503|A-99-OUT,B-88-OUT,GT-100-OUT,EQ-101-OUT,LT-101-OUT;n:type:ShaderForge.SFN_Slider,id:99,x:32201,y:32554,ptlb:EdgeWidth,ptin:_EdgeWidth,min:0,cur:100,max:100;n:type:ShaderForge.SFN_Vector1,id:100,x:32255,y:32641,v1:1;n:type:ShaderForge.SFN_Vector1,id:101,x:32279,y:32713,v1:0;n:type:ShaderForge.SFN_Color,id:109,x:31952,y:32334,ptlb:Glowcolor,ptin:_Glowcolor,glob:False,c1:0.1783088,c2:0.5140213,c3:0.7132353,c4:1;n:type:ShaderForge.SFN_Multiply,id:110,x:31744,y:32359|A-109-RGB,B-98-OUT;n:type:ShaderForge.SFN_Tex2d,id:182,x:31967,y:32153,ptlb:Diffuse,ptin:_Diffuse,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:195,x:31744,y:32153|A-196-RGB,B-182-RGB;n:type:ShaderForge.SFN_Color,id:196,x:31892,y:31945,ptlb:Diffusecolor,ptin:_Diffusecolor,glob:False,c1:1,c2:1,c3:1,c4:1;proporder:12-23-25-32-37-99-109-182-196;pass:END;sub:END;*/

Shader "Shader Forge/rongjie_Dissolve" {
    Properties {
        _DiffuseTint ("DiffuseTint", Color) = (0.5,0.5,0.5,1)
        _specGlass ("specGlass", Range(1, 11)) = 7.456789
        _Specintensity ("Specintensity", Range(0, 1)) = 1
        _BlendAmount ("BlendAmount", Range(0, 1)) = 1
        _node_37 ("node_37", 2D) = "white" {}
        _EdgeWidth ("EdgeWidth", Range(0, 100)) = 100
        _Glowcolor ("Glowcolor", Color) = (0.1783088,0.5140213,0.7132353,1)
        _Diffuse ("Diffuse", 2D) = "white" {}
        _Diffusecolor ("Diffusecolor", Color) = (1,1,1,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float _BlendAmount;
            uniform sampler2D _node_37; uniform float4 _node_37_ST;
            uniform float _EdgeWidth;
            uniform float4 _Glowcolor;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _Diffusecolor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), unity_WorldToObject).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                float2 node_209 = i.uv0;
                float node_88 = pow((((tex2D(_node_37,TRANSFORM_TEX(node_209.rg, _node_37)).r*_BlendAmount)*4.0)+_BlendAmount),100.0);
                clip(clamp(node_88,0,1) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
////// Emissive:
                float node_98_if_leA = step(_EdgeWidth,node_88);
                float node_98_if_leB = step(node_88,_EdgeWidth);
                float node_101 = 0.0;
                float3 emissive = (_Glowcolor.rgb*lerp((node_98_if_leA*node_101)+(node_98_if_leB*1.0),node_101,node_98_if_leA*node_98_if_leB));
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * (_Diffusecolor.rgb*tex2D(_Diffuse,TRANSFORM_TEX(node_209.rg, _Diffuse)).rgb);
                finalColor += emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float _BlendAmount;
            uniform sampler2D _node_37; uniform float4 _node_37_ST;
            uniform float _EdgeWidth;
            uniform float4 _Glowcolor;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _Diffusecolor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), unity_WorldToObject).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                float2 node_210 = i.uv0;
                float node_88 = pow((((tex2D(_node_37,TRANSFORM_TEX(node_210.rg, _node_37)).r*_BlendAmount)*4.0)+_BlendAmount),100.0);
                clip(clamp(node_88,0,1) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * (_Diffusecolor.rgb*tex2D(_Diffuse,TRANSFORM_TEX(node_210.rg, _Diffuse)).rgb);
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCollector"
            Tags {
                "LightMode"="ShadowCollector"
            }
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCOLLECTOR
            #define SHADOW_COLLECTOR_PASS
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcollector
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float _BlendAmount;
            uniform sampler2D _node_37; uniform float4 _node_37_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_COLLECTOR;
                float2 uv0 : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_SHADOW_COLLECTOR(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_211 = i.uv0;
                float node_88 = pow((((tex2D(_node_37,TRANSFORM_TEX(node_211.rg, _node_37)).r*_BlendAmount)*4.0)+_BlendAmount),100.0);
                clip(clamp(node_88,0,1) - 0.5);
                SHADOW_COLLECTOR_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Cull Off
            Offset 1, 1
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float _BlendAmount;
            uniform sampler2D _node_37; uniform float4 _node_37_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_212 = i.uv0;
                float node_88 = pow((((tex2D(_node_37,TRANSFORM_TEX(node_212.rg, _node_37)).r*_BlendAmount)*4.0)+_BlendAmount),100.0);
                clip(clamp(node_88,0,1) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
