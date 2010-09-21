package friends {
    import org.flixel.FlxGame;
    import org.flixel.FlxG;    

    [SWF(width="640", height="480", backgroundColor="#000000")];
    
    public class Main extends FlxGame {
        public function Main():void {
            super(320, 240, PlayState, 2);

            //useDefaultHotKeys = false;
            FlxG.mouse.show();
        }
    }
}