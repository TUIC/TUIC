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
		internal var _numPoints:uint; // number of touch points
		internal var _validPoints:Array;
		
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
		public function get numPoints():uint{
			return _numPoints;
		}
		public function get validPoints():Array{
			return _validPoints.slice();
		}
		public function enableTUICEvents():void{
			// adding event listeners when the sprite
			// transforms from an overlay to a tag.
			
			this.addEventListener(GestureEvent.GESTURE_ROTATE, rotateHandler);
			this.addEventListener(GestureEvent.GESTURE_DRAG, dragHandler);
			this.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			this.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
		}
		private function rotateHandler(event:GestureEvent){
			this.rotation += event.value;
			//Console.log(this.tactualObjectManager.tactualObjects);
			  
			// use the reference points (_validPoints[0] and _validPoints[1])
			// to fix the drifting problem
			this.x = (_validPoints[0].x + _validPoints[1].x) / 2;
			this.y = (_validPoints[0].y + _validPoints[1].y) / 2;
			
			this.dispatchEvent(new TUICEvent(event, TUICEvent.ROTATE));
		}
		private function dragHandler(event:GestureEvent){
			this.x += event.dx; this.y +=event.dy;
			this.dispatchEvent(new TUICEvent(event, TUICEvent.MOVE));
		}
		private function touchDownHandler(event:TouchEvent){
			// handles the sprite's own touchDown, do not propagate
			// to TUICContainerSprite
			++_numPoints;
			
			//TODO: how about updateing the valid points?
			
			// recalculate all points to determine the reference points.
			trace('sprite.touchDown: ' + event.tactualObject.id + ", curretTarget = " + (event.currentTarget == this) );
			event.stopImmediatePropagation();
			this.dispatchEvent(new TUICEvent(event, TUICEvent.DOWN));
		}
		private function touchUpHandler(event:TouchEvent){
			trace('sprite.touchUp: ' + event.tactualObject.id);
			var pointIndex = _validPoints.indexOf(event.tactualObject);
			if(pointIndex > 1){
				// remove the point form _validPoints[] only if the removed point is not
				// one of the reference points (_validPoints[0|1])
				_validPoints.splice(pointIndex,1); 
			}else if(pointIndex == 0 || pointIndex == 1){
				// the reference point is lost.
				// TODO: Do something dude!
				
				this.dispatchEvent(new TUICEvent(event, TUICEvent.UP));
			}
			
			if(--_numPoints == 0){
				this.dispatchEvent(new TUICEvent(event, TUICEvent.UP));
			}
		}

	}
}