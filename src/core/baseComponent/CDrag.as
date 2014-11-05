package core.baseComponent
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 *增加拖动效果 
	 * @author binli
	 * 
	 */	
	public class CDrag extends Sprite
	{
		private var vWidth:int;
		private var vHeight:int;
		private var _target:Sprite;
		private var shape:Shape;
		private var dragMask:Sprite;
		private var isAutoMove:Boolean;
		public function CDrag(_w:int,_h:int,_isAutoMove:Boolean = false)
		{
			super();
			
			vWidth = _w;
			vHeight = _h;
			isAutoMove = _isAutoMove;
			
			shape = new Shape();
			shape.graphics.beginFill(0xaa0000,.3);
			shape.graphics.drawRect(0,0,vWidth,vHeight);
			shape.graphics.endFill();
			this.addChild(shape);
			
			dragMask = new Sprite();
			dragMask.graphics.beginFill(0x00cc00,0.3);
			dragMask.graphics.drawRect(0,0,vWidth,vHeight);
			dragMask.graphics.endFill();
			dragMask.visible = false;
			
		}

		public function get target():Sprite
		{
			return _target;
		}

		private var dragRect:Rectangle;
		public function set target(value:Sprite):void
		{
			_target = value;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN,startdragHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
			this.addChild(_target);
			this.addChild(dragMask);
			_target.mask = shape;
			
			if(isAutoMove)
			{
				autoMove = new AutoMove(vWidth);
				autoMove.target = _target;
				autoMove.start();
			}
		}
		private var autoMove:AutoMove;
		private var mouse_beginX:int;
		private var mouse_beginY:int;
		private var standar_dis:int = 10;
		private function startdragHandler(event:MouseEvent):void
		{
			mouse_beginX = this.mouseX;
			mouse_beginY = this.mouseY;
			
			var yy:Number = (-_target.height+vHeight)<0?(-_target.height+vHeight):0;
			var xx:Number = (-_target.width + vWidth)<0?(-_target.width + vWidth):0;
			dragRect = new Rectangle(xx,yy,(_target.width - vWidth)<0?0:(_target.width - vWidth),(_target.height-vHeight)<0?0:(_target.height-vHeight));
			_target.startDrag(false,dragRect);
			if(isAutoMove)
			{
				autoMove.stop();
			}
			
			this.addEventListener(Event.ENTER_FRAME,enterHandler);
			
		}
		private var hasAddMove:Boolean = false;
		public function enterHandler(event:Event):void
		{
			if(!hasAddMove && Math.sqrt((this.mouseX - mouse_beginX)*(this.mouseX - mouse_beginX) + (this.mouseY - mouse_beginY)*(this.mouseY - mouse_beginY)) >= standar_dis)
			{
				_target.addEventListener(MouseEvent.MOUSE_MOVE,moveOntargetHandler);
				hasAddMove = true;
			}
		}
		private function moveOntargetHandler(event:MouseEvent):void
		{
			_target.mouseChildren = _target.mouseEnabled = false;
			dragMask.addEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
			dragMask.addEventListener(MouseEvent.MOUSE_OUT,stopdragHandler);
			dragMask.visible = true;
		}
		private function stopdragHandler(event:MouseEvent):void
		{
			_target.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,enterHandler);
			if(hasAddMove)
			{
				_target.removeEventListener(MouseEvent.MOUSE_MOVE,moveOntargetHandler);
				dragMask.removeEventListener(MouseEvent.MOUSE_UP,stopdragHandler);
				dragMask.removeEventListener(MouseEvent.MOUSE_OUT,stopdragHandler);
			}
			dragMask.visible = false;
			hasAddMove = false;
			_target.mouseChildren = _target.mouseEnabled = true;
			if(isAutoMove)
			{
				autoMove.start();
			}
		}

	}
}