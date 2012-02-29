package zhanglubin.legend.game.sousou.menu
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.sousou.object.LSouSouSMapMethod;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouSMapMenuProps extends LSprite
	{
		private var _menuBitmap:LBitmap;
		private var _menuSelect:LBitmap;
		private var _menuScrollbar:LScrollbar;
		private var _menuBack:LSprite;
		private var _propsList:Array;
		public function LSouSouSMapMenuProps(charaCoordinate:LCoordinate)
		{
			addMenu(charaCoordinate);
		}
		private function addMenu(charaCoordinate:LCoordinate):void{
			var bar_h:int = 15;
			var btn_h:int = 34;
			var btn_w:int = 115;
			var bar_w:int = 5;
			var menu_w:int=165;
			var menu_h:int = 20 + btn_h*5;
			_menuBitmap = new LBitmap(new BitmapData(menu_w,menu_h,false,0x333333));
			charaCoordinate.x += LSouSouObject.sMap.nodeLength;
			if(charaCoordinate.x + LSouSouObject.sMap.mapCoordinate.x + _menuBitmap.width > LSouSouObject.sMap.SCREEN_WIDTH)charaCoordinate.x -= (_menuBitmap.width + LSouSouObject.sMap.nodeLength); 
			if(charaCoordinate.y + LSouSouObject.sMap.mapCoordinate.y + _menuBitmap.height > LSouSouObject.sMap.SCREEN_HEIGHT)charaCoordinate.y = LSouSouObject.sMap.SCREEN_HEIGHT-_menuBitmap.height - LSouSouObject.sMap.mapCoordinate.y;
			//this.xy = charaCoordinate;
			this.x = charaCoordinate.x + LSouSouObject.sMap.mapCoordinate.x;
			this.y = charaCoordinate.y + LSouSouObject.sMap.mapCoordinate.y;
			_menuSelect = new LBitmap(new BitmapData(btn_w,btn_h,false));
			
			//_menuBitmap.bitmapData.copyPixels(backBitmapdata,new Rectangle(0,0,135,184),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(menu_w - bar_w,0));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,menu_h - bar_w));
			
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,0));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,menu_h - bar_h));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,menu_h - bar_h));
			this.addChild(_menuBitmap);
			
			//_menuScrollbar
			_menuBack = new LSprite();
			_menuSelect.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_select.png"),
				new Rectangle(0,0,btn_w,btn_h),new Point(0,0));
			_menuSelect.alpha = 0;
			_menuBack.addChild(_menuSelect);
			var slist:XML;
			var lbltext:LLabel;
			var lblnum:LLabel;
			var index:int = 0;
			var img:LBitmap;
			_propsList = new Array();
			for each(slist in LSouSouObject.propsList.elements()){
				if(int(slist.@num.toString()) == 0)continue;
				img = new LBitmap(new BitmapData(10,btn_h));
				img.alpha = 0;
				img.xy = new LCoordinate(0,btn_h*index);
				_menuBack.addChild(img);
				lbltext = new LLabel();
				lbltext.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.props["Props"+slist.@index].Name+"</b></font>";
				lbltext.xy = new LCoordinate(25 + (90-lbltext.width)/2,btn_h*index + (btn_h - lbltext.height)/2);
				_menuBack.addChild(lbltext);
				
				img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],LSouSouObject.props["Props"+slist.@index].Icon));
				img.width = 30;
				img.height = 30;
				img.xy = new LCoordinate(5,btn_h*index + (btn_h - img.height)/2);
				_menuBack.addChild(img);
				lblnum = new LLabel();
				lblnum.htmlText = "<font color='#ffffff' size='15'><b>"+slist.@num+"</b></font>";
				lblnum.xy = new LCoordinate(100,btn_h*index + (btn_h - lbltext.height)/2);
				_menuBack.addChild(lblnum);
				_propsList.push(slist.@index);
				index++;
			}
			_menuScrollbar = new LScrollbar(_menuBack,125,btn_h*5,20,false);
			_menuScrollbar.x = 10;
			_menuScrollbar.y = bar_w + 5;
			this.addChild(_menuScrollbar);
		}
		public function onMove(mx:int,my:int):void{
			var btn_h:int = 34;
			var bar_w:int = 5;
			my -= this.y;
			if(mx >= this.x + 10 && mx <= this.x + 125){
				_menuSelect.alpha = 1;
				_menuSelect.y = int((my - _menuBack.y - bar_w - 5)/btn_h)*btn_h;
				
			}else{
				_menuSelect.alpha = 0;
			}
		}
		public function onClick(mx:int,my:int):void{
			var btn_h:int = 34;
			var bar_w:int = 5;
			my -= this.y;
			var propsIndex:int;
			if(mx >= this.x + 10 && mx <= this.x + 125){
				propsIndex = int((my - _menuBack.y - bar_w - 5)/btn_h);
				if(propsIndex < this._propsList.length){
					LSouSouObject.sMap.menu.name = "";
					LSouSouObject.sMap.menu.removeFromParent();
					this.removeFromParent();
					LSouSouObject.sMap.menu = null;
					LSouSouObject.sMap.cancel_menu.removeAllEventListener();
					LSouSouObject.sMap.cancel_menu.addEventListener(MouseEvent.MOUSE_UP,function(event:MouseEvent):void{
						LSouSouObject.sMap.cancel_menu.removeAllEventListener();
						LSouSouObject.sMap.props = null;
						LSouSouObject.sMap.showCtrlMenu("props");
						LSouSouObject.sMap.cancel_menu.addEventListener(MouseEvent.MOUSE_UP,function(event:MouseEvent):void{
							LSouSouObject.sMap.cancel_menu.removeAllEventListener();
							LSouSouObject.sMap.cancel_menu.visible = false;
							LSouSouObject.sMap.menu.name = "";
							LSouSouObject.sMap.menu.removeFromParent();
							LSouSouObject.sMap.menu = null;
							LSouSouObject.sMap.showCtrlMenu("ctrl");
						});
					});
					LSouSouObject.sMap.props = LSouSouObject.props["Props" + _propsList[propsIndex]];
					LSouSouObject.sMap.props.index = _propsList[propsIndex];
					
				}
			}
			
		}
	}
}