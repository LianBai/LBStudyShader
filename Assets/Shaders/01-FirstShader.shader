Shader "LianBai/01-myshader" //引号内为shader的路径+名字，可以跟文件名字不一样
{ 
	Properties	//属性（类似于C#脚本中的public属性，通过外界可以调节），一个shader只可以有一个
	{
		//颜色，变量名字为_Color,面板上显示的名字为MyColor,类型为color,
		_Color("MyColor",Color) = (1,1,1,1)					//float4 
		//向量，四维向量,syzw,Color和Vector本质上是一种类型
		_Vector("MyVector",Vector) = (1,2,3,4)				//float4 
		//整数
		_Int("MyInt",Int) = 1234							//float
		//小数
		_Float("MyFloat",Float) = 4.5						//float
		//范围类型
		_Range("MyRange",Range(1,11)) = 6					//float
		//图片,当不指定图片的时候，用"red",可以是其他颜色
		_2D("MyTexture",2D) = "red"{}						//sampler2D
		//立方体纹理,天空盒子可以用到
		_Cube("MyCube",Cube) = "white"{}					//samplerCube
		//3D纹理
		_3D("MyTexture",3D) = "black"{}						//sampler3D
	}

	SubShader	//子shader块，可以有很多个，编写渲染的代码。显卡运行效果的时候，从第一个SubShader,如果第一个SubShader中有部分无法实现，就会自动运行下一个SubShader
	{
		Pass	//必须有一个pass块，可以有很多pass块，一个pass块代表的一个方法
		{
			//编写shader代码 可以用CGPROGRAM 或者HLSLPROGRAM
			CGPROGRAM
			//使用CG语言编写代码,需要对属性进行重新定义,不用重新定义默认值
			fixed4 _Color;	//float = half = fixed 都可以代替
			float4 _Vector;
			float _Int;
			float _Float;
			float _Range;
			sampler2D _2D;
			samplerCube _Cube;
			sampler3D _3D;
			//float 32位存储
			//half 16位存储(-6万 ~ 6万)
			//fixed 11位存储(-2 ~ 2)	//color一般用fixed存储

			ENDCG
		}
	}

	Fallback "VertexLit"	//当设备发现上面的SubShader都无法执行的时候，就会执行后这个后备方案
}
