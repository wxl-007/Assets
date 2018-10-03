// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.10 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.10;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,nrsp:0,limd:3,spmd:0,grmd:0,uamb:True,mssp:False,bkdf:False,rprd:False,enco:True,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:1,culm:0,dpts:2,wrdp:True,dith:0,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.49126,fgcg:0.4463668,fgcb:0.6323529,fgca:1,fgde:0.01,fgrn:20,fgrf:50,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:4883,x:32889,y:32621,varname:node_4883,prsc:2|diff-7705-OUT,spec-8047-OUT,emission-3734-OUT;n:type:ShaderForge.SFN_NormalVector,id:5847,x:29780,y:32801,prsc:2,pt:False;n:type:ShaderForge.SFN_Normalize,id:3270,x:29954,y:32803,varname:node_3270,prsc:2|IN-5847-OUT;n:type:ShaderForge.SFN_Transform,id:3485,x:30129,y:32802,varname:node_3485,prsc:2,tffrom:0,tfto:3|IN-3270-OUT;n:type:ShaderForge.SFN_ComponentMask,id:9517,x:30293,y:32807,varname:node_9517,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-3485-XYZ;n:type:ShaderForge.SFN_Multiply,id:6829,x:30500,y:32875,varname:node_6829,prsc:2|A-9517-OUT,B-1553-OUT;n:type:ShaderForge.SFN_Add,id:324,x:30688,y:32964,varname:node_324,prsc:2|A-6829-OUT,B-1553-OUT;n:type:ShaderForge.SFN_Vector1,id:1553,x:30296,y:32993,varname:node_1553,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Tex2d,id:2711,x:30950,y:32845,ptovrint:False,ptlb:MatSkin,ptin:_MatSkin,varname:node_2711,prsc:2,ntxv:0,isnm:False|UVIN-324-OUT;n:type:ShaderForge.SFN_Tex2d,id:7982,x:32278,y:32933,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:node_7982,prsc:2,tex:289072cfca27d7e4ca0d58f4366a2aa4,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:4512,x:31586,y:32667,varname:node_4512,prsc:2|A-7982-RGB,B-2711-RGB;n:type:ShaderForge.SFN_Tex2d,id:215,x:30968,y:32294,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_215,prsc:2,tex:404664de07d29a94c82b831904052552,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Lerp,id:491,x:32354,y:32731,varname:node_491,prsc:2|A-6121-OUT,B-3874-OUT,T-2711-RGB;n:type:ShaderForge.SFN_Lerp,id:6121,x:32062,y:32871,varname:node_6121,prsc:2|A-4512-OUT,B-2711-RGB,T-5505-OUT;n:type:ShaderForge.SFN_Slider,id:5505,x:31735,y:32953,ptovrint:False,ptlb:Ambient-Lerp,ptin:_AmbientLerp,varname:node_5505,prsc:2,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:6646,x:30936,y:33134,ptovrint:False,ptlb:MatRef,ptin:_MatRef,varname:_MatMap_copy,prsc:2,ntxv:0,isnm:False|UVIN-324-OUT;n:type:ShaderForge.SFN_Color,id:8289,x:31198,y:32001,ptovrint:False,ptlb:Metal-Color,ptin:_MetalColor,varname:node_8289,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:6816,x:31437,y:32153,varname:node_6816,prsc:2|A-8289-RGB,B-3081-OUT,C-6646-RGB;n:type:ShaderForge.SFN_Multiply,id:3081,x:31208,y:32176,varname:node_3081,prsc:2|A-6583-OUT,B-215-R;n:type:ShaderForge.SFN_Slider,id:6583,x:30826,y:32121,ptovrint:False,ptlb:Metal-Light,ptin:_MetalLight,varname:node_6583,prsc:2,min:0,cur:1,max:12;n:type:ShaderForge.SFN_Add,id:8665,x:31850,y:32385,varname:node_8665,prsc:2|A-9661-OUT,B-4512-OUT;n:type:ShaderForge.SFN_Power,id:9661,x:31650,y:32188,varname:node_9661,prsc:2|VAL-6816-OUT,EXP-113-OUT;n:type:ShaderForge.SFN_Slider,id:113,x:31459,y:32368,ptovrint:False,ptlb:Metal-Power,ptin:_MetalPower,varname:node_113,prsc:2,min:0,cur:1,max:10;n:type:ShaderForge.SFN_Lerp,id:3874,x:32066,y:32530,varname:node_3874,prsc:2|A-8665-OUT,B-4512-OUT,T-215-G;n:type:ShaderForge.SFN_ViewVector,id:2207,x:31200,y:32997,varname:node_2207,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:9308,x:31205,y:33259,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:3510,x:31415,y:33166,varname:node_3510,prsc:2,dt:0|A-2207-OUT,B-9308-OUT;n:type:ShaderForge.SFN_Multiply,id:3644,x:31596,y:33078,varname:node_3644,prsc:2|A-9173-OUT,B-3510-OUT;n:type:ShaderForge.SFN_Vector1,id:9173,x:31425,y:33044,varname:node_9173,prsc:2,v1:-1;n:type:ShaderForge.SFN_Add,id:3367,x:31818,y:33144,varname:node_3367,prsc:2|A-3644-OUT,B-1019-OUT;n:type:ShaderForge.SFN_Vector1,id:1019,x:31586,y:33311,varname:node_1019,prsc:2,v1:1.2;n:type:ShaderForge.SFN_Add,id:8458,x:32508,y:32829,varname:node_8458,prsc:2|A-491-OUT,B-2418-OUT;n:type:ShaderForge.SFN_Power,id:8047,x:32092,y:33199,varname:node_8047,prsc:2|VAL-3367-OUT,EXP-6047-OUT;n:type:ShaderForge.SFN_Slider,id:6047,x:31691,y:33417,ptovrint:False,ptlb:Rim,ptin:_Rim,varname:node_6047,prsc:2,min:0,cur:2,max:12;n:type:ShaderForge.SFN_Multiply,id:2418,x:32350,y:33265,varname:node_2418,prsc:2|A-8047-OUT,B-6550-RGB,C-215-B;n:type:ShaderForge.SFN_Color,id:6550,x:32085,y:33380,ptovrint:False,ptlb:Rim-Color,ptin:_RimColor,varname:node_6550,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_LightColor,id:2791,x:32884,y:32128,varname:node_2791,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7705,x:32774,y:32411,varname:node_7705,prsc:2|A-2791-RGB,B-8458-OUT,C-8345-OUT;n:type:ShaderForge.SFN_LightAttenuation,id:8345,x:32482,y:32189,varname:node_8345,prsc:2;n:type:ShaderForge.SFN_AmbientLight,id:5916,x:32529,y:33030,varname:node_5916,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3734,x:32669,y:32907,varname:node_3734,prsc:2|A-8458-OUT,B-5916-RGB;proporder:7982-215-2711-6646-8289-5505-6583-113-6047-6550;pass:END;sub:END;*/

Shader "MyShader/MatCap&Light-Shader" {
    Properties {
        _Diffuse ("Diffuse", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
        _MatSkin ("MatSkin", 2D) = "white" {}
        _MatRef ("MatRef", 2D) = "white" {}
        _MetalColor ("Metal-Color", Color) = (0.5,0.5,0.5,1)
        _AmbientLerp ("Ambient-Lerp", Range(0, 1)) = 0
        _MetalLight ("Metal-Light", Range(0, 12)) = 1
        _MetalPower ("Metal-Power", Range(0, 10)) = 1
        _Rim ("Rim", Range(0, 12)) = 2
        _RimColor ("Rim-Color", Color) = (0.5,0.5,0.5,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MatSkin; uniform float4 _MatSkin_ST;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _AmbientLerp;
            uniform sampler2D _MatRef; uniform float4 _MatRef_ST;
            uniform float4 _MetalColor;
            uniform float _MetalLight;
            uniform float _MetalPower;
            uniform float _Rim;
            uniform float4 _RimColor;
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
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 0.5;
                float specPow = exp2( gloss * 10.0+1.0);
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                UnityGI gi = UnityGlobalIllumination (d, 1, gloss, normalDirection);
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float LdotH = max(0.0,dot(lightDirection, halfDirection));
                float node_8047 = pow((((-1.0)*dot(viewDirection,i.normalDir))+1.2),_Rim);
                float3 specularColor = float3(node_8047,node_8047,node_8047);
                float specularMonochrome = max( max(specularColor.r, specularColor.g), specularColor.b);
                float NdotV = max(0.0,dot( normalDirection, viewDirection ));
                float NdotH = max(0.0,dot( normalDirection, halfDirection ));
                float VdotH = max(0.0,dot( viewDirection, halfDirection ));
                float visTerm = SmithBeckmannVisibilityTerm( NdotL, NdotV, 1.0-gloss );
                float normTerm = max(0.0, NDFBlinnPhongNormalizedTerm(NdotH, RoughnessToSpecPower(1.0-gloss)));
                float specularPBL = max(0, (NdotL*visTerm*normTerm) * (UNITY_PI / 4));
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularPBL*lightColor*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float3 directDiffuse = ((1 +(fd90 - 1)*pow((1.00001-NdotL), 5)) * (1 + (fd90 - 1)*pow((1.00001-NdotV), 5)) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float node_1553 = 0.5;
                float2 node_324 = ((mul( UNITY_MATRIX_V, float4(normalize(i.normalDir),0) ).xyz.rgb.rg*node_1553)+node_1553);
                float4 _MatSkin_var = tex2D(_MatSkin,TRANSFORM_TEX(node_324, _MatSkin));
                float3 node_4512 = (_Diffuse_var.rgb*_MatSkin_var.rgb);
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _MatRef_var = tex2D(_MatRef,TRANSFORM_TEX(node_324, _MatRef));
                float3 diffuseColor = (_LightColor0.rgb*(lerp(lerp(node_4512,_MatSkin_var.rgb,_AmbientLerp),lerp((pow((_MetalColor.rgb*(_MetalLight*_Mask_var.r)*_MatRef_var.rgb),_MetalPower)+node_4512),node_4512,_Mask_var.g),_MatSkin_var.rgb)+(node_8047*_RimColor.rgb*_Mask_var.b))*attenuation);
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float3 emissive = ((lerp(lerp(node_4512,_MatSkin_var.rgb,_AmbientLerp),lerp((pow((_MetalColor.rgb*(_MetalLight*_Mask_var.r)*_MatRef_var.rgb),_MetalPower)+node_4512),node_4512,_Mask_var.g),_MatSkin_var.rgb)+(node_8047*_RimColor.rgb*_Mask_var.b))*UNITY_LIGHTMODEL_AMBIENT.rgb);
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MatSkin; uniform float4 _MatSkin_ST;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _AmbientLerp;
            uniform sampler2D _MatRef; uniform float4 _MatRef_ST;
            uniform float4 _MetalColor;
            uniform float _MetalLight;
            uniform float _MetalPower;
            uniform float _Rim;
            uniform float4 _RimColor;
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
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 0.5;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float LdotH = max(0.0,dot(lightDirection, halfDirection));
                float node_8047 = pow((((-1.0)*dot(viewDirection,i.normalDir))+1.2),_Rim);
                float3 specularColor = float3(node_8047,node_8047,node_8047);
                float specularMonochrome = max( max(specularColor.r, specularColor.g), specularColor.b);
                float NdotV = max(0.0,dot( normalDirection, viewDirection ));
                float NdotH = max(0.0,dot( normalDirection, halfDirection ));
                float VdotH = max(0.0,dot( viewDirection, halfDirection ));
                float visTerm = SmithBeckmannVisibilityTerm( NdotL, NdotV, 1.0-gloss );
                float normTerm = max(0.0, NDFBlinnPhongNormalizedTerm(NdotH, RoughnessToSpecPower(1.0-gloss)));
                float specularPBL = max(0, (NdotL*visTerm*normTerm) * (UNITY_PI / 4));
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularPBL*lightColor*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float3 directDiffuse = ((1 +(fd90 - 1)*pow((1.00001-NdotL), 5)) * (1 + (fd90 - 1)*pow((1.00001-NdotV), 5)) * NdotL) * attenColor;
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float node_1553 = 0.5;
                float2 node_324 = ((mul( UNITY_MATRIX_V, float4(normalize(i.normalDir),0) ).xyz.rgb.rg*node_1553)+node_1553);
                float4 _MatSkin_var = tex2D(_MatSkin,TRANSFORM_TEX(node_324, _MatSkin));
                float3 node_4512 = (_Diffuse_var.rgb*_MatSkin_var.rgb);
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _MatRef_var = tex2D(_MatRef,TRANSFORM_TEX(node_324, _MatRef));
                float3 diffuseColor = (_LightColor0.rgb*(lerp(lerp(node_4512,_MatSkin_var.rgb,_AmbientLerp),lerp((pow((_MetalColor.rgb*(_MetalLight*_Mask_var.r)*_MatRef_var.rgb),_MetalPower)+node_4512),node_4512,_Mask_var.g),_MatSkin_var.rgb)+(node_8047*_RimColor.rgb*_Mask_var.b))*attenuation);
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    
}
