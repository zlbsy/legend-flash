package com.lufylegend.legend.game.sousou.map.rmap
{
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import com.lufylegend.legend.display.LButton;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterS;
	import com.lufylegend.legend.game.sousou.map.LSouSouCharacterProfile;
	import com.lufylegend.legend.game.sousou.map.LSouSouWindow;
	import com.lufylegend.legend.game.sousou.map.window.LSouSouWindwoArchive;
	import com.lufylegend.legend.game.sousou.map.window.LSouSouWindwoCondition;
	import com.lufylegend.legend.game.sousou.map.window.LSouSouWindwoEquipment;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.math.LCoordinate;
	
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
			LSouSouObject.rMap.menuLayer.addChild(_btn_lib);
			
			_btn_game = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"game"));
			_btn_game.filters = [new GlowFilter()];
			_btn_game.xy = new LCoordinate(755,45);
			_btn_game.addEventListener(MouseEvent.MOUSE_UP,libGameExplanation);
			LSouSouObject.rMap.menuLayer.addChild(_btn_game);
			
			_btn_member = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"member"));
			_btn_member.filters = [new GlowFilter()];
			_btn_member.xy = new LCoordinate(755,90);
			_btn_member.addEventListener(MouseEvent.MOUSE_UP,memberView);
			LSouSouObject.rMap.menuLayer.addChild(_btn_member);
			
			_btn_equipment = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"equipment_menu.png"));
			_btn_equipment.filters = [new GlowFilter()];
			_btn_equipment.xy = new LCoordinate(755,135);
			_btn_equipment.addEventListener(MouseEvent.MOUSE_UP,equipmentChange);
			LSouSouObject.rMap.menuLayer.addChild(_btn_equipment);
			
			_btn_luggage = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"luggage_menu.png"));
			_btn_luggage.filters = [new GlowFilter()];
			_btn_luggage.xy = new LCoordinate(755,180);
			_btn_luggage.addEventListener(MouseEvent.MOUSE_UP,luggageShow);
			LSouSouObject.rMap.menuLayer.addChild(_btn_luggage);
			
			_btn_system = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"system_menu.png"));
			_btn_system.filters = [new GlowFilter()];
			_btn_system.xy = new LCoordinate(755,225);
			_btn_system.addEventListener(MouseEvent.MOUSE_UP,systemShow);
			LSouSouObject.rMap.menuLayer.addChild(_btn_system);
			
			_btn_gameclose = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"gameclose"));
			_btn_gameclose.filters = [new GlowFilter()];
			_btn_gameclose.xy = new LCoordinate(755,400);
			_btn_gameclose.addEventListener(MouseEvent.MOUSE_UP,gameClose);
			LSouSouObject.rMap.menuLayer.addChild(_btn_gameclose);
			//_menuLayer.x = 6;
			
		}
		private function gameClose(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			LGlobal.script.lineList.unshift("endif;");
			LGlobal.script.lineList.unshift("SouSouGame.close();");
			LGlobal.script.lineList.unshift("if(@select==0);");
			LGlobal.script.lineList.unshift("SouSouTalk.select(1.关闭游戏,2.继续游戏);");
			LGlobal.script.analysis();
		}
		private function memberView(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			LSouSouObject.charaSNow = new LSouSouCharacterS(LSouSouObject.memberList[0],0,0,0);
			var profile:LSouSouCharacterProfile = new LSouSouCharacterProfile(0);
			
			LGlobal.script.scriptLayer.addChild(profile);
		}
		private function systemShow(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindwoArchive();
			(window as LSouSouWindwoArchive).show();
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function luggageShow(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindow = new LSouSouWindow();
			window.luggage();
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
		private function equipmentChange(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			var window:LSouSouWindwoEquipment = new LSouSouWindwoEquipment();
			//var window:LSouSouWindow = new LSouSouWindow();
			window.show();
			LGlobal.script.scriptLayer.addChild(window);
		}
	}
}