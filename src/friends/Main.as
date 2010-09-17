package friends {
    import org.flixel.FlxGame;
    import org.flixel.FlxG;    
    import AssetLibrary;

    [SWF(width="640", height="480", backgroundColor="#000000")];
    
    public class Main extends FlxGame {
        public function Main():void {
            super(640, 480, PlayState, 1);

            //useDefaultHotKeys = false;
            FlxG.mouse.show();
        }
    }
}