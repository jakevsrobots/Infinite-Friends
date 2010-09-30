package friends {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    
    [SWF(width="480", height="540", backgroundColor="#000000")];
    
    public class Main extends Engine {
        public function Main():void {
            super(480, 540, 60, false);
            FP.screen.scale = 1;
            
            //FP.console.enable();

            FP.world = new PlayWorld();
            //FP.world = new Preloader("friends.PlayWorld");
        }

        override public function init():void {
            //trace('loaded');
        }
    }
}