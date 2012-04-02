package zhanglubin.legend.game.sousou.map
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterPreWar;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.character.LSouSouMember;
	import zhanglubin.legend.game.sousou.map.window.LSouSouWindwoSystem;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.sousou.object.LSouSouSMapMethod;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.ScriptFunction;
	import zhanglubin.legend.scripts.analysis.slg.sousou.ScriptSouSouSave;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.math.LCoordinate;
	import zhanglubin.legend.utils.transitions.LManager;

	public class LSouSouWindow extends LSprite
	{
		private var _perWarList:Array;
		private var _selectWarList:Array;
		private var _selectDisplay:LSprite;
		private var _shopIndex:int;
		private var _shopLayer:LSprite;
		private var _shopScrollbar:LScrollbar;
		private var _money:LLabel;
		private var _viewLayer:LSprite;
		private var _windowSingled:LSouSouSingled;
		private var _urlloader:LURLLoader;
		private var _save_ctrl:String;
		private var systemArray:Array;
		public function LSouSouWindow()
		{
		}

		public function get windowSingled():LSouSouSingled
		{
			return _windowSingled;
		}
		
		public function singled(params:Array):void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			LSouSouObject.window.name = "singled";
			_windowSingled = new LSouSouSingled(int(params[0]),int(params[1]),int(params[2]),int(params[3]),int(params[4]),int(params[5]));
			_windowSingled.xy = new LCoordinate(100,50);
			this.addChild(_windowSingled);
			setBox(100,50,LGlobal.stage.stageWidth-200,LGlobal.stage.stageHeight-100);
		}
		public function libGameExplanation():void{
			_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadGameExplanationOver);
			_urlloader.load(new URLRequest("initialization/g.lf"));
			
		}
		private function loadGameExplanationOver(event:Event):void{
			var explanation:String = _urlloader.data;
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			setBox(15,15,LGlobal.stage.stageWidth - 50,400);
			var explanationTxt:LLabel = new LLabel();
			explanationTxt.xy = new LCoordinate(50,50);
			explanationTxt.width = 700;
			explanationTxt.wordWrap = true;
			while(explanation.indexOf("\r\n")>=0)explanation = explanation.replace("\r\n","\n");
			explanationTxt.htmlText = "<b><font color='#ffffff' size='18'>" + explanation + "</font></b>";;
			this.addChild(explanationTxt);
			
			addCloseButton();
		}
		public function libExplanation():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			setBox(15,15,LGlobal.stage.stageWidth - 50,300);
			var explanationTxt:LLabel = new LLabel();
			explanationTxt.xy = new LCoordinate(50,50);
			explanationTxt.width = 700;
			explanationTxt.wordWrap = true;
			explanationTxt.htmlText = "<b><font color='#ffffff' size='25'>" + 
					"LegendForFlashProgramming，简称legend，\n" + 
					"是一款游戏引擎，目前您正在玩的游戏由该引擎的0.1.2版本制作完成。\n\n" + 
					"如果您想了解更多关于该游戏引擎的最新信息以及该游戏引擎的使用方法，\n" + 
					"欢迎光临作者的官方博客：\n" + "</font></b>";
			this.addChild(explanationTxt);
			var urlTxt:LLabel = new LLabel();
			urlTxt.xy = new LCoordinate(50,250);
			urlTxt.htmlText = "<b><font color='#ffffff' size='25'><u><a href='event:http://blog.csdn.com/lufy_Legend'>http://blog.csdn.com/lufy_Legend</a></u></font></b>";
			urlTxt.addEventListener(TextEvent.LINK, function (event:TextEvent):void{
				var url:String = "http://blog.csdn.com/lufy_Legend";
				var request:URLRequest = new URLRequest(url);
				navigateToURL(request);
				trace("goto");
			});
			this.addChild(urlTxt);
			
			var banTxt:LLabel = new LLabel();
			banTxt.xy = new LCoordinate(450,430);
			banTxt.htmlText = "<b><font color='#ffffff' size='18'>LegendForFlashProgramming0.11</font></b>";
			this.addChild(banTxt);
			
			addCloseButton();
		}
		protected function addCloseButton(run:Boolean = false):void{
			var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"close2");
			//var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"close_over");
			var btnClose:LButton = new LButton(bitmapup);
			btnClose.alpha = 0.6;
			btnClose.xy = new LCoordinate(740,10);
			btnClose.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
				if(run)LGlobal.script.analysis();
			});
			this.addChild(btnClose);
		}
		
		public function setMsg(params:Array):void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			var msg :String = params[0];
			if(msg.indexOf("\\n"))msg = msg.replace("\\n","\n");
			var lblMsg:LLabel = new LLabel();
			lblMsg.htmlText = "<font color='#ffffff'><b>"+msg+"</b></font>";
			lblMsg.wordWrap = true;
			lblMsg.width = 400;
			lblMsg.xy = new LCoordinate((LGlobal.stage.stageWidth - lblMsg.width)/2,(LGlobal.stage.stageHeight - lblMsg.height)/2);
			this.addChild(lblMsg);
			
			setBox(lblMsg.x - 10,lblMsg.y - 10,420,lblMsg.height + 20);
			if(params.length == 2 || params[2]==0){
				this.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
					removeFromParent();
					if(params[1]=="1")LGlobal.script.analysis();
				});
			}else if(int(params[2]) > 0){
				LManager.wait(int(params[2]),function ():void{
					removeFromParent();
					if(params[1]=="1")LGlobal.script.analysis();
				});
			}
		}
		public function luggage():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			var i:int;
			
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
			
			_shopIndex = 0;
			_shopLayer = new LSprite();
			_shopScrollbar = new LScrollbar(_shopLayer,360,420,20,false);
			_shopScrollbar.x = 30;
			_shopScrollbar.y = 30;
			this.addChild(_shopScrollbar);
			
			var xmllist:XML;
			for each(xmllist in LSouSouObject.propsList.elements()){
				setPropsList([xmllist.@index,xmllist.@num]);
			}
			for each(xmllist in LSouSouObject.itemsList.elements()){
				setItemList([xmllist.@index,xmllist.@lv]);
			}
			
			addCloseButton();
		}
		private function setItemList(param:Array):void{
			var color:int = this._shopIndex%2 == 0?0x000033:0x330000;
			_shopLayer.graphics.lineStyle(0,0x000000,1);
			LDisplay.drawRect(_shopLayer.graphics,[0,1+this._shopIndex*60,380,58],true,color,0.2,5);
			
			var itemXml:XMLList = LSouSouObject.item["Child" + param[0]];
			var itemBit:LBitmap = new LBitmap(
				LGlobal.getBitmapData(
					LGlobal.script.scriptArray.swfList["item"],itemXml["Icon"]
				)
			);
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
			
			var btn:LButton = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"btn_001.png"));
			btn.label = "确认";
			btn.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				//************************************************
				//showItem(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OVER,function (event:MouseEvent):void{
				//************************************************
				//showItem(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OUT,function (event:MouseEvent):void{
				_viewLayer.die();
			});
			//btn.alpha = 1;
			btn.xy = new LCoordinate(260,11+this._shopIndex*60);
			_shopLayer.addChild(btn);
			this._shopIndex++;
		}
		private function setPropsList(param:Array):void{
			var color:int = this._shopIndex%2 == 0?0x000033:0x330000;
			_shopLayer.graphics.lineStyle(0,0x000000,1);
			LDisplay.drawRect(_shopLayer.graphics,[0,1+this._shopIndex*60,380,58],true,color,0.2,5);
			//Props
			var propsXml:XMLList = LSouSouObject.props["Props" + param[0]];
			var propsBit:LBitmap = new LBitmap(
				LGlobal.getBitmapData(
					LGlobal.script.scriptArray.swfList["item"],propsXml["Icon"]
				)
			);
			propsBit.width = 50;
			propsBit.height = 50;
			propsBit.xy = new LCoordinate(0,this._shopIndex*60+5);
			_shopLayer.addChild(propsBit);
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+propsXml.Name+"</b></font>";
			lblName.xy = new LCoordinate(70,this._shopIndex*60+5);
			_shopLayer.addChild(lblName);
			
			var lblMoney:LLabel = new LLabel();
			lblMoney.htmlText = "<font color='#ffffff' size='20'><b>"+param[1]+"个</b></font>";
			lblMoney.xy = new LCoordinate(170,this._shopIndex*60+5);
			_shopLayer.addChild(lblMoney);
			
			var btn:LButton = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"btn_001.png"));
			btn.label = "确认";
			btn.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				//************************************************
				//showProps(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OVER,function (event:MouseEvent):void{
				//************************************************
				//showProps(param);
			});
			btn.addEventListener(MouseEvent.MOUSE_OUT,function (event:MouseEvent):void{
				_viewLayer.die();
			});
			//btn.alpha = 1;
			btn.xy = new LCoordinate(260,11+this._shopIndex*60);
			_shopLayer.addChild(btn);
			this._shopIndex++;
		}
		public function isEndRoundSelect():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			var _characterS:LSouSouCharacterS;
			var fun:Function;
			var clicks:Array = [];
			fun = function (event:MouseEvent):void{
					for each(_characterS in LSouSouObject.sMap.ourlist){
						if(_characterS.visible &&  _characterS.action_mode != LSouSouCharacterS.MODE_STOP){
							_characterS.action = LSouSouCharacterS.DOWN + _characterS.direction;
							_characterS.action_mode = LSouSouCharacterS.MODE_STOP;				
						}
					}
					LSouSouObject.window.removeFromParent();
					LSouSouSMapMethod.checkCharacterSOver(LSouSouObject.BELONG_SELF);
				};
			clicks.push(fun);
			fun = function (event:MouseEvent):void{
					LSouSouObject.window.removeFromParent();
					LGlobal.script.analysis();
				};
			clicks.push(fun);
			var i:int;
			var btn:LButton;
			var params:Array = ["回合结束","继续战斗"];
			for(i=0;i<params.length;i++){
				btn = new LButton(this.getBoxBitmapData(200,30));
				btn.labelColor = "#ffffff";
				btn.label = params[i];
				btn.x = (LGlobal.stage.stageWidth-btn.width)/2;
				btn.y = 200 + i*50;
				btn.addEventListener(MouseEvent.MOUSE_UP,clicks[i]);
				this.addChild(btn);
			}
			
		}
		public function preWar(param:Array):void{
			LSouSouObject.window = this;
			LDisplay.drawRect(this.graphics,[0,0,800,480],true,0x000000,0.5,5);
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			setBox(50,50,700,250);
			setBox(50,320,700,100);
			//LDisplay.drawRect(this.graphics,[50,50,700,250],false,0xffffff,1,2);
			//LDisplay.drawRect(this.graphics,[50,320,700,100],false,0xffffff,1,2);
			var scrollbar:LScrollbar;
			var sCharaDisplay:LSprite = new LSprite();
			var charaPreWar:LSouSouCharacterPreWar;
			var member:LSouSouMember;
			
			_selectDisplay = new LSprite();
			_selectDisplay.xy = new LCoordinate(50,320);
			this.addChild(_selectDisplay);
			//LSouSouObject.perWarList = new Array();
			_perWarList = new Array();
			_selectWarList = new Array();
			for each(member in LSouSouObject.memberList){
				charaPreWar = new LSouSouCharacterPreWar(member);
				sCharaDisplay.addChild(charaPreWar);
				//LSouSouObject.perWarList.push({character:charaPreWar, name:member.name, lv:member.lv});
				_perWarList.push({character:charaPreWar, name:member.name, lv:member.lv});
			}
			sortPreWar("lv");
			scrollbar = new LScrollbar(sCharaDisplay,700,250,20,false);
			scrollbar.xy = new LCoordinate(50,50);
			this.addChild(scrollbar);
			var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"logobtnup.png");
			var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"logobtnover.png");
			var btnDeparture:LButton = new LButton(bitmapup,bitmapover,bitmapover);
			btnDeparture.label = "出战";
			btnDeparture.xy = new LCoordinate(140,430);
			btnDeparture.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				trace("出战",_selectWarList);
				LSouSouObject.perWarList = _selectWarList;
				LGlobal.script.saveList();
				LGlobal.script.dataList.unshift(["Layer.clear(-);Load.script(" + param + ");"]);
				LGlobal.script.toList("Layer.clear(-);Load.script(" + param + ");");
			});
			this.addChild(btnDeparture);
			var btnReturn:LButton = new LButton(bitmapup,bitmapover,bitmapover);
			btnReturn.label = "返回";
			btnReturn.xy = new LCoordinate(410,430);
			btnReturn.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{LSouSouObject.window.removeFromParent();});
			this.addChild(btnReturn);
		}
		public function sortPreWar(value:String):void{
			//LSouSouObject.perWarList.sortOn(value);
			_perWarList.sortOn(value);
			var obj:Object;
			var charaPreWar:LSouSouCharacterPreWar;
			var i:int = 0;
			for each(obj in _perWarList){
				charaPreWar = obj.character;
				charaPreWar.y = charaPreWar.height*(i++);
			}
		}
		public function setWarList(index:int,isSelect:Boolean):void{
			_selectDisplay.die();
			var i:int;
			var length:int = _selectWarList.length;
			var showbitmap:LBitmap;
			var data01:BitmapData,imagedata:BitmapData;
			if(!isSelect){
				for(i=0;i<length;i++){
					if(index == _selectWarList[i]){
						_selectWarList.splice(i,1);
						break;
					}
				}
			}else{
				_selectWarList.push(index);
			}
			length = _selectWarList.length;
			for(i=0;i<length;i++){
				data01 = LSouSouObject.charaMOVList[LSouSouObject.chara["peo"+_selectWarList[i]]["S"]];
				/*
				LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["S"],
					LSouSouObject.chara["peo"+_selectWarList[i]]["S"] + "mov");
				*/
				imagedata = new BitmapData(48,48,true);
				imagedata.copyPixels(data01,new Rectangle(0,288,48,48),new Point(0,0));
				showbitmap = new LBitmap(imagedata);
				showbitmap.xy = new LCoordinate(int(i%60)*60,int(i/60)*60);
				_selectDisplay.addChild(showbitmap);
			}
		}
		
		protected function setBox(_menuX:int,_menuY:int,_menuW:int,_menuH:int):void{
			var _menuBitmap:LBitmap;
			_menuBitmap = new LBitmap(new BitmapData(_menuW,5,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,_menuH,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,_menuH,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuW + _menuX - _menuBitmap.width;
			_menuBitmap.y = _menuY;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(_menuW,5,true));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY + _menuH - 5;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"));
			_menuBitmap.x = _menuW + _menuX - 15;
			_menuBitmap.y = _menuY;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY + _menuH - 15;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")));
			_menuBitmap.x = _menuW + _menuX - 15;
			_menuBitmap.y = _menuY + _menuH - 15;
			this.addChild(_menuBitmap);
		}
		protected function getBoxBitmapData(menu_w:int,menu_h:int):BitmapData{
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
	}
}