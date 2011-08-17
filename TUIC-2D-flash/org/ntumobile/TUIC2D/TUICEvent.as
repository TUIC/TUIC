package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICEvent extends GestureEvent
	{
		public static const DOWN:String = "TUIC_tagDown";
		public static const UP:String = "TUIC_tagUp";
		public static const MOVE:String = "TUIC_tagMove";
		public static const ROTATE:String = "TUIC_tagRotate";		
		
		public var value:*;
		private var _originalEvent:Event;
		public function TUICEvent(old_evt:*, eventType:String)
		{
			_originalEvent = old_evt;
			
			// Initialize inherited attributes by passing old_evt's properties.
			// TUIC Events should bubble so that users can register their event
			// listeners on TUICContainerSprite.
			super(eventType, true, false, old_evt.localX, old_evt.localY, old_evt.stageX, old_evt.stageY, old_evt.relatedObject, old_evt.tactualObjects);
		}

		public function get originalEvent():Event
		{
			return _originalEvent;
		}
	}
}
