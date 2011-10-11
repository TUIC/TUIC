package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;

	/**
	* Events of a TUIC tag
	*/
	public class TUICEvent extends GestureEvent
	{
		/**
		* event fired by TUICContainer when a valid tag is put on the TUICContainer.
		* The TUICSprite representing the TUIC tag is passed though the `value' 
		* attribute of the event object.
		*/
		public static const DOWN:String = "TUIC_tagDown";
		
		/**
		* event fired by TUICSprite when all points of a tag is removed from
		* the container.
		* This event also bubbles to the TUICContainerSprite containing this sprite.
		*/
		public static const UP:String = "TUIC_tagUp";
		
		/**
		* event fired by TUICSprite when tag is moved around.
		* This event also bubbles to the TUICContainerSprite containing this sprite.
		*/
		public static const MOVE:String = "TUIC_tagMove";
		
		/**
		* event fired by TUICSprite when tag is rotated.
		* This event also bubbles to the TUICContainerSprite containing this sprite.
		*/
		public static const ROTATE:String = "TUIC_tagRotate";		
		
		/**
		* event value.
		* For TUICEvent.DOWN event this value is passed a TUICSprite representing
		* the TUIC tag.
		*/
		public var value:*;
		
		private var _originalEvent:Event;
		
		/**
		* constructor of a TUICEvent.
		* @param old_evt the original event fired by GestureWorks.
		* @param eventType a string indicating the event type.
		*/
		public function TUICEvent(old_evt:*, eventType:String)
		{
			_originalEvent = old_evt;
			
			// Initialize inherited attributes by passing old_evt's properties.
			// TUIC Events should bubble so that users can register their event
			// listeners on TUICContainerSprite.
			super(eventType, true, false, old_evt.localX, old_evt.localY, old_evt.stageX, old_evt.stageY, old_evt.relatedObject, old_evt.tactualObjects);
		}

		/**
		* the original event fired by GestureWorks.
		*/
		public function get originalEvent():Event
		{
			return _originalEvent;
		}
	}
}
