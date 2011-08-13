package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public dynamic class TUICSprite extends TouchSprite
	{
		// x, y: center position
		public function TUICSprite()
		{
			super();
			// enable multi-touch gesture analysis
			this.blobContainerEnabled = true;
		}
		public function enableTUICEvents():void{
			// adding event listeners when the sprite
			// transforms from an overlay to a tag.
			
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragEventHandler);
			this.addEventListener(GestureEvent.GESTURE_ROTATE, generalHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, generalHandler);		
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
			// handles the sprite's own touchDown, do not propagate
			// to TUICContainerSprite
			//Console.log(event);
			event.stopPropagation();
		}
	}
}