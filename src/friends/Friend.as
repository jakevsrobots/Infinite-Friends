package friends {
    import flash.geom.Point;
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;    
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.graphics.Text;    
    import net.flashpunk.graphics.Graphiclist;
    
    public class Friend extends Entity {
        // Static
        public static var RUNNING:uint = 0;
        public static var JUMPING:uint = 1;
        
        // Instance
        public var jumpState:uint = 0;
        public var altitude:Number = 0;
        public var baseY:Number;
        private var jumpSpeed:Number = 30;
        private var fallSpeed:Number = 30;
        private var jumpPeak:Number = 5;
        private var jumpingVelocity:Number = 0;
        private var _key:int;
        private var keyLabel:Text;
        public var asleep:Boolean = true;
        
        // Physics
        public var gravity:Number = 120;
        public var friction:Point = new Point(0,0);
        public var maxSpeed:Point = new Point(100,120);
        public var speed:Point = new Point(0,0);
        public var acceleration:Point = new Point(0,0);
        public var onGround:Boolean = false;
        
        [Embed (source="/../data/friend.png")]
        private var FriendGraphic:Class;
        private var friendSprite:Spritemap;

        public function Friend(x:Number = 0, y:Number = 0):void {
            super();

            friendSprite = new Spritemap(FriendGraphic, 32, 32);

            friendSprite.add('running', [0,1,2,3,4,5,6,7,8], 20 + (Math.random() * 4), true);
            friendSprite.add('jumping', [0], 16, false);

            friendSprite.originX = 15;
            friendSprite.originY = 15;
            friendSprite.smooth = false;
            friendSprite.play('running');

            setHitbox(32, 32, 0, 0);

            keyLabel = new Text('-', 12, -16);
            graphic = new Graphiclist(friendSprite, keyLabel);

            type = "friend";

            reset(x, y, Key.Q);
        }

        public function reset(x:Number, y:Number, key:int):void {
            this.key = key;
            this.x = x;
            this.y = y;
            speed.x = maxSpeed.x;
            asleep = true;
        }
        
        override public function update():void {
            // Find out if friend is on the ground
            onGround = false;
            if(collide('wall', x, y + FP.sign(gravity))) {
                onGround = true;
            }

            if(asleep) {
                if(Input.pressed(key)) {
                    asleep = false;
                }
                return;
            }
            
            // Do gravity flip
            if(Input.pressed(key)) {
                gravity *= -1;
                if(friendSprite.angle == 180) {
                    friendSprite.angle = 0;                    
                } else {
                    friendSprite.angle = 180;
                }
            }

            // Apply gravity;
            speed.y += gravity;
            
            // Apply max speed

            if(Math.abs(speed.x) > maxSpeed.x) {
                speed.x = maxSpeed.x * FP.sign(speed.x);
            }
            if(Math.abs(speed.y) > maxSpeed.y) {
                speed.y = maxSpeed.y * FP.sign(speed.y);
            }

            // Get speed relative to just the amount of time passed in this frame
            var frameSpeed:Point = new Point(speed.x * FP.elapsed, speed.y * FP.elapsed);
            
            // Apply horizontal motion, if the friend is on the ground
            if(onGround) {
                for(var i:int = 0; i < Math.abs(frameSpeed.x); i++) {
                    var nextX:int = x + FP.sign(frameSpeed.x);
                    if(nextX >= FP.width - width || nextX <= 0) {
                        speed.x *= -1;
                    }
                    
                    x += FP.sign(frameSpeed.x);
                    
                    /*
                    if(!collide("wall", x + FP.sign(frameSpeed.x), y)) {
                    } else {
                        // Hit a wall, turn around.
                        speed.x *= -1;
                        break;
                    }*/
                }
            }
            
            // Apply vertical motion            
            for(var j:int = 0; j < Math.abs(frameSpeed.y); j++) {
                if(!collide("wall", x, y + FP.sign(frameSpeed.y))) {
                    y += FP.sign(frameSpeed.y);
                } else {
                    // Hit a wall, stop.
                    speed.y = 0;
                    break;
                }
            }

            /*
            if(jumpState == Friend.JUMPING) {
                friendSprite.play('jumping');
                friendSprite.scale = 1 + ((altitude / jumpPeak) * 3);
                altitude += jumpingVelocity * FP.elapsed;
                if(altitude >= jumpPeak) {
                    altitude = jumpPeak;
                    jumpingVelocity *= -1;
                } else if(altitude <= 0) {
                    altitude = 0;
                    jumpingVelocity = 0;
                    jumpState = Friend.RUNNING;
                }
                y = baseY - (friendSprite.scale * 32);
            } else {
                friendSprite.play('running');
                friendSprite.scale = 1;
                y = baseY;
            }
            */

            super.update();
        }
        
        public function jump():void {
            if(jumpState == Friend.RUNNING) {
                jumpState = Friend.JUMPING;
                jumpingVelocity = jumpSpeed;
            }
        }

        public function get key():int {
            return _key;
        }

        public function set key(value:int):void {
            _key = value;
            if(keyLabel != null) {
                keyLabel.text = Key.name(value);
            }
        }
    }
}