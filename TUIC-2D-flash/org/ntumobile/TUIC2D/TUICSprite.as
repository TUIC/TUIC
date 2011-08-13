package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public dynamic class TUICSprite extends TouchSprite
	{
		private var _orientation:Number;
		private var _sideLength: Number;
		// x, y: center position
		public function TUICSprite(x:Number, y:Number, sideLength:uint, orientation:Number)
		{
			super();
			this.x = x - sideLength/2; this.y=y - sideLength/2;
			_sideLength = sideLength;
			_orientation = orientation;
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,sideLength,sideLength);
			this.rotation = orientation;
					
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragEventHandler);
			this.addEventListener(GestureEvent.GESTURE_ROTATE, generalHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, generalHandler);
			this.blobContainerEnabled = true;
		}
		private function generalHandler(event:Event):void
		{
			this.dispatchEvent(new TUICEvent(event));
		}
		private function dragEventHandler(event:GestureEvent):void
    	{
			trace("n point drag", event.dx,event.dy);
			this.x += event.dx; this.y +=event.dy;
    	}
		private function touchDownHandler(event:TouchEvent):void{
			event.stopPropagation();
		}
		public function get orientation(){
			return _orientation;
		}
		public function get sideLength(){
			return _sideLength;
		}
		
	}
}