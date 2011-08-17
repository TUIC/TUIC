package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICSprite extends TouchSprite
	{
		internal var _sideLength:Number;
		internal var _payloads:Array;
		internal var _value:uint;
		internal var _numPoints:uint; // number of touch points
		
		// x, y: center position
		public function TUICSprite()
		{
			super();
			// enable multi-touch gesture analysis
			this.blobContainerEnabled = true;
		}
		public function get sideLength():Number{
			return _sideLength;
		}
		public function get payloads():Array{
			return _payloads;
		}
		public function get value():uint{
			return _value;
		}
		public function get numPoints():uint{
			return _numPoints;
		}
		public function enableTUICEvents():void{
			// adding event listeners when the sprite
			// transforms from an overlay to a tag.
			
			this.addEventListener(GestureEvent.GESTURE_ROTATE, rotateHandler);
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
		}
		private function rotateHandler(event:GestureEvent){
			this.rotation += event.value;
			this.dispatchEvent(new TUICEvent(event, TUICEvent.ROTATE));
		}
		private function dragHandler(event:GestureEvent){
			this.x += event.dx; this.y +=event.dy;
			this.dispatchEvent(new TUICEvent(event, TUICEvent.MOVE));
		}
		private function touchDownHandler(event:TouchEvent){
			// handles the sprite's own touchDown, do not propagate
			// to TUICContainerSprite
			++_numPoints;
			event.stopPropagation();
			this.dispatchEvent(new TUICEvent(event, TUICEvent.DOWN));
		}
		private function touchUpHandler(event:TouchEvent){
			trace('numPoints:', _numPoints);
			if(--_numPoints == 0){
				this.dispatchEvent(new TUICEvent(event, TUICEvent.UP));
			}
		}

	}
}