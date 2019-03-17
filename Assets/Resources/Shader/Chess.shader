// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chess" 
{
    Properties
    {
        _gridCount("网格个数", Float) = 8
    }
    
    SubShader 
    {
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            uniform float _gridCount;

            struct vertexInput 
            {
                float4 vertex : POSITION;
                float4 texcoord0 : TEXCOORD0;
            };

            struct fragmentInput
            {
                float4 position : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
            };

            fragmentInput vert(vertexInput i)
            {
                fragmentInput o;
                o.position = UnityObjectToClipPos (i.vertex);
                o.texcoord0 = i.texcoord0;
                return o;
            }

            fixed4 frag(fragmentInput i) : SV_Target {
                fixed4 color;
                if ( fmod(i.texcoord0.x * _gridCount, 2.0) < 1.0 ){
                    if ( fmod(i.texcoord0.y * _gridCount, 2.0) < 1.0 )
                    {
                        color = fixed4(1.0, 1.0, 1.0, 1.0);
                    } else {
                        color = fixed4(0.0, 0.0, 0.0, 1.0);
                    }
                } else {
                    if ( fmod(i.texcoord0.y * _gridCount, 2.0) > 1.0 )
                    {
                        color = fixed4(1.0, 1.0, 1.0, 1.0);
                    } else {
                        color = fixed4(0.0, 0.0, 0.0, 1.0);}
                    }
                return color;
            }
            ENDCG
        }
    }
}