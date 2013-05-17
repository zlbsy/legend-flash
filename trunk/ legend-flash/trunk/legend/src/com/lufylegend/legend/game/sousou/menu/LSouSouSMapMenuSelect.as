package com.lufylegend.legend.game.sousou.menu
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterS;
	import com.lufylegend.legend.game.sousou.map.LSouSouCharacterProfile;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.game.sousou.object.LSouSouSMapMethod;
	import com.lufylegend.legend.objects.LAnimation;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LSouSouSMapMenuSelect extends LSprite
	{
		private var _menuBitmap:LBitmap;
		private var _menuSelect:LBitmap;
		public function LSouSouSMapMenuSelect(charaCoordinate:LCoordinate)
		{
			LSouSouSMapMethod.setLocation();
			if(LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF && LSouSouObject.charaSNow.action_mode != LSouSouCharacterS.MODE_STOP){
				addMenuOur(charaCoordinate);
			}else{
				addMenu(charaCoordinate);
			}
		}
		private function addMenuOur(charaCoordinate:LCoordinate):void{
			var bar_h:int = 15;
			var btn_h:int = 34;
			var btn_w:int = 115;
			var bar_w:int = 5;
			var menu_w:int=135;
			var menu_h:int = 20 + btn_h*4;
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
			
			_menuSelect.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_select.png"),
				new Rectangle(0,0,btn_w,btn_h),new Point(0,0));
			_menuSelect.alpha = 0;
			_menuSelect.x = (menu_w - btn_w) / 2;
			this.addChild(_menuSelect);
			
			var lbl01:LLabel = new LLabel();
			lbl01.htmlText = "<font color='#ffffff' size='15'><b>武将移动</b></font>";
			lbl01.xy = new LCoordinate(35 + (90-lbl01.width)/2,bar_w + 5 + (btn_h - lbl01.height)/2);
			var lbl02:LLabel = new LLabel();
			lbl02.htmlText = "<font color='#ffffff' size='15'><b>武将情报</b></font>";
			lbl02.xy = new LCoordinate(35 + (90-lbl02.width)/2,btn_h +bar_w + 5 + (btn_h - lbl02.height)/2);
			var lbl03:LLabel = new LLabel();
			lbl03.htmlText = "<font color='#ffffff' size='15'><b>原地待命</b></font>";
			lbl03.xy = new LCoordinate(35 + (90-lbl03.width)/2,2*btn_h +bar_w + 5 + (btn_h - lbl03.height)/2);
			var lbl04:LLabel = new LLabel();
			lbl04.htmlText = "<font color='#ffffff' size='15'><b>行动取消</b></font>";
			lbl04.xy = new LCoordinate(35 + (90-lbl04.width)/2,3*btn_h +bar_w + 5 + (btn_h - lbl04.height)/2);
			this.addChild(lbl01);
			this.addChild(lbl02);
			this.addChild(lbl03);
			this.addChild(lbl04);
			
			var img:LBitmap;
			img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_move.png"));
			img.xy = new LCoordinate(15,bar_w + 5 + (btn_h - img.height)/2);
			this.addChild(img);
			img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_chara.png"));
			img.xy = new LCoordinate(15,btn_h +bar_w + 5 + (btn_h - img.height)/2);
			this.addChild(img);
			img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_stop.png"));
			img.xy = new LCoordinate(15,2*btn_h +bar_w + 5 + (btn_h - img.height)/2);
			this.addChild(img);
			img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_cancel.png"));
			img.xy = new LCoordinate(15,3*btn_h +bar_w + 5 + (btn_h - img.height)/2);
			this.addChild(img);
		}
		private function addMenu(charaCoordinate:LCoordinate):void{
			var bar_h:int = 15;
			var btn_h:int = 34;
			var btn_w:int = 115;
			var bar_w:int = 5;
			var menu_w:int=135;
			var menu_h:int = 20 + btn_h*2;
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
			
			_menuSelect.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_select.png"),
				new Rectangle(0,0,btn_w,btn_h),new Point(0,0));
			_menuSelect.alpha = 0;
			_menuSelect.x = (menu_w - btn_w) / 2;
			this.addChild(_menuSelect);
			var lbl01:LLabel = new LLabel();
			lbl01.htmlText = "<font color='#ffffff' size='15'><b>武将情报</b></font>";
			lbl01.xy = new LCoordinate(35 + (90-lbl01.width)/2,bar_w + 5 + (btn_h - lbl01.height)/2);
			var lbl02:LLabel = new LLabel();
			lbl02.htmlText = "<font color='#ffffff' size='15'><b>行动取消</b></font>";
			lbl02.xy = new LCoordinate(35 + (90-lbl02.width)/2,btn_h +bar_w + 5 + (btn_h - lbl02.height)/2);
			this.addChild(lbl01);
			this.addChild(lbl02);
			//this.addChild(lbl03);
			//this.addChild(lbl04);
			
			var img:LBitmap;
			img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_chara.png"));
			img.xy = new LCoordinate(15,bar_w + 5 + (btn_h - img.height)/2);
			this.addChild(img);
			img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_cancel.png"));
			img.xy = new LCoordinate(15,btn_h +bar_w + 5 + (btn_h - img.height)/2);
			this.addChild(img);
		}
		public function onMove(mx:int,my:int):void{
			var btn_h:int = 34;
			var bar_w:int = 5;
			if(mx >= this.x + 10 && mx <= this.x + 125){
				if(my >= this.y + bar_w + 5 && my < this.y + btn_h + bar_w + 5){
					_menuSelect.alpha = 1;
					_menuSelect.y = bar_w + 5;
				}else if(my >= this.y + btn_h + bar_w + 5 && my < this.y + 2*btn_h + bar_w + 5){
					_menuSelect.alpha = 1;
					_menuSelect.y = btn_h + bar_w + 5;
				}else if(my >= this.y + 2*btn_h + bar_w + 5 && my < this.y + 3*btn_h + bar_w + 5 && this.height > 4*btn_h + bar_w + 5){
					_menuSelect.alpha = 1;
					_menuSelect.y = 2*btn_h + bar_w + 5;
				}else if(my >= this.y + 3*btn_h + bar_w + 5 && my < this.y + 4*btn_h + bar_w + 5 && this.height > 4*btn_h + bar_w + 5){
					_menuSelect.alpha = 1;
					_menuSelect.y = 3*btn_h + bar_w + 5;
				}else{
					_menuSelect.alpha = 0;
				}
			}else{
				_menuSelect.alpha = 0;
			}
		}
		public function onClick(mx:int,my:int):void{
			if(LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF && LSouSouObject.charaSNow.action_mode != LSouSouCharacterS.MODE_STOP){
				onClickMenuOur(mx,my);
			}else{
				onClickMenu(mx,my);
			}
		}
		private function onClickMenuOur(mx:int,my:int):void{
			var btn_h:int = 34;
			var bar_w:int = 5;
			var clickon:Boolean;
			var i:int;
			var thisChara:LSouSouCharacterS;
			if(mx >= this.x + 10 && mx <= this.x + 125){
				if(my >= this.y + bar_w + 5 && my < this.y + btn_h + bar_w + 5){
					LSouSouObject.sMap.roadList = LSouSouObject.sStarQuery.makePath(LSouSouObject.charaSNow);
					
					name = "";
					removeFromParent();
					LSouSouObject.sMap.menu = null;
					
				}else if(my >= this.y + btn_h + bar_w + 5 && my < this.y + 2*btn_h + bar_w + 5){
					showProfile();
				}else if(my >= this.y + 2*btn_h + bar_w + 5 && my < this.y + 3*btn_h + bar_w + 5 && this.height > 4*btn_h + bar_w + 5){
					this.name = "";
					this.removeFromParent();
					LSouSouObject.sMap.showCtrlMenu();
					
				}else if(my >= this.y + 3*btn_h + bar_w + 5 && my < this.y + 4*btn_h + bar_w + 5 && this.height > 4*btn_h + bar_w + 5){
					removeMenu();
				}
			}
		}
		private function onClickMenu(mx:int,my:int):void{
			var btn_h:int = 34;
			var bar_w:int = 5;
			var clickon:Boolean;
			var i:int;
			var thisChara:LSouSouCharacterS;
			if(mx >= this.x + 10 && mx <= this.x + 125){
				if(my >= this.y + bar_w + 5 && my < this.y + btn_h + bar_w + 5){
					showProfile();
				}else if(my >= this.y + btn_h + bar_w + 5 && my < this.y + 2*btn_h + bar_w + 5){
					removeMenu();
				}
			}
		}
		private function showProfile():void{
			name = "";
			removeFromParent();
			LSouSouObject.sMap.menu = null;
			var profile:LSouSouCharacterProfile = new LSouSouCharacterProfile();
			LGlobal.script.scriptLayer.addChild(profile);
		}
		private function removeMenu():void{
			this.name = "";
			this.removeFromParent();
			LSouSouObject.sMap.menu = null;
		}
	}
}