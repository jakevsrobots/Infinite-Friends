package friends {
    import flash.geom.Rectangle;
    import net.flashpunk.World;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;    
    import net.flashpunk.graphics.Image;
    
    public class PlayWorld extends World {
        // Instance
        private var activeFriends:Array;
        private var sleepingFriends:Array;        
        private var allKeys:Array;
        private var usedKeys:Array;        
        private var background:Background;
        private var title:TextMessage;
        private var highestPointBuilt:int;
        private var topGrinder:Grinder;        
        private var bottomGrinder:Grinder;
        
        public function PlayWorld():void {
            super();

            // Setup keys for friends.
            allKeys = [
                Key.A, Key.B, Key.C, Key.D, Key.F, Key.G, Key.H, Key.J,
                Key.K, Key.M, Key.N, Key.P, Key.Q, Key.R,
                Key.T, Key.W, Key.X, Key.Y,
                
                Key.DIGIT_3,
                Key.DIGIT_4, Key.DIGIT_6, Key.DIGIT_7,
                Key.DIGIT_8, Key.DIGIT_9
            ];
        }

        override public function begin():void {
            usedKeys = [];

            // Setup background.
            background = new Background();
            add(background);

            sleepingFriends = [];
            activeFriends = [];
            
            // Set up testing friend and walls
            /*
            var friend:Friend = new Friend(FP.width / 2, FP.height / 2);
            friend.key = getRandomKey();
            add(friend);
            activeFriends.push(friend);
            */
            
            //add(new Wall(0, friend.y + 64, FP.width, 16));

            //highestPointBuilt = friend.y + 128;
            highestPointBuilt = FP.camera.y + FP.height;

            var bottomWall:Wall = create(Wall) as Wall;
            bottomWall.reset(0, highestPointBuilt, FP.width, 16);
            add(bottomWall);

            // Set up grinders
            topGrinder = new Grinder(0, -16);
            add(topGrinder);
            bottomGrinder = new Grinder(0, FP.height + 16);
            add(bottomGrinder);
            
            topGrinder.layer = bottomGrinder.layer = 0;
            
            //FP.camera.y = -440;
            
            //title = new TextMessage('hi', FP.width / 2, FP.height / 2);
            //add(title);
            
            //FP.watch(FP.camera.y);
        }
        
        override public function update():void {
            buildNewWorldParts();
            
            FP.camera.y -= 15 * FP.elapsed;
            
            //FP.log('active friends: ' + activeFriends.length);

            topGrinder.y = FP.camera.y - 16;
            bottomGrinder.y = FP.camera.y + FP.height - 16;
            
            super.update();
        }

        public function sortFriends():void {
            var spread:int = 32;
            var baseX:int = (FP.width / 2) - ((activeFriends.length * spread) / 2);
            
            for(var i:uint = 0; i < activeFriends.length; i++) {
                var friend:Friend = activeFriends[i];
                friend.x = baseX + (i * spread)
                friend.y = (FP.height / 2) + (FP.height / 4);
                friend.baseY = friend.y;
            }
        }

        private function getRandomKey():int {
            var key:int = FP.choose(allKeys);

            usedKeys.push(key);
            
            return key;
        }

        public function removeFriend(friend:Friend):void {
            if(activeFriends.indexOf(friend) != -1) {
                activeFriends.splice(activeFriends.indexOf(friend), 1);
            } else if(sleepingFriends.indexOf(friend) != -1) {
                sleepingFriends.splice(sleepingFriends.indexOf(friend), 1);
            }
            
            recycle(friend);
        }

        public function activateFriend(friend:Friend):void {
            if(sleepingFriends.indexOf(friend) != -1) {
                sleepingFriends.splice(sleepingFriends.indexOf(friend), 1);
            }
            
            if(activeFriends.indexOf(friend) == -1) {
                activeFriends.push(friend);
            }
        }

        private function buildNewWorldParts():void {
            var nextPointToBuild:int = highestPointBuilt - 128;
            
            if(FP.camera.y < nextPointToBuild + 32) {
                buildRandomWalls(nextPointToBuild);
                
                highestPointBuilt = nextPointToBuild;
            }
        }

        private function buildRandomWalls(elevation:int):void {
            var holeWidth:int = 64 + int(Math.random() * 128);
            var holeMargin:Number = 0.1;
            var leftMostPoint:int = holeMargin * FP.width;
            var rightMostPoint:int = (FP.width - (holeMargin * FP.width)) - holeWidth;
            var holeStart:int = leftMostPoint + (Math.random() * (rightMostPoint - leftMostPoint));
            var holeEnd:int = holeStart + holeWidth;

            var leftWall:Wall = create(Wall) as Wall;
            leftWall.reset(0, elevation, holeStart, 16);

            var rightWall:Wall = create(Wall) as Wall;
            rightWall.reset(holeEnd, elevation, FP.width, 16);

            // Build a few blocks
            var blocks:Array = [];
            for(var i:int=0; i < 3; i++) {
                var blockX:int = Math.random() * FP.width;
                while(blockX > holeStart - 16 && blockX < holeEnd) {
                    blockX = Math.random() * FP.width;
                }

                var block:Wall = create(Wall) as Wall;
                block.reset(blockX, elevation - 32, 32, 32);
                blocks.push(block);
            }
            
            var friend:Friend = create(Friend) as Friend;
            var friendX:int = Math.random() * FP.width;

            var foundGoodSpotForFriend:Boolean = false;
            while(!foundGoodSpotForFriend) {
                friendX = Math.random() * FP.width;                
                
                foundGoodSpotForFriend = true;
                if(friendX + 32 > holeStart && friendX < holeEnd) {
                    foundGoodSpotForFriend = false;
                    continue;
                }

                var friendRect:Rectangle = new Rectangle(friendX, elevation - friend.height, friend.width, friend.height);
                for each(var blockToCheck:Wall in blocks) {
                    var blockRect:Rectangle = new Rectangle(blockToCheck.x, blockToCheck.y, blockToCheck.width, blockToCheck.height);
                    if(blockRect.intersects(friendRect)) {
                        foundGoodSpotForFriend = false;
                    }
                }
            }
            
            friend.reset(friendX, elevation - friend.height, getRandomKey());
        }

        public function explodeFriend(friend:Friend):void {
             var explosion:Explosion = create(Explosion) as Explosion;
            //explosion.reset(friend.x + (friend.width / 2), friend.y + (friend.height / 2));
            explosion.reset(friend.x, friend.y, friend.friendSprite.color);
            removeFriend(friend);
        }
    }
}