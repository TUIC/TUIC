package org.ntumobile.TUIC2D
{
	import flash.events.Event;
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	import id.core.TouchSprite;
	import id.core.TactualObject;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class TUICSprite extends TouchSprite
	{
		internal var _sideLength:Number;
		internal var _payloads:Array;
		internal var _value:uint;
		internal var _validPoints:Array; // first two valid points are ref points
		private var _hasRefTactualObjects:Boolean; 
			// Indicating that whether the tactual objects of reference points
			// are available. They are important when correcting the sprite's
			// position.
		
		// x, y: center position
		public function TUICSprite()
		{
			super();
			// enable multi-touch gesture analysis
			this.blobContainerEnabled = true;
		}
		public function get sideLength():Number{
			return _sideLength;
		}
		public function get payloads():Array{
			return _payloads;
		}
		public function get value():uint{
			return _value;
		}
		public function numPoints():uint{
			return validPoints.length;
		}
		public function get validPoints():Array{
			return _validPoints.slice();
		}
		internal function enableTUICSprite():void{
			// adding event listeners when the sprite
			// transforms from an overlay to a tag.
			
			this.addEventListener(GestureEvent.GESTURE_ROTATE, rotateHandler);
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			
			_hasRefTactualObjects = true;
		}
		internal static function dist(a:Object, b:Object):Number
		{
			return Math.sqrt( (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
		}
		internal static function extractMaxDistPair(points:Array):Array{
			// points: an array with objects containing x and y attributes
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
		private function rotateHandler(event:GestureEvent){
			this.rotation += event.value;
			//Console.log(this.tactualObjectManager.tactualObjects);
			  
			// use the reference points (_validPoints[0] and _validPoints[1])
			// to fix the drifting problem
			if(_hasRefTactualObjects){
				this.x = (_validPoints[0].x + _validPoints[1].x) / 2;
				this.y = (_validPoints[0].y + _validPoints[1].y) / 2;
			}
			
			this.dispatchEvent(new TUICEvent(event, TUICEvent.ROTATE));
		}
		private function dragHandler(event:GestureEvent){
			this.x += event.dx; this.y +=event.dy;
			this.dispatchEvent(new TUICEvent(event, TUICEvent.MOVE));
		}
		private function touchDownHandler(event:TouchEvent){
			// handles the sprite's own touchDown, do not propagate
			// to TUICContainerSprite
			_validPoints.push(event.tactualObject);
			
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
				trace('_hasRefTactualObjects', _hasRefTactualObjects);
			}
			
			// recalculate all points to determine the reference points.
			trace('sprite.touchDown: ' + event.tactualObject.id + ", curretTarget = " + (event.currentTarget == this) );
			event.stopImmediatePropagation();
			this.dispatchEvent(new TUICEvent(event, TUICEvent.DOWN));
		}
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