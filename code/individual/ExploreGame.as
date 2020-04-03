package lib.survive
{
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.MovieClip
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import lib.survive.Player;
	import lib.survive.Particle;
	import com.adobe.tvsdk.mediacore.TextFormat;
	
	public class ExploreGame extends MovieClip
	{
		private var bullets:Array;
		private var turrets:Array;
		private var touchLayer:Sprite;
		private var background:Sprite;
		private var player:Player;
		private var particlesLayer:Sprite;
		private var turretsLayer:Sprite;
		private var splodeSpread:Number;
		private var splodeNum:Number;
		private var turretsNum:int;
		private var score:Number;
		private var gameScore:TextField;
		
		public function ExploreGame()
		{
			turretsNum = 10;
			splodeSpread = 0.5;
			splodeNum = 2;
			makeLevelOne();
			
			bullets = new Array();
			
			addEventListener(Event.ENTER_FRAME, update);
			
			touchLayer = new Sprite();
			
			addChild(touchLayer);
			addEventListener(Event.ADDED_TO_STAGE, setupTouchLayer);
			touchLayer.addEventListener(MouseEvent.MOUSE_DOWN, startFiring);
			touchLayer.addEventListener(MouseEvent.MOUSE_UP, stopFiring);
		}
		
		private function startFiring(evt:MouseEvent):void
		{
			player.startFiring();
		}
		
		private function stopFiring(evt:MouseEvent):void
		{
			player.stopFiring();
		}
		
		private function keyDownHandler(evt:KeyboardEvent):void//changed this to allow
		//for movement including thrust
		{
			
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87)
			{
				player.directionY = "up";
			}
			else if (evt.keyCode == 83)
			{
				player.directionY = "down";
			}
			else if (evt.keyCode == 68)
			{
				player.directionX = "right";
			}
			else if (evt.keyCode == 65)
			{
				player.directionX = "left";
			}
			//87=w 68=d 83=s 65=a
			/*if (evt.keyCode == Keyboard.W)//changed this
			{
				player.thrust = 50;
			}
			else if (evt.keyCode == Keyboard.S)
			{
				player.thrust = -3;
			}
		
			else if (evt.keyCode == Keyboard.D)
			{
				player.rotationVel = 5;
			}
			else if (evt.keyCode == Keyboard.A)
			{
				player.rotationVel = -5;
			}*/
		}
		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			//87=w 68=d 83=s 65=a
			/*if (evt.keyCode == Keyboard.W || evt.keyCode == Keyboard.S)
			{
				player.thrust = 0;
			}
			else if (evt.keyCode == Keyboard.A || evt.keyCode == Keyboard.D)
			{
				player.rotationVel = 0;
			}*/
			//87=w 68=d 83=s 65=a
			if (evt.keyCode == 87 || evt.keyCode == 83)
			{
				player.directionY = "none";
				//player.thrust = 0;
			}
			else if (evt.keyCode == 68 || evt.keyCode == 65)
			{
				player.directionX = "none";
				//player.rotates = 0;
			}
		}
		
		private function setupTouchLayer(evt:Event):void
		{
			touchLayer.graphics.beginFill(0x000000, 0);
			touchLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			touchLayer.graphics.endFill();
	
			player.x = -1000;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function makeLevelOne():void
		{
			player = new ShipA();
			background = new LevelOne();
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 25;
			
			score = 0;
			gameScore = new TextField();
			gameScore.x = 552;
			gameScore.y = 76;
			gameScore.textColor = 0xFFFFFF;
			gameScore.background = false;
			gameScore.defaultTextFormat = myFormat;
			gameScore.text = "Enemies Defeated: 0";trace("here");
			gameScore.width = 400;
			
			addChild(background);
			
			turretsLayer = new Sprite();
			background.addChild(turretsLayer);
			
			background.addChild(player);
			
			particlesLayer = new Sprite();
			background.addChild(particlesLayer);
			
			makeTurrets();
			addChild(gameScore);
		}
		
		private function makeTurrets():void
		{
			turrets = new Array();
			
			while (turrets.length < turretsNum)
			{
				var turret:Turret = new BlueTurret();
				
				turrets.push(turret);
				turretsLayer.addChild(turret);
				
				turret.target = player;
				
				turret.x = Math.random() * background.width;
				turret.y = Math.random() * background.height;
			}
		}
		
		private function updatePlayer():void
		{
			player.update();
			background.x = -player.x + stage.stageWidth / 2;
			background.y = -player.y + stage.stageHeight / 2;
			var shot:Particle = player.fire();
			if (shot != null)
			{
				particlesLayer.addChild(shot);
				bullets.push(shot);
			}
		}
		
		private function killBullet(bullet:Particle):void
		{
			try
			{
				var i:int;
				for (i = 0; i < bullets.length; i++)
				{
					if (bullets[i].name == bullet.name)
					{
						bullets.splice(i, 1);
						particlesLayer.removeChild(bullet);
						
						if (bullet.interacts)
						{
							var j:int;
							for (j = 0; j < splodeNum; j++)
							{
								var splode:Particle = new Explosion();
								splode.scaleX = splode.scaleY = 1 + Math.random();
								splode.x = bullet.x;
								splode.y = bullet.y;
								splode.xVel = Math.random() * splodeSpread - splodeSpread / 2;
								splode.yVel = Math.random() * splodeSpread - splodeSpread / 2;
								splode.life = 20;
								splode.interacts = false;
								bullets.push(splode);
								particlesLayer.addChild(splode);
							}
						}
						
						i = bullets.length;
					}
				}
			}
			catch(e:Error)
			{
				trace("Failed to delete bullet!", e);
			}
		}
		
		private function update(evt:Event):void
		{
			//trace(turretsLayer.x, particlesLayer.x);
			
			var target:Point = new Point(stage.mouseX, stage.mouseY);
			
			var angleRad:Number = Math.atan2(target.y, target.x);
			
			var angle:Number = angleRad * 180 / Math.PI;
			
			updatePlayer();
			
			for each (var bullet:Particle in bullets)
			{
				bullet.update();
				
				if (bullet.life <= 0)
				{
					killBullet(bullet);
				}
				else if (bullet.interacts)
				{
					if (bullet.ownedByPlayer)
					{
						var i:Number = 0;
						for each (var targetTurret:Turret in turrets)
						{
							if (targetTurret.hitTestPoint(bullet.x + background.x, bullet.y + background.y, true))
							{
								killBullet(bullet);
								targetTurret.hit();//added this
								if (targetTurret.getTurretLife() <= 0){
									killTurret(targetTurret,i);
								}
								
								break;
							}
							i++;//keeps track of turrect index
						}
					}
					else
					{
						if (player.hitTestPoint(bullet.x + background.x, bullet.y + background.y, true))
						{
							killBullet(bullet);
						}
					}
				}
			}
			
			for each (var turret:Turret in turrets)
			{
				var shot:Particle = turret.update();
				if (shot != null)
				{
					particlesLayer.addChild(shot);
					bullets.push(shot);
				}
			}
		}
		
		private function killTurret(turret:Turret, index:Number):void {
			//get rid of turret
			turretsLayer.removeChild(turret);
			turret.target = null;
			delete turrets[index];
			
			//increment score
			score++;
			gameScore.text = "Enemies Defeated: " + score.toString();
			
		}
	}
}