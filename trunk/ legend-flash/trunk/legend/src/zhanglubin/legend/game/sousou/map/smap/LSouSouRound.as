package zhanglubin.legend.game.sousou.map.smap
{
	import flash.display.BitmapData;
	
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LGlobal;

	public class LSouSouRound extends LSprite
	{
		private var _belongLayer:LSprite;
		private var _countLayer:LSprite;
		public function LSouSouRound(belong:int,count:int)
		{
			super();
			var bitColor:BitmapData = new BitmapData(50,50,false,0x990000);
			trace("******* LSouSouRound belong = " + belong);
			var belongStr:String = (belong == LSouSouObject.BELONG_ENEMY)?"敌":(belong == LSouSouObject.BELONG_FRIEND?"友":"我");
			_belongLayer = LGlobal.getColorText(bitColor,belongStr + "军回合",150);
			_belongLayer.y = -_belongLayer.height/2;
			_countLayer = LGlobal.getColorText(bitColor,"第" + count + "回合",100);
			_countLayer.y = _belongLayer.y - _countLayer.height - 10;
			this.addChild(_countLayer);
			this.addChild(_belongLayer);
		}
	}
}