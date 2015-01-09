package core.filter
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;

	public class CFilter
	{
		public function CFilter()
		{
		}
		//,
		public static var glowFilter:Array = [new GlowFilter(0x33CCFF,1,16,16,2,1),new GlowFilter(0xAACC00,1,16,16,2,1)];
		public static var blueYellowFilter:Array = [new GlowFilter(0xffffff,0.75,20,20,2,1,false,false),new GlowFilter(0xdfab2,1,5,5,2,1,true)];//,new GlowFilter(182245252,1,10,110,2,1,true)
		public static var grayFilter:Array = [new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0])];
		public static var whiteFilter:Array = [new GlowFilter(0xffffff,1,4,4,8)];
		public static var photoBorderFilter:Array = [new GlowFilter(0xdbdbdb,1,4,4,8)];
		
		public static var moveFilter:GradientGlowFilter = new GradientGlowFilter(-30,0,[0xff0000, 0x00ff00, 0x0000FF, 0xaacc00, 0x00cccc],
			[0.6, 0.4, 0.3, 0.2,0.1],[0, 32, 64, 128, 225],64,0,1,BitmapFilterQuality.HIGH,BitmapFilterType.OUTER);
		
//		public static var shadowFilter:DropShadowFilter = new DropShadowFilter(40,0,0xffb90f,.3,20,0,1,1,false);
		public static var shadowFilter:Array = [new DropShadowFilter(40,0,0xffb90f,.1,50,0,1,1,false)];
	}
}