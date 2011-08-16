package 
{
	import flash.display.MovieClip;
	import id.core.Application;
	import org.ntumobile.TUIC2D.TUICContainerSprite;
	import org.ntumobile.TUIC2D.TUICSprite;
	import org.ntumobile.TUIC2D.TUICEvent;
	import flash.events.Event; // for stage.resize
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class Main extends Application
	{
		private var container:TUICContainerSprite;
		public function Main()
		{
			// extends the stage and TUICContainerSprite
			// as the window resizes.
			//
			var stage = this.stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, fillScreen);

			settingsPath = "application.xml";
		}

		override protected function initialize():void
		{
			container = new TUICContainerSprite(true);
			fillScreen();
			container.addEventListener(TUICEvent.DOWN, downHandler);
			container.addEventListener(TUICEvent.UP, debugHandler);
			container.addEventListener(TUICEvent.ROTATE, debugHandler);
			container.addEventListener(TUICEvent.MOVE, debugHandler);
			
			addChild(container);
		}
		private function downHandler(event:TUICEvent){
			var sprite = event.target;
			//sprite.graphics.lineStyle(2, 0xCCCCCC, 1);
			//sprite.graphics.drawRect(sprite.width/2, sprite.height/2, sprite.width, sprite.height);
		}
		// fills the container with the screen
		private function fillScreen(event:Event = undefined){
			// 'this' refers to main
			var stage = this.stage;
			container.graphics.clear();
			container.graphics.beginFill(0xff00ff, 1);
			container.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			container.graphics.endFill();
			
			container.resizeOverlay();
		}
		
		private function debugHandler(event:TUICEvent)
		{
			Console.log(event.type);
			drawCircleOn(event.target, 0,0);
		}
		
		private function drawCircleOn(sprite:*, x:Number, y:Number, color:uint = 0xffffff, size:Number = 20):void{
			// debugging purpose
			sprite.graphics.lineStyle(1, color, 1);
			sprite.graphics.drawCircle(x, y, size);
			sprite.graphics.beginFill(color, 1);
			sprite.graphics.drawCircle(x,y,5);
			sprite.graphics.endFill();
		}
		
		
	}

}