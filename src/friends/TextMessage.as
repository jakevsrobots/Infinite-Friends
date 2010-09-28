package friends {
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Text;    

    public class TextMessage extends Entity {
        private var textGraphic:Text;
        private var fadeLength:Number = 2.0;
        private var fadeTimer:Number = 0;
        public var autoFade:Boolean = true;
        public var destroyAfterFade:Boolean = true;
        private var colorSwitchAccum:Number = 0;
        
        public function TextMessage():void {
            textGraphic = new Text('blank', 0, 0);
            graphic = textGraphic;
            
            super();
        }

        public function reset(text:String, x:Number = 0, y:Number = 0, size:int = 16, autoFade:Boolean = true, destroyAfterFade:Boolean = true):void {
            // Do this swap because otherwise flashpunk won't render the clipping rectangle correctly
            var oldTextSize:int = Text.size;
            Text.size = size;
            textGraphic = new Text(text, x, y);
            textGraphic.size = size;
            graphic = textGraphic;

            Text.size = oldTextSize;
            textGraphic.centerOrigin();
            textGraphic.x = (FP.width / 2) - (textGraphic.width / 2);
            fadeTimer = fadeLength;

            this.autoFade = autoFade;
            this.destroyAfterFade = destroyAfterFade;
        }

        private function setRandomColor():void {
            // Try to generate random 'bright' colors by
            // working in Hue/Saturation/Value colorspace instead of RGB.
            var hue:Number = Math.random() * 360;
            var saturation:Number = 200;
            var value:Number = 200;
            var hsvcolor:Array = ColorUtils.HSVtoRGB(hue, saturation, value);
            textGraphic.color = ColorUtils.RGBToHex(hsvcolor[0],hsvcolor[1],hsvcolor[2]);
        }
        
        override public function update():void {
            colorSwitchAccum += FP.elapsed;
            if(colorSwitchAccum >= 0.125) {
                setRandomColor();
                colorSwitchAccum = 0;
            }
            
            if(autoFade) {
                if(fadeTimer > 0) {
                    fadeTimer -= FP.elapsed;

                    textGraphic.alpha = fadeTimer / fadeLength;
                    //textGraphic.scale = fadeTimer / fadeLength;
                    
                    if(fadeTimer <= 0) {
                        textGraphic.alpha = 0;
                        textGraphic.scale = 0;
                    }
                    
                    super.update();
                } else {
                    if(destroyAfterFade) {
                        FP.world.recycle(this);
                    }
                }
            } else {
                super.update();
            }
        }
    }
}