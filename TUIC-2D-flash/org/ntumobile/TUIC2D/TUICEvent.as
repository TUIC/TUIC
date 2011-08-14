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
		
		public var value:*;
		private var _originalEvent:Event;
		public function TUICEvent(old_evt:Event, eventType:String)
		{
			_originalEvent = old_evt;
			
			// TUIC Events should bubble so that users can register 
			// their event listeners on TUICContainerSprite.
			super(eventType, true);
		}

		public function get originalEvent():Event
		{
			return _originalEvent;
		}
	}
}
