package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;
	import id.core.TactualObject;

	import com.actionscript_flash_guru.fireflashlite.Console;

	/**
	* a sprite that acts as a TUIC tag.
	* A new TUICSprite is created by TUICContainerSprite whenever a new TUIC tag
	* is detected.
	*/
	public class TUICSprite extends TouchSprite
	{
		// side length of the tag
		internal var _sideLength:Number;
		
		// payload bits of tha tag, an array of 1's and 0's, indicating each bit.
		internal var _payloads:Array;
		
		// integer value of payload bits.
		internal var _value:uint;
		
		// array of valid points.
		// First two valid points are ref points
		internal var _validPoints:Array; 
		
		// a boolean valueindicating that whether the tactual objects of reference 
		// points are available. They are important when correcting the sprite's
		// position.
		private var _hasRefTactualObjects:Boolean; 
			
		/**
		* constructor of TUICSprite.
		*/
		public function TUICSprite()
		{
			super();
			
			// enable multi-touch gesture analysis
			this.blobContainerEnabled = true;
		}
		
		/**
		* side length of the tag.
		*/
		public function get sideLength():Number{
			return _sideLength;
		}
		
		/**
		* payload array
		*/
		public function get payloads():Array{
			return _payloads;
		}
		
		/**
		* integer value of payload bits
		*/
		public function get value():uint{
			return _value;
		}
		
		/**
		* copy of _validPoints array
		*/
		public function get validPoints():Array{
			return _validPoints.slice();
		}
		
		/**
		* adding event listeners when this sprite changes from an overlay to a tag
		*/
		internal function enableTUICSprite():void{

			this.addEventListener(GestureEvent.GESTURE_ROTATE, rotateHandler);
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			
			_hasRefTactualObjects = true;
		}
		
		/**
		* calculates the distance of two points
		*/
		internal static function dist(a:Object, b:Object):Number
		{
			return Math.sqrt( (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
		}
		
		/**
		* extracts the two furthest points from the given points array.
		* @param points array of points to evaluate. The two furthest points
		*               will be removed from this array.
		*
		* @return the two furthest points
		*/
		internal static function extractMaxDistPair(points:Array):Array{
			var refPoints:Array, maxDist:Number = 0, deli:uint, delj:uint;

			for (var i:uint=0; i<points.length-1; ++i)
			{
				for (var j:uint=i; j<points.length; ++j)
				{
					var d:Number = dist(points[i],points[j]);
					if (d > maxDist)
					{
						maxDist = d;
						refPoints = [points[i],points[j]];
						deli = i; delj = j;
					}
				}
			}
			
			// remove the found refPoints from points[]
			// notice that j>i so we should delete points[j] first
			points.splice(delj,1); points.splice(deli,1);
			
			return refPoints;
		}
		
		/**
		* number of tactual points in the sprite
		*/
		public function numPoints():uint{
			return validPoints.length;
		}
		
		/**
		* @private
		* rotates the sprite and fires TUICEvent.ROTATE.
		*/
		private function rotateHandler(event:GestureEvent){
			this.rotation += event.value;
			//Console.log(this.tactualObjectManager.tactualObjects);
			  
			// use the reference points (_validPoints[0] and _validPoints[1])
			// to fix the position drifting problem
			if(_hasRefTactualObjects){
				this.x = (_validPoints[0].x + _validPoints[1].x) / 2;
				this.y = (_validPoints[0].y + _validPoints[1].y) / 2;
			}
			
			this.dispatchEvent(new TUICEvent(event, TUICEvent.ROTATE));
		}
		
		/**
		* @private
		* moves the sprite as the tag is dragged around.
		* This fires TUICEvent.MOVE
		*/
		private function dragHandler(event:GestureEvent){
			this.x += event.dx; this.y +=event.dy;
			this.dispatchEvent(new TUICEvent(event, TUICEvent.MOVE));
		}
		
		/**
		* @private
		* handles the situation that a point is returned on the tag.
		*/
		private function touchDownHandler(event:TouchEvent){
			// handles the sprite's own touchDown, do not propagate
			// to TUICContainerSprite
			_validPoints.push(event.tactualObject);
			
			// If reference points are lifted, check whether the reference
			// points return to the tag.
			if(!_hasRefTactualObjects){
				var refPoints = extractMaxDistPair(_validPoints),
				    maxDist = dist(refPoints[0], refPoints[1]),
					legalMaxDist = Math.SQRT2 * _sideLength;
					
				// put the extracted ref points back into _validPoints[]
				_validPoints = refPoints.concat(_validPoints);
				
				// if the found max-dist pair has a desirable distance
				if( maxDist > legalMaxDist*7/8 && 
				    maxDist < legalMaxDist*9/8 ){
					_hasRefTactualObjects = true;
				}
			}
			
			trace('sprite.touchDown: ' + event.tactualObject.id + ", curretTarget = " + (event.currentTarget == this) );
			
			// prevent this event to propagate to TUICContainerSprite.
			event.stopImmediatePropagation();
		}
		
		/**
		* @private
		* removes points from _validPoints[] when a point is lifted
		* If all points on a tag are lifted, TUICEvent.UP is fired.
		*/
		private function touchUpHandler(event:TouchEvent){
			trace('sprite.touchUp: ' + event.tactualObject.id);
			var pointIndex = _validPoints.indexOf(event.tactualObject);
			if(pointIndex > -1){
				// remove the point form _validPoints[] only if the removed point is not
				// one of the reference points (_validPoints[0|1])
				_validPoints.splice(pointIndex,1); 
				
				if(pointIndex == 0 || pointIndex == 1){
					// the reference point is lost.
					_hasRefTactualObjects = false;
				}
			}
			
			if(numPoints() == 0){
				this.dispatchEvent(new TUICEvent(event, TUICEvent.UP));
			}
		}
		
	}
}