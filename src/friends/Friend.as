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

        // Physics
        public var gravity:Number = 0.4;
        public var friction:Point = new Point(0,0);
        public var maxSpeed:Point = new Point(0,0);
        public var speed:Point = new Point(0,0);
        public var acceleration:Point = new Point(0,0);
        public var onGround:Boolean = false;
        
        [Embed (source="/../data/friend.png")]
        private var FriendGraphic:Class;
        private var friendSprite:Spritemap;

        
        public function Friend(x:Number, y:Number):void {
            friendSprite = new Spritemap(FriendGraphic, 32, 32);

            friendSprite.add('running', [0,1,2,3,4,5,6,7,8], 20 + (Math.random() * 4), true);
            friendSprite.add('jumping', [0], 16, false);

            friendSprite.originX = 15;
            friendSprite.originY = 31;
            friendSprite.smooth = false;
            friendSprite.play('running');
            
            this.key = Key.Q;
            keyLabel = new Text(Key.name(this.key), 12, -16);
            graphic = new Graphiclist(friendSprite, keyLabel);

            setHitBox(32, 32, 0, 0);
            type = "friend";
            
            super(x, y);
        }

        override public function update():void {
            // Find out if friend is on the ground
            onground = false;
            if(collide('solid', x, y+1)) {
                onground = true;
            }

            // Do gravity flip
            if(Input.pressed(key)) {
                gravity *= -1;
            }
            
            // Apply gravity;
            speed.y += gravity;
            
            // Apply max speed
            

            // Apply motion
            
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

        public function setPosition(x:Number, y:Number):void {
            this.x = x;
            this.y = y;
        }
    }
}