package zhanglubin.legend.game.sousou.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.components.LRadioChild;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.text.LTextField;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouCharacterProfile extends LSprite
	{
		private var _view:int;
		private var _showLabel:LLabel;
		private var _tabMenu:LRadio;
		private var _tabLayer:LSprite;
		private var _backLayer:LSprite;
		private var _listLayer:LSprite;
		private var _memNameBitmap:LBitmap;
		private var _memSelectBitmap:LBitmap;
		
		public function LSouSouCharacterProfile(view:int = -1)
		{
			init(view);
		}
		private function init(value:int):void{
			_backLayer = new LSprite();
			this.addChild(_backLayer);
			_listLayer = new LSprite();
			this.addChild(_listLayer);
			if(value>=0)showMemberList();
			viewMember();
		}
		private function viewMember():void{
			_backLayer.die();
			addBackground();
			addFace();
			addSkill();
			addTab();
			addButton();
		}
		private function addTab():void{
			LSouSouObject.setBox(299,33,400,436,_backLayer);
			
			_tabMenu = new LRadio();
			var tab_menu_on:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"tab_menu_on");
			var tab_menu_over:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"tab_menu_over");
			
			var btn_status:LButton = new LButton(tab_menu_on,tab_menu_over,tab_menu_over);
			btn_status.labelColor = "#999999";
			btn_status.label = "人物属性";
			var tabChild:LRadioChild;
			tabChild = new LRadioChild("status",new LBitmap(tab_menu_over),	btn_status);
			_tabMenu.push(tabChild);
			
			var btn_arms:LButton = new LButton(tab_menu_on,tab_menu_over,tab_menu_over);
			btn_arms.labelColor = "#999999";
			btn_arms.label = "兵种属性";
			tabChild = new LRadioChild("arms",new LBitmap(tab_menu_over),	btn_arms);
			tabChild.x = 95;
			_tabMenu.push(tabChild);
			
			var btn_strategy:LButton = new LButton(tab_menu_on,tab_menu_over,tab_menu_over);
			btn_strategy.labelColor = "#999999";
			btn_strategy.label = "策略属性";
			tabChild = new LRadioChild("strategy",new LBitmap(tab_menu_over),	btn_strategy);
			tabChild.x = 95*2;
			_tabMenu.push(tabChild);
			
			var btn_equipment:LButton = new LButton(tab_menu_on,tab_menu_over,tab_menu_over);
			btn_equipment.labelColor = "#999999";
			btn_equipment.label = "装备属性";
			tabChild = new LRadioChild("equipment",new LBitmap(tab_menu_over),	btn_equipment);
			tabChild.x = 95*3;
			_tabMenu.push(tabChild);
			
			_tabMenu.addEventListener(LEvent.CHANGE_VALUE,changeValue);
			_tabMenu.x = 300;
			_tabMenu.y = 10;
			_backLayer.addChild(_tabMenu);
			
			_showLabel = new LLabel();
			_showLabel.y = 12;
			_showLabel.x = _tabMenu.x;
			_backLayer.addChild(_showLabel);
			
			_tabLayer = new LSprite();
			_tabLayer.x = 300;
			_tabLayer.y = 50;
			_backLayer.addChild(_tabLayer);
			
			_tabMenu.value = "status";
		}
		private function changeValue(event:LEvent):void{
			switch(_tabMenu.value){
				case "status":
					addStatus();
					_showLabel.htmlText = "<font color='#cccccc' size='15'><b>人物属性</b></font>";
					_showLabel.x = _tabMenu.x + 14;
					break;
				case "arms":
					addArms();
					_showLabel.x = _tabMenu.x + 14 + 95;
					_showLabel.htmlText = "<font color='#cccccc' size='15'><b>兵种属性</b></font>";
					break;
				case "strategy":
					addStrategy();
					_showLabel.x = _tabMenu.x + 14 + 95*2;
					_showLabel.htmlText = "<font color='#cccccc' size='15'><b>策略属性</b></font>";
					break;
				case "equipment":
					addEquipment();
					_showLabel.x = _tabMenu.x + 14 + 95*3;
					_showLabel.htmlText = "<font color='#cccccc' size='15'><b>装备属性</b></font>";
					break;
			}
		}
		private function showMemberList():void{
			var memLayer:LSprite;
			var memScroll:LScrollbar;
			memLayer = new LSprite();
			var bitmapName:BitmapData;
			var lblName:LLabel;
			_memNameBitmap = new LBitmap(new BitmapData(100,28,false,0xcccccc));
			_memSelectBitmap = new LBitmap(new BitmapData(100,28,false,0x999999));
			_memNameBitmap.visible = false;
			_memNameBitmap.alpha = 0.5;
			_memSelectBitmap.alpha = 0.5;
			memLayer.addChild(_memNameBitmap);
			memLayer.addChild(_memSelectBitmap);
			
			var i:int;
			for(i=0;i<LSouSouObject.memberList.length;i++){
				lblName = new LLabel();
				lblName.htmlText = "<font color='#cccccc' size='18'><b>" + LSouSouObject.memberList[i].name + "</b></font>";
				lblName.x = 10;
				lblName.y = 30*i + 2;
				memLayer.addChild(lblName);
			}
			LDisplay.drawRect(memLayer.graphics,[0,0,110,30*i],true,0,0);
			memLayer.addEventListener(MouseEvent.MOUSE_UP,selectMember);
			memLayer.addEventListener(MouseEvent.ROLL_OUT,outMember);
			memLayer.addEventListener(MouseEvent.MOUSE_MOVE,moveMember);
			memScroll = new LScrollbar(memLayer,105,225,20,false);
			memScroll.alpha = 0.9;
			memScroll.xy = new LCoordinate(5,5);
			_listLayer.addChild(memScroll);
			LSouSouObject.setBox(0,0,110,235,_listLayer);
		}
		private function outMember(event:MouseEvent):void{
			_memNameBitmap.visible = false;
		}
		private function moveMember(event:MouseEvent):void{
			var index:int = int((event.currentTarget as LSprite).mouseY/30);
			_memNameBitmap.y = index*30 + 1;
			_memNameBitmap.visible = true;
		}
		private function selectMember(event:MouseEvent):void{
			var index:int = int((event.currentTarget as LSprite).mouseY/30);
			_memSelectBitmap.y = index*30 + 1;
			LSouSouObject.charaSNow = new LSouSouCharacterS(LSouSouObject.memberList[index],0,0,0);
			this.viewMember();
		}
		/**
		 * 显示策略
		 */
		private function addStrategy():void{
			_tabLayer.die();
			//LDisplay.drawRect(_backLayer.graphics,[260,260,240,130],false,0xffffff,1,2);
			var lblTitle:LLabel = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='18'><b>策略名称</b></font>";
			lblTitle.x = 15 + 30;
			lblTitle.y = 15;
			_tabLayer.addChild(lblTitle);
			lblTitle = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='18'><b>消耗MP</b></font>";
			lblTitle.x = 150;
			lblTitle.y = 15;
			_tabLayer.addChild(lblTitle);
			//LDisplay.drawRect(_backLayer.graphics,[265,290,230,95],false,0xffffff,1,2);
			
			
			var strategyLayer:LSprite = new LSprite();
			var i:int;
			var lblStrategy:LLabel;
			var lblMp:LLabel;
			var slist:XML;
			var img:LBitmap;
			for each(slist in LSouSouObject.charaSNow.member.strategyList.elements()){
				if(slist.@lv > LSouSouObject.charaSNow.member.lv)continue;
				LDisplay.drawRect(strategyLayer.graphics,[0,i*20,140,20],false,0xffffff);
				LDisplay.drawRect(strategyLayer.graphics,[140,i*20,60,20],false,0xffffff);
				img = new LBitmap(LSouSouObject.meffImg[LSouSouObject.strategy["Strategy" + slist].Icon.toString()]);
				//img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],LSouSouObject.strategy["Strategy" + slist].Icon.toString()));
				img.width = 20;
				img.height = 20;
				img.xy = new LCoordinate(0,i*20);
				strategyLayer.addChild(img);
				lblStrategy = new LLabel();
				lblStrategy.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.strategy["Strategy" + slist].Name+"</b></font>";
				lblStrategy.x = 25;
				lblStrategy.y = i*20;
				strategyLayer.addChild(lblStrategy);
				lblMp = new LLabel();
				lblMp.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.strategy["Strategy" + slist].Cost+"</b></font>";
				lblMp.x = 150;
				lblMp.y = i*20;
				strategyLayer.addChild(lblMp);
				i++;
			}
			var scrollbar:LScrollbar = new LScrollbar(strategyLayer,300,200,15,false);
			scrollbar.x = 15;
			scrollbar.y = 40;
			_tabLayer.addChild(scrollbar);
		}
		/**
		 * 显示兵种信息
		 */
		private function addArms():void{
			_tabLayer.die();
			//LDisplay.drawRect(_backLayer.graphics,[510,10,250,240],false,0xffffff,1,2);
			
			var lblX:int = 20;
			var lblY:int = 10;
			var arms:LBitmap = new LBitmap(LSouSouObject.charaSNow.bitmapData.clone());
			arms.x = lblX + 10;
			arms.y = lblY;
			_tabLayer.addChild(arms);
			
			
			var lblArmsName:LLabel = new LLabel();
			lblArmsName.htmlText = "<font color='#ffffff' size='20'><b>" + LSouSouObject.charaSNow.member.armsName + "</b></font>";
			lblArmsName.x = lblX;
			lblArmsName.y = lblY + 60;
			_tabLayer.addChild(lblArmsName);
			
			var armsProperty:XMLList = LSouSouObject.charaSNow.member.armsProperty;
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY + 90;
			_tabLayer.addChild(attackBitmap);
			var attack:int = LSouSouObject.charaSNow.member.attack;
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Attack"] + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY + 90;
			_tabLayer.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 120;
			_tabLayer.addChild(spiritBitmap);
			var spirit:int = LSouSouObject.charaSNow.member.spirit;
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Spirit"] + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 120;
			_tabLayer.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 150;
			_tabLayer.addChild(defenseBitmap);
			var defense:int = LSouSouObject.charaSNow.member.defense;
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Defense"] + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 150;
			_tabLayer.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 180;
			_tabLayer.addChild(breakoutBitmap);
			var breakout:int = LSouSouObject.charaSNow.member.breakout;
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Breakout"] + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 180;
			_tabLayer.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 210;
			_tabLayer.addChild(moraleBitmap);
			var morale:int = LSouSouObject.charaSNow.member.morale;
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Morale"] + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 210;
			_tabLayer.addChild(lblMorale);
			
			var moveBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_move.png"));
			moveBitmap.smoothing = true;
			moveBitmap.width = 20;
			moveBitmap.height = 20;
			moveBitmap.x = lblX;
			moveBitmap.y = lblY + 240;
			_tabLayer.addChild(moveBitmap);
			var move:int = LSouSouObject.charaSNow.member.distance;
			var lblMove:LLabel = new LLabel();
			lblMove.htmlText = "<font color='#ffffff' size='15'>" + move + "</font>";
			lblMove.width = 230;
			lblMove.x = lblX + 40;
			lblMove.y = lblY + 240;
			_tabLayer.addChild(lblMove);
			
			//LDisplay.drawRect(_backLayer.graphics,[620,80,120,120],true,0xffffff,0.5,0);
			var attRect:XMLList = LSouSouObject.charaSNow.rangeAttack;
			var attRectsWidth:int = 120;
			var attRectCount:int = 3;
			var nodeStr:String;
			var nodeArr:Array;
			for each(nodeStr in attRect){
				nodeArr = nodeStr.split(",");
				if(attRectCount < Math.abs(int(nodeArr[0])))attRectCount = Math.abs(int(nodeArr[0]));
				if(attRectCount < Math.abs(int(nodeArr[1])))attRectCount = Math.abs(int(nodeArr[1]));
			}
			var attRectWidth:Number = attRectsWidth/(attRectCount*2 + 1);
			var i:int,j:int;
			var rx:int = 620 + attRectCount*attRectWidth;
			var ry:int = 80 + attRectCount*attRectWidth;
			_tabLayer.graphics.lineStyle(0,0x000000);
			for(i = -attRectCount;i<attRectCount + 1;i++){
				LDisplay.drawRect(_tabLayer.graphics,[rx + attRectWidth*i,ry - attRectWidth*attRectCount,attRectWidth,attRectWidth*(attRectCount*2+1)],true,0x999999,0.5,0);
			}
			_tabLayer.graphics.lineStyle(0,0x000000);
			for(i = -attRectCount;i<attRectCount + 1;i++){
				LDisplay.drawRect(_tabLayer.graphics,[rx - attRectWidth*attRectCount,ry + attRectWidth*i,attRectWidth*(attRectCount*2+1),attRectWidth],true,0x999999,0.5,0);
			}
			LDisplay.drawRect(_tabLayer.graphics,[rx,ry,attRectWidth,attRectWidth],true,0x0000ff,0.5,0);
			for each(nodeStr in attRect){
				nodeArr = nodeStr.split(",");
				LDisplay.drawRect(_tabLayer.graphics,[rx + int(nodeArr[0])*attRectWidth,ry + int(nodeArr[1])*attRectWidth,attRectWidth,attRectWidth],true,0xff0000,0.5,0);
			}

			//兵种介绍
			lblX = 10;
			lblY = 280;
			LSouSouObject.setBox(lblX,lblY,130,30,_tabLayer);
			var lblTitle:LLabel = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='20'><b>兵种介绍</b></font>";
			lblTitle.x = lblX + 10;
			lblTitle.y = lblY + 2;
			_tabLayer.addChild(lblTitle);
			LSouSouObject.setBox(lblX,lblY + 35,380,100,_tabLayer);
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.armIntroduction + "</font>";
			lblIntroduction.autoSize = LTextField.NONE;
			lblIntroduction.wordWrap = true;
			lblIntroduction.width = 360;
			lblIntroduction.x = lblX + 10;
			lblIntroduction.y = lblY + 40;
			_tabLayer.addChild(lblIntroduction);
		}
		/**
		 * 显示装备
		 */
		private function addEquipment():void{
			_tabLayer.die();
			LSouSouObject.setBox(20,10,250,70,_tabLayer);
			LDisplay.drawRectGradient(_tabLayer.graphics,[30,20,50,50],[0xffffff,0x333333]);
			LDisplay.drawRectGradient(_tabLayer.graphics,[90,20,50,50],[0xffffff,0x333333]);
			LDisplay.drawRectGradient(_tabLayer.graphics,[150,20,50,50],[0xffffff,0x333333]);
			LDisplay.drawRectGradient(_tabLayer.graphics,[210,20,50,50],[0xffffff,0x333333]);
			
			var helmet:XMLList = LSouSouObject.charaSNow.member.helmet;
			var equipment:XMLList = LSouSouObject.charaSNow.member.equipment;
			var weapon:XMLList = LSouSouObject.charaSNow.member.weapon;
			var horse:XMLList = LSouSouObject.charaSNow.member.horse;
			trace("addEquipment = ",helmet,equipment,weapon,horse);
			//饰品
			if(int(helmet.toString()) > 0){
				var helmetBit:LBitmap = new LBitmap(LSouSouObject.itemImg[LSouSouObject.item["Child" + helmet.toString()]["Icon"]]);
				helmetBit.width = 50;
				helmetBit.height = 50;
				helmetBit.xy = new LCoordinate(30,20);
				_tabLayer.addChild(helmetBit);
			}
			//装备
			if(int(equipment.toString()) > 0){
				var equipmentBit:LBitmap = new LBitmap(LSouSouObject.itemImg[LSouSouObject.item["Child" + equipment.toString()]["Icon"]]);
				equipmentBit.width = 50;
				equipmentBit.height = 50;
				equipmentBit.xy = new LCoordinate(90,20);
				_tabLayer.addChild(equipmentBit);
			}
			//武器
			if(int(weapon.toString()) > 0){
				var weaponBit:LBitmap = new LBitmap(LSouSouObject.itemImg[LSouSouObject.item["Child" + weapon.toString()]["Icon"]]);
				weaponBit.width = 50;
				weaponBit.height = 50;
				weaponBit.xy = new LCoordinate(150,20);
				_tabLayer.addChild(weaponBit);
			}
			//坐骑
			if(int(horse.toString()) > 0){
				var horseBit:LBitmap = new LBitmap(LSouSouObject.itemImg[LSouSouObject.item["Child" + horse.toString()]["Icon"]]);
				horseBit.width = 50;
				horseBit.height = 50;
				horseBit.xy = new LCoordinate(210,20);
				_tabLayer.addChild(horseBit);
			}
		}
		/**
		 * 显示基本状态
		 */
		private function addStatus():void{
			_tabLayer.die();
			//LDisplay.drawRect(_tabLayer.graphics,[260,10,240,240],false,0xffffff,1,2);
			
			
			var lblX:int,lblY:int;
			//exp
			lblX = 20;
			lblY = 15;
			var exp:LLabel = new LLabel();
			exp.htmlText = "<font color='#ffffff' size='15'>Exp</font>";
			exp.x = lblX;
			exp.y = lblY;
			_tabLayer.addChild(exp);
			_tabLayer.graphics.lineStyle(0);
			LDisplay.drawRect(_tabLayer.graphics,[lblX + 140 - LSouSouObject.charaSNow.member.exp,lblY + 5,LSouSouObject.charaSNow.member.exp,10],true,0xff0000,1,0);
			LDisplay.drawRect(_tabLayer.graphics,[lblX + 40,lblY + 5,100,10],false,0xcccccc,1,2);
			var lblExp:LLabel = new LLabel();
			lblExp.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.exp + "/100</font>";
			lblExp.x = lblX + 150;
			lblExp.y = lblY;
			_tabLayer.addChild(lblExp);
			//hp
			var hertBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"hert.png"));
			hertBitmap.width = 20;
			hertBitmap.height = 20;
			hertBitmap.x = lblX;
			hertBitmap.y = lblY + 30;
			_tabLayer.addChild(hertBitmap);
			var troops:int = LSouSouObject.charaSNow.member.troops;
			var maxTroops:int = LSouSouObject.charaSNow.member.maxTroops;
			_tabLayer.graphics.lineStyle(0);
			LDisplay.drawRect(_tabLayer.graphics,[lblX + 140 - int(troops*100/maxTroops),lblY + 35,int(troops*100/maxTroops),10],true,0xff0000,1,0);
			LDisplay.drawRect(_tabLayer.graphics,[lblX + 40,lblY + 35,100,10],false,0xcccccc,1,2);
			var lblTroops:LLabel = new LLabel();
			lblTroops.htmlText = "<font color='#ffffff' size='15'>" + troops + "/" + maxTroops + "</font>";
			lblTroops.x = lblX + 150;
			lblTroops.y = lblY + 30;
			_tabLayer.addChild(lblTroops);
			//mp
			var fanBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"fan.png"));
			fanBitmap.smoothing = true;
			fanBitmap.width = 20;
			fanBitmap.height = 20;
			fanBitmap.x = lblX;
			fanBitmap.y = lblY + 60;
			_tabLayer.addChild(fanBitmap);
			var strategy:int = LSouSouObject.charaSNow.member.strategy;
			var maxStrategy:int = LSouSouObject.charaSNow.member.maxStrategy;
			_tabLayer.graphics.lineStyle(0);
			LDisplay.drawRect(_tabLayer.graphics,[lblX + 140 - int(strategy*100/maxStrategy),lblY + 65,int(strategy*100/maxStrategy),10],true,0xff0000,1,0);
			LDisplay.drawRect(_tabLayer.graphics,[lblX + 40,lblY + 65,100,10],false,0xcccccc,1,2);
			var lblStrategy:LLabel = new LLabel();
			lblStrategy.htmlText = "<font color='#ffffff' size='15'>" + strategy + "/" + maxStrategy + "</font>";
			lblStrategy.x = lblX + 150;
			lblStrategy.y = lblY + 60;
			_tabLayer.addChild(lblStrategy);
			//人物属性
			lblX = 20;
			lblY = 130;
			var lblForce:LLabel = new LLabel();
			lblForce.htmlText = "<font color='#ffffff' size='15'><b>武力</b></font>";
			lblForce.x = lblX;
			lblForce.y = lblY;
			_tabLayer.addChild(lblForce);
			lblForce = new LLabel();
			lblForce.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.force+ "</font>";
			lblForce.x = lblX + 50;
			lblForce.y = lblY;
			_tabLayer.addChild(lblForce);
			
			var lblIntelligence:LLabel = new LLabel();
			lblIntelligence.htmlText = "<font color='#ffffff' size='15'><b>智力</b></font>";
			lblIntelligence.x = lblX;
			lblIntelligence.y = lblY + 30;
			_tabLayer.addChild(lblIntelligence);
			lblIntelligence = new LLabel();
			lblIntelligence.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.intelligence+ "</font>";
			lblIntelligence.x = lblX + 50;
			lblIntelligence.y = lblY + 30;
			_tabLayer.addChild(lblIntelligence);
			
			var lblCommand:LLabel = new LLabel();
			lblCommand.htmlText = "<font color='#ffffff' size='15'><b>统帅</b></font>";
			lblCommand.x = lblX;
			lblCommand.y = lblY + 60;
			_tabLayer.addChild(lblCommand);
			lblCommand = new LLabel();
			lblCommand.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.command+ "</font>";
			lblCommand.x = lblX + 50;
			lblCommand.y = lblY + 60;
			_tabLayer.addChild(lblCommand);
			
			var lblAgile:LLabel = new LLabel();
			lblAgile.htmlText = "<font color='#ffffff' size='15'><b>敏捷</b></font>";
			lblAgile.x = lblX;
			lblAgile.y = lblY + 90;
			_tabLayer.addChild(lblAgile);
			lblAgile = new LLabel();
			lblAgile.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.agile+ "</font>";
			lblAgile.x = lblX + 50;
			lblAgile.y = lblY + 90;
			_tabLayer.addChild(lblAgile);
			
			var lblLuck:LLabel = new LLabel();
			lblLuck.htmlText = "<font color='#ffffff' size='15'><b>运气</b></font>";
			lblLuck.x = lblX;
			lblLuck.y = lblY + 120;
			_tabLayer.addChild(lblLuck);
			lblLuck = new LLabel();
			lblLuck.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.luck+ "</font>";
			lblLuck.x = lblX + 50;
			lblLuck.y = lblY + 120;
			_tabLayer.addChild(lblLuck);
			
			//状态属性
			lblX = 230;
			lblY = 130;
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY;
			_tabLayer.addChild(attackBitmap);
			var attack:int = LSouSouObject.charaSNow.member.attack;
			var addAtk:int = int(LSouSouObject.charaSNow.statusArray[LSouSouCharacterS.STATUS_ATTACK][2]);
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>" + (attack+addAtk) + "/" + attack + "("+addAtk+")" + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY;
			_tabLayer.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 30;
			_tabLayer.addChild(spiritBitmap);
			var spirit:int = LSouSouObject.charaSNow.member.spirit;
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>" + spirit + "/" + spirit + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 30;
			_tabLayer.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 60;
			_tabLayer.addChild(defenseBitmap);
			var defense:int = LSouSouObject.charaSNow.member.defense;
			var addDef:int = int(LSouSouObject.charaSNow.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2]);
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>" + (defense + addDef) + "/" + defense + "("+addDef+")" + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 60;
			_tabLayer.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 90;
			_tabLayer.addChild(breakoutBitmap);
			var breakout:int = LSouSouObject.charaSNow.member.breakout;
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>" + breakout + "/" + breakout + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 90;
			_tabLayer.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 120;
			_tabLayer.addChild(moraleBitmap);
			var morale:int = LSouSouObject.charaSNow.member.morale;
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>" + morale + "/" + morale + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 120;
			_tabLayer.addChild(lblMorale);
			
			//人物介绍
			lblX = 10;
			lblY = 280;
			LSouSouObject.setBox(lblX,lblY,130,30,_tabLayer);
			var lblTitle:LLabel = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='20'><b>人物介绍</b></font>";
			lblTitle.x = lblX + 10;
			lblTitle.y = lblY + 2;
			_tabLayer.addChild(lblTitle);
			LSouSouObject.setBox(lblX,lblY + 35,380,100,_tabLayer);
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.htmlText = "<font color='#ffffff' size='13'>" + LSouSouObject.charaSNow.member.introduction + "</font>";
			lblIntroduction.autoSize = LTextField.NONE;
			lblIntroduction.wordWrap = true;
			lblIntroduction.width = 360;
			lblIntroduction.x = lblX + 10;
			lblIntroduction.y = lblY + 40;
			_tabLayer.addChild(lblIntroduction);
		}
		/**
		 * 显示特技
		 */
		private function addSkill():void{
			
			var lblX:int = 10;
			var lblY:int = 335;
			
			var skillNameBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(65,30));
			skillNameBit.x = lblX;
			skillNameBit.y = lblY;
			_backLayer.addChild(skillNameBit);
			skillNameBit = new LBitmap(LSouSouObject.getBoxBitmapData(160,30));
			skillNameBit.x = lblX + 80;
			skillNameBit.y = lblY;
			_backLayer.addChild(skillNameBit);
			
			var skillBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(260,100));
			skillBit.x = lblX;
			skillBit.y = lblY + 35;
			_backLayer.addChild(skillBit);
			
			var notSkill:Boolean;
			if(int(LSouSouObject.charaSNow.member.skill.toString()) <= 0)notSkill = true;
			var skill:XMLList = LSouSouObject.skill["Skill" + LSouSouObject.charaSNow.member.skill];
			if(skill == null)notSkill = true;
			var lblTitle:LLabel = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='20'><b>特技</b></font>";
			lblTitle.x = lblX + 10;
			lblTitle.y = lblY + 2;
			_backLayer.addChild(lblTitle);
			
			var lblComment:LLabel;
			if(!notSkill){
				var lblSkill:LLabel = new LLabel();
				lblSkill.htmlText = "<font color='#ffffff' size='20'><b>"+skill.Name+"</b></font>";
				lblSkill.x = lblX + 90;
				lblSkill.y = lblY + 2;
				_backLayer.addChild(lblSkill);
				
				lblComment = new LLabel();
				lblComment.htmlText = "<font color='#ffffff' size='15'>"+skill.Introduction+"</font>";
				lblComment.autoSize =LTextField.NONE;
				lblComment.width = 240;
				lblComment.wordWrap = true;
				lblComment.x = lblX + 5;
				lblComment.y = lblY + 40;
				_backLayer.addChild(lblComment);
			}
		}
		/**
		 * 显示按钮
		 */
		private function addButton():void{
			var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"close2");
			//var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"close_over");
			var btnClose:LButton = new LButton(bitmapup);
			btnClose.xy = new LCoordinate(740,20);
			btnClose.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
			});
			_backLayer.addChild(btnClose);
		}
		/**
		 * 显示头像姓名简介
		 */
		private function addFace():void{
			var facedata:BitmapData = LSouSouObject.getBoxBitmapData(130,130);
			var faceIndex:int = LSouSouObject.chara["peo"+LSouSouObject.charaSNow.index]["Face"];
			facedata.copyPixels(LSouSouObject.charaFaceList[faceIndex],new Rectangle(0,0,120,120),new Point(5,5));
			var face:LBitmap = new LBitmap(facedata);
			face.x = 140;
			face.y = 10;
			_backLayer.addChild(face);
			
			var nameBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(130,30));
			nameBit.x = 140;
			nameBit.y = 145;
			_backLayer.addChild(nameBit);
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+LSouSouObject.charaSNow.member.name+"</b></font>";
			lblName.x = 150;
			lblName.y = 147;
			_backLayer.addChild(lblName);
			
			var lvBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(130,30));
			lvBit.x = 140;
			lvBit.y = 175;
			_backLayer.addChild(lvBit);
			var lblLv:LLabel = new LLabel();
			lblLv.htmlText = "<font color='#ffffff' size='20'><b>Lv."+LSouSouObject.charaSNow.member.lv+"</b></font>";
			lblLv.x = 150;
			lblLv.y = 177;
			_backLayer.addChild(lblLv);
			
			var belongBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(130,30));
			belongBit.x = 140;
			belongBit.y = 205;
			_backLayer.addChild(belongBit);
			var lblBelong:LLabel = new LLabel();
			lblBelong.htmlText = "<font color='#ffffff' size='20'><b>"+(LSouSouObject.charaSNow.belong==LSouSouObject.BELONG_SELF?"我军":(LSouSouObject.charaSNow.belong==LSouSouObject.BELONG_FRIEND?"友军":"敌军"))+"</b></font>";
			lblBelong.x = 150;
			lblBelong.y = 207;
			_backLayer.addChild(lblBelong);
			
			//状态
			var statusBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(260,80));
			statusBit.x = 10;
			statusBit.y = 240;
			_backLayer.addChild(statusBit);
		}
		/**
		 * 显示背景
		 */
		private function addBackground():void{
			LDisplay.drawRect(_backLayer.graphics,[0,0,800,480],true,0x000000,0.7,5);
			LSouSouObject.setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight,_backLayer);
		}
	}
}