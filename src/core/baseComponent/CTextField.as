package core.baseComponent
{
	import flash.text.TextField;
	
	public class CTextField extends TextField
	{
		private var _text:String;
		public function CTextField()
		{
			super();
			this.selectable = false;
			this.mouseEnabled = false;
		}
	}
}