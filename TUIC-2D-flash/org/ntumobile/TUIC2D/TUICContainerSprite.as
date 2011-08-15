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
				_touchDownEvents = [];// FIXME: is AS GC aggresive enough to collect this?
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
			event.value.graphics.beginFill(0x000000, 0);
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


		private function calcTag(points:Array):Object
		{
			// test if the points form a valid TUIC tag.
			// If the points form a valud TUIC tag, the information of
			// the tag is calculated and returned.
			var ret:Object = {};
			
			// step0: basic point number check
			if (points.length < 3)
			{
				ret.valid = false;
				return ret;
			}
			
			// step1: find max distance pair.
			//        these are diagonal reference points.
			//
			var refPoints:Array, maxDist:Number = 0;

			for (var i:uint = 0; i < points.length - 1; ++i)
			{
				for (var j:uint=i; j<points.length; ++j)
				{
					var d:Number = dist(points[i],points[j]);
					if (d > maxDist)
					{
						maxDist = d;
						refPoints = [points[i],points[j]];
					}
				}
			}
			
			// remove reference points out of points[]
			points = points.filter(function(elem:Object, i:int, arr:Array):Boolean{
				return !( elem === refPoints[0] || elem === refPoints[1] );
			});
			if(refPoints[0].y > refPoints[1].y){ 
				// keep refPoints[0] 'higher' than refPoints[1]
				var tmp = refPoints[0]; refPoints[0] = refPoints[1]; refPoints[1] = tmp;
			}
			// calculate center of the tag
			ret.x = (refPoints[0].x + refPoints[1].x)/2;
			ret.y = (refPoints[0].y + refPoints[1].y)/2;
			ret.side = Math.SQRT2 / 2 * maxDist;

			// step2: find the third reference points.
			//        this reference point determines the orientation of the tag.
			//
			/*               refPoints[0]
			   ret.side . `/ 
			       . `    /
			A . `        /    A-refPoints[0]-refPoints[1] is a 45-45-90 Right Triangle
			  \         /     We wish to test whether point A is also touched down.
			   \       /` .   
			    \     /     ` (ret.x, ret.y)
				 \   /        
				  \ / theta
			------------------------- Horizon
			       refPoints[1]                                                      */
			
			var possibleRefPoints:Array,
				dy:Number = ret.y - refPoints[0].y, 
				dx:Number = refPoints[0].x - ret.x,
				theta = 180 * Math.atan(dy/dx) / Math.PI; // in degrees
			if(dx<0){ 
				// refPoints[0] is the higher one so dy is always > 0
				// thus dx < 0 indicates refPoints[0]-refPoints[1] forms
				// a negative-sloped line.
				// For negative sloped line Math.atan gives negative angles.
				// We want to normalize it so it matches the figure above
				// for simplicity.
				theta += 180;
			}
			Console.log("(dy,dx): ", dy,dx);
			Console.log("Theta: ", theta);
			
			// For positive-sloped lines,
			// possibleRefPoint[0] is the ref point above the line;
			// For negative-sloped lines,
			// possible_ref_point[1] is the ref point below the line;
			possibleRefPoints = [
				{ x: ret.x - dy, y: ret.y - dx },
				{ x: ret.x + dy, y: ret.y + dx }
			];
						
			var toleranceRadius:Number = ret.side * Math.SQRT2 / 4, index:String;
			// TODO: this is for 9-bit TUIC tag.
			// for 4-bit TUIC tags, the tolerance radius should be ret.side*sqrt(2)/3

			ret.valid = false; // used as a flag here 

			drawCircle(possibleRefPoints[0], 0x0000ff, toleranceRadius);
			drawCircle(possibleRefPoints[1], 0x00ff00, toleranceRadius);

			// actually find third refPoint
			// by testing which point is within the tolerance radius one-by-one
			for (index in points){
				if( dist(points[index], possibleRefPoints[0]) < toleranceRadius ){
					ret.orientation = theta + 90;
					ret.valid = true;
					break;
				}else if(dist(points[index], possibleRefPoints[1]) < toleranceRadius){
					ret.orientation = theta + 270;
					ret.valid = true;
					break;
				}
			}
			if(ret.valid){
				ret.orientation %= 360; 
				refPoints.push(points[index]); // insert the new ref point
				points.splice(index,1); // remove the ref point from points[]
			}else{	// no third point is found
				return ret;
			}
			
			// step 3: detemine the payload bits
			//
			Console.log(ret);
			ret.valid=false;
			return ret;
		}
		private function dist(a:Object, b:Object):Number
		{
			return Math.sqrt( (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
		}
		
		private function drawCircle(point:Object, color:uint = 0xffffff, size:Number = 20):void{
			// debugging purpose
			_overlay.graphics.lineStyle(1, color, 1);
			_overlay.graphics.drawCircle(point.x, point.y, size);
			
		}
		private function debugHandler(event:Event)
		{
			Console.log(event);
		}
	}
}