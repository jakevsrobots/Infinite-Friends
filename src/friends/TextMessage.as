package friends {
    import net.flashpunk.Entity;    
    import net.flashpunk.graphics.Text;    

    public class TextMessage extends Entity {
        private var textGraphic:Text;
        
        public function TextMessage(text:String, x:Number = 0, y:Number = 0):void {
            textGraphic = new Text(text, x, y);

            graphic = textGraphic;
        }
    }
}