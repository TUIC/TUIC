package 
{
	import flash.display.MovieClip;
	import id.core.Application;
	import org.ntumobile.TUIC2D.TUICSprite;
	import org.ntumobile.TUIC2D.TUICEvent;

	import com.actionscript_flash_guru.fireflashlite.Console;

	public class Main extends Application
	{

		public function Main()
		{
			// constructor code
			settingsPath = "application.xml";
		}

		override protected function initialize():void
		{
			var sprite = new TUICSprite();
			sprite.graphics.beginFill(0x336699);
			sprite.graphics.drawRect(0,0,400,400);
			
			sprite.addEventListener(TUICEvent.DOWN, debugHandler);
			sprite.addEventListener(TUICEvent.UP, debugHandler);
			sprite.addEventListener(TUICEvent.ROTATE, debugHandler);
			sprite.addEventListener(TUICEvent.MOVE, debugHandler);

			addChild(sprite);
		}

		private function debugHandler(event:TUICEvent)
		{
			Console.log(event);
		}
	}

}