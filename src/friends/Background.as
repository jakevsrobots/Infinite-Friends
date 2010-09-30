package friends {
    import net.flashpunk.FP;    
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Backdrop;
    
    public class Background extends Entity {
        [Embed (source="/../data/background-repeatable.png")]
        private var BackgroundGraphic:Class;
        [Embed (source="/../data/starfield.jpg")]
        private var StarsGraphic:Class;

        private var colorSwitchAccum:Number = 0;
        
        public function Background():void {
            //graphic = new Backdrop(BackgroundGraphic);
            graphic = new Backdrop(StarsGraphic);
            layer = 10;
        }

        override public function update():void {
            if((FP.world as PlayWorld).activeFriends.length > 4) {
                colorSwitchAccum += FP.elapsed;
                if(colorSwitchAccum >= 0.125) {
                    setRandomColor();
                    colorSwitchAccum = 0;
                }
            } else {
                (graphic as Backdrop).color = 0xffffffff;
            }
            
            super.update();
        }
        
        private function setRandomColor():void {
            // Try to generate random 'bright' colors by
            // working in Hue/Saturation/Value colorspace instead of RGB.
            var hue:Number = Math.random() * 360;
            var saturation:Number = 200;
            var value:Number = 200;
            var hsvcolor:Array = ColorUtils.HSVtoRGB(hue, saturation, value);
            (graphic as Backdrop).color = ColorUtils.RGBToHex(hsvcolor[0],hsvcolor[1],hsvcolor[2]);
        }
    }
}