package core.date
{
	import com.hurlant.crypto.tls.MACs;

	public class CDate
	{
		
		public function CDate()
		{
		}
		/**
		 *返回当前时间 2012-5-22  17:55 
		 * @return 
		 * 
		 */		
		public static function getTime():String
		{
			var date:Date = new Date();
			return date.getFullYear()+"-"+(date.getMonth()%12+1)+"-"+date.getDate()+"	"+date.getHours()+":"+date.getMinutes();
		}
//		public static function 
		public static function getData():String
		{
			var date:Date = new Date();
//			return date.getDate() + " / " + (date.getMonth()%12+1);
			return date.getFullYear()+"-"+(date.getMonth()%12+1)+"-"+date.getDate();
		}
		public static function getWeek():String
		{
			var str:String = "";
			var cstr:String = "星期";
			var date:Date = new Date();
			switch(date.getDay())
			{
				case 1:
					str = "一";
					break;
				case 2:
					str = "二";
					break;
				case 3:
					str = "三";
					break;
				case 4:
					str = "四";
					break;
				case5:
					str = "五";
					break;
				case 6:
					str = "六";
					break;
				case 0:
					str = "日";
					break;
				default:
					return null;
					break;
			}
			
			return cstr + str;
		}
		/**
		 * 
		 * @param t  单位  s
		 * @return 
		 * 
		 */		
		public static function timeFormate(t:Number):String
		{
			var xx:int = Math.ceil(t);
			var min:int = xx / 60;
			var sc:int = t % 60;
			
			var minS:String = min + "";
			if(min < 10)
			{
				minS = "0" + min;
			}
			var scS:String = sc + "";
			if(sc < 10)
			{
				scS = "0" + sc;
			}
			return minS + ":" + scS;
			
		}
	}
}