Shader "H3D/InGame/Others/UIWiggleAlphaBlend" {
	Properties {
		_MainTex ("主颜色(RGB)透明度（A）", 2D) = "white" {}
		_WiggleTex ("扭动纹理(A)", 2D) = "white" {}
		_WiggleStrength ("扭动强度", Range (0.01, 10.0)) = 0.03
		_ScrollX ("主纹理 uv X", Float) = 0.0
	    _ScrollY ("主纹理 uv Y", Float) = 0.0
	    _WiggleScrollX ("扰动纹理 uv X", Float) = 1.0
	    _WiggleScrollY ("扰动纹理 uv Y", Float) = 0.0
	   
	}
	Category {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "ForceNoShadowCasting" = "True"}
   		Blend SrcAlpha OneMinusSrcAlpha 
		cull off ZWrite Off
		SubShader {
			LOD 200
			pass{
					
				CGPROGRAM
		        #pragma vertex   vert
		        #pragma fragment frag
			    #include "UnityCG.cginc"
				 struct v2f {
		            float4 pos : SV_POSITION;
		            half2  muv  : TEXCOORD0;
				 };
				 
				 half      _ScrollX;
				 half      _ScrollY; 
				 half      _WiggleScrollX;
				 half      _WiggleScrollY;    
				 sampler2D _MainTex;
				 sampler2D _WiggleTex;
				 half4     _MainTex_ST;
				 half      _WiggleStrength;
			     
		         v2f vert (appdata_base v)
		         {
		            v2f o;
		            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		            o.muv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
		            return o;
		         }
		         half4 frag (v2f i) : SV_Target
		         {
					
					half2 uv = i.muv.xy;
					uv   += frac(half2( _WiggleScrollX,_WiggleScrollY) * _Time);
					fixed4 wiggle = tex2D(_WiggleTex, uv);
					
					i.muv.x -= wiggle.r * _WiggleStrength;
					i.muv.y += wiggle.b * _WiggleStrength;
					i.muv.xy +=  frac(half2(_ScrollX, _ScrollY) * _Time);
					fixed4 c = tex2D(_MainTex, i.muv.xy);
		            return c;
		        }
		       ENDCG 
		   }
	   }// Lod 200
	   SubShader 
	  {
		   LOD 100
	       Pass 
		   {

	           SetTexture [_MainTex] { combine texture }
	   
	       }
      }
 }
}







