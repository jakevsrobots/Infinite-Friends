package friends {
    import net.flashpunk.World;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;    
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;    
    
    public class PlayWorld extends World {
        // Instance
        private var allFriends:Array;
        private var allKeys:Array;
        private var usedKeys:Array;        
        private var background:Background;
        private var title:TextMessage;
        
        public function PlayWorld():void {
            super();

            // Setup keys for friends.
            allKeys = [
                Key.A, Key.B, Key.C, Key.D, Key.F, Key.G, Key.H, Key.J,
                Key.K, Key.M, Key.N, Key.P, Key.Q, Key.R,
                Key.T, Key.U, Key.V, Key.W, Key.X, Key.Y,
                
                Key.DIGIT_3,
                Key.DIGIT_4, Key.DIGIT_6, Key.DIGIT_7,
                Key.DIGIT_8, Key.DIGIT_9
            ];
            usedKeys = [];

            // Setup background.
            background = new Background();
            add(background);

            // Set up testing friend and walls
            allFriends = [];
            var friend:Friend = new Friend(FP.width / 2, FP.height / 2);
            friend.key = getRandomKey();
            add(friend);
            allFriends.push(friend);
            
            add(new Wall(friend.x - 64, friend.y + 64, 128, 16));
            
            //title = new TextMessage('hi', FP.width / 2, FP.height / 2);
            //add(title);
        }

        override public function update():void {
            for each(var key:int in usedKeys) {
                if(Input.pressed(key)) {
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
                friend.x = baseX + (i * spread)
                friend.y = (FP.height / 2) + (FP.height / 4);
                friend.baseY = friend.y;
            }
        }

        private function pressKey(key:int):void {
            for(var i:int = 0; i < allFriends.length; i++) {
                var friend:Friend = allFriends[i];
                
                if(key == friend.key) {
                    friend.jump();
                }
            }
        }

        private function getRandomKey():int {
            var key:int = FP.choose(allKeys);

            usedKeys.push(key);
            
            return key;
        }
    }
}