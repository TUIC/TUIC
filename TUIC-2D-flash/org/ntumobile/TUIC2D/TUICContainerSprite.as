package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICContainerSprite extends TUICSprite
	{

		private var _touchThreshold:Number = 1;
		// time threshold for all points to be detected on screen, in seconds

		private var _newPointTimeoutHandler:uint;
		private var _touchDownEvents:Array;
		private var _overlay:TUICSprite;
		public function TUICContainerSprite()
		{
			super();
			// initialize private variables
			_touchDownEvents = [];
		}
		override protected function initialize():void
		{
			// set dimensions and listeners
			addChild(makeOverlay());
		}
		private function newPointHandler(event:Event):void
		{
			clearTimeout(_newPointTimeoutHandler);
			_touchDownEvents.push(event);
			_newPointTimeoutHandler = setTimeout(newTagHandler,_touchThreshold * 1000);
		}
		private function newTagHandler():void
		{
			// extract points from the events collected in the last _touchThreshold seconds.
			var points = _touchDownEvents.map(function(event:TouchEvent, index:int, arr:Array):Object{
				return {x: event.localX, y:event.localY};
			});

			// validate tag
			var tag:Object = calcTag(points);
			if (! tag.valid)
			{
				return;
			}

			// create TUICEvent and the TUIC tag.
			var event = new TUICEvent(_touchDownEvents[0], TUICEvent.DOWN);
			// FIXME: localX and localY of the event should be changed after we figure out 
			// assign old overlay to event.value and make a new overlay.
			event.value = _overlay; // save the old overlay into event.value
			this.addChild(makeOverlay());
			this.setChildIndex(_overlay, 0); // push the new layout to bottom
			
			// resize the old overlay to the size of a TUIC tag.
			event.value.x = tag.x - tag.side / 2;
			event.value.y = tag.y - tag.side / 2;
			event.value.graphics.clear();
			event.value.graphics.beginFill(0x000000);
			event.value.graphics.drawRect(0,0,tag.side,tag.side);
			event.value.graphics.endFill();
			event.value.removeEventListener(TouchEvent.TOUCH_DOWN, newPointHandler);
			// only currently active overlay needs this event listener.
			event.value.enableTUICEvents();
			
			// dispatch the event so that the sprite(old overlay) is available;
			// to the developers.
			this.dispatchEvent(event);

			// cleanup
			_touchDownEvents = [];// FIXME: is AS GC aggresive enough to collect this?
		}
		private function makeOverlay():TUICSprite
		{
			// this modifies _overlay property
			
			_overlay = new TUICSprite();
			_overlay.graphics.beginFill(0xff00ff,1);
			_overlay.graphics.drawRect(0,0,width,height);
			_overlay.graphics.endFill();
			_overlay.addEventListener(TouchEvent.TOUCH_DOWN, newPointHandler);
			
			return _overlay;
		}

		private function calcTag(points:Array):Object
		{
			// TODO: finish this from createTag code
			return {
				valid:true,
				x: (points[0]).x,
				y: (points[0]).y,
				side: 50
			};
		}
		private function createTag(points:Array):TUICSprite
		{
			// TODO: this is obsolete now.
			var point:Object = points[0];
			return new TUICSprite();
			//-----

			// test if the points form a valid TUIC tag, and
			// create a TUICSprite when a new tag is found.

			// step0: basic point number check
			if (points.length < 3)
			{
				return null;
			}

			// step1: find max distance pair.
			//        these are diagonal reference points.
			var ref_points:Array,maxDist:Number = 0;

			for (var i:uint = 0; i < points.length - 1; ++i)
			{
				for (var j:uint=i; j<points.length; ++j)
				{
					var d:Number = dist(points[i],points[j]);
					if (d > maxDist)
					{
						maxDist = d;
						ref_points = [points[i],points[j]];
					}
				}
			}
			// remove reference points out of points[]
			points = points.filter(function(elem:Object, i:int, arr:Array):Boolean{
			return !( elem === ref_points[0] || elem === ref_points[1] );
			});

			// step2: find the third reference points
			//        this reference point determines the orientation of the tag

			return null;

		}
		private function dist(a:Object, b:Object):Number
		{
			return Math.sqrt( (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
		}

		private function debugHandler(event:Event)
		{
			Console.log(event);
		}
	}
}