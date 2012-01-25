package zhanglubin.legend.game.sousou.meff
{
	import flash.display.BitmapData;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouCalculate;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.objects.LAnimation;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;

	public class LSouSouSkill extends LBitmap
	{
		private const SPEED:int = 1;
		private var _speed:int = 0;
		private var _dataArray:Array;
		private var _animation:LAnimation;
		private var _overfun:Function;
		public function LSouSouSkill(fun:Function)
		{
			super();
			_overfun = fun;
			setImage();
		}

		private function setImage():void{
			var _skilllength:int = 12;
			var bit:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"skillview");
			var bitarr:Array = LImage.divideByCopyPixels(bit,1,_skilllength);
			_dataArray = new Array();
			_dataArray.push(bitarr);
			this._animation = new LAnimation(bitarr);
			this._animation.rowIndex = 0;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			
			this._animation.addEventListener(LEvent.ANIMATION_COMPLETE,function():void{
				LSouSouObject.sMap.skill = null;
				_overfun();
			});
			this.x = 0;
			this.y = 100;
		}
		/**
		 *贞
		 */
		public function onFrame():void{
			if(!(_speed++ % SPEED == 0))return;
			_speed -= SPEED;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			
		}
	}
}