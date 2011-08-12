package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICContainerSprite extends TouchSprite
	{

		private var _touchThreshold:Number = 1;
		// time threshold for all points to be detected on screen, in seconds

		private var _newPointTimeoutHandler:uint;
		private var _touchDownEvents:Array;

		public function TUICContainerSprite()
		{
			super();
			_touchDownEvents = [];
			this.addEventListener(TouchEvent.TOUCH_DOWN, newPointHandler);
		}
		private function newPointHandler(event:Event):void
		{
			clearTimeout(_newPointTimeoutHandler);
			_touchDownEvents.push(event);
			_newPointTimeoutHandler = setTimeout(newSpriteHandler,_touchThreshold * 1000);
		}
		private function newSpriteHandler():void
		{
			// extract points from the events collected in the last _touchThreshold seconds.
			var points = _touchDownEvents.map(function(event:TouchEvent, index:int, arr:Array):Object{
			return {x: event.localX, y:event.localY};
			});

			// create TUICEvent and the TUIC tag.
			var event = new TUICEvent(_touchDownEvents[0]);
			_touchDownEvents = [];// FIXME: is AS GC aggresive enough to collect this?
			event.value = createTag(points);

			if (event.value !== null)
			{
				this.dispatchEvent(new TUICEvent(event));
			}
		}
		private function createTag(points:Array):TUICSprite
		{
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

	}

}