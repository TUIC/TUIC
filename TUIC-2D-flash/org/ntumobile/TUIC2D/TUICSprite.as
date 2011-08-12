package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICSprite extends TouchSprite
	{
		private var _orientation:Number;
		public function TUICSprite()
		{
			super();
			
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragEventHandler);
			this.addEventListener(GestureEvent.GESTURE_ROTATE, generalHandler);
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
    	}    

	}


}