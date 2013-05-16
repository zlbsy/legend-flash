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

	public class LSouSouMeffShow extends LBitmap
	{
		private const SPEED:int = 1;
		private var _speed:int = 0;
		private var _dataArray:Array;
		private var _animation:LAnimation;
		private var _overfun:Function;
		private var _index:int;
		public function LSouSouMeffShow(mx:int,my:int,_meffXml:XMLList,fun:Function=null)
		{
			super();
			this.x = mx;
			this.y = my;
			_overfun = fun;
			setImage(_meffXml);
		}

		private function setImage(_meffXml:XMLList):void{
			trace("_meffXml = " + _meffXml);
			var _mefflength:int = int(_meffXml.Num.toString());
			var _skilllength:int = 12;
			
			//var bit:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["meff"],_meffXml.Img.toString());
			var bit:BitmapData = LSouSouObject.meffImg[_meffXml.Img.toString()];
			var arr:Array = LImage.divideByCopyPixels(bit,_mefflength,1);
			_dataArray = new Array();
			var i:int;
			var bitarr:Array = new Array();
			for(i=0;i<_mefflength;i++){
				bitarr.push(arr[i][0]);
			}
			_dataArray.push(bitarr);
			this._animation = new LAnimation(_dataArray);
			//this._animation = new LAnimation(bitarr);
			this._animation.rowIndex = 0;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			
			this._animation.addEventListener(LEvent.ANIMATION_COMPLETE,function():void{
				LSouSouObject.sMap.meffShowList.splice(_index,1);
				if(_overfun != null)_overfun();
			});
		}
		/**
		 *贞
		 */
		public function onFrame(i:int):void{
			if(!(_speed++ % SPEED == 0))return;
			_index = i;
			_speed -= SPEED;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			
		}
	}
}