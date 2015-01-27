package core.baseComponent
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import core.tween.TweenLite;
	
	public class LoopAtlas extends Sprite
	{
		private var viewArr:Array;
		private var currentPage:int = 0;
		private var _selfWidth:int = 1920;
		public static const PLAY_OVER:String = "loopplayover";
		/**
		 *图集大小 
		 */		
		private var _size:Point;
		/**
		 *是否自动翻页 
		 */		
		private var autoMove:Boolean;
		/**
		 *是否显示 图集下方 当前页码提示小圆点 
		 */		
		private var _showTipCircle:Boolean;
		
		private var circleContain:Sprite;
		public function LoopAtlas(_viewArr:Array,_autoMove:Boolean = true)
		{
			super();
			
			viewArr = _viewArr;
			autoMove = _autoMove;
			len = viewArr.length;
			viewContain = new Sprite();
			addChild(viewContain);
			circleContain = new Sprite();
			addChild(circleContain);
			init();
		}
		private var viewContain:Sprite;
		private var len:int;
		private var leftView:Sprite = new Sprite();
		private var midView:Sprite = new Sprite();
		private var rightView:Sprite = new Sprite();
		private var leftIndex:int;
		private var rightIndex:int;
		private var manger:Array;
		private var dataViewArr:Array;
		private var timer:Timer;
		private function init():void
		{
			manger = new Array();
			manger.push(leftView);
			manger.push(midView);
			manger.push(rightView);
			
			dataViewArr = new Array();
			
			
		}
		private var dir:int = -1;
		private var isMoving:Boolean = false;
		private function autoMoveHandler(event:TimerEvent):void
		{
			isMoving = true;
			var endX:int = viewContain.x +_selfWidth * dir;
			TweenLite.to(viewContain,.4,{x:endX,onComplete:moveOver});
		}
		public function next():void
		{
			if(isMoving) return;
			if(timer) timer.stop();
			autoMoveHandler(null);
		}
		public function prev():void
		{
			if(isMoving) return;
			if(timer) timer.stop();
			dir = 1;
			autoMoveHandler(null);
		}
		public function gotoPage(index:int):void
		{
			currentPage = index;
			getView();
		}
		private function moveOver():void
		{
			reDrawCircle();
			currentPage -= dir;
			dispatchEvent(new Event("MOVE_OVER"));
			if(currentPage > viewArr.length - 1)
			{
				currentPage = 0;
				dispatchEvent(new Event(PLAY_OVER));
				trace("dispatch loop play over event");
			}
			if(currentPage < 0)
			{
				currentPage = viewArr.length - 1;
			}
			if(dir == -1)//left
			{
				
			}else{//right
				
			}
			dir = -1;
			getView();
		}
		private function reDrawCircle():void
		{
			if(!circleArr) return;
			var sindex:int = currentPage;
			if(sindex > viewArr.length - 1)
			{
				sindex = 0;
			}
			if(sindex < 0)
			{
				sindex = viewArr.length - 1;
			}
			
			var currShpae:Shape = circleArr[sindex];
			currShpae.graphics.clear();
			currShpae.graphics.beginFill(0xffffff,.5);
			currShpae.graphics.drawCircle(0,0,10);
			currShpae.graphics.endFill();
			
			var willIndex:int = sindex - dir;
			if(willIndex > viewArr.length - 1)
			{
				willIndex = 0;
			}
			if(willIndex < 0)
			{
				willIndex = viewArr.length - 1;
			}
			
			var willCurrShape:Shape = circleArr[willIndex];
			willCurrShape.graphics.clear();
			willCurrShape.graphics.beginFill(0x00cc00,.7);
			willCurrShape.graphics.drawCircle(0,0,10);
			willCurrShape.graphics.endFill();
		}
		private function getView():void
		{
//			while(dataViewArr.length)
//			{
//				dataViewArr.shift();
//			}
			dataViewArr.length = 0;
			if(currentPage - 1 >=0)
			{
				leftIndex = currentPage - 1;
			}
			else{
				leftIndex = len - 1;
			}
			if(currentPage + 1 > len - 1)
			{
				rightIndex = 0;
			}else{
				rightIndex = currentPage + 1;
			}
			dataViewArr.push(viewArr[leftIndex]);
			dataViewArr.push(viewArr[currentPage]);
			dataViewArr.push(viewArr[rightIndex]);
			
			reLayout();
		}
//		private 
		private function reLayout():void
		{
			viewContain.x = 0;
			var n:int = - 1;
			for each(var view:Sprite in dataViewArr)
			{
				view.x = n * _selfWidth;
				viewContain.addChild(view);
				n++;
			}
			while(viewContain.numChildren  > 3)
			{
				viewContain.removeChildAt(0);
			}
			isMoving = false;
			if(timer && !timer.running)
			{
				timer.start();
				trace("restart timer.runing = ",timer.running);
			}
		}
		
		public function get size():Point
		{
			return _size;
		}

		public function set size(value:Point):void
		{
			_size = value;
			_selfWidth = _size.x;
			
			
			if(autoMove)
			{
				timer = new Timer(1000 * 7);
				timer.addEventListener(TimerEvent.TIMER,autoMoveHandler);
				timer.start();
			}
			getView();
			
			var maskShape:Shape = new Shape();
			maskShape.graphics.beginFill(0xaa0000,.2);
			maskShape.graphics.drawRect(0,0,_size.x,_size.y);
			maskShape.graphics.endFill();
			addChild(maskShape);
			this.mask = maskShape;
		}

		public function get showTipCircle():Boolean
		{
			return _showTipCircle;
		}
		private var circleArr:Array;
		public function set showTipCircle(value:Boolean):void
		{
			_showTipCircle = value;
			circleArr = new Array();
			var circleShape:Shape;
			var shapeConain:Sprite = new Sprite();
			for(var m:int = 0;m < viewArr.length;m++)
			{
				circleShape = new Shape();
				if(m == 0)
				{
					circleShape.graphics.beginFill(0x00cc00,.5);
				}
				else{
					circleShape.graphics.beginFill(0xffffff,.7);
				}
				circleShape.graphics.drawCircle(0,0,10);
				circleShape.graphics.endFill();
				
				circleArr.push(circleShape);
				shapeConain.addChild(circleShape);
				circleShape.x = m * 50;
			}
			circleContain.addChild(shapeConain);
			circleContain.y = _size.y - 40;
			relayOutCircle(shapeConain);
			
		}
		private function relayOutCircle(_sp:Sprite):void
		{
			var ww:int = _sp.width;
			_sp.x = (_size.x  - ww) / 2;
		}
		public function clear():void
		{
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,autoMoveHandler);
				timer = null;
			}
			for each(var s:Sprite in viewArr)
			{
				s = null;
			}
		}
		public function reset():void
		{
//			viewContain.x = 0;
		}
		public function getCurrentPage():int
		{
			return currentPage;
		}


	}
}