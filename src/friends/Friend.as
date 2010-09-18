package friends {
    import org.flixel.*;

    public class Friend extends FlxSprite {
        [Embed (source="/../data/friend.png")]
        private var FriendGraphic:Class;
                
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
        
        public function Friend(x:Number, y:Number):void {
            super(x, y);

            baseY = y;
            
            //createGraphic(16, 16, 0xffffffff, true);
            loadGraphic(FriendGraphic, true, false, 32, 32);
            addAnimation('running', [0,1,2,3,4,5,6,7,8], 20 + (Math.random() * 4), true);
            addAnimation('jumping', [0], 16, false);
        }

        public function jump():void {
            if(jumpState == Friend.RUNNING) {
                jumpState = Friend.JUMPING;
                jumpingVelocity = jumpSpeed;
            }
        }

        override public function update():void {
            if(jumpState == Friend.JUMPING) {
                play('jumping');
                scale.x = scale.y = 1 + ((altitude / jumpPeak) * 3);
                altitude += jumpingVelocity * FlxG.elapsed;
                if(altitude >= jumpPeak) {
                    altitude = jumpPeak;
                    jumpingVelocity *= -1;
                } else if(altitude <= 0) {
                    altitude = 0;
                    jumpingVelocity = 0;
                    jumpState = Friend.RUNNING;
                }
                y = baseY - (scale.y * 32);
            } else {
                play('running');
                scale.x = scale.y = 1;
                y = baseY;
            }
            
            super.update();
        }
    }
}