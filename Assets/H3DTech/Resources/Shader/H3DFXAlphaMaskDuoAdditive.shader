Shader "H3D/InGame/Others/FX Alpha Mask Duo(Addtive)" {
	Properties {
		_MainColor("主颜色(RGB), 透明度(A)", Color) = (1,1,1,1)
		_bright("亮度", Range(0,1) ) = 0
		
		_rgbc("纹理(RGB)混合运算控制 [Multiply(<0.5) or Add(>0.5)]", Range(0,1) ) = 0
		_ac("纹理(A)混合运算控制 [Multiply(<0.5)  or Add(>0.5)]", Range(0,1) ) = 0
		
		_Emi1("纹理<1>(RGB) 透明度(A)", 2D) = "white" {}
		_Emi2("纹理<2>(RGB) 透明度(A)", 2D) = "white" {}
		_EmiMove("纹理<1>(Speed(XY)) 纹理<2> Speed(ZW)", Vector) = (0,0,0,0)

		_Alph("透明掩码纹理<3>(A) ", 2D) = "white" {}
		_PanA("透明掩码纹理<3> (Speed(XY))", Vector) = (0,0,0,0)
		
	}
	Category {
	
		Tags{
		  "Queue"="Transparent" 
		  "IgnoreProjector"="True"
		  "RenderType"="Transparent"
		}

		Blend SrcAlpha one
		Cull Off
		ZWrite Off
		ZTest LEqual
		ColorMask RGBA
		SubShader 
	    {
			LOD 200
			pass{
			
				CGPROGRAM
		        #pragma vertex vert
		        #pragma fragment frag
		        #include "UnityCG.cginc"
		        #pragma target 2.0
		        
		        sampler2D _Emi1;
				sampler2D _Emi2;
				sampler2D _Alph;
				
				half4     _Emi1_ST;
		        half4     _Emi2_ST;
		        half4     _Alph_ST;
		        
		        half4     _EmiMove;
		        half4     _PanA;
		        
		        fixed4    _MainColor;
		        fixed     _rgbc;
		        fixed     _bright;
		        fixed     _ac;
		        
		        
				struct v2f {
				  float4 pos     : SV_POSITION;
				  half4  uv      : TEXCOORD0;
				  half2  alpha_uv: TEXCOORD1;
				};
		         
				v2f vert (appdata_base v)
				{
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.uv.xy = TRANSFORM_TEX(v.texcoord, _Emi1);
					o.uv.zw = TRANSFORM_TEX(v.texcoord, _Emi2);
					o.alpha_uv = TRANSFORM_TEX(v.texcoord, _Alph);
					return o;
				}

				half4 frag (v2f i) : SV_Target
				{

				    i.uv.xy    += frac(_EmiMove.xy * _Time.y);
				    i.uv.zw    += frac(_EmiMove.zw * _Time.y);
				    i.alpha_uv += frac(_PanA.xy * _Time.y);
				    
					fixed4 emc1 = tex2D(_Emi1,i.uv.xy);
					fixed4 emc2 = tex2D(_Emi2,i.uv.zw);
					fixed4 alp  = tex2D(_Alph,i.alpha_uv);
					
					fixed4 c = 0;
					
					if ((_rgbc < 0.5)){
                        c.xyz= (((emc1.xyz * emc2.xyz) + _bright) * _MainColor.xyz);
				    }
				    else{
				        c.xyz = (((emc1.xyz + emc2.xyz) + _bright) * _MainColor.xyz);
				    }
    
				    if ((_ac < 0.5)){
				    
				        c.w = (((emc1.w * emc2.w) * alp.w) * _MainColor.w);
				    }
				    else{
				        c.w = (((emc1.w + emc2.w) * alp.w) * _MainColor.w);
				    }	
				   

					return c;
				
				}
				ENDCG 
			
			}
		}//Lod 200
	 
	}
}