package friends {
    import net.flashpunk.FP;    
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.TiledSpritemap;

    public class Grinder extends Entity {
        [Embed (source="/../data/spinning-gears.png")]
        private var GrinderGraphic:Class;
        
        private var grinderSprite:TiledSpritemap;
        
        public function Grinder(x:int, y:int):void {
            super();

            this.x = x;
            this.y = y;

            grinderSprite = new TiledSpritemap(GrinderGraphic, 16, 16, FP.width, 16);
            grinderSprite.add('spin', [0,1,2,3,4,5], 16, true);
            grinderSprite.play('spin');
            grinderSprite.scale = 2;
            
            graphic = grinderSprite;

            setHitbox(FP.width, 32, 0, 0);
            
            type = 'grinder';
        }
    }
}