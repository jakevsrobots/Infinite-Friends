package friends {
    import org.flixel.*;

    public class Friend extends FlxSprite {
        // Static
        public static var RUNNING:uint = 0;
        public static var JUMPING:uint = 1;

        // Instance
        public var jumpState:uint = 0;
        public var altitude:Number = 0;
        private var jumpSpeed:Number = 20;
        private var fallSpeed:Number = 20;
        private var jumpPeak:Number = 10;
        
        private var jumpingVelocity:Number = 0;
        
        public function Friend(x:Number, y:Number):void {
            super(x, y);

            createGraphic(16, 16, 0xffffffff, true);
        }

        public function jump():void {
            if(jumpState == Friend.RUNNING) {
                jumpState = Friend.JUMPING;
                jumpingVelocity = jumpSpeed;
            }

            if(jumpState == Friend.JUMPING && jumpingVelocity > 0) {
                
            }
        }

        override public function update():void {
            super.update();
        }
    }
}