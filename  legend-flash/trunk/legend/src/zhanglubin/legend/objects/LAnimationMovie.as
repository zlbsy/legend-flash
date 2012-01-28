package zhanglubin.legend.objects
{
	import flash.events.Event;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LSprite;
	
	public class LAnimationMovie extends LSprite
	{
		private var _animation:LAnimation;
		private var _bitmap:LBitmap;
		private var _mode:int = LAnimation.POSITIVE;
		private var _speed:int = 1;
		private var _speedIndex:int = 1;
		public function LAnimationMovie(anima:LAnimation,speed:int = 1)
		{
			super();
			_animation = anima;
			_speed = speed;
			_bitmap = new LBitmap(_animation.dataBMP);
			this.addChild(_bitmap);
			this.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		private function onFrame(event:Event):void{
			if(!(_speedIndex++ % _speed == 0))return;
			_speedIndex -= _speed;
			this._animation.run(_mode);
			_bitmap.bitmapData = this._animation.dataBMP;
		}
		public function set action(value:int):void
		{
			this._animation.rowIndex = value;
			this._animation.run(LAnimation.POSITIVE);
			_bitmap.bitmapData = this._animation.dataBMP;
			//this._mode = LAnimation.CIRCULATION;
		}
	}
}