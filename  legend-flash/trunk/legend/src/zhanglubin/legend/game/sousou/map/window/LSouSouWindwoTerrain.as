package zhanglubin.legend.game.sousou.map.window
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.components.LRadioChild;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class LSouSouWindwoTerrain extends LSouSouWindow
	{
		private var _bitmap:LBitmap;
		private var _name:LLabel;
		private var _hlbl:LLabel;
		private var _flbl:LLabel;
		private var _slbl:LLabel;
		private var _dlbl:LLabel;
		public function LSouSouWindwoTerrain()
		{
			super();
		}
		public function show(mx:int,my:int):void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.1,5);
			LSouSouObject.window = this;
			var fun:Function;
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			
			var tx:int = int(mx/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength;
			var ty:int = int(my/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength;
			_bitmap = new LBitmap(new BitmapData(LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength));
			_bitmap.bitmapData.copyPixels(LSouSouObject.sMap.map.bitmapData,new Rectangle(tx,ty,LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength),new Point(0,0));
			this.addChild(_bitmap);
			
			var intX:int = int((mx - LSouSouObject.sMap.mapCoordinate.x)/LSouSouObject.sMap.nodeLength);
			var intY:int = int((my - LSouSouObject.sMap.mapCoordinate.y)/LSouSouObject.sMap.nodeLength);
			var meffStr:String = LSouSouObject.terrain["Terrain"+LSouSouObject.sMap.mapData[intY][intX]].@meff;
			_hlbl = new LLabel();
			_hlbl.htmlText = "<font color='#ffffff' size='15'><b>火</b></font>";
			_flbl = new LLabel();
			_flbl.htmlText = "<font color='#ffffff' size='15'><b>风</b></font>";
			_slbl = new LLabel();
			_slbl.htmlText = "<font color='#ffffff' size='15'><b>水</b></font>";
			_dlbl = new LLabel();
			_dlbl.htmlText = "<font color='#ffffff' size='15'><b>地</b></font>";
			this.addChild(_hlbl);
			this.addChild(_flbl);
			this.addChild(_slbl);
			this.addChild(_dlbl);
			_hlbl.alpha = 0.2;
			_flbl.alpha = 0.2;
			_slbl.alpha = 0.2;
			_dlbl.alpha = 0.2;
			if(meffStr.length > 0){
				var meffs:Array = meffStr.split(",");
				for each(var meff:int in meffs){
					if(meff == 1){
						_hlbl.alpha = 1;
					}else if(meff == 2){
						_flbl.alpha = 1;
					}else if(meff == 3){
						_slbl.alpha = 1;
					}else if(meff == 4){
					}
				}
				
			}
			
			_name = new LLabel();
			_name.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.terrain["Terrain"+LSouSouObject.sMap.mapData[intY][intX]]+"</b></font>";
			this.addChild(_name);
			if(tx < LSouSouObject.sMap.nodeLength){
				tx = LSouSouObject.sMap.nodeLength;
			}else if(tx > 672){
				tx = 672;
			}
			if(ty < LSouSouObject.sMap.nodeLength){
				ty = LSouSouObject.sMap.nodeLength;
			}else if(ty > 384){
				ty = 384;
			}
			_bitmap.x = tx;
			_bitmap.y = ty;
			_name.x = tx + (LSouSouObject.sMap.nodeLength - _name.width)/2;
			_name.y = ty - LSouSouObject.sMap.nodeLength + (LSouSouObject.sMap.nodeLength - _name.height)/2;
			_hlbl.x = tx - 25;
			_flbl.x = tx;
			_slbl.x = tx + 25;
			_dlbl.x = tx + 50;
			
			_hlbl.y = ty + LSouSouObject.sMap.nodeLength + (LSouSouObject.sMap.nodeLength - _name.height)/2;
			_flbl.y = ty + LSouSouObject.sMap.nodeLength + (LSouSouObject.sMap.nodeLength - _name.height)/2;
			_slbl.y = ty + LSouSouObject.sMap.nodeLength + (LSouSouObject.sMap.nodeLength - _name.height)/2;
			_dlbl.y = ty + LSouSouObject.sMap.nodeLength + (LSouSouObject.sMap.nodeLength - _name.height)/2; 
			var tw:int = LSouSouObject.sMap.nodeLength*3;
			var th:int = tw;
			LDisplay.drawRect(this.graphics,[tx-LSouSouObject.sMap.nodeLength,ty-LSouSouObject.sMap.nodeLength,tw,th],true,0x000000,0.7,5);
			
			setBox(tx-LSouSouObject.sMap.nodeLength,ty-LSouSouObject.sMap.nodeLength,tw,th);
			
			
			this.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
			});
		}
	}
}