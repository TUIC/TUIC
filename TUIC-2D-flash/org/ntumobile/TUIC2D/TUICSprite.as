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

			event.stopPropagation();
			this.dispatchEvent(new TUICEvent(event, TUICEvent.DOWN));
		}
		private function touchUpHandler(event:TouchEvent){
			this.dispatchEvent(new TUICEvent(event, TUICEvent.UP));
		}

	}
}