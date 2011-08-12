package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICSprite extends TouchSprite
	{
		public function TUICSprite()
		{
			super();
			this.addEventListener(GestureEvent.GESTURE_DRAG, generalHandler);
			this.addEventListener(GestureEvent.GESTURE_ROTATE, generalHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, generalHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, generalHandler);
		}
		private function generalHandler(event:Event)
		{
			this.dispatchEvent(new TUICEvent(event));
		}

	}


}