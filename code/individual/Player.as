package lib.survive
{
	import flash.display.MovieClip;
	import lib.survive.Particle;
	
	public class Player extends MovieClip
	{
		public var speed:Number;
		public var turnRate:Number;
		public var directionX:String;
		public var directionY:String;
		public var brakes:Number;
		public var xVel:Number;
		public var yVel:Number;
		public var accel:Number;
		public var friction:Number;//added
		public var thrust:Number;//added
		private var targetAngle:Number;
		public var firing:Boolean;
		public var fireDelay:int;
		public var fireCounter:int;
		public var shotSpeed:Number;
		public var currDirection:Number;
		public var rotates:Number;
		
		public function Player()
		{
			fireDelay = 3;
			fireCounter = 0;
			firing = false;
			targetAngle = 0;
			accel = 0.1;
			xVel = 0;
			yVel = 0;
			directionX = "none";
			directionY = "none";
			currDirection = 0;
			speed = 10;
			turnRate = 0.1;
			brakes = 0.97;
		}
		
		public function startFiring():void
		{
			firing = true;
		}
		
		public function stopFiring():void
		{
			firing = false;
		}
		
		public function fire():Particle
		{
			var shot:Particle;
			if (firing)
			{
				shot = new Bullet();
				shot.x = x;
				shot.y = y;
				
				var shotAngle:Number = Math.atan2(stage.mouseY - stage.stageHeight / 2, stage.mouseX - stage.stageWidth / 2);
				
				shot.interacts = true;
				shot.xVel = xVel + Math.cos(shotAngle) * speed;
				shot.yVel = yVel + Math.sin(shotAngle) * speed;
			}
			if (fireCounter < fireDelay)
			{
				fireCounter++;
			}
			return shot;
		}
		
		public function update():void
		{
			//original player movement
			if (directionX != "none" || directionY != "none")
			{trace(rotation);
				if (directionY != "none"){
					if (directionX == "left")
					{
						targetAngle = 135;
						//targetAngle = this.rotation + 5;
						//rotates = 5;
					}
					else if (directionX == "right")
					{
						targetAngle = 45;
						//targetAngle = this.rotation -5;
						//rotates = -5;
					}
					else {
						targetAngle = 90;
					}
					if (directionY == "up")
					{
						targetAngle *= -1;
						//thrust = 3;
					}
					//else if (directionY == "down") {
						//thrust = -3;
					//}
				}
				else if (directionX == "left")
				{
					targetAngle = 180;
				}
				
				xVel += ((Math.cos(targetAngle / 180 * Math.PI) * speed) - xVel) * accel;
				yVel += ((Math.sin(targetAngle / 180 * Math.PI) * speed) - yVel) * accel;
			}
			if (targetAngle - rotation > 180)
			{
				targetAngle -= 360;
			}
			else if (targetAngle - rotation < -180)
			{
				targetAngle += 360;
			}
			//this.rotation += rotates;
			rotation += (targetAngle - rotation) * turnRate;
			
			xVel *= brakes;
			yVel *= brakes;
			
			this.x += xVel;
			this.y += yVel;
			
			/*var playerHalfWidth:Number = width/2;
			var playerHalfHeight:Number = height/2
			
			rotation += rotationVel;
			targetAngle = rotation / 180 * Math.PI;
			var ax:Number = Math.cos(targetAngle) * thrust - xVel;
			var ay:Number = Math.sin(targetAngle) * thrust - yVel;
			xVel += ax;
			yVel += ay;
			xVel *= brakes;
			yVel *= brakes;
			x += xVel;
			y += yVel;*/
		}
	}
}