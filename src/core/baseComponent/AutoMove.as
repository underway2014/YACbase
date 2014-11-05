package core.baseComponent
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.tween.TweenLite;

	public class AutoMove
	{
		private var vwidth:int;
		private var _target:Sprite;
		private var moveDis:int;
		public function AutoMove(_w:int,_moveDis:int = 500)
		{
			vwidth = _w;
			moveDis = _moveDis;
			timer = new Timer(2000);
			timer.addEventListener(TimerEvent.TIMER,moveHandler);
		}

		public function get target():Sprite
		{
			return _target;
		}

		public function set target(value:Sprite):void
		{
			_target = value;
			
//			if(_target.width > vwidth)
//			{
//				autoMove();
//			}
		}

		private var direction:int = -1;//left
		private var timer:Timer;
		public function autoMove():void
		{
			timer.start();
		}
		private function moveHandler(event:TimerEvent):void
		{
			var endX:int = _target.x + direction * moveDis;
			if(direction == -1)
			{
				if(endX < -(_target.width - vwidth))
				{
					endX = -(_target.width - vwidth);
					direction *= -1;
				}
			}else{
				if(endX > 0)
				{
					endX = 0;
					direction *= -1;
				}
			}
			TweenLite.to(_target,.3,{x:endX});
		}
		public function stop():void
		{
			timer.stop();
		}
		public function start():void
		{
			if(_target.width > vwidth)
			{
				timer.start();
			}
		}
	}
}