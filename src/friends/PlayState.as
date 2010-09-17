package friends {
    import org.flixel.*;

    public class PlayState extends FlxState {
        private var allFriends:FlxGroup;
        private var keys:Array;
        
        override public function create():void {
            keys = ['A','S','D','F',     'J','K','L','SEMICOLON'];

            var startingFriends:int = 8;
            allFriends = new FlxGroup();
            for(var i:uint = 0; i < startingFriends; i++) {
                allFriends.add(new Friend(0, 0));
            }

            sortFriends();
            add(allFriends);
        }

        override public function update():void {
            for each(var key:String in keys) {
                if(FlxG.keys.justPressed(key)) {
                    pressKey(key);
                }
            }

            if(FlxG.keys.justPressed('ONE')) {
                allFriends.add(new Friend(0,0));
                sortFriends();
            }

            if(FlxG.keys.justPressed('TWO')) {
                var removeFriend:Friend = allFriends.members[0];
                allFriends.remove(removeFriend, true);
                sortFriends();
            }
            
            super.update();
        }
        
        private function pressKey(key:String):void {
            var keyPosition:int = keys.indexOf(key);

            keyPosition = int((Number(keyPosition) / Number(keys.length)) * allFriends.members.length);

            FlxG.log('key position: ' + keyPosition);
            
            for(var i:int = 0; i < allFriends.members.length; i++) {
                var friend:Friend = allFriends.members[i];
                var friendKeyPosition:int = int( Number(i) / Number(allFriends.members.length) * allFriends.members.length );

                FlxG.log('friend position ' + i + ': ' + friendKeyPosition);
                
                if(keyPosition == friendKeyPosition) {
                    friend.jump();
                }
            }

            FlxG.log('-----');
        }
        
        public function sortFriends():void {
            var spread:int = 32;
            var baseX:int = (FlxG.width / 2) - ((allFriends.members.length * spread) / 2);
            
            for(var i:uint = 0; i < allFriends.members.length; i++) {
                var friend:Friend = allFriends.members[i];
                friend.x = baseX + (i * spread);
                friend.y = FlxG.height / 2;
            }
        }
    }
}