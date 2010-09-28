package friends {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Backdrop;
    
    public class Background extends Entity {
        [Embed (source="/../data/background-repeatable.png")]
        private var BackgroundGraphic:Class;
        
        public function Background():void {
            graphic = new Backdrop(BackgroundGraphic);
        }
    }
}