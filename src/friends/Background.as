package friends {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    
    public class Background extends Entity {
        [Embed (source="/../data/background-repeatable.png")]
        private var BackgroundGraphic:Class;
        
        public function Background():void {
            super(0, -480);

            var image:Image = new Image(BackgroundGraphic)
            
            graphic = image;
        }
    }
}