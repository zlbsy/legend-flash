package com.lufylegend.legend.game.sousou.meff
{
	import flash.display.BitmapData;
	
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterS;
	import com.lufylegend.legend.game.sousou.object.LSouSouCalculate;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.objects.LAnimation;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;

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