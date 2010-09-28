package friends {
    import net.flashpunk.FP;    
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.TiledSpritemap;

    public class Grinder extends Entity {
        [Embed (source="/../data/spinning-gears.png")]
        private var GrinderGraphic:Class;
        
        private var grinderSprite:TiledSpritemap;
        private var colorSwitchAccum:Number = 0;
        
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


        private function setRandomColor():void {
            // Try to generate random 'bright' colors by
            // working in Hue/Saturation/Value colorspace instead of RGB.
            var hue:Number = Math.random() * 360;
            var saturation:Number = 200;
            var value:Number = 200;
            var hsvcolor:Array = ColorUtils.HSVtoRGB(hue, saturation, value);
            grinderSprite.color = ColorUtils.RGBToHex(hsvcolor[0],hsvcolor[1],hsvcolor[2]);
        }
        
        override public function update():void {
            colorSwitchAccum += FP.elapsed;
            if(colorSwitchAccum >= 0.125) {
                setRandomColor();
                colorSwitchAccum = 0;
            }
            
            super.update();
        }
    }
}