package 
{
	// GestureWorks dependency
	import id.core.Application;
	
	// TUIC2D libraries
	import org.ntumobile.TUIC2D.TUICContainerSprite;
	import org.ntumobile.TUIC2D.TUICSprite;
	import org.ntumobile.TUIC2D.TUICEvent;
	
	// below are for resizing the stages or drawing within this demo
	import flash.events.Event; 
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.GradientType;
	import flash.geom.Matrix;

	// the entry point of the applicatoin.
	// This is the same as any GestureWorks application.
	public class Main extends Application
	{
		private var container:TUICContainerSprite;
		
		/**
		* constructor of Main
		* Since GestureWorks is not ready here, we can just set the properties
		* about stages here.
		*/
		public function Main()
		{
			// extends the stage and TUICContainerSprite
			// as the window resizes.
			//
			var stage = this.stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, fillScreen);

			// set xml path for GestureWorks
			settingsPath = "application.xml";
		}

		// initialize method of TUICEvent
		override protected function initialize():void
		{
			// create a container sprite and binds the event listeners
			container = new TUICContainerSprite(0);
			container.addEventListener(TUICEvent.DOWN, downHandler);
			container.addEventListener(TUICEvent.UP, upHandler);
			container.addEventListener(TUICEvent.ROTATE, rotateHandler);
			container.addEventListener(TUICEvent.MOVE, moveHandler);
			
			// make the container fills the screen and append it to the stage
			fillScreen();
			addChild(container);
		}
		private function downHandler(event:TUICEvent){
			// get the new tag from event.value
			var sprite = event.value; 
			drawSprite(sprite);
		}
		
		private function upHandler(event:TUICEvent){
			// since TUICEvent.UP is fired from the TUICSprite,
			// event.target refers to the TUICSprite.
			var sprite = event.target;
			
			// the decision of whether to remove the TUICSprite is left to the
			// developer. Here we decide to remove the sprite.
			container.removeChild(sprite);
		}
		
		private function rotateHandler(event:TUICEvent){
			// since TUICEvent.ROTATE is fired from the TUICSprite,
			// event.target refers to the TUICSprite.
			var sprite = event.target;
		}
		
		private function moveHandler(event:TUICEvent){
			// since TUICEvent.MOVE is fired from the TUICSprite,
			// event.target refers to the TUICSprite.
			var sprite = event.target;
		}
		
		private function drawSprite(sprite:TUICSprite){
			// in this demo, we draw a circle around the generated sprite.
			// Notice that for sprite, coordinate (0,0) is its center.
			// We can retrive the side length of the sprite via its sideLength method.
			var side = sprite.sideLength * 1.1;
			
			sprite.graphics.lineStyle(20, 0xffffff, 0.5);
			sprite.graphics.drawCircle(0,0, Math.SQRT2*side/2);
			
			sprite.graphics.lineStyle(1, 0x0, 0.2);
			sprite.graphics.beginFill(0xffffff, 0.7);
			sprite.graphics.drawCircle(-side/2, -side/2, 7);
			sprite.graphics.endFill();
			
			trace('New tag value: ', sprite.value);
			trace('New tag side length: ', sprite.sideLength);
		}
		// fills in the TUICContainerSprite so that its size 
		// matches the stage size.
		private function fillScreen(event:Event = undefined){
			var stage = this.stage, w = stage.stageWidth, h = stage.stageHeight,
			    m:Matrix = new Matrix;
			m.createGradientBox(w, h, 0);
			container.graphics.clear();
			container.graphics.beginGradientFill(GradientType.RADIAL, 
												 [0xeeeeee, 0xcccccc], [1, 1], [0, 255],
												 m );
			container.graphics.drawRect(0,0,w,h);
			container.graphics.endFill();
			
			// Notice that after we MUST call the container's resizeOverlay method
			// to resize the container's overlay !!
			container.resizeOverlay();
		}
	}
}