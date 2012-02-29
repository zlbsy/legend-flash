package zhanglubin.legend.game.sousou.map.smap
{
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;
	
	public class LSouSouCtrlMenuLayer extends LSprite
	{
		//menu
		private var _btn_lib:LButton;
		private var _btn_game:LButton;
		private var _btn_zk:LButton;
		private var _btn_member:LButton;
		private var _btn_equipment:LButton;
		private var _btn_luggage:LButton;
		private var _btn_system:LButton;
		private var _btn_gameclose:LButton;
		private var _cancel_menu:LButton;
		public function LSouSouCtrlMenuLayer()
		{
			super();
		}

		public function get cancel_menu():LButton
		{
			return _cancel_menu;
		}

		public function addMenu():void{
			
			_btn_lib = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"lib"));
			_btn_lib.filters = [new GlowFilter()];
			_btn_lib.xy = new LCoordinate(755,0);
			_btn_lib.addEventListener(MouseEvent.MOUSE_UP,libExplanation);
			LSouSouObject.sMap.menuLayer.addChild(_btn_lib);
			
			_btn_game = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"game"));
			_btn_game.filters = [new GlowFilter()];
			_btn_game.xy = new LCoordinate(755,45);
			_btn_game.addEventListener(MouseEvent.MOUSE_UP,libGameExplanation);
			LSouSouObject.sMap.menuLayer.addChild(_btn_game);
			
			_btn_zk = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"zk"));
			_btn_zk.filters = [new GlowFilter()];
			_btn_zk.xy = new LCoordinate(755,90);
			_btn_zk.addEventListener(MouseEvent.MOUSE_UP,zkView);
			LSouSouObject.sMap.menuLayer.addChild(_btn_zk);
			
			_btn_luggage = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"luggage_menu.png"));
			_btn_luggage.filters = [new GlowFilter()];
			_btn_luggage.xy = new LCoordinate(755,135);
			_btn_luggage.addEventListener(MouseEvent.MOUSE_UP,luggageShow);
			LSouSouObject.sMap.menuLayer.addChild(_btn_luggage);
			
			_btn_system = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"system_menu.png"));
			_btn_system.filters = [new GlowFilter()];
			_btn_system.xy = new LCoordinate(755,180);
			_btn_system.addEventListener(MouseEvent.MOUSE_UP,systemShow);
			LSouSouObject.sMap.menuLayer.addChild(_btn_system);
			//_btn_system.visible = false;
			
			_btn_gameclose = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"gameclose"));
			_btn_gameclose.filters = [new GlowFilter()];
			_btn_gameclose.xy = new LCoordinate(755,400);
			_btn_gameclose.addEventListener(MouseEvent.MOUSE_UP,gameClose);
			LSouSouObject.sMap.menuLayer.addChild(_btn_gameclose);
			
			_cancel_menu = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"cancel"));
			_cancel_menu.filters = [new GlowFilter()];
			_cancel_menu.xy = new LCoordinate(755,225);
			_cancel_menu.visible = false;
			LSouSouObject.sMap.menuLayer.addChild(_cancel_menu);
			
		}
		private function gameClose(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			LGlobal.script.lineList.unshift("endif;");
			LGlobal.script.lineList.unshift("SouSouGame.close();");
			LGlobal.script.lineList.unshift("if(@select==0);");
			LGlobal.script.lineList.unshift("SouSouTalk.select(1.关闭游戏,2.继续游戏);");
			LGlobal.script.analysis();
		}
		private function luggageShow(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindow();
			window.luggage();
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function zkView(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindow();
			window.condition(LSouSouObject.sMap.condition,true);
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function systemShow(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindow();
			//window.systemShow("read");
			window.systemShow();
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function libGameExplanation(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindow();
			window.libGameExplanation();
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function libExplanation(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindow();
			window.libExplanation();
			LGlobal.script.scriptLayer.addChild(window);
		}
	}
}