package friends {
    import flash.geom.Rectangle;
    import net.flashpunk.World;
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;    
    import net.flashpunk.graphics.Image;
    
    public class PlayWorld extends World {
        // Instance
        public var globalSpeedModifier:Number = 1.0;
        public var activeFriends:Array;
        private var sleepingFriends:Array;        
        private var allKeys:Array;
        private var usedKeys:Array;        
        private var background:Background;
        private var gameTitle:TextMessage;        
        private var globalTitle:TextMessage;
        private var highestPointBuilt:int;
        private var topGrinder:Grinder;        
        private var bottomGrinder:Grinder;

        // Music
        private var drumsPlayer:Sfx;
        private var synthPlayer:Sfx;
        private var synthLowPlayer:Sfx;
        private var synthHiPlayer:Sfx;        

        [Embed(source='/../data/music/friends-drums.mp3')]
        private var DrumsMusic:Class;
        [Embed(source='/../data/music/friends-synth.mp3')]
        private var SynthMusic:Class;
        [Embed(source='/../data/music/friends-synth-low.mp3')]
        private var SynthLowMusic:Class;
        [Embed(source='/../data/music/friends-synth-hi.mp3')]
        private var SynthHiMusic:Class;

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

            // Set up music players
            drumsPlayer = new Sfx(DrumsMusic);
            synthPlayer = new Sfx(SynthMusic);
            synthLowPlayer = new Sfx(SynthLowMusic);
            synthHiPlayer = new Sfx(SynthHiMusic);
        }

        override public function begin():void {
            usedKeys = [];

            // Setup background.
            background = new Background();
            add(background);

            sleepingFriends = [];
            activeFriends = [];
            
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

            globalTitle = new TextMessage();
            globalTitle.reset("Press buttons \nto have friends!\n(& press buttons\n to flip them)", 0, FP.camera.y, 48, false, false);
            add(globalTitle);
            
            gameTitle = new TextMessage();
            gameTitle.reset("INFINITE FRIENDS", 0, FP.camera.y - 128, 48, false, false);
            add(gameTitle);

            // Start music
            drumsPlayer.loop(0);
            synthPlayer.loop(1);
            synthLowPlayer.loop(0);
            synthHiPlayer.loop(0);
        }
        
        override public function update():void {
            buildNewWorldParts();
            
            FP.camera.y -= 15 * FP.elapsed * globalSpeedModifier;
            
            topGrinder.y = FP.camera.y - 16;
            bottomGrinder.y = FP.camera.y + FP.height - 16;

            globalTitle.y = FP.camera.y + (FP.height / 2);
            gameTitle.y = FP.camera.y + (FP.height / 2) - 128;

            updateMusic();

            // Update speed modifier
            if(activeFriends.length < 2) {
                globalSpeedModifier = 1;                
            } else if(activeFriends.length < 4) {
                globalSpeedModifier = 1.25;
            } else if(activeFriends.length < 6) {
                globalSpeedModifier = 1.3;
            } else if(activeFriends.length < 8) {
                globalSpeedModifier = 1.5;
            } else if(activeFriends.length < 12) {
                globalSpeedModifier = 2;
            } else if(activeFriends.length < 16) {
                globalSpeedModifier = 3;
            } else if(activeFriends.length < 20) {
                globalSpeedModifier = 5;
            }
            
            super.update();
        }

        private function updateMusic():void {
            if(activeFriends.length == 0) {
                //drumsPlayer.volume = 1;
                synthPlayer.volume = 1;
                synthLowPlayer.volume = 0;
                synthHiPlayer.volume = 0;
            } else if(activeFriends.length == 1) {
                //drumsPlayer.volume = 1;
                synthPlayer.volume = 1;
                synthLowPlayer.volume = 0.5;
                synthHiPlayer.volume = 0;
            } else if(activeFriends.length < 4) {
                //drumsPlayer.volume = 1;
                synthPlayer.volume = 0.25 * activeFriends.length;
                synthLowPlayer.volume = 1;
                synthHiPlayer.volume = 0.125 * activeFriends.length;
            } else if(activeFriends.length < 8) {
                //drumsPlayer.volume = 1;
                synthPlayer.volume = 1;
                synthLowPlayer.volume = 1;
                synthHiPlayer.volume = 0.125 * activeFriends.length;
            } else {
                //drumsPlayer.volume = 1;
                synthPlayer.volume = 1;
                synthLowPlayer.volume = 1;
                synthHiPlayer.volume = 1;
            }
        }
        
        private function getRandomKey():int {
            var key:int = FP.choose(allKeys);
            
            if(usedKeys.length < allKeys.length) {
                while(usedKeys.indexOf(key) != -1) {
                    key = FP.choose(allKeys);                    
                }
                
                usedKeys.push(key);
                return key;
            } else {
                usedKeys.push(key);
                return key;
            }
        }

        public function removeFriend(friend:Friend):void {
            if(activeFriends.indexOf(friend) != -1) {
                activeFriends.splice(activeFriends.indexOf(friend), 1);

            } else if(sleepingFriends.indexOf(friend) != -1) {
                sleepingFriends.splice(sleepingFriends.indexOf(friend), 1);
            }

            if(activeFriends.length == 0) {
                globalTitle.reset("Press buttons \nto have friends!\n(& press buttons\n to flip them)", 0, FP.camera.y, 48, false, false);                
                gameTitle.reset("INFINITE FRIENDS", 0, FP.camera.y - 128, 48, false, false);
            } else {
                showFriendsText();
            }
            
            recycle(friend);
        }

        public function activateFriend(friend:Friend):void {
            if(sleepingFriends.indexOf(friend) != -1) {
                sleepingFriends.splice(sleepingFriends.indexOf(friend), 1);
            }
            
            if(activeFriends.indexOf(friend) == -1) {
                if(activeFriends.length == 0) {
                    globalTitle.autoFade = true;
                    gameTitle.autoFade = true;                    
                }
                
                activeFriends.push(friend);
            }

            showFriendsText();
        }

        private function showFriendsText():void {
            var title:TextMessage = create(TextMessage) as TextMessage;
            var text:String = '' + activeFriends.length + ' friend';
            if(activeFriends.length != 1) {
                text += 's';
            }
            title.reset(text, 0, FP.camera.y + (FP.height / 4), 48);
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


            var createdFriendXPositions:Array = [];
            var friendsToCreate:int;
            
            if(activeFriends.length == 0) {
                friendsToCreate = 1;
            } else {
                friendsToCreate = Math.ceil(Number(activeFriends.length) / 4.0);
            }
            
            for(var j:int = 0; j < friendsToCreate; j++) {
                var friend:Friend = create(Friend) as Friend;
                var friendX:int = Math.random() * FP.width;

                var foundGoodSpotForFriend:Boolean = false;
                while(!foundGoodSpotForFriend) {
                    friendX = Math.random() * FP.width;
                    foundGoodSpotForFriend = true;

                    if(friendX + 32 >= FP.width) {
                        foundGoodSpotForFriend = false;
                        continue;
                    }
                    
                    if(friendX + 32 > holeStart && friendX < holeEnd) {
                        foundGoodSpotForFriend = false;
                        continue;
                    }

                    // Try not to overlap friends
                    for each(var otherFriendX:int in createdFriendXPositions) {
                        if(Math.abs(otherFriendX - friendX) < 8) {
                            foundGoodSpotForFriend = false;
                            continue;
                        }
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
                createdFriendXPositions.push(friendX);
            }
        }

        public function explodeFriend(friend:Friend):void {
             var explosion:Explosion = create(Explosion) as Explosion;
            explosion.reset(friend.x, friend.y, friend.friendSprite.color);
            removeFriend(friend);
        }
    }
}