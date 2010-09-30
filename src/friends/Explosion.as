package friends {
    import net.flashpunk.FP;
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Emitter;
    
    public class Explosion extends Entity {
        private var particleEmitter:Emitter;

        [Embed (source="/../data/single-friend.png")]
        private var FriendChunkGraphic:Class;

        private var lifeSpan:Number = 3;

        private var numberOfFrames:int = 64;
        
        public function Explosion():void {
            particleEmitter = new Emitter(FriendChunkGraphic, 4, 4);
            graphic = particleEmitter;


            for(var i:int = 0; i < numberOfFrames; i++) {
                particleEmitter.newType("chunk_" + i, [i]);
                particleEmitter.setAlpha("chunk_" + i, 1, 0);
                particleEmitter.setMotion("chunk_" + i, 0, 0, 0.8, 360, 320, 1.0);
            }
            
            super();
        }

        public function reset(x:int, y:int, color:uint):void {
            this.x = x;
            this.y = y;

            lifeSpan = 3;


            for(var i:int = 0; i < numberOfFrames; i++) {
                particleEmitter.setColor("chunk_" + i, color)
            }
            
            for(var j:int = 0; j < 80; j++) {
                particleEmitter.emit("chunk_" + int(Math.random() * numberOfFrames), Math.random() * 32, Math.random() * 32);
            }
        }

        override public function update():void {
            lifeSpan -= FP.elapsed;
            
            super.update();
            
            if(lifeSpan <= 0) {
                FP.world.recycle(this);
            }
        }

        override public function render():void {
            super.render();
        }
    }
}