Shader "H3D/InGame/Others/Parallax Fire Addtive"
{
	Properties {
		_Color("主颜色(RGB), 透明度(A)", Color) = (1,1,1,1)
		_MainTex("主纹理(RGB) 透明度(A)", 2D) = "white" {}
		_Prlx("景深纹理", 2D) = "white" {}
		_prl1("景深纹理影度(On - Off)", Range(0,1) ) = 0
		_height("高度", Float) = 0.3
		_ScrollX ("主纹理 uv X", Float) = 0.0
	    _ScrollY ("主纹理 uv Y", Float) = 0.0
	    _PrlxScrollX("景深纹理 uv X", Float) = 0.0
	    _PrlxScrollY("景深纹理 uv Y", Float) = 0.0
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
		        
		        sampler2D _MainTex;
				sampler2D _Prlx;
				half4     _MainTex_ST;
		        half4     _Prlx_ST;
				fixed4    _Color;
				half      _prl1;
				half      _height;
	 			half      _ScrollX;
				half      _ScrollY; 
		        half      _PrlxScrollX;
		        half      _PrlxScrollY;
		        
				struct v2f {
				  float4 pos : SV_POSITION;
				  half4  uv  : TEXCOORD0;
				};
		         
				v2f vert (appdata_base v)
				{
				
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv.zw = TRANSFORM_TEX(v.texcoord, _MainTex);
					return o;
				}

				half4 frag (v2f i) : SV_Target
				{

				    i.uv.xy += frac(half2( _ScrollX,_ScrollY) * _Time.y);
				    i.uv.zw += frac(half2( _PrlxScrollX,_PrlxScrollY) * _Time.y);
					fixed4 p = tex2D( _Prlx,i.uv.zw);
					half2 po = ParallaxOffset( p.w, _height, p.xyz);		
					i.uv.xy  = lerp((i.uv.xy + po), i.uv.xy, _prl1);
					fixed4 c =  tex2D( _MainTex, i.uv.xy);
					c.xyz = (c.xyz * _Color.xyz);
					c.w = (c.w * _Color.w);
					return c;
				
				}
				ENDCG 
			
			}
		}//Lod 200
	 
	}
}