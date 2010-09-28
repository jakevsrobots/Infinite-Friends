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
        public var friendSprite:Spritemap;

        public function Friend(x:Number = 0, y:Number = 0):void {
            super();

            friendSprite = new Spritemap(FriendGraphic, 32, 32);

            friendSprite.add('running', [0,1,2,3,4,5,6,7,8], 20 + (Math.random() * 4), true);
            friendSprite.add('standing', [0], 16, false);            
            friendSprite.add('jumping', [0], 16, false);

            friendSprite.originX = 15;
            friendSprite.originY = 15;
            friendSprite.smooth = false;
            
            friendSprite.play('standing');

            setHitbox(32, 32, 0, 0);

            keyLabel = new Text('-', 12, -16);
            graphic = new Graphiclist(friendSprite, keyLabel);

            type = "friend";

            reset(x, y, Key.Q);

            layer = 1;
        }

        public function reset(x:Number, y:Number, key:int):void {
            this.key = key;
            this.x = x;
            this.y = y;
            speed.x = maxSpeed.x;
            asleep = true;
            friendSprite.play('standing');
            gravity = 120;
            friendSprite.angle = 0;
            keyLabel.x = 12;
            keyLabel.y = -16;
            setRandomColor();
        }

        private function setRandomColor():void {
                // Try to generate random 'bright' colors by
                // working in Hue/Saturation/Value colorspace instead of RGB.
                var hue:Number = Math.random() * 360;
                var saturation:Number = 100;
                var value:Number = 200;
                var hsvcolor:Array = ColorUtils.HSVtoRGB(hue, saturation, value);
                friendSprite.color = ColorUtils.RGBToHex(hsvcolor[0],hsvcolor[1],hsvcolor[2]);
                
                //this.color = uint(Math.random() * 16777.215) * 1000;
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
                    (FP.world as PlayWorld).activateFriend(this);
                    friendSprite.play('running');                    
                }
                return;
            }
            
            // Do gravity flip
            if(Input.pressed(key)) {
                gravity *= -1;
                if(friendSprite.angle == 180) {
                    friendSprite.angle = 0;
                    //keyLabel.angle = 0;
                    keyLabel.x = 12;
                    keyLabel.y = -16;
                } else {
                    friendSprite.angle = 180;
                    keyLabel.x = 12;
                    keyLabel.y = 32;
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
                        break;
                    }
                    
                    x += FP.sign(frameSpeed.x);
                    
                    if(collide("wall", x + FP.sign(frameSpeed.x), y)) {
                        // Hit a wall, turn around.
                        speed.x *= -1;
                        break;
                    }
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

            super.update();
            
            // Check for screen boundaries
            if(y + (height * 2) < FP.camera.y || y - (height * 2) > FP.camera.y + FP.height) {
                (FP.world as PlayWorld).removeFriend(this);
            }

            // Check for grinder
            if(collide('grinder', x, y)) {
                (FP.world as PlayWorld).explodeFriend(this);
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