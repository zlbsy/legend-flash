package com.lufylegend.legend.game.sousou.map.window
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.components.LRadio;
	import com.lufylegend.legend.components.LRadioChild;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LButton;
	import com.lufylegend.legend.display.LScrollbar;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.game.sousou.character.LSouSouMember;
	import com.lufylegend.legend.game.sousou.map.LSouSouWindow;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LFilter;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LSouSouWindwoEquipment extends LSouSouWindow
	{
		private var _equipmentLayer:LSprite;
		private var _equipmentScroll:LScrollbar;
		private var _itemLayer:LSprite;
		private var _itemScroll:LScrollbar;
		private var _profileLayer:LSprite;
		private var _canItemList:Array;
		private var _selectMemberIndex:int;
		private var _listLayer:LSprite;
		private var _memNameBitmap:LBitmap;
		private var _memSelectBitmap:LBitmap;
		
		public function LSouSouWindwoEquipment()
		{
			super();
		}
		public function show():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			_listLayer = new LSprite();
			this.addChild(_listLayer);
			showMemberList();
			
			_profileLayer = new LSprite();
			_profileLayer.xy = new LCoordinate(150,15);
			this.addChild(_profileLayer);
			setBox(130,0,610,LGlobal.stage.stageHeight);
			
			setBox(405,95,300,360);
			
			_itemLayer = new LSprite();
			_itemScroll = new LScrollbar(_itemLayer,300,350,20,false);
			_itemScroll.xy = new LCoordinate(410,100);
			_itemLayer.addEventListener(MouseEvent.MOUSE_MOVE,function (event:MouseEvent):void{
				_itemLayer.graphics.clear();
				LDisplay.drawRect(_itemLayer.graphics,[0,0,290,_canItemList.length*40],true,0xffffff,0.1,0);
				LDisplay.drawRect(event.currentTarget.graphics,[0,int(event.currentTarget.mouseY/40)*40,290,38],true,0xffffff,0.2);
				LDisplay.drawRect(event.currentTarget.graphics,[0,int(event.currentTarget.mouseY/40)*40,290,38],false,0xffffff,0.8,2);
			});
			_itemLayer.addEventListener(MouseEvent.MOUSE_OUT,function (event:MouseEvent):void{
				_itemLayer.graphics.clear();
				LDisplay.drawRect(_itemLayer.graphics,[0,0,290,_canItemList.length*40],true,0xffffff,0.1,0);
			});
			_itemLayer.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				setItem(int(event.currentTarget.mouseY/40));
			});
			this.addChild(_itemScroll);
			
			addCloseButton();
			setProfile(0);
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
			memScroll = new LScrollbar(memLayer,100,225,20,false);
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
			setProfile(index);
			//LSouSouObject.charaSNow = new LSouSouCharacterS(LSouSouObject.memberList[index],0,0,0);
			//this.viewMember();
		}
		private function setItem(i:int):void{
			var selectItem:XMLList = _canItemList[i];
			var newXml:XML = <data></data>;
			var member:LSouSouMember = LSouSouObject.memberList[_selectMemberIndex];
			var nowItem:XMLList;
			trace("setItem ","Child"+selectItem.@index);
			var itemXml:XMLList = LSouSouObject.item["Child"+selectItem.@index];
			
			var listXml:XML;
			for each(listXml in LSouSouObject.itemsList.elements()){
				if(listXml.@id != selectItem.@id){
					newXml.appendChild(listXml);
				}
			}
			if(int(itemXml.Type) == 0){
				nowItem = member.helmet;
				member.helmet = new XMLList("<Helmet id='"+selectItem.@id+"' lv='0' exp='0'>"+selectItem.@index+"</Helmet>");
			}else if(int(itemXml.Type) == 1){
				nowItem = member.weapon;
				member.weapon = new XMLList("<Weapon id='"+selectItem.@id+"' lv='"+selectItem.@lv+"' exp='"+selectItem.@exp+"'>"+selectItem.@index+"</Weapon>");
				
			}else if(int(itemXml.Type) == 2){
				nowItem = member.equipment;
				member.equipment = new XMLList("<Equipment id='"+selectItem.@id+"' lv='"+selectItem.@lv+"' exp='"+selectItem.@exp+"'>"+selectItem.@index+"</Equipment>");
			}else if(int(itemXml.Type) == 3){
				nowItem = member.horse;
				member.horse = new XMLList("<Horse id='"+selectItem.@id+"' lv='0' exp='0'>"+selectItem.@index+"</Horse>");
			}
			if(int(nowItem.toString()) > 0){
				newXml.appendChild(new XMLList("<list id='"+nowItem.@id+"' index='"+nowItem+"' lv='"+nowItem.@lv+"' exp='"+(nowItem.@Exp.toString() == ""?0:nowItem.@Exp)+"' />"));
			}
			LSouSouObject.itemsList = newXml;
			setProfile(_selectMemberIndex);
		}
		private function setProfile(i:int):void{
			_selectMemberIndex = i;
			_profileLayer.die();
			_itemLayer.removeAllChild();
			_itemLayer.graphics.clear();
			_itemScroll.scrollToTop();
			var member:LSouSouMember = LSouSouObject.memberList[_selectMemberIndex];
			
			var facedata:BitmapData = LSouSouObject.getBoxBitmapData(130,130);
			var faceIndex:int = member.face;
			facedata.copyPixels(LSouSouObject.charaFaceList[faceIndex],new Rectangle(0,0,120,120),new Point(5,5));
			var face:LBitmap = new LBitmap(facedata);
			
			face.x = 10;
			face.y = 10;
			_profileLayer.addChild(face);
			var itemImg:LBitmap;
			var itemXml:XMLList;
			var listXml:XML;
			var nameLabel:LLabel;
			var lvLabel:LLabel;
			_canItemList = new Array();
			for each(listXml in LSouSouObject.itemsList.elements()){
				itemXml = LSouSouObject.item["Child"+listXml.@index];
				
				if(itemXml.Can["list"+member.arms] == null)continue;
				if(int(itemXml.Can["list"+member.arms].toString()) == 1){
					itemImg = new LBitmap(LSouSouObject.itemImg[itemXml.Icon]);
					itemImg.width = 38;
					itemImg.height = 38;
					itemImg.x = 5;
					itemImg.y = _canItemList.length * 40+1;
					_itemLayer.addChild(itemImg);
					nameLabel = new LLabel();
					nameLabel.htmlText = "<font color='#ffffff' size='20'>"+itemXml.Name+"</font>";
					nameLabel.xy = new LCoordinate(50,itemImg.y + 5);
					_itemLayer.addChild(nameLabel);
					lvLabel = new LLabel();
					lvLabel.htmlText = "<font color='#ffffff' size='20'>lv:"+listXml.@lv+"</font>";
					lvLabel.xy = new LCoordinate(150,itemImg.y + 5);
					_itemLayer.addChild(lvLabel);
					_canItemList.push(new XMLList(listXml.toXMLString()));
				}
				
			}
			LDisplay.drawRect(_itemLayer.graphics,[0,0,290,_canItemList.length*40],true,0xffffff,0.1,0);
			
			
			var nameBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(130,30));
			nameBit.x = 10;
			nameBit.y = 145;
			_profileLayer.addChild(nameBit);
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+member.name+"</b></font>";
			lblName.x = 20;
			lblName.y = 147;
			_profileLayer.addChild(lblName);
			var lvBit:LBitmap = new LBitmap(LSouSouObject.getBoxBitmapData(130,30));
			lvBit.x = 10;
			lvBit.y = 175;
			_profileLayer.addChild(lvBit);
			var lblLv:LLabel = new LLabel();
			lblLv.htmlText = "<font color='#ffffff' size='20'><b>Lv."+member.lv+"</b></font>";
			lblLv.x = 20;
			lblLv.y = 177;
			_profileLayer.addChild(lblLv);
			
			var lblX:int,lblY:int;
			
			lblX = 10;
			lblY = 210;
			var exp:LLabel = new LLabel();
			exp.htmlText = "<font color='#ffffff' size='15'>Exp</font>";
			exp.x = lblX;
			exp.y = lblY;
			_profileLayer.addChild(exp);
			_profileLayer.graphics.lineStyle(0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 140 - member.exp,lblY + 5,member.exp,10],true,0xff0000,1,0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 40,lblY + 5,100,10],false,0xcccccc,1,2);
			var lblExp:LLabel = new LLabel();
			lblExp.htmlText = "<font color='#ffffff' size='15'>" + member.exp + "/100</font>";
			lblExp.x = lblX + 150;
			lblExp.y = lblY;
			_profileLayer.addChild(lblExp);
			
			var hertBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"hert.png"));
			hertBitmap.width = 20;
			hertBitmap.height = 20;
			hertBitmap.x = lblX;
			hertBitmap.y = lblY + 30;
			_profileLayer.addChild(hertBitmap);
			var troops:int = member.troops;
			var maxTroops:int = member.maxTroops;
			_profileLayer.graphics.lineStyle(0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 140 - int(troops*100/maxTroops),lblY + 35,int(troops*100/maxTroops),10],true,0xff0000,1,0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 40,lblY + 35,100,10],false,0xcccccc,1,2);
			var lblTroops:LLabel = new LLabel();
			lblTroops.htmlText = "<font color='#ffffff' size='15'>" + troops + "/" + maxTroops + "</font>";
			lblTroops.x = lblX + 150;
			lblTroops.y = lblY + 30;
			_profileLayer.addChild(lblTroops);
			
			var fanBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"fan.png"));
			fanBitmap.smoothing = true;
			fanBitmap.width = 20;
			fanBitmap.height = 20;
			fanBitmap.x = lblX;
			fanBitmap.y = lblY + 60;
			_profileLayer.addChild(fanBitmap);
			var strategy:int = member.strategy;
			var maxStrategy:int = member.maxStrategy;
			_profileLayer.graphics.lineStyle(0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 140 - int(strategy*100/maxStrategy),lblY + 65,int(strategy*100/maxStrategy),10],true,0xff0000,1,0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 40,lblY + 65,100,10],false,0xcccccc,1,2);
			var lblStrategy:LLabel = new LLabel();
			lblStrategy.htmlText = "<font color='#ffffff' size='15'>" + strategy + "/" + maxStrategy + "</font>";
			lblStrategy.x = lblX + 150;
			lblStrategy.y = lblY + 60;
			_profileLayer.addChild(lblStrategy);
			
			lblX = 10;
			lblY = 300;
			var lblForce:LLabel = new LLabel();
			lblForce.htmlText = "<font color='#ffffff' size='15'><b>武力</b></font>";
			lblForce.x = lblX;
			lblForce.y = lblY;
			_profileLayer.addChild(lblForce);
			lblForce = new LLabel();
			lblForce.htmlText = "<font color='#ffffff' size='15'>" + member.force+ "</font>";
			lblForce.x = lblX + 50;
			lblForce.y = lblY;
			_profileLayer.addChild(lblForce);
			var lblIntelligence:LLabel = new LLabel();
			lblIntelligence.htmlText = "<font color='#ffffff' size='15'><b>智力</b></font>";
			lblIntelligence.x = lblX;
			lblIntelligence.y = lblY + 30;
			_profileLayer.addChild(lblIntelligence);
			lblIntelligence = new LLabel();
			lblIntelligence.htmlText = "<font color='#ffffff' size='15'>" + member.intelligence+ "</font>";
			lblIntelligence.x = lblX + 50;
			lblIntelligence.y = lblY + 30;
			_profileLayer.addChild(lblIntelligence);
			var lblCommand:LLabel = new LLabel();
			lblCommand.htmlText = "<font color='#ffffff' size='15'><b>统帅</b></font>";
			lblCommand.x = lblX;
			lblCommand.y = lblY + 60;
			_profileLayer.addChild(lblCommand);
			lblCommand = new LLabel();
			lblCommand.htmlText = "<font color='#ffffff' size='15'>" + member.command+ "</font>";
			lblCommand.x = lblX + 50;
			lblCommand.y = lblY + 60;
			_profileLayer.addChild(lblCommand);
			var lblAgile:LLabel = new LLabel();
			lblAgile.htmlText = "<font color='#ffffff' size='15'><b>敏捷</b></font>";
			lblAgile.x = lblX;
			lblAgile.y = lblY + 90;
			_profileLayer.addChild(lblAgile);
			lblAgile = new LLabel();
			lblAgile.htmlText = "<font color='#ffffff' size='15'>" + member.agile+ "</font>";
			lblAgile.x = lblX + 50;
			lblAgile.y = lblY + 90;
			_profileLayer.addChild(lblAgile);
			var lblLuck:LLabel = new LLabel();
			lblLuck.htmlText = "<font color='#ffffff' size='15'><b>运气</b></font>";
			lblLuck.x = lblX;
			lblLuck.y = lblY + 120;
			_profileLayer.addChild(lblLuck);
			lblLuck = new LLabel();
			lblLuck.htmlText = "<font color='#ffffff' size='15'>" + member.luck+ "</font>";
			lblLuck.x = lblX + 50;
			lblLuck.y = lblY + 120;
			_profileLayer.addChild(lblLuck);
			
			lblX = 120;
			lblY = 210;
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY + 90;
			_profileLayer.addChild(attackBitmap);
			var attack:int = member.attack;
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>" + attack + "/" + attack + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY + 90;
			_profileLayer.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 120;
			_profileLayer.addChild(spiritBitmap);
			var spirit:int = member.spirit;
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>" + spirit + "/" + spirit + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 120;
			_profileLayer.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 150;
			_profileLayer.addChild(defenseBitmap);
			var defense:int = member.defense;
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>" + defense + "/" + defense + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 150;
			_profileLayer.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 180;
			_profileLayer.addChild(breakoutBitmap);
			var breakout:int = member.breakout;
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>" + breakout + "/" + breakout + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 180;
			_profileLayer.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 210;
			_profileLayer.addChild(moraleBitmap);
			var morale:int = member.morale;
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>" + morale + "/" + morale + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 210;
			_profileLayer.addChild(lblMorale);
			
			addEquipment(member);
			
		}
		/**
		 * 显示装备
		 */
		private function addEquipment(member:LSouSouMember):void{
			var lblX:int = 270;
			var lblY:int = 10;
			
			LSouSouObject.setBox(lblX-10,lblY-10,250,70,_profileLayer);
			LDisplay.drawRectGradient(_profileLayer.graphics,[lblX,lblY,50,50],[0xffffff,0x333333]);
			LDisplay.drawRectGradient(_profileLayer.graphics,[lblX + 60,lblY,50,50],[0xffffff,0x333333]);
			LDisplay.drawRectGradient(_profileLayer.graphics,[lblX + 120,lblY,50,50],[0xffffff,0x333333]);
			LDisplay.drawRectGradient(_profileLayer.graphics,[lblX + 180,lblY,50,50],[0xffffff,0x333333]);
			
			var helmet:XMLList = member.helmet;
			var equipment:XMLList = member.equipment;
			var weapon:XMLList = member.weapon;
			var horse:XMLList = member.horse;
			trace("addEquipment = ",helmet.toXMLString(),equipment.toXMLString(),weapon.toXMLString(),horse.toXMLString());
			//饰品
			if(int(helmet.toString()) > 0){
				var helmetBit:LBitmap = new LBitmap(
					LSouSouObject.itemImg[LSouSouObject.item["Child" + helmet.toString()]["Icon"]]	);
				helmetBit.width = 50;
				helmetBit.height = 50;
				helmetBit.xy = new LCoordinate(lblX,lblY);
				_profileLayer.addChild(helmetBit);
			}
			//装备
			if(int(equipment.toString()) > 0){
				var equipmentBit:LBitmap = new LBitmap(
					LSouSouObject.itemImg[LSouSouObject.item["Child" + equipment.toString()]["Icon"]]);
				equipmentBit.width = 50;
				equipmentBit.height = 50;
				equipmentBit.xy = new LCoordinate(lblX + 60,lblY);
				
				_profileLayer.addChild(equipmentBit);
			}
			//武器
			if(int(weapon.toString()) > 0){
				var weaponBit:LBitmap = new LBitmap(
					LSouSouObject.itemImg[LSouSouObject.item["Child" + weapon.toString()]["Icon"]]);
				weaponBit.width = 50;
				weaponBit.height = 50;
				weaponBit.xy = new LCoordinate(lblX + 120,lblY);
				_profileLayer.addChild(weaponBit);
			}
			//坐骑
			if(int(horse.toString()) > 0){
				var horseBit:LBitmap = new LBitmap(
					LSouSouObject.itemImg[LSouSouObject.item["Child" + horse.toString()]["Icon"]]);
				horseBit.width = 50;
				horseBit.height = 50;
				horseBit.xy = new LCoordinate(lblX + 180,lblY);
				_profileLayer.addChild(horseBit);
			}
			_profileLayer.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				var member:LSouSouMember;
				if(helmetBit != null && event.currentTarget.mouseX >= helmetBit.x && event.currentTarget.mouseX <= helmetBit.x + helmetBit.width){
					member = LSouSouObject.memberList[_selectMemberIndex];
					LSouSouObject.itemsList.appendChild(new XMLList("<list index='"+member.helmet+"' />"));
					member.helmet =  new XMLList("<Helmet>0</Helmet>");
					setProfile(_selectMemberIndex);
				}else if(equipmentBit != null && event.currentTarget.mouseX >= equipmentBit.x && event.currentTarget.mouseX <= equipmentBit.x + equipmentBit.width){
					member = LSouSouObject.memberList[_selectMemberIndex];
					LSouSouObject.itemsList.appendChild(new XMLList("<list index='"+member.equipment+"' lv='"+member.equipment.@lv+"' exp='"+member.equipment.@exp+"' />"));
					member.equipment =  new XMLList("<Equipment lv='1' exp='0'>0</Equipment>");
					setProfile(_selectMemberIndex);
				}else if(weaponBit != null && event.currentTarget.mouseX >= weaponBit.x && event.currentTarget.mouseX <= weaponBit.x + weaponBit.width){
					member = LSouSouObject.memberList[_selectMemberIndex];
					LSouSouObject.itemsList.appendChild(new XMLList("<list index='"+member.weapon+"' lv='"+member.weapon.@lv+"' exp='"+member.weapon.@exp+"' />"));
					member.weapon =  new XMLList("<Weapon lv='1' exp='0'>0</Weapon>");
					setProfile(_selectMemberIndex);
				}else if(horseBit != null && event.currentTarget.mouseX >= horseBit.x && event.currentTarget.mouseX <= horseBit.x + horseBit.width){
					member = LSouSouObject.memberList[_selectMemberIndex];
					LSouSouObject.itemsList.appendChild(new XMLList("<list index='"+member.horse+"' lv='"+member.horse.@lv+"' exp='"+member.horse.@exp+"' />"));
					member.horse =  new XMLList("<Horse>0</Horse>");
					setProfile(_selectMemberIndex);
				}
			});
		}
	}
}