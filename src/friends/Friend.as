package friends {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;
    import net.flashpunk.FP;
    
    public class Friend extends Entity {
        // Static
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
        
        [Embed (source="/../data/friend.png")]
        private var FriendGraphic:Class;
        public var friendSprite:Spritemap;
        
        public function Friend(x:Number, y:Number):void {
            friendSprite = new Spritemap(FriendGraphic, 32, 32);

            friendSprite.add('running', [0,1,2,3,4,5,6,7,8], 20 + (Math.random() * 4), true);
            friendSprite.add('jumping', [0], 16, false);

            friendSprite.originX = 15;
            friendSprite.originY = 31;
            
            graphic = friendSprite;

            friendSprite.play('running');

            super(x, y);
        }

        override public function update():void {
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
            
            super.update();
        }
        
        public function jump():void {
            if(jumpState == Friend.RUNNING) {
                jumpState = Friend.JUMPING;
                jumpingVelocity = jumpSpeed;
            }
        }
    }
}