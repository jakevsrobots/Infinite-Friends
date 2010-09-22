package friends {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    
    [SWF(width="640", height="480", backgroundColor="#000000")];
    
    public class Main extends Engine {
        public function Main():void {
            super(640, 480, 60, false);
            FP.world = new PlayWorld();
        }

        override public function init():void {
            //trace('loaded');
        }
    }
}