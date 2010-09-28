package friends {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Backdrop;
    
    public class Background extends Entity {
        [Embed (source="/../data/background-repeatable.png")]
        private var BackgroundGraphic:Class;
        [Embed (source="/../data/starfield.jpg")]
        private var StarsGraphic:Class;
        
        public function Background():void {
            //graphic = new Backdrop(BackgroundGraphic);
            graphic = new Backdrop(StarsGraphic);
            layer = 10;
        }
    }
}