package core.baseComponent
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import core.loadEvents.CLoaderMany;
	import core.tween.TweenLite;
	
	public class HScroller extends Sprite
	{
		//BAR 滑动槽，滑动块图片地址
		
		private var loader:CLoaderMany;
		private var _target:Sprite;
		
		private var maskWidht:int;
		private var maskHeight:int;
		private var objX:int;
		private var objY:int;
		
		private var barSprite:Sprite = new Sprite;
		
		private var sliderSprite:Sprite = new Sprite;
		private var shape:Shape;
		private var _barX:int;
		private var isShowBar:Boolean = true;
		private var isScrollBar:Boolean = false;
		/**
		 * 
		 * @param _maskwidth  遮罩宽，高
		 * @param _maskheight
		 * 
		 */		
		public function HScroller(_maskwidth:int,_maskheight:int,barSrcUrls:Array = null)
		{
			//,_objx:int=0,_objy:int=0
			super();
			maskWidht = _maskwidth;
			maskHeight = _maskheight;
			
			
			barSprite.x = maskWidht;
			
			shape = new Shape();
			shape.graphics.beginFill(0xaacc00);
			shape.graphics.drawRect(0,0,maskWidht,maskHeight);
			shape.graphics.endFill();
			this.addChild(shape);
			
			dragMask = new Sprite();
			dragMask.graphics.beginFill(0xaacc00,0);
			dragMask.graphics.drawRect(0,0,_maskwidth,_maskheight);
			dragMask.graphics.endFill();
			dragMask.visible = false;
			if(barSrcUrls)
			{
				isScrollBar = true;
				isShowBar = false;
				loader = new CLoaderMany;
				loader.load(barSrcUrls);
				loader.addEventListener(CLoaderMany.LOADE_COMPLETE,bgOkHandler);
			}
			//			this.addEventListener(MouseEvent.MOUSE_DOWN,startdragHandler);
			//			this.addEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
		}
		private var dragMask:Sprite;

		public function get barX():int
		{
			return _barX;
		}

		public function set barX(value:int):void
		{
			_barX = value;
			barSprite.x = value;
		}

		/**
		 *滑块拖动 
		 * @param event
		 * 
		 */		
		private function barStartDragHandler(event:MouseEvent):void
		{
			trace("slider start drag..",barSprite.height);
			sliderSprite.startDrag(false,new Rectangle(0,0,0,barSprite.height-sliderSprite.height));
			addEventListener(Event.ENTER_FRAME,updateContent);
		}
		private function barStopDragHandler(event:MouseEvent):void
		{
			sliderSprite.stopDrag();
			removeEventListener(Event.ENTER_FRAME,updateContent);
		}
		private var barslider:DisplayObjectContainer;
		private function bgOkHandler(event:Event):void
		{
			barSprite.y = (maskHeight - loader._loaderContent[1].height) / 2;
//			loader._loaderContent[1].height = maskHeight;
			barSprite.addChild(loader._loaderContent[1]);
			
			var bgslider:Shape = new Shape();
			bgslider.graphics.beginFill(0xaacc00,0);
			bgslider.graphics.drawRect(0,0,loader._loaderContent[0].width,loader._loaderContent[0].height + 30);
			bgslider.graphics.endFill();
			
			sliderSprite.addChild(bgslider);
			loader._loaderContent[0].y = 15;
			sliderSprite.addChild(loader._loaderContent[0]);
			loader._loaderContent[0].x = 8;
			barSprite.addChild(sliderSprite);
//			sliderSprite.addEventListener(MouseEvent.MOUSE_DOWN,barStartDragHandler);
//			sliderSprite.addEventListener(MouseEvent.MOUSE_UP,barStopDragHandler);
//			sliderSprite.addEventListener(MouseEvent.MOUSE_OUT,barStopDragHandler);
			//			barslider = loader._loaderContent[0];
		}
		
		/**
		 *更新滑块位置 
		 * @param event
		 * 
		 */		
		public function updateSlider(event:Event):void
		{
			
			if(!hasAddMove && Math.sqrt((this.mouseX - mouse_beginX)*(this.mouseX - mouse_beginX) + (this.mouseY - mouse_beginY)*(this.mouseY - mouse_beginY)) >= standar_dis)
			{
				_target.addEventListener(MouseEvent.MOUSE_MOVE,moveOntargetHandler);
				hasAddMove = true;
			}
			//			
			//			barslider.y = Math.abs(_target.y-objY)/(_target.height-maskHeight)*(maskHeight-barslider.height);
			sliderSprite.y = Math.abs(_target.y-objY)/(_target.height-maskHeight)*(barSprite.height - sliderSprite.height);
			if(sliderSprite.y > (barSprite.height - sliderSprite.height - 2))
			{
				tipImg.visible = false;
			}else{
//				tipImg.visible = true;
			}
			
		}
		private function updateContent(event:Event):void
		{
			trace("==sliderSprite==",sliderSprite.y);
			_target.y = -sliderSprite.y/(barSprite.height-sliderSprite.height)*(_target.height-maskHeight)+objY;
		}
		public function get target():Sprite
		{
			return _target;
		}
		private var tipImg:CImage;
		public function set target(value:Sprite):void
		{
			_target = value;
			_target.addEventListener(MouseEvent.MOUSE_DOWN,startdragHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
			//			_target.addEventListener(MouseEvent.MOUSE_OUT,stopdragHandler);
			this.addChild(_target);
			this.addChild(barSprite);
			this.addChild(dragMask);
			_target.mask = shape;
			tipImg = new CImage(284,38,false,false);
			tipImg.url = "source/public/moreTip.png";
			if(isScrollBar)
			this.addChild(tipImg);
			tipImg.y = height - 38;
			tipImg.x = (width - 284) / 2;
			
			this.x =_target.x;
			this.y = _target.y;
			objX = _target.x;
			objY = _target.y;
		}
		private var mouse_beginX:int = 0;
		private var mouse_beginY:int = 0;
		private var standar_dis:int = 10;
		private var hasAddMove:Boolean;
		private function startdragHandler(event:MouseEvent):void
		{
			mouse_beginX = this.mouseX;
			mouse_beginY = this.mouseY;
			var yy:Number = (-_target.height+maskHeight)<0?(-_target.height+maskHeight):0;
			_target.startDrag(false,new Rectangle(objX,yy+objY,0,(_target.height-maskHeight)<0?0:(_target.height-maskHeight)));
			//			var yy:Number = (-_target.height+maskHeight)<0?(-_target.height+maskHeight) - 40:0;
			//			_target.startDrag(false,new Rectangle(objX,yy+objY,0,(_target.height-maskHeight + 40)<0?0:(_target.height-maskHeight + 40)));
			
			this.addEventListener(Event.ENTER_FRAME,updateSlider);
			
			//			_target.addEventListener(MouseEvent.MOUSE_MOVE,moveOntargetHandler);
		}
		private function moveOntargetHandler(event:MouseEvent):void
		{
			_target.mouseChildren = _target.mouseEnabled = false;
			dragMask.addEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
			dragMask.addEventListener(MouseEvent.MOUSE_OUT,stopdragHandler);
			dragMask.visible = true;
			
			tipImg.visible = false;
			
		}
		private function stopdragHandler(event:MouseEvent):void
		{
			_target.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,updateSlider);
			if(hasAddMove)
			{
				_target.removeEventListener(MouseEvent.MOUSE_MOVE,moveOntargetHandler);
				dragMask.removeEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
				dragMask.removeEventListener(MouseEvent.MOUSE_OUT,stopdragHandler);
			}
			dragMask.visible = false;
			hasAddMove = false;
			_target.mouseChildren = _target.mouseEnabled = true;
		}
		public function changeScrollBarState(_isShow:Boolean):void
		{
			barSprite.visible = _isShow;
		}
		public function scrollTo(yy:int):void
		{
			if(-yy < -(_target.height - maskHeight))
			{
				yy = _target.height - maskHeight;
			}
			TweenLite.to(target,.5,{y:-yy,onComplete:moveOve});
			
		}
		public function moveOve():void
		{
			sliderSprite.y = Math.abs(_target.y-objY)/(_target.height-maskHeight)*(barSprite.height - sliderSprite.height);
			if(sliderSprite.y > (barSprite.height - sliderSprite.height - 2))
			{
				tipImg.visible = false;
			}else{
//				tipImg.visible = true;
			}
		}
		public function reset():void
		{
			sliderSprite.y = _target.y = 0;
			if(target.height <= maskHeight)
			{
				tipImg.visible = barSprite.visible = false;
			}else{
				tipImg.visible = barSprite.visible = true;
			}
		}
	}
}