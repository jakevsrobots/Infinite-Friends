package friends {
    import org.flixel.*;

    public class PlayState extends FlxState {
        var friends:FlxGroup;
        
        override public function create():void {
            friends = new FlxGroup();
            for(var i:uint = 0; i < 8; i++) {
                friends.add(new Friend(0, 0));
            }

            sortFriends();
            
            add(friends);
        }

        override public function update():void {
            if(FlxG.keys.justPressed('A')) {
                player.jump();
            }
            
            super.update();
        }

        public function sortFriends():void {
            for each() {
            }
        }
    }
}