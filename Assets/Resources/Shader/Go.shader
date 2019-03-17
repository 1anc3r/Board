Shader "Custom/Go" 
{
    Properties
    {
        _lineColor("线条颜色", Color) = (0,0, 0,1)
        _lineWidth("线条宽度", Range(0.0001, 0.01)) = 0.0025
        _gridSpace("网格间距", Range(0.01, 1)) = 0.03
        _gridCount("网格个数", Float) = 18
    }
    
    SubShader
    {
        CGINCLUDE

        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform float4 _originColor;
            uniform float4 _lineColor;
            uniform float _lineWidth;
            uniform float _gridSpace;
            uniform float _gridCount;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };

            struct fragmentInput
            {
                float4 vertex : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
            };

            fragmentInput vert(vertexInput i)
            {
                fragmentInput o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.texcoord0 = i.texcoord0;
                return o;
            }

            float4 frag(fragmentInput i) : COLOR
            {
                float2 r = 2.0 * i.texcoord0;
                float4 color = _originColor;
                if (fmod(r.x, _gridSpace) < _lineWidth || fmod(r.y, _gridSpace) < _lineWidth)
                {
                    color = _lineColor;
                }
                if (fmod(r.x, _gridSpace) > _gridSpace - _lineWidth || fmod(r.y, _gridSpace) > _gridSpace - _lineWidth)
                {
                    color = _lineColor;
                }
                if (abs(color.x) == _originColor.x
                    && abs(color.y) == _originColor.y
                    && abs(color.z) == _originColor.z
                    && abs(color.w) == _originColor.w)
                {
                    discard;
                }
                return color;
            }
            ENDCG
        }
    }
}