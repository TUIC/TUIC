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
	import id.core.ITactualObject;

	public class TUICContainerSprite extends TUICSprite
	{

		private var _touchThreshold:Number = 50;
		// time threshold for all points to be detected on screen, in milliseconds

		private var _newTagTimeoutHandler:uint;
		private var _isolatedPoints:Object;
		// isolated touch points that is not mapped to a TUIC tag yet
		// in a form of tactualObject id->Point map.

		private var _overlay:TUICSprite;
		private var _spriteAlpha:Number;
		public function TUICContainerSprite(sideLength:Number = 0, debug:Boolean = false)
		{
			super();

			// sideLength: target tag side length. If 0, side length is unlimited.
			_sideLength = sideLength;
			_spriteAlpha = debug ? 1:0;
			// initialize private variables
			_isolatedPoints = {};
		}
		override protected function initialize():void
		{
			// set dimensions and listeners
			addChild(makeOverlay());
		}

		// Extends the overlay to be the same size as the container.
		// If the overlay is not yet constructed, this function does nothing.
		public function resizeOverlay():void
		{
			if (_overlay)
			{
				_overlay.graphics.copyFrom(this.graphics);
			}
		}

		/*private function newPointHandler(event:Event):void
		{
		clearTimeout(_newPointTimeoutHandler);
		_touchDownEvents.push(event);
		_newPointTimeoutHandler = setTimeout(newTagHandler,_touchThreshold * 1000);
		}*/
		private function newTagHandler():void
		{
			// validate tag
			var tag:Object = calcTag();
			if (tag.valid)
			{
				tag.validPoints.forEach(function(point:Object, index:int, arr:Array){
					delete _isolatedPoints[point.id];
				});
			}
			else
			{// invalid tag
				return;// abort this handler
			}

			// create TUICEvent and the TUIC tag.
			var newEvent = new TUICEvent(new TouchEvent(TouchEvent.TOUCH_DOWN), TUICEvent.DOWN),
			oldOverlay = _overlay;// save the old overlay
			// FIXME: localX and localY of the event should be changed after we figure out 
			// assign old overlay to oldOverlay and make a new overlay.
			this.addChild(makeOverlay());
			this.setChildIndex(_overlay, 0);
			// push the new layout to bottom;

			// resize the old overlay to the size of a TUIC tag.
			/*
			   Coordinates of a TUIC tag sprite:
			   
			(-tag.side/2, -tag.side/2) O----------------O (tag.side/2, -tag.side/2)
			                           |                |
			                           |                |
			                           |                |
			                           |     (0,0)      |  O: Reference points.
			                           |                |     The one on the top left
			                           |                |     determines the orientation
			                           |                |     of the tag.
			 (-tag.side/2, tag.side/2) O----------------/  
			                                                                            */

			var side = tag.side * 5 / 4;// enlarge the side by 5/4
			oldOverlay.x = tag.x;
			oldOverlay.y = tag.y;
			oldOverlay.rotation = 135 - tag.orientation;
			//oldOverlay.orientation = tag.orientation;
			oldOverlay._sideLength = tag.side;
			oldOverlay._value = tag.value;
			oldOverlay._payloads = tag.payloads;
			oldOverlay._validPoints = tag.validPoints;
			oldOverlay.graphics.clear();

			oldOverlay.graphics.beginFill(0x000000, _spriteAlpha);
			oldOverlay.graphics.drawRect(-side/2, -side/2,side, side);
			oldOverlay.graphics.beginFill(0xffffff, _spriteAlpha);
			oldOverlay.graphics.drawRect(-side/2, -side/2, side/4, side/4);
			oldOverlay.graphics.endFill();

			// only currently active overlay needs this event listener.;
			// since oldOverlay is becoming a new TUIC tag, it cannot be bound with
			// this handler anymore.
			oldOverlay.removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			oldOverlay.removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);

			oldOverlay.enableTUICSprite();

			newEvent.value = oldOverlay;
			// dispatch the event so that the sprite(old overlay) is available;
			// to the developers.
			this.dispatchEvent(newEvent);

			// cleanup
			//_touchDownEvents = [];// FIXME: is AS GC aggresive enough to collect this?
		}


		private function calcTag():Object
		{
			// test if the points form a valid TUIC tag.
			// If the points form a valud TUIC tag, the information of
			// the tag is calculated and returned.
			var ret:Object = {validPoints:[]},points:Array = [];
			/*
			returned tag object:
			{
				valid: Boolean, // whether the tag is valid or not
				side: Number,   // side length of th tag
				orientation:Number, // orientation of the tag in degrees,
									// left horizon = 0
				x:Number,			// center x coordinate
				y:Number,			// center y coordinate
				payloads:Array(n),  // payloads of n-bit TUIC tag
				value:uint	// payloads represented in decimal value
							// (p[0]p[1]....p[n])_2
				validPoints:Array // array of valid touch points as TactualObjects
			}
			*/

			// step0: basic point number check
			for each (var point in _isolatedPoints)
			{
				points.push(point);
			}
			if (points.length < 3)
			{
				ret.valid = false;
				return ret;
			}

			// step1: find max distance pair.
			//        these are diagonal reference points.
			//
			var refPoints = extractMaxDistPair(points),
			    maxDist = dist(refPoints[0], refPoints[1]);
			
			if (refPoints[0].y > refPoints[1].y)
			{
				// keep refPoints[0] 'higher' than refPoints[1]
				var tmp = refPoints[0];
				refPoints[0] = refPoints[1];
				refPoints[1] = tmp;
			}
			// calculate center of the tag
			ret = midPointOf(refPoints[0],refPoints[1]);
			ret.side = Math.SQRT2 / 2 * maxDist;

			// side length filter
			// tolerance = 1/10 * sideLength (5 bits per side for 9-bit TUIC tag)
			if (_sideLength !== 0 && 
			   !(0.9*_sideLength < ret.side && ret.side < 1.1*_sideLength) )
			{
				trace('invalid side length:', ret.side);
				ret.valid = false;
				return ret;
			}

			ret.validPoints = [refPoints[0],refPoints[1]];

			// step2: Create the possible position of third reference points and the 
			//        payload bits.
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
			-------+----------------- Horizon
			       refPoints[1]                                                      */

			var possibleRefPoints:Array,
				possiblePayloads:Array,
				dy:Number = ret.y - refPoints[0].y, 
				dx:Number = refPoints[0].x - ret.x,
				theta = 180 * Math.atan(dy/dx) / Math.PI;// in degrees
			if (dx<0)
			{
				// refPoints[0] is the higher one so dy is always > 0
				// thus dx < 0 indicates refPoints[0]-refPoints[1] forms
				// a negative-sloped line.
				// For negative sloped line Math.atan gives negative angles.
				// We want to normalize it so it matches the figure above
				// for simplicity.
				theta +=  180;
			}

			// For positive-sloped lines,
			// possibleRefPoint[0] is the ref point above the line;
			// For negative-sloped lines,
			// possible_ref_point[1] is the ref point below the line;
			possibleRefPoints = [
				{ x: ret.x - dy, y: ret.y - dx },
				{ x: ret.x + dy, y: ret.y + dx }
			];

			possiblePayloads = makePossiblePayloads({x:dx / 2,y:dy / 2},ret);

			var toleranceRadius:Number = ret.side / 8;
			// TODO: this is for 9-bit TUIC tag.
			// for 4-bit TUIC tags, the tolerance radius should be ret.side / 6

			ret.valid = false;// used as a flag here 

			/*
			drawCircle(possibleRefPoints[0], 0x0000ff, toleranceRadius);
			drawCircle(possibleRefPoints[1], 0x00ff00, toleranceRadius);
			var debugColor:uint = 0x000000;
			for each(var point in possiblePayloads){
			drawCircle(point, debugColor, toleranceRadius);
			debugColor += 0x181818;
			}
			//*/

			// Step 3: Find the third reference & payloads by testing points against
			//        the tolerance radius one-by-one.
			//        The third reference point determines the orientation of the tag,
			//        as well as the index of payload bits
			//

			var reverseBits:Boolean = false, 
			numPoints = 3;// there must be 3 ref points for valid tags
			ret.payloads = [0,0,0,0,0,0,0,0,0];// TODO: 4-bit TUIC support

			points.forEach(function(point:Object, index:int, arr:Array){
				if( dist(point, possibleRefPoints[0]) < toleranceRadius ){
					ret.orientation = theta + 90;
					ret.validPoints.push(point);
					reverseBits = true;
					ret.valid = true;
				}else if(dist(point, possibleRefPoints[1]) < toleranceRadius){
					ret.orientation = theta + 270;
					ret.validPoints.push(point);
					ret.valid = true;
				}else{ // not in the two possible ref point area
					// test if the point is a payload bit
					possiblePayloads.every(
					function(possiblePayload:Object, index:int, arr:Array){
						if(dist(point, possiblePayload) < toleranceRadius){
							// payload bit found.
							ret.payloads[index] = 1;
							ret.validPoints.push(point);
							++numPoints;
							// stop this for-loop
							return false; 
						}
						return true;
					});
				}
			});

			if (ret.valid)
			{// the third ref point is successfully found
				ret.orientation %= 360;
				if (reverseBits)
				{
					ret.payloads.reverse();
				}
					ret.value = 0;
					ret.numPoints = numPoints;
					ret.payloads.forEach(function(payload:int, index:int, arr:Array){
					ret.value = ret.value * 2 + payload;
				});
				//refPoints.push(points[index]); // insert the new ref point;
				// points.splice(index,1); // remove the ref point from points[]
			}

			//Console.log(ret);
			//ret.valid=false;
			return ret;
		}
		private function touchDownHandler(event:TouchEvent)
		{
			_isolatedPoints[event.tactualObject.id] = event.tactualObject;
			trace('container.touchDown: ' + event.tactualObject.id + ", curretTarget = " + (event.currentTarget == this) );
			clearTimeout(_newTagTimeoutHandler);
			_newTagTimeoutHandler = setTimeout(newTagHandler,_touchThreshold);
		}
		private function touchUpHandler(event:TouchEvent)
		{
			trace('container.touchUp: ' + event.tactualObject.id);
			delete _isolatedPoints[event.tactualObject.id];
		}

		private function makeOverlay():TUICSprite
		{
			// this modifies _overlay property

			_overlay = new TUICSprite();
			resizeOverlay();

			_overlay.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			_overlay.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);

			return _overlay;
		}

		private function makePossiblePayloads(payloadVec:Object, ret:Object):Array
		{
			// ret: the tag returned by calcTag.
			/*           * refPoint[0]
			           ↗- payloadVec <dx/2, dy/2>
			    0  1  2
			        ↗
			    3  4  5
			        `(ret.x, ret.y)
			    6  7  8                     #: possiblePayloads
			
			 * 
			 refPoint[1]
			*/
			var possiblePayloads = [ // FIXME: 9-bit only. And this IS ugly.
				{ x: ret.x - payloadVec.y, y: ret.y - payloadVec.x},
				{},
				{ x: ret.x + payloadVec.x, y: ret.y - payloadVec.y},
				{},
				{ x: ret.x, y: ret.y},
				{},
				{ x: ret.x - payloadVec.x, y: ret.y + payloadVec.y},
				{},
				{x: ret.x + payloadVec.y, y: ret.y + payloadVec.x}
			];
			possiblePayloads[1] = midPointOf(possiblePayloads[0],possiblePayloads[2]);
			possiblePayloads[3] = midPointOf(possiblePayloads[0],possiblePayloads[6]);
			possiblePayloads[5] = midPointOf(possiblePayloads[2],possiblePayloads[8]);
			possiblePayloads[7] = midPointOf(possiblePayloads[6],possiblePayloads[8]);

			return possiblePayloads;
		}

		private function midPointOf(a:Object, b:Object):Object
		{
			return {
				x: 0.5 * (a.x + b.x),
				y: 0.5 * (a.y + b.y)
			};
		}

		private function drawCircle(point:Object, color:uint = 0xffffff, size:Number = 20):void
		{
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