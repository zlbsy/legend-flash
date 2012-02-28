package zhanglubin.legend.game.sousou.object
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.map.*;
	import zhanglubin.legend.game.sousou.script.LSouSouSoundScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;

	public class LSouSouObject
	{
		
		/**
		 *所属 （0我方，1敌方，-1友方）
		 **/
		public static const BELONG_SELF:int = 0;
		public static const BELONG_FRIEND:int = -1;
		public static const BELONG_ENEMY:int = 1;
		public static const OFF:String = "off";
		public static const ON:String = "on";
		public static const AVERAGE:String = "average";
		public static const FAST:String = "fast";
		public static const SOUND_FLAG:String = "SOUND_FLAG";
		public static const SPEED_FLAG:String = "SPEED_FLAG";
		public static const STR_IMG:String = "img";
		public static const STR_COLOR:String = "color";
		public static var sound:LSouSouSoundScript = new LSouSouSoundScript();
		public static var charaR0List:Array = [];
		public static var charaR1List:Array = [];
		public static var charaATKList:Array = [];
		public static var charaMOVList:Array = [];
		public static var charaSPCList:Array = [];
		public static var charaFaceList:Array = [];
		public static var meffImg:Array = [];
		public static var itemImg:Array = [];
		public static var chara:XML;
		public static var arms:XML;
		public static var mapStage:XML;
		public static var item:XML;
		public static var strategy:XML;
		public static var props:XML;
		public static var skill:XML;
		public static var terrain:XML;
		public static var talk:Boolean;
		public static var dieIsRuning:Boolean = false;
		public static var talkLayer:LSprite;
		public static var rStarQuery:LSouSouStarR;
		public static var sStarQuery:LSouSouStarS;
		public static var charaSNow:LSouSouCharacterS;
		public static var runSChara:LSouSouCharacterS;
		public static var rMap:LSouSouRMap;
		public static var sMap:LSouSouSMap;
		public static var storyCtrl:Boolean;
		public static var returnFunction:Function;
		public static var checkFunction:Function;
		public static var memberList:Array;
		public static var perWarList:Array;
		public static var window:LSouSouWindow;
		public static var money:int;
		public static var itemsList:XML = <data></data>;
		public static var propsList:XML = <data></data>;
		
		/** 
		 *S存档回复用xml
		 */
		public static var sMapSaveXml:XML;
		/**
		public static var propsList:XML = <data>
			<list index='0' num='6' />
			<list index='1' num='10' />
			<list index='0' num='6' />
			<list index='1' num='10' />
			<list index='0' num='6' />
			<list index='1' num='10' />
			<list index='0' num='6' />
			<list index='1' num='10' />
			<list index='0' num='6' />
			<list index='1' num='10' />
		</data>;
		*/
		public static function addBoxBitmapdata(_menuBitmapData:BitmapData):BitmapData{
			var bar_h:int = 15;
			var btn_h:int = 34;
			var btn_w:int = 115;
			var bar_w:int = 5;
			var menu_w:int = _menuBitmapData.width,menu_h:int = _menuBitmapData.height;
			
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,0));
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(0,0));
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(menu_w - bar_w,0));
			_menuBitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,menu_h - bar_w));
			
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,0));
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,0));
			_menuBitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,menu_h - bar_h));
			_menuBitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,menu_h - bar_h));
			return _menuBitmapData;
		}
		public static function getBoxBitmapData(menu_w:int,menu_h:int):BitmapData{
			var bar_h:int = 15;
			var btn_h:int = 34;
			var btn_w:int = 115;
			var bar_w:int = 5;
			var _menuBitmapData:BitmapData = new BitmapData(menu_w,menu_h,false,0x333333);
			
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,0));
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(0,0));
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(menu_w - bar_w,0));
			_menuBitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,menu_h - bar_w));
			
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,0));
			_menuBitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,0));
			_menuBitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,menu_h - bar_h));
			_menuBitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,menu_h - bar_h));
			return _menuBitmapData;
		}
		public static function setBox(_menuX:int,_menuY:int,_menuW:int,_menuH:int,layer:LSprite):void{
			var _menuBitmap:LBitmap;
			_menuBitmap = new LBitmap(new BitmapData(_menuW,5,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,_menuH,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,_menuH,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuW + _menuX - _menuBitmap.width;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(_menuW,5,true));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY + _menuH - 5;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"));
			_menuBitmap.x = _menuW + _menuX - 15;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY + _menuH - 15;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")));
			_menuBitmap.x = _menuW + _menuX - 15;
			_menuBitmap.y = _menuY + _menuH - 15;
			layer.addChild(_menuBitmap);
		}
	}
}