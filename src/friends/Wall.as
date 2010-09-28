package friends {
	import flash.geom.Rectangle;    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;    
    import net.flashpunk.graphics.TiledImage;    
    
    public class Wall extends Entity {
        [Embed (source="/../data/wall.png")]
        private var WallGraphic:Class;
        
        public var wallSprite:TiledImage;
        
        public function Wall(x:int = 0, y:int = 0, width:int = 16, height:int = 16):void {
            reset(x,y,width,height);
            type = "wall";
            graphic = wallSprite;

            layer = 5;
        }

        public function reset(x:int, y:int, width:int, height:int):void {
            wallSprite = new TiledImage(WallGraphic, width, height);
            
            setHitbox(width, height);

            this.x = x;
            this.y = y;

            graphic = wallSprite;
        }

        override public function update():void {
            if(y + (height * 2) < FP.camera.y || y - (height * 2) > FP.camera.y + FP.height) {
                FP.world.recycle(this);
            }
        }
    }
}