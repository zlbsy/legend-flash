package com.lufylegend.legend.game.sousou.map.window
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
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
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LFilter;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LString;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LSouSouWindwoShop extends LSouSouWindow
	{
		
		private var _shopIndex:int;
		private var _shopLayer:LSprite;
		private var _shopScrollbar:LScrollbar;
		private var _money:LLabel;
		private var _viewLayer:LSprite;
		public function LSouSouWindwoShop()
		{
			super();
		}
		public function show():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			
			setBox(20,20,400,440);
			
			setBox(450,20,300,300);
			
			setBox(450,340,300,100);
			
			var lblMoney:LLabel = new LLabel();
			lblMoney.htmlText = "<font color='#ffffff' size='30'><b>银两 </b></font>";
			lblMoney.xy = new LCoordinate(460,350);
			this.addChild(lblMoney);
			lblMoney = new LLabel();
			lblMoney.htmlText = "<font color='#ffffff' size='30'><b>两 </b></font>";
			lblMoney.xy = new LCoordinate(690,380);
			this.addChild(lblMoney);
			_money = new LLabel();
			_money.htmlText = "<font color='#ffffff' size='20'><b>"+LSouSouObject.money+"</b></font>";
			_money.xy = new LCoordinate(530,390);
			this.addChild(_money);
			
			_viewLayer = new LSprite();
			_viewLayer.xy = new LCoordinate(450,20);
			this.addChild(_viewLayer);
			
			addCloseButton(true);
			
			_shopIndex = 0;
			_shopLayer = new LSprite();
			_shopScrollbar = new LScrollbar(_shopLayer,360,420,20,false);
			_shopScrollbar.x = 30;
			_shopScrollbar.y = 30;
			this.addChild(_shopScrollbar);
			setShop();
		}
		private function setShop():void{
			var script:LScript = LGlobal.script;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				setShop();
				return;
			}
			trace("LSouSouWindwoShop show lineValue = " + lineValue);
			if(lineValue == "endWindow"){
				return;
			}
			var start:int = lineValue.indexOf("(");
			var end:int = lineValue.indexOf(")");
			switch(lineValue.substr(0,start)){
				case "shopProps":
					shopProps(lineValue.substring(start+1,end).split(","));
					break;
				case "shopItem":
					shopItem(lineValue.substring(start+1,end).split(","));
					break;
				default:
			}
		}
		private function shopProps(param:Array):void{
			var color:int = this._shopIndex%2 == 0?0x000033:0x330000;
			_shopLayer.graphics.lineStyle(0,0x000000,1);
			LDisplay.drawRect(_shopLayer.graphics,[0,1+this._shopIndex*60,380,58],true,color,0.2,5);
			//Props
			var propsXml:XMLList = LSouSouObject.props["Props" + param[0]];
			var propsBit:LBitmap = new LBitmap(LSouSouObject.itemImg[propsXml.Icon]);
			propsBit.width = 50;
			propsBit.height = 50;
			propsBit.xy = new LCoordinate(0,this._shopIndex*60+5);
			_shopLayer.addChild(propsBit);
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+propsXml.Name+"</b></font>";
			lblName.xy = new LCoordinate(70,this._shopIndex*60+5);
			_shopLayer.addChild(lblName);
			
			var lblMoney:LLabel = new LLabel();
			lblMoney.htmlText = "<font color='#ffffff' size='20'><b>"+propsXml.Money+"两</b></font>";
			lblMoney.xy = new LCoordinate(170,this._shopIndex*60+5);
			_shopLayer.addChild(lblMoney);
			
			var btn:LButton = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"btn_001.png"));
			btn.label = "購入";
			btn.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				buyProps(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OVER,function (event:MouseEvent):void{
				showProps(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OUT,function (event:MouseEvent):void{
				_viewLayer.die();
			});
			//btn.alpha = 1;
			btn.xy = new LCoordinate(260,11+this._shopIndex*60);
			_shopLayer.addChild(btn);
			this._shopIndex++;
			setShop();
		}
		private function showProps(param:Array):void{
			var propsXml:XMLList = LSouSouObject.props["Props" + param[0]];
			var propsBit:LBitmap = new LBitmap(LSouSouObject.itemImg[propsXml.Icon]);
			propsBit.width = 100;
			propsBit.height = 100;
			propsBit.xy = new LCoordinate(10,10);
			_viewLayer.addChild(propsBit);
			
			var lblX:int = 10;
			var lblY:int = 115;
			
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+propsXml.Name+"</b></font>";
			lblName.xy = new LCoordinate(lblX,lblY);
			_viewLayer.addChild(lblName);
			
			
			lblX = 120;
			lblY = 10;
			
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY;
			_viewLayer.addChild(attackBitmap);
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Force) + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY;
			_viewLayer.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 25;
			_viewLayer.addChild(spiritBitmap);
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Intelligence) + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 25;
			_viewLayer.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 50;
			_viewLayer.addChild(defenseBitmap);
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Command) + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 50;
			_viewLayer.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 75;
			_viewLayer.addChild(breakoutBitmap);
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Agile) + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 75;
			_viewLayer.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 100;
			_viewLayer.addChild(moraleBitmap);
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Luck) + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 100;
			_viewLayer.addChild(lblMorale);
			
			lblX = 210;
			lblY = 10;
			
			var hpBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"hert.png"));
			hpBitmap.smoothing = true;
			hpBitmap.width = 20;
			hpBitmap.height = 20;
			hpBitmap.x = lblX;
			hpBitmap.y = lblY;
			_viewLayer.addChild(hpBitmap);
			var lblHp:LLabel = new LLabel();
			lblHp.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Hp) + "</font>";
			lblHp.x = lblX + 40;
			lblHp.y = lblY;
			_viewLayer.addChild(lblHp);
			
			var mpBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"fan.png"));
			mpBitmap.smoothing = true;
			mpBitmap.width = 20;
			mpBitmap.height = 20;
			mpBitmap.x = lblX;
			mpBitmap.y = lblY + 25;
			_viewLayer.addChild(mpBitmap);
			var lblMp:LLabel = new LLabel();
			lblMp.htmlText = "<font color='#ffffff' size='15'>+" + int(propsXml.Mp) + "</font>";
			lblMp.x = lblX + 40;
			lblMp.y = lblY + 25;
			_viewLayer.addChild(lblMp);
			
			
			var moveBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_move.png"));
			moveBitmap.smoothing = true;
			moveBitmap.width = 20;
			moveBitmap.height = 20;
			moveBitmap.x = lblX;
			moveBitmap.y = lblY + 50;
			_viewLayer.addChild(moveBitmap);
			var lblMove:LLabel = new LLabel();
			lblMove.htmlText = "<font color='#ffffff' size='15'>" + int(propsXml.Distance) + "</font>";
			lblMove.width = 230;
			lblMove.x = lblX + 40;
			lblMove.y = lblY + 50;
			_viewLayer.addChild(lblMove);
			
			lblX = 10;
			lblY = 170;
			
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.htmlText = "<font color='#ffffff' size='15'>" + propsXml.Introduction + "</font>";
			lblIntroduction.wordWrap = true;
			lblIntroduction.width = 280;
			lblIntroduction.x = lblX;
			lblIntroduction.y = lblY;
			_viewLayer.addChild(lblIntroduction);
		}
		private function buyProps(param:Array):void{
			var window:LSouSouWindow;
			var propsXml:XMLList = LSouSouObject.props["Props" + param[0]];
			if(LSouSouObject.money < int(propsXml.Money.toString())){
				window = new LSouSouWindow();
				window.setMsg(["银两不足！",0]);
				LGlobal.script.scriptLayer.addChild(window);
				return;
			}
			var xmllist:XML;
			var ishava:Boolean;
			for each(xmllist in LSouSouObject.propsList.elements()){
				if(int(xmllist.@index) == int(param[0])){
					xmllist.@num = int(xmllist.@num) + 1;
					ishava = true;
					break;
				}
			}
			if(!ishava){
				LSouSouObject.propsList.appendChild(new XMLList("<list index='"+param[0]+"' num='1' />"));
			}
			
			LSouSouObject.money -= int(propsXml.Money.toString());
			
			_money.htmlText = "<font color='#ffffff' size='20'><b>"+LSouSouObject.money+"</b></font>";
			window = new LSouSouWindow();
			window.setMsg(["买入一个"+propsXml.Name,0]);
			trace("LSouSouObject.propsList = "+LSouSouObject.propsList);
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function shopItem(param:Array):void{
			var color:int = this._shopIndex%2 == 0?0x000033:0x330000;
			_shopLayer.graphics.lineStyle(0,0x000000,1);
			LDisplay.drawRect(_shopLayer.graphics,[0,1+this._shopIndex*60,380,58],true,color,0.2,5);
			//LDisplay.drawRect(_shopLayer.graphics,[260,11+this._shopIndex*60,80,38],false,0xffffff,0.7,3);
			
			
			var itemXml:XMLList = LSouSouObject.item["Child" + param[0]];
			var itemBit:LBitmap = new LBitmap(LSouSouObject.itemImg[itemXml.Icon]);
			itemBit.width = 50;
			itemBit.height = 50;
			itemBit.xy = new LCoordinate(0,this._shopIndex*60+5);
			_shopLayer.addChild(itemBit);
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+itemXml.Name+"</b></font>";
			lblName.xy = new LCoordinate(70,this._shopIndex*60+5);
			_shopLayer.addChild(lblName);
			
			var lblLv:LLabel = new LLabel();
			lblLv.htmlText = "<font color='#ffffff' size='15'>Lv:"+param[1]+"</font>";
			lblLv.xy = new LCoordinate(70,this._shopIndex*60+30);
			_shopLayer.addChild(lblLv);
			
			var lblMoney:LLabel = new LLabel();
			lblMoney.htmlText = "<font color='#ffffff' size='20'><b>"+itemXml.Money+"两</b></font>";
			lblMoney.xy = new LCoordinate(170,this._shopIndex*60+5);
			_shopLayer.addChild(lblMoney);
			
			
			var btn:LButton = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"btn_001.png"));
			btn.label = "購入";
			btn.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				buyItem(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OVER,function (event:MouseEvent):void{
				showItem(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OUT,function (event:MouseEvent):void{
				_viewLayer.die();
			});
			//btn.alpha = 1;
			btn.xy = new LCoordinate(260,11+this._shopIndex*60);
			_shopLayer.addChild(btn);
			this._shopIndex++;
			setShop();
		}
		private function showItem(param:Array):void{
			var itemXml:XMLList = LSouSouObject.item["Child" + param[0]];
			var itemBit:LBitmap = new LBitmap(LSouSouObject.itemImg[itemXml.Icon]);
			itemBit.width = 100;
			itemBit.height = 100;
			itemBit.xy = new LCoordinate(10,10);
			_viewLayer.addChild(itemBit);
			
			var lblX:int = 10;
			var lblY:int = 115;
			
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+itemXml.Name+"</b></font>";
			lblName.xy = new LCoordinate(lblX,lblY);
			_viewLayer.addChild(lblName);
			
			var lblLv:LLabel = new LLabel();
			lblLv.htmlText = "<font color='#ffffff' size='15'>Lv:"+param[1]+"</font>";
			lblLv.xy = new LCoordinate(lblX,lblY+25);
			_viewLayer.addChild(lblLv);
			
			lblX = 120;
			lblY = 10;
			
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY;
			_viewLayer.addChild(attackBitmap);
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Attack) + int(itemXml.Attack.@add)*(int(param[1])-1)) + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY;
			_viewLayer.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 25;
			_viewLayer.addChild(spiritBitmap);
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Spirit) + int(itemXml.Spirit.@add)*(int(param[1])-1)) + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 25;
			_viewLayer.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 50;
			_viewLayer.addChild(defenseBitmap);
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Defense) + int(itemXml.Defense.@add)*(int(param[1])-1)) + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 50;
			_viewLayer.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 75;
			_viewLayer.addChild(breakoutBitmap);
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Breakout) + int(itemXml.Breakout.@add)*(int(param[1])-1)) + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 75;
			_viewLayer.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 100;
			_viewLayer.addChild(moraleBitmap);
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Morale) + int(itemXml.Morale.@add)*(int(param[1])-1)) + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 100;
			_viewLayer.addChild(lblMorale);
			
			lblX = 210;
			lblY = 10;
			
			var hpBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"hert.png"));
			hpBitmap.smoothing = true;
			hpBitmap.width = 20;
			hpBitmap.height = 20;
			hpBitmap.x = lblX;
			hpBitmap.y = lblY;
			_viewLayer.addChild(hpBitmap);
			var lblHp:LLabel = new LLabel();
			lblHp.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Hp) + int(itemXml.Hp.@add)*(int(param[1])-1)) + "</font>";
			lblHp.x = lblX + 40;
			lblHp.y = lblY;
			_viewLayer.addChild(lblHp);
			
			var mpBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"fan.png"));
			mpBitmap.smoothing = true;
			mpBitmap.width = 20;
			mpBitmap.height = 20;
			mpBitmap.x = lblX;
			mpBitmap.y = lblY + 25;
			_viewLayer.addChild(mpBitmap);
			var lblMp:LLabel = new LLabel();
			lblMp.htmlText = "<font color='#ffffff' size='15'>+" + (int(itemXml.Mp) + int(itemXml.Mp.@add)*(int(param[1])-1)) + "</font>";
			lblMp.x = lblX + 40;
			lblMp.y = lblY + 25;
			_viewLayer.addChild(lblMp);
			
			
			var moveBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_move.png"));
			moveBitmap.smoothing = true;
			moveBitmap.width = 20;
			moveBitmap.height = 20;
			moveBitmap.x = lblX;
			moveBitmap.y = lblY + 50;
			_viewLayer.addChild(moveBitmap);
			var lblMove:LLabel = new LLabel();
			lblMove.htmlText = "<font color='#ffffff' size='15'>" + (int(itemXml.Distance) + int(itemXml.Distance.@add)*(int(param[1])-1)) + "</font>";
			lblMove.width = 230;
			lblMove.x = lblX + 40;
			lblMove.y = lblY + 50;
			_viewLayer.addChild(lblMove);
			
			lblX = 10;
			lblY = 170;
			
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.htmlText = "<font color='#ffffff' size='15'>" + itemXml.Introduction + "</font>";
			lblIntroduction.wordWrap = true;
			lblIntroduction.width = 280;
			lblIntroduction.x = lblX;
			lblIntroduction.y = lblY;
			_viewLayer.addChild(lblIntroduction);
		}
		private function buyItem(param:Array):void{
			var window:LSouSouWindow;
			var itemXml:XMLList = LSouSouObject.item["Child" + param[0]];
			if(LSouSouObject.money < int(itemXml.Money.toString())){
				window = new LSouSouWindow();
				window.setMsg(["银两不足！",0]);
				LGlobal.script.scriptLayer.addChild(window);
				return;
			}
			LSouSouObject.itemsList.appendChild(new XMLList("<list index='"+param[0]+"' lv='"+param[1]+"' />"));
			LSouSouObject.money -= int(LSouSouObject.item["Child" + param[0]].Money.toString());
			
			_money.htmlText = "<font color='#ffffff' size='20'><b>"+LSouSouObject.money+"</b></font>";
			window = new LSouSouWindow();
			window.setMsg(["买入"+param[1]+"级"+itemXml.Name,0]);
			LGlobal.script.scriptLayer.addChild(window);
		}
	}
}