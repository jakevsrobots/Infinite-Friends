package friends {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    
    [SWF(width="480", height="640", backgroundColor="#000000")];
    
    public class Main extends Engine {
        public function Main():void {
            super(480, 640, 60, false);
            FP.screen.scale = 1;
            
            //FP.console.enable();

            FP.world = new PlayWorld();
        }

        override public function init():void {
            //trace('loaded');
        }
    }
}