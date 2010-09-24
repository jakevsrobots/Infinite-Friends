package friends {
	import flash.geom.Rectangle;    
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Canvas;
    
    public class Wall extends Entity {
        public var wallSprite:Canvas;
        
        public function Wall(x:int, y:int, width:int = 16, height:int = 16):void {
            wallSprite = new Canvas(width, height);
            wallSprite.fill(new Rectangle(x, y, width, height));
            
            graphic = wallSprite;
            type="solid";
            
            setHitBox(width, height);

            this.x = x;
            this.y = y;
            
            type = "Wall";
        }
    }
}