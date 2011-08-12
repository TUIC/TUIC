package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICEvent extends Event
	{
		public static const DOWN:String = "TUIC_tagDown";
		public static const UP:String = "TUIC_tagUp";
		public static const MOVE:String = "TUIC_tagMove";
		public static const ROTATE:String = "TUIC_tagRotate";		
		
		private var _originalEvent:Event;
		public function TUICEvent(old_evt:Event)
		{
			_originalEvent = old_evt;
			var eventType = determineEventType(old_evt);
			super(eventType);
		}

		public function get originalEvent():Event
		{
			return _originalEvent;
		}

		private function determineEventType(old_evt:Event):String
		{
			switch (old_evt.type)
			{
				case GestureEvent.GESTURE_DRAG :
					return MOVE;
				case TouchEvent.TOUCH_DOWN :
					return DOWN;
				case TouchEvent.TOUCH_UP :
					return UP;
				case GestureEvent.GESTURE_ROTATE :
					return ROTATE;
				default :
					throw new Error("Unsupported event type");
			}
		}
	}

}