package friends {
    import net.flashpunk.World;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;    
    import net.flashpunk.graphics.Image;
    
    public class PlayWorld extends World {
        // Instance
        private var allFriends:Array;
        private var keys:Array;
        private var background:Background;

        public function PlayWorld():void {
            super();

            // Setup keys to control friends.
            keys = [
                // Left:
                Key.A, Key.S, Key.D, Key.F,

                // Right:
                Key.J, Key.K, Key.L, 186 // 186 = semicolon
            ];

            // Setup background.
            background = new Background();
            add(background);
            
            // Setup friends.
            var startingFriends:int = 8;
            allFriends = [];
            for(var i:uint = 0; i < startingFriends; i++) {
                var friend:Friend = new Friend(0, 0)
                add(friend);
                allFriends.push(friend);
            }

            sortFriends();
        }

        override public function update():void {
            for each(var key:int in keys) {
                if(Input.pressed(key)) {
                    FP.log('pressed ' + key);
                    pressKey(key);
                }
            }

            super.update();
        }

        public function sortFriends():void {
            var spread:int = 32;
            var baseX:int = (FP.width / 2) - ((allFriends.length * spread) / 2);
            
            for(var i:uint = 0; i < allFriends.length; i++) {
                var friend:Friend = allFriends[i];
                friend.x = baseX + (i * spread);
                friend.y = (FP.height / 2) + (FP.height / 4);
                friend.baseY = friend.y;
            }
        }

        private function pressKey(key:int):void {
            var keyPosition:int = keys.indexOf(key);

            keyPosition = int((Number(keyPosition) / Number(keys.length)) * allFriends.length);

            for(var i:int = 0; i < allFriends.length; i++) {
                var friend:Friend = allFriends[i];
                var friendKeyPosition:int = int( Number(i) / Number(allFriends.length) * allFriends.length );
                
                if(keyPosition == friendKeyPosition) {
                    friend.jump();
                }
            }
        }
    }
}