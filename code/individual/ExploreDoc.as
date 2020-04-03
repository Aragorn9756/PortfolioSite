package lib.survive
{
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import lib.survive.ExploreGame;
	
	public class ExploreDoc extends MovieClip
	{
		public function ExploreDoc()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createStartMenu();
		}
		
		private function createStartMenu():void
		{
			var startMenu:StartScreen = new StartScreen();//create new start screen
			
			addChild(startMenu);
			
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
			//new start button?
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			
			createGame();
		}
		
		private function createGame():void
		{
			var game:ExploreGame = new ExploreGame();
			
			addChild(game);
		}
	}
}