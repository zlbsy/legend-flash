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
		private var _equipmentLayer:LSprite;
		private var _equipmentScroll:LScrollbar;
		private var _profileLayer:LSprite;
		private var _itemLayer:LSprite;
		private var _itemScroll:LScrollbar;
		private var _money:LLabel;
		private var _viewLayer:LSprite;
		private var _canItemList:Array;
		private var _selectMemberIndex:int;
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
		public function systemShow(ctrl:String = ""):void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			var readBtn:LButton;
			var saveBtn:LButton;
			var expLbl:LLabel;
			var saveList:Array = new Array();
			systemArray = new Array();
			setBox(20,70,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save1.slf"));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,80);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档一："+(saveList[0] == null?"空":saveList[0][7])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,150,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save2.slf"));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,160);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档二："+(saveList[1] == null?"空":saveList[1][7])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,230,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save3.slf"));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,240);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档三："+(saveList[2] == null?"空":saveList[2][7])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,310,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save4.slf"));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,320);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档四："+(saveList[3] == null?"空":saveList[3][7])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,390,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save5.slf"));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,400);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档五："+(saveList[4] == null?"空":saveList[4][7])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			
			if(ctrl == "" || ctrl == "read"){
				if(saveList[0] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,80);
					readBtn.name = "read01";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[1] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,160);
					readBtn.name = "read02";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[2] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,240);
					readBtn.name = "read03";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[3] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,320);
					readBtn.name = "read04";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[4] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,400);
					readBtn.name = "read05";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
			}
			readBtn = null;
			if(ctrl == "" || ctrl == "save"){
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,80);
				saveBtn.name = "save01";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,160);
				saveBtn.name = "save02";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,240);
				saveBtn.name = "save03";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,320);
				saveBtn.name = "save04";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,400);
				saveBtn.name = "save05";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
			}
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			if(ctrl == "save"){
				addCloseButton(true);
			}else{
				addCloseButton();
			}
		}
		private function readGame(event:MouseEvent):void{
			trace("readGame event"+event.target.name);
			if(event.target.name == "read01"){
				ScriptSouSouSave.readGameAsFile("save1");
			}else if(event.target.name == "read02"){
				ScriptSouSouSave.readGameAsFile("save2");
			}else if(event.target.name == "read03"){
				ScriptSouSouSave.readGameAsFile("save3");
			}else if(event.target.name == "read04"){
				ScriptSouSouSave.readGameAsFile("save4");
			}else if(event.target.name == "read05"){
				ScriptSouSouSave.readGameAsFile("save5");
			}
		}
		private function saveGame(event:MouseEvent):void{
			trace("saveGame event = "+event.target.name);
			var strName:String;
			if(event.target.name == "save01"){
				strName = ScriptSouSouSave.saveGameAsFile("save1");
				systemArray[0].htmlText = "<font color='#ffffff' size='18'>"+
					"存档一："+strName + "<b></b></font>";
			}else if(event.target.name == "save02"){
				strName = ScriptSouSouSave.saveGameAsFile("save2");
				systemArray[1].htmlText = "<font color='#ffffff' size='18'>"+
					"存档二："+strName + "<b></b></font>";
			}else if(event.target.name == "save03"){
				strName = ScriptSouSouSave.saveGameAsFile("save3");
				systemArray[2].htmlText = "<font color='#ffffff' size='18'>"+
					"存档三："+strName + "<b></b></font>";
			}else if(event.target.name == "save04"){
				strName = ScriptSouSouSave.saveGameAsFile("save4");
				systemArray[3].htmlText = "<font color='#ffffff' size='18'>"+
					"存档四："+strName + "<b></b></font>";
			}else if(event.target.name == "save05"){
				strName = ScriptSouSouSave.saveGameAsFile("save5");
				systemArray[4].htmlText = "<font color='#ffffff' size='18'>"+
					"存档五："+strName + "<b></b></font>";
			}
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
					"是一款游戏引擎，目前您正在玩的游戏由该引擎的0.11版本制作完成。\n\n" + 
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
		private function addCloseButton(run:Boolean = false):void{
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
		public function equipmentChange():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			setBox(15,15,110,LGlobal.stage.stageHeight-30);
			_equipmentLayer = new LSprite();
			var i:int;
			var lblname:LLabel;
			var member:LSouSouMember;
			for(i=0;i<LSouSouObject.memberList.length;i++){
				member = LSouSouObject.memberList[i];
				lblname = new LLabel();
				lblname.htmlText = "<font color='#ffffff' size='20'>"+member.name+"</font>";
				lblname.y = i*40 + 7;
				_equipmentLayer.addChild(lblname);
				
			}
			_equipmentScroll = new LScrollbar(_equipmentLayer,80,LGlobal.stage.stageHeight-40,20,false);
			_equipmentScroll.xy = new LCoordinate(20,20);
			_equipmentLayer.addEventListener(MouseEvent.MOUSE_MOVE,function (event:MouseEvent):void{
				_equipmentLayer.graphics.clear();
				LDisplay.drawRect(event.currentTarget.graphics,[0,int(event.currentTarget.mouseY/40)*40,80,40],true,0xffffff,0.2);
				LDisplay.drawRect(event.currentTarget.graphics,[0,int(event.currentTarget.mouseY/40)*40,80,40],false,0xffffff,0.8,2);
			});
			_equipmentLayer.addEventListener(MouseEvent.MOUSE_OUT,function (event:MouseEvent):void{
				_equipmentLayer.graphics.clear();
			});
			_equipmentLayer.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				_itemLayer.graphics.clear();
				_equipmentLayer.graphics.clear();
				LSouSouObject.window.setProfile(int(event.currentTarget.mouseY/40));
			});
			
			this.addChild(_equipmentScroll);
			_profileLayer = new LSprite();
			_profileLayer.xy = new LCoordinate(150,15);
			this.addChild(_profileLayer);
			setBox(150,15,600,LGlobal.stage.stageHeight-30);
			setBox(155,20,250,250);
			setBox(420,290,320,160);
			_itemLayer = new LSprite();
			_itemScroll = new LScrollbar(_itemLayer,310,150,20,false);
			_itemScroll.xy = new LCoordinate(425,295);
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
				LSouSouObject.window.setItem(int(event.currentTarget.mouseY/40));
			});
			this.addChild(_itemScroll);
			
			addCloseButton();
			/**
			var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"closebtnup.png");
			var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"closebtnover.png");
			var btnClose:LButton = new LButton(bitmapup,bitmapover,bitmapover);
			btnClose.xy = new LCoordinate(770,10);
			btnClose.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
			});
			this.addChild(btnClose);*/
		}
		public function setItem(i:int):void{
			var selectItem:XMLList = _canItemList[i];
			var newXml:XML = <data></data>;
			var member:LSouSouMember = LSouSouObject.memberList[_selectMemberIndex];
			var nowItem:XMLList;
			var itemXml:XMLList = LSouSouObject.item["Child"+selectItem.@index];
			
			var listXml:XML;
			for each(listXml in LSouSouObject.itemsList.elements()){
				if(listXml.@index != selectItem.@index || listXml.@lv != selectItem.@lv || listXml.@exp != selectItem.@exp){
					newXml.appendChild(listXml);
				}
			}
			if(int(itemXml.Type) == 0){
				nowItem = member.helmet;
				member.helmet = new XMLList("<Helmet>"+selectItem.@index+"</Helmet>");
			}else if(int(itemXml.Type) == 1){
				nowItem = member.weapon;
				member.weapon = new XMLList("<Weapon lv='"+selectItem.@lv+"' exp='"+selectItem.@exp+"'>"+selectItem.@index+"</Weapon>");

			}else if(int(itemXml.Type) == 2){
				nowItem = member.equipment;
				member.equipment = new XMLList("<Equipment lv='"+selectItem.@lv+"' exp='"+selectItem.@exp+"'>"+selectItem.@index+"</Equipment>");
			}else if(int(itemXml.Type) == 3){
				nowItem = member.horse;
				member.horse = new XMLList("<Horse>"+selectItem.@index+"</Horse>");
			}
			newXml.appendChild(nowItem);
			LSouSouObject.itemsList = newXml;
			setProfile(_selectMemberIndex);
		}
		public function setProfile(i:int):void{
			_selectMemberIndex = i;
			_profileLayer.die();
			_itemLayer.removeAllChild();
			
			var member:LSouSouMember = LSouSouObject.memberList[_selectMemberIndex];
			var facedata:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["face"],
				"face" + member.face +"-0");
			var face:LBitmap = new LBitmap(facedata);
			face.x = 10;
			face.y = 10;
			_profileLayer.addChild(face);
			var itemImg:LBitmap;
			var itemXml:XMLList;
			var listXml:XML;
			var nameLabel:LLabel;
			_canItemList = new Array();
			for each(listXml in LSouSouObject.itemsList.elements()){
				itemXml = LSouSouObject.item["Child"+listXml.@index];
				
				if(itemXml.Can["list"+member.arms] == null)continue;
				if(int(itemXml.Can["list"+member.arms].toString()) == 1){
					itemImg = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],itemXml.Icon));
					itemImg.width = 40;
					itemImg.height = 40;
					itemImg.y = _canItemList.length * 40;
					_itemLayer.addChild(itemImg);
					nameLabel = new LLabel();
					nameLabel.htmlText = "<font color='#ffffff' size='20'>"+itemXml.Name+"</font>";
					nameLabel.xy = new LCoordinate(50,itemImg.y + 5);
					_itemLayer.addChild(nameLabel);
					_canItemList.push(new XMLList(listXml.toXMLString()));
				}
				
			}
			LDisplay.drawRect(_itemLayer.graphics,[0,0,290,_canItemList.length*40],true,0xffffff,0.1,0);
			
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+member.name+"</b></font>";
			lblName.x = 15;
			lblName.y = 261;
			_profileLayer.addChild(lblName);
			var lblLv:LLabel = new LLabel();
			lblLv.htmlText = "<font color='#ffffff' size='20'><b>Lv."+member.lv+"</b></font>";
			lblLv.x = 110;
			lblLv.y = 261;
			_profileLayer.addChild(lblLv);
			
			var lblX:int = 400;
			var lblY:int = 105;
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
			
			lblX = 265;
			lblY = 15;
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
			
			
			lblX = 20;
			lblY = 320;
			
			LDisplay.drawRect(_profileLayer.graphics,[lblX-10,lblY-10,250,70],false,0xffffff,1,2);
			LDisplay.drawRect(_profileLayer.graphics,[lblX,lblY,50,50],true,0xffffff,0.5,0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 60,lblY,50,50],true,0xffffff,0.5,0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 120,lblY,50,50],true,0xffffff,0.5,0);
			LDisplay.drawRect(_profileLayer.graphics,[lblX + 180,lblY,50,50],true,0xffffff,0.5,0);
			
			var helmet:XMLList = member.helmet;
			var equipment:XMLList = member.equipment;
			var weapon:XMLList = member.weapon;
			var horse:XMLList = member.horse;
			trace("addEquipment = ",helmet,equipment,weapon,horse);
			//饰品
			if(int(helmet.toString()) > 0){
				var helmetBit:LBitmap = new LBitmap(
					LGlobal.getBitmapData(
						LGlobal.script.scriptArray.swfList["item"],
						LSouSouObject.item["Child" + helmet.toString()]["Icon"]
					)
				);
				helmetBit.width = 50;
				helmetBit.height = 50;
				helmetBit.xy = new LCoordinate(lblX,lblY);
				_profileLayer.addChild(helmetBit);
			}
			//装备
			if(int(equipment.toString()) > 0){
				var equipmentBit:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],
					LSouSouObject.item["Child" + equipment.toString()]["Icon"]));
				equipmentBit.width = 50;
				equipmentBit.height = 50;
				equipmentBit.xy = new LCoordinate(lblX + 60,lblY);
				
				_profileLayer.addChild(equipmentBit);
			}
			//武器
			if(int(weapon.toString()) > 0){
				var weaponBit:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],
					LSouSouObject.item["Child" + weapon.toString()]["Icon"]));
				weaponBit.width = 50;
				weaponBit.height = 50;
				weaponBit.xy = new LCoordinate(lblX + 120,lblY);
				_profileLayer.addChild(weaponBit);
			}
			//坐骑
			if(int(horse.toString()) > 0){
				var horseBit:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],
					LSouSouObject.item["Child" + horse.toString()]["Icon"]));
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
				showItem(param);
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
				showProps(param);
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
		}
		public function shop():void{
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
			
			addCloseButton();
			/**
			var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"closebtnup.png");
			var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"closebtnover.png");
			var btnClose:LButton = new LButton(bitmapup,bitmapover,bitmapover);
			btnClose.xy = new LCoordinate(770,10);
			btnClose.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
			});
			this.addChild(btnClose);
			*/
			_shopIndex = 0;
			_shopLayer = new LSprite();
			_shopScrollbar = new LScrollbar(_shopLayer,360,420,20,false);
			_shopScrollbar.x = 30;
			_shopScrollbar.y = 30;
			this.addChild(_shopScrollbar);
			setShop();
		}
		public function setShop():void{
			var script:LScript = LGlobal.script;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				setShop();
				return;
			}
			if(lineValue == "endfunction"){
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
			var propsBit:LBitmap = new LBitmap(
				LGlobal.getBitmapData(
					LGlobal.script.scriptArray.swfList["item"],propsXml["Icon"]
				)
			);
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
			
			var lblMoney:LLabel = new LLabel();
			lblMoney.htmlText = "<font color='#ffffff' size='20'><b>"+itemXml.Money+"两</b></font>";
			lblMoney.xy = new LCoordinate(170,this._shopIndex*60+5);
			_shopLayer.addChild(lblMoney);
			
			
			//lblMoney = new LLabel();
			//lblMoney.htmlText = "<font color='#ffffff' size='20'><b>买入</b></font>";
			//lblMoney.xy = new LCoordinate(275,15+this._shopIndex*60);
			//_shopLayer.addChild(lblMoney);
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
			var itemBit:LBitmap = new LBitmap(
				LGlobal.getBitmapData(
					LGlobal.script.scriptArray.swfList["item"],itemXml["Icon"]
				)
			);
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
		public function condition(param:Array,clickMenu:Boolean = false):void{
			LSouSouObject.sMap.condition = param;
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			
			var lblText:LLabel;
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			
			var _menuX:int = 50;
			var _menuY:int = 20;
			var _menuW:int = 700;
			var _menuH:int = 50;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>回合数:" + LSouSouObject.sMap.roundCount +"/--</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 10;
			this.addChild(lblText);
			
			_menuX = 50;
			_menuY = 80;
			_menuW = 700;
			_menuH = 150;
			setBox(_menuX,_menuY,_menuW,_menuH);
			
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>胜利条件:</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 10;
			this.addChild(lblText);
			lblText = new LLabel();
			var winText:String = param[0];
			while(winText.indexOf("\\n")>=0)winText = winText.replace("\\n","\n");
			lblText.htmlText = "<font size='22' color='#ffffff'><b>"+winText+"</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 50;
			this.addChild(lblText);
			
			_menuX = 50;
			_menuY = 250;
			_menuW = 700;
			_menuH = 150;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>失败条件:</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 10;
			this.addChild(lblText);
			lblText = new LLabel();
			var failText:String = param[1];
			while(failText.indexOf("\\n")>=0)failText = failText.replace("\\n","\n");
			
			lblText.htmlText = "<font size='22' color='#ffffff'><b>"+failText+"</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 50;
			this.addChild(lblText);
			var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"logobtnover.png");
			if(clickMenu){
				//var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"logobtnover.png");
				//var btnDeparture:LButton = new LButton(bitmapup,bitmapover,bitmapover);
				var btnRoundOver:LButton = new LButton(bitmapover);
				btnRoundOver.labelColor = "#ffffff";
				btnRoundOver.label = "回合结束";
				btnRoundOver.xy = new LCoordinate((LGlobal.stage.width - btnRoundOver.width)/2 - btnRoundOver.width/2-10,410);
				btnRoundOver.addEventListener(MouseEvent.MOUSE_UP,
					function (event:MouseEvent):void{
						//LSouSouObject.window.removeFromParent();
						//LGlobal.script.analysis();
						LSouSouObject.window.die();
						LSouSouObject.window.isEndRoundSelect();
					});
				this.addChild(btnRoundOver);
				
				//var btnDeparture:LButton = new LButton(bitmapup,bitmapover,bitmapover);
				var btnContinue:LButton = new LButton(bitmapover);
				btnContinue.labelColor = "#ffffff";
				btnContinue.label = "继续游戏";
				btnContinue.xy = new LCoordinate((LGlobal.stage.width - btnContinue.width)/2 + btnContinue.width/2+10,410);
				btnContinue.addEventListener(MouseEvent.MOUSE_UP,
					function (event:MouseEvent):void{
						LSouSouObject.window.removeFromParent();
						LGlobal.script.analysis();
					});
				this.addChild(btnContinue);
			}else{
				var btnStart:LButton = new LButton(bitmapover);
				btnStart.labelColor = "#ffffff";
				btnStart.label = "开始战斗";
				btnStart.xy = new LCoordinate((LGlobal.stage.width - btnStart.width)/2,410);
				btnStart.addEventListener(MouseEvent.MOUSE_UP,
					function (event:MouseEvent):void{
						LSouSouObject.window.removeFromParent();
						LGlobal.script.analysis();
					});
				this.addChild(btnStart);
			}
			LSouSouObject.window = this;
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