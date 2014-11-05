package core.date
{
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
			return date.getFullYear()+"-"+(date.getMonth()%12+1)+"-"+date.getDate();
		}
		public static function getWeek():String
		{
			var str:String = "";
			var cstr:String = "星期";
			var date:Date = new Date();
			switch(date.getDay())
			{
				case 0:
					str = "一";
					break;
				case 1:
					str = "二";
					break;
				case 2:
					str = "三";
					break;
				case 3:
					str = "四";
					break;
				case 4:
					str = "五";
					break;
				case 5:
					str = "六";
					break;
				case 6:
					str = "日";
					break;
				default:
					return null;
					break;
			}
			
			return cstr + str;
		}
	}
}