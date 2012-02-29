package zhanglubin.legend.game.sousou.map
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LShape;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.map.LMap;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacter;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterR;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.character.LSouSouMember;
	import zhanglubin.legend.game.sousou.map.smap.LSouSouCtrlMenuLayer;
	import zhanglubin.legend.game.sousou.map.smap.LSouSouRound;
	import zhanglubin.legend.game.sousou.meff.LSouSouMeff;
	import zhanglubin.legend.game.sousou.meff.LSouSouMeffShow;
	import zhanglubin.legend.game.sousou.meff.LSouSouSkill;
	import zhanglubin.legend.game.sousou.menu.LSouSouSMapMenu;
	import zhanglubin.legend.game.sousou.object.LSouSouCalculate;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.sousou.object.LSouSouSMapMethod;
	import zhanglubin.legend.game.sousou.script.LSouSouSMapScript;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.load.LLoading;
	import zhanglubin.legend.objects.LAnimation;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.ScriptFunction;
	import zhanglubin.legend.scripts.analysis.slg.sousou.ScriptSouSouSCharacter;
	import zhanglubin.legend.text.LTextField;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LHitTest;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.math.LCoordinate;
	
	public class LSouSouSMap extends LMap
	{
		
		private const SPEED:int = 4;
		private const SPEED2:int = 50;
		public const SCREEN_WIDTH:int = 768;
		public const SCREEN_HEIGHT:int = 480;
		public var belong_mode:int = 100;
		
		private var _nodeLength:int = 48;
		
		private var _speed:int = 0;
		private var _speed2:int = 0;
		/**
		 *回合显示，设定等相关 
		 */
		private var _roundCtrl:LSouSouRound;
		private var _round_show:int = 0;
		private var _roundCount:int = 1;
		//private var _round_bitmap:LBitmap;
		//private var _round_x:int = 0;
		//private var _roundText:LLabel = new LLabel();

		private var _mouseIsDown:Boolean;
		private var _mapMove:Array = [];
		private var _mapData:Array;
		private var _map:LBitmap;
		private var _miniMap:LBitmap;
		private var _mapBitmapData:BitmapData;
		private var _minimapBitmapData:BitmapData;
		private var _miniScale:Number;
		private var _miniSelf:BitmapData;
		private var _miniFriend:BitmapData;
		private var _miniEnemy:BitmapData;
		private var _miniWindow:LSprite;
		private var _miniCoordinate:int;
		private var _mapCoordinate:LCoordinate = new LCoordinate(0,0);
		private var _mapToCoordinate:LCoordinate = new LCoordinate(0,0);
		private var _labelDetails:LTextField;
		private var _labelDetailsList:Array;
		private var _characterS:LSouSouCharacterS;
		
		private var _urlloader:LURLLoader;
		private var _hero:LSouSouCharacterR;
		private var _characterR:LSouSouCharacterR;
		private var _funList:Array = new Array();
		private var _ourlist:Vector.<LSouSouCharacterS> = new Vector.<LSouSouCharacterS>();
		private var _enemylist:Vector.<LSouSouCharacterS> = new Vector.<LSouSouCharacterS>();
		private var _friendlist:Vector.<LSouSouCharacterS> = new Vector.<LSouSouCharacterS>();
		
		private var _characterList:Vector.<LSouSouCharacterR> = new Vector.<LSouSouCharacterR>();
		private var _friendIsNull:Boolean;
		
		private var _linecolor:int = 0xff0000;
		private var _linesize:int = 1;
		private var grid:LShape = new LShape();
		
		private var _mapH:int;
		private var _mapW:int;
		
		private var _sMenu:LSouSouSMapMenu = new LSouSouSMapMenu();
		private var _menu:LSprite;
		private var _menuBitmap:LBitmap;
		private var _menuSelect:LBitmap;
		private var frames:int;
		private var _timeCount:int;
		private var text:LLabel = new LLabel();
		
		private var _mapLayer:LSprite;
		private var _characterLayer:LSprite;
		private var _menuLayer:LSprite;
		private var _rightMenu:LSouSouCtrlMenuLayer;
		private var _drawLayer:LShape;
		
		//行动结束时测试
		private var _loopList:Array = new Array();
		//回合开始时测试
		private var _loopListStart:Array = new Array();
		
		private var _loopIsRun:Boolean;
		private var _loadBar:LLoading;
		private var _roadList:Array;
		private var _attackRange:XMLList;
		private var _attackTargetRange:XMLList;
		private var _strategy:XMLList;
		private var _props:XMLList;
		
		private var _sMapScript:LSouSouSMapScript = new LSouSouSMapScript();
		
		private var _numList:Array = new Array();
		
		private var _meff:LSouSouMeff;
		private var _skill:LSouSouSkill;
		//法术效果演示
		private var _meffShowList:Array = new Array();
		//战场物件，火，船等[icon,index,x，y，stageindex]
		private var _stageList:Array = new Array();
		
		private var _condition:Array = ["****","****"];
		
		
		public function LSouSouSMap()
		{
			LSouSouObject.sMap = this;
			_mapLayer = new LSprite();
			_characterLayer = new LSprite();
			_menuLayer = new LSprite();
			_rightMenu = new LSouSouCtrlMenuLayer();
			_menuLayer.addChild(_rightMenu);
			_drawLayer = new LShape();
			
			//如果不是存档文件，则将变量进行初始化
			if(LSouSouObject.sMapSaveXml == null){
				for(var i:int = 0;i< 300;i++){
					LGlobal.script.scriptArray.varList["adjacent" + i] = null;
					LGlobal.script.scriptArray.varList["atBelongCoordinate" + i] = null;
					LGlobal.script.scriptArray.varList["atBelongCoordinates" + i] = null;
					LGlobal.script.scriptArray.varList["checkHp" + i] = null;
					LGlobal.script.scriptArray.varList["checkround" + i] = null;
					
					LGlobal.script.scriptArray.varList["param_adjacent" + i] = null;
					LGlobal.script.scriptArray.varList["param_atBelongCoordinate" + i] = null;
					LGlobal.script.scriptArray.varList["param_atBelongCoordinates" + i] = null;
					LGlobal.script.scriptArray.varList["param_checkHp" + i] = null;
					LGlobal.script.scriptArray.varList["param_checkround" + i] = null;
				}
			}
			LSouSouObject.dieIsRuning = false;
			LSouSouObject.runSChara = null;
			LGlobal.script.scriptArray.funList = new Array();
			
			_sMapScript.analysis();
			//analysis();
			LGlobal.script.scriptLayer.addChild(this);
			
			//如果不是存档文件，则HP和MP初始化
			if(LSouSouObject.sMapSaveXml == null){
				var mbr:LSouSouMember;
				for each(mbr in LSouSouObject.memberList){
					mbr.troops = mbr.maxTroops;
					mbr.strategy = mbr.maxStrategy;
				}
			}else{
			}
			this.addChild(_mapLayer);
			this.addChild(_characterLayer);
			this.addChild(_drawLayer);
			this.addChild(_menuLayer);
			
		}

		public function get nodeLength():int
		{
			return _nodeLength;
		}

		public function set condition(value:Array):void
		{
			_condition = value;
		}

		/**
		 * 战况
		 * 胜利条件，失败条件等
		 * */
		public function get condition():Array
		{
			return _condition;
		}

		public function get rightMenu():LSprite
		{
			return _rightMenu;
		}
		public function get menuLayer():LSprite
		{
			return _menuLayer;
		}

		public function get meffShowList():Array
		{
			return _meffShowList;
		}

		public function get skill():LSouSouSkill
		{
			return _skill;
		}

		public function set skill(value:LSouSouSkill):void
		{
			_skill = value;
		}

		public function get stageList():Array
		{
			return _stageList;
		}

		public function set stageList(value:Array):void
		{
			_stageList = value;
		}

		public function get loopListStart():Array
		{
			return _loopListStart;
		}

		public function set loopListStart(value:Array):void
		{
			_loopListStart = value;
		}

		public function get roundCount():int
		{
			return _roundCount;
		}

		public function set roundCount(value:int):void
		{
			_roundCount = value;
		}

		public function get loopIsRun():Boolean
		{
			return _loopIsRun;
		}

		public function set loopIsRun(value:Boolean):void
		{
			_loopIsRun = value;
		}

		public function get loopList():Array
		{
			return _loopList;
		}

		public function set loopList(value:Array):void
		{
			_loopList = value;
		}

		public function get props():XMLList
		{
			return _props;
		}

		public function set props(value:XMLList):void
		{
			_props = value;
		}

		public function set meff(value:LSouSouMeff):void
		{
			_meff = value;
		}

		public function get strategy():XMLList
		{
			return _strategy;
		}

		public function set strategy(value:XMLList):void
		{
			_strategy = value;
		}

		public function set attackTargetRange(value:XMLList):void
		{
			_attackTargetRange = value;
		}

		public function get friendIsNull():Boolean
		{
			return _friendIsNull;
		}

		public function set friendIsNull(value:Boolean):void
		{
			_friendIsNull = value;
		}

		public function get mapW():int
		{
			return _mapW;
		}

		public function set mapW(value:int):void
		{
			_mapW = value;
		}

		public function get mapH():int
		{
			return _mapH;
		}

		public function set mapH(value:int):void
		{
			_mapH = value;
		}

		public function get mapToCoordinate():LCoordinate
		{
			return _mapToCoordinate;
		}

		public function set mapToCoordinate(value:LCoordinate):void
		{
			_mapToCoordinate = value;
		}

		public function get mapData():Array
		{
			return _mapData;
		}

		public function set mapData(value:Array):void
		{
			_mapData = value;
		}

		public function get numList():Array
		{
			return _numList;
		}

		public function set numList(value:Array):void
		{
			_numList = value;
		}

		public function get drawLayer():LShape
		{
			return _drawLayer;
		}

		public function set drawLayer(value:LShape):void
		{
			_drawLayer = value;
		}

		public function get round_show():int
		{
			return _round_show;
		}

		public function set round_show(value:int):void
		{
			_round_show = value;
			
			
			_roundCtrl = new LSouSouRound(_round_show == 1?0:(_round_show == 2?1:0),_roundCount);
			_roundCtrl.x = 84;
			_roundCtrl.y = 220;
			this.addChild(_roundCtrl);
			_roundCtrl.scaleY = 0.1;
		}

		public function get cancel_menu():LButton
		{
			return _rightMenu.cancel_menu;
		}

		public function set attackRange(value:XMLList):void
		{
			_attackRange = value;
		}

		public function get sMenu():LSouSouSMapMenu
		{
			return _sMenu;
		}

		public function get mapCoordinate():LCoordinate
		{
			return _mapCoordinate;
		}

		public function get roadList():Array
		{
			return _roadList;
		}

		public function set roadList(value:Array):void
		{
			_roadList = value;
		}

		public function get friendlist():Vector.<LSouSouCharacterS>
		{
			return _friendlist;
		}

		public function get enemylist():Vector.<LSouSouCharacterS>
		{
			return _enemylist;
		}

		public function get ourlist():Vector.<LSouSouCharacterS>
		{
			return _ourlist;
		}

		public function get funList():Array
		{
			return _funList;
		}

		public function set funList(value:Array):void
		{
			_funList = value;
		}

		public function get menu():LSprite{
			return _menu;
		}
		public function set menu(value:LSprite):void{
			this._menu = value;
		}
		override public function die():void{
			LGlobal.script.scriptArray.funList = new Array();
			LSouSouObject.sMap = null;
			LSouSouObject.sStarQuery = null;
			LSouSouObject.perWarList = null;
			super.die();
		}
		public function setMenu():void{
			LSouSouObject.perWarList = null;
			this.addChild(text);
			_rightMenu.addMenu();
			_menuLayer.x = 6;

			this.addEventListener(Event.ENTER_FRAME,onFrame);
			this.addEventListener(MouseEvent.MOUSE_UP,onUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			
			//如果是存档文件，不进行S初始剧情
			if(LSouSouObject.sMapSaveXml != null){
				LSouSouObject.sMapSaveXml = null;
				
				this.belong_mode = LSouSouObject.BELONG_SELF;
				LGlobal.script.lineList.unshift("Exit.run();");
				LGlobal.script.lineList.unshift("SouSouRunMode.start(0);");
				LGlobal.script.lineList.unshift("SouSouRunMode.set(0);");
			}
			LGlobal.script.analysis();
		}

		public function addFriendCharacter(param:Array):void{
			var mbr:LSouSouMember;
			var memberxml:XMLList = LSouSouObject.chara["peo"+param[0]];
			memberxml.Index = param[0];
			memberxml.Lv = param[1];
			mbr = new LSouSouMember(new XML(memberxml.toString()));
			
			_characterS = new LSouSouCharacterS(mbr,-1,int(param[2]),int(param[6]));
			_characterS.xy = new LCoordinate(int(param[3])*_nodeLength,int(param[4])*_nodeLength);
			_characterS.tagerCoordinate = _characterS.xy;
			if(param[5] == "0")_characterS.visible = false;
			_characterS.member.troops = _characterS.member.maxTroops;
			_characterS.member.strategy = _characterS.member.maxStrategy;
			this._friendlist.push(_characterS);
			
			//this.initialization();
			this._sMapScript.initialization();
		}
		public function addEnemyCharacter(param:Array):void{
			var mbr:LSouSouMember;
			var memberxml:XMLList = LSouSouObject.chara["peo"+param[0]];
			memberxml.Index = param[0];
			memberxml.Lv = param[1];
			mbr = new LSouSouMember(new XML(memberxml.toString()));
			
			_characterS = new LSouSouCharacterS(mbr,1,int(param[2]),int(param[6]));
			_characterS.xy = new LCoordinate(int(param[3])*_nodeLength,int(param[4])*_nodeLength);
			
			_characterS.tagerCoordinate = _characterS.xy;
			if(param[5] == "0")_characterS.visible = false;
			_characterS.member.troops = _characterS.member.maxTroops;
			_characterS.member.strategy = _characterS.member.maxStrategy;
			this._enemylist.push(_characterS);
			
			//this.initialization();
			this._sMapScript.initialization();
		}
		public function addOurCharacter(param:Array):void{
			if(int(param[0]) >= LSouSouObject.perWarList.length){
				this._sMapScript.initialization();
				return;
			}
			var mbr:LSouSouMember;
			
			for each(mbr in LSouSouObject.memberList)if(mbr.index == LSouSouObject.perWarList[int(param[0])])break;
			
			_characterS = new LSouSouCharacterS(mbr,0,int(param[1]),0);
			_characterS.xy = new LCoordinate(int(param[2])*_nodeLength,int(param[3])*_nodeLength);
			_characterS.tagerCoordinate = _characterS.xy;
			if(param[4] == "0")_characterS.visible = false;
			_characterS.member.troops = _characterS.member.maxTroops;
			_characterS.member.strategy = _characterS.member.maxStrategy;
			this._ourlist.push(_characterS);
			//this.initialization();
			this._sMapScript.initialization();
		}
		public function setSaveCharas():void{
			//存档数据恢复
			var xmldata:XML,charas:LSouSouCharacterS;
			for each(xmldata in LSouSouObject.sMapSaveXml.charalist.elements()){
				trace("xmldata = " + xmldata);
				trace("xxx = " + xmldata["peo" + xmldata.index]);
				var mbr:LSouSouMember = new LSouSouMember(new XML(xmldata["peo" + xmldata.index].toXMLString()));
				
				charas = new LSouSouCharacterS(mbr,xmldata.belong,xmldata.direction,xmldata.command);
				charas.xy = new LCoordinate(xmldata.x,xmldata.y);
				trace("charas.xy = " + charas.xy);
				charas.tagerCoordinate = charas.xy;
				
				if(int(xmldata.belong) == LSouSouObject.BELONG_SELF){
					this._ourlist.push(charas);
				}else if(int(xmldata.belong) == LSouSouObject.BELONG_FRIEND){
					this._friendlist.push(charas);
				}else{
					this._enemylist.push(charas);
				}
				
				charas.belong = xmldata.belong;
				charas.visible = xmldata.visible == "true"?true:false;
				charas.mode = xmldata.mode;
				charas.direction = xmldata.direction;
				charas.action = xmldata.action;
				charas.action_mode = xmldata.action_mode;
				charas.statusArray[LSouSouCharacterS.STATUS_CHAOS] = (xmldata.status.chaos.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_FIXED] = (xmldata.status.fixed .toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_POISON] = (xmldata.status.poison.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_STATEGY] = (xmldata.status.stategy.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_ATTACK] = (xmldata.status.attack.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_SPIRIT] = (xmldata.status.spirit.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE] = (xmldata.status.defense.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_BREAKOUT] = (xmldata.status.breakout.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_MORALE] = (xmldata.status.morale .toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_MOVE] = (xmldata.status.move.toString()).split(",");
				charas.statusArray[LSouSouCharacterS.STATUS_NOATK] = (xmldata.status.noatk.toString()).split(",");
				//charas.member.data = xmldata["peo" + xmldata.index];
				
				//this._sMapScript.initialization();
			}
		}
		/**
		 * 读取地图
		 * 
		 * @param param [地图名，后缀名]
		 */
		public function addMap(param:Array):void{
			_loadBar = new LLoading(400);
			_loadBar.xy = new LCoordinate((LGlobal.stage.stageWidth - _loadBar.width)/2,(LGlobal.stage.stageHeight - _loadBar.height)/2);
			this.addChild(_loadBar);
			_urlloader = new LURLLoader();
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.addEventListener(Event.COMPLETE,loadMapOver);
			_urlloader.addEventListener(ProgressEvent.PROGRESS,progress);
			_urlloader.load(new URLRequest(param[0] + "/" + param[1]));
			
		}
		/**
		 * 读取地图过程事件
		 * 
		 * @param event 事件
		 */
		private function progress(event:ProgressEvent):void{
			_loadBar.per = Math.floor(event.bytesLoaded*100/event.bytesTotal);
			
		}
		/**
		 * 读取地图完成事件
		 * 
		 * @param event 事件
		 */
		private function loadMapOver(event:Event):void{
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			mapW = bytes.readUnsignedInt(); 
			mapH = bytes.readUnsignedInt();
			var mapdata:String = bytes.readUTF();
			var arr:Array = mapdata.split("\n");
			var i:int = 0;
			_mapData = [];
			while(i<arr.length){
				_mapData[i] = (arr[i] as String).split(",");
				i++;
			}
			LSouSouObject.sStarQuery = new LSouSouStarS(_mapData);
			this._mapBitmapData = new BitmapData(mapW, mapH, true, 0);
			_mapBitmapData.setPixels(_mapBitmapData.rect, bytes);
			_miniScale = 200/mapW;
			
			_minimapBitmapData = new BitmapData(mapW*_miniScale, mapH*_miniScale, true, 0);
			var rect:Rectangle=new Rectangle(0,0,mapW, mapH);
			_minimapBitmapData.draw(_mapBitmapData,new Matrix(_miniScale,0,0,_miniScale,0,0),null,null,rect,false);
			_miniSelf = new BitmapData(_miniScale*36,_miniScale*36,false,0xff0000);
			_miniFriend = new BitmapData(_miniScale*36,_miniScale*36,false,0xf59249);
			_miniEnemy = new BitmapData(_miniScale*36,_miniScale*36,false,0x0000ff);
			_miniCoordinate = 5 + _miniScale*12;
			
			this._map = new LBitmap(new BitmapData(SCREEN_WIDTH,SCREEN_HEIGHT,false));
			//添加战场地图
			_mapLayer.addChild(_map);

			_miniMap = new LBitmap(new BitmapData(_minimapBitmapData.width + 10,_minimapBitmapData.height + 10,false));
			_miniMap.bitmapData.copyPixels(_minimapBitmapData,_minimapBitmapData.rect,new Point(5,5));
			LSouSouObject.addBoxBitmapdata(_miniMap.bitmapData);
			
			var lblBitmapdata:BitmapData = new BitmapData(210,110,true,0xff0000);
			lblBitmapdata.draw(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"transparent.png"),
				new Matrix(210,0,0,110,0,0),null,null,new Rectangle(0,0,210,110),false);
			LSouSouObject.addBoxBitmapdata(lblBitmapdata);
			var m:LBitmap = new LBitmap(lblBitmapdata);
			m.y = _miniMap.height;
			_labelDetails = new LTextField();
			_labelDetailsList = [];
			_labelDetails.width = 200;
			_labelDetails.height = 100;
			_labelDetails.wordWrap = true;
			_labelDetails.x = 5;
			_labelDetails.y = _miniMap.height + 5;
			//添加战场小地图
			_miniWindow = new LSprite();
			LDisplay.drawRect(_miniWindow.graphics,[0,_miniMap.height,210,110],true,0x000000,0.7,0);
			_miniWindow.addChild(_miniMap);
			_miniWindow.addChild(_labelDetails);
			_miniWindow.addChild(m);
			_mapLayer.addChild(_miniWindow);
			_loadBar.removeFromParent();
			
			//this.drawGrid();
			//this.initialization();
			this._sMapScript.initialization();
			
			drawMap();
		}
		public function setDetails(value:String):void{
			_labelDetailsList.push(value);
			if(_labelDetailsList.length > 6)_labelDetailsList.shift();
			_labelDetails.htmlText = "<font color='#ffffff'>"+_labelDetailsList.join("\n")+"</font>";
			_labelDetails.scrollV = _labelDetails.bottomScrollV;
		}
		private function drawMiniMap(charas:LSouSouCharacterS):void{
			if(charas.belong == LSouSouObject.BELONG_SELF){
				_miniMap.bitmapData.copyPixels(_miniSelf,_miniSelf.rect,new Point(_miniCoordinate + charas.x*_miniScale,_miniCoordinate + charas.y*_miniScale));
			}else if(charas.belong == LSouSouObject.BELONG_FRIEND){
				_miniMap.bitmapData.copyPixels(_miniFriend,_miniFriend.rect,new Point(_miniCoordinate + charas.x*_miniScale,_miniCoordinate + charas.y*_miniScale));
			}else {
				_miniMap.bitmapData.copyPixels(_miniEnemy,_miniEnemy.rect,new Point(_miniCoordinate + charas.x*_miniScale,_miniCoordinate + charas.y*_miniScale));
			}
		}
		private function drawNum():void{
			var i:int,j:int;
			var child:Array;
			var numStr:String;
			var numBitmap:BitmapData;
			for(i=0;i<_numList.length;i++){
				child = _numList[i];
				numStr = child[0];
				for(j=0;j<numStr.length;j++){
					numBitmap = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],numStr.charAt(j) + ".png");
					this._map.bitmapData.copyPixels(numBitmap,numBitmap.rect,new Point(child[1] + j*20,child[2]));
				}
				child[2] = int(child[2]) - 2;
				child[3] = int(child[3]) + 1;
				if(int(child[3]) > 10){
					_numList.splice(i,1);
					i--;
				}
			}
		}
		/**
		 * 回合显示_roundCtrl
		 * */
		private function roundShow():void{
			LSouSouObject.storyCtrl = true;
			
			if(_roundCtrl.scaleY >= 1){
				_roundCtrl.removeFromParent();
				_roundCtrl = null;
			/**
			if(_round_bitmap.height >= 150){
				_roundText.removeFromParent();
				_round_bitmap.removeFromParent();
				_round_bitmap = null;*/
				
				LSouSouSMapScript.loopListCheck();
				if(LSouSouObject.sMap.loopIsRun){
					return;
				}
				
				if(belong_mode == LSouSouObject.BELONG_FRIEND){
					//我军动作变更
					for each(_characterS in _ourlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						_characterS.action_mode = "";
						if(_characterS.member.troops < _characterS.member.maxTroops*0.25){
							_characterS.action = LSouSouCharacterS.PANT;
						}else{
							_characterS.action = LSouSouCharacterS.MOVE_DOWN + _characterS.direction;
						}
						_characterS.mode = LAnimation.POSITIVE;
					}
					//友军状态恢复
					for each(_characterS in _friendlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						_characterS.resume();
					}
					//友军AI
					for each(_characterS in _friendlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						this._characterS.ai();
						break;
					}
				}else if(belong_mode == LSouSouObject.BELONG_ENEMY){
					if(this._friendIsNull){
						//我军动作变更
						for each(_characterS in _ourlist){
							if(!_characterS.visible || _characterS.member.troops == 0)continue;
							_characterS.action_mode = "";
							//if(_characterS.action<4)_characterS.action += 4;
							if(_characterS.member.troops < _characterS.member.maxTroops*0.25){
								_characterS.action = LSouSouCharacterS.PANT;
							}else{
								_characterS.action = LSouSouCharacterS.MOVE_DOWN + _characterS.direction;
							}
							_characterS.mode = LAnimation.POSITIVE;
						}
						//友军动作变更
					}else{
						for each(_characterS in _friendlist){
							if(!_characterS.visible || _characterS.member.troops == 0)continue;
							_characterS.action_mode = "";
							//if(_characterS.action<4)_characterS.action += 4;
							if(_characterS.member.troops < _characterS.member.maxTroops*0.25){
								_characterS.action = LSouSouCharacterS.PANT;
							}else{
								_characterS.action = LSouSouCharacterS.MOVE_DOWN + _characterS.direction;
							}
							_characterS.mode = LAnimation.POSITIVE;
						}
					}
					//敌军状态恢复
					for each(_characterS in _enemylist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						_characterS.resume();
					}
					//敌军AI
					for each(_characterS in _enemylist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						this._characterS.ai();
						break;
					}
				}else{
					for each(_characterS in _enemylist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						_characterS.action_mode = "";
						//if(_characterS.action<4)_characterS.action += 4;
						if(_characterS.member.troops < _characterS.member.maxTroops*0.25){
							_characterS.action = LSouSouCharacterS.PANT;
						}else{
							_characterS.action = LSouSouCharacterS.MOVE_DOWN + _characterS.direction;
						}
						_characterS.mode = LAnimation.POSITIVE;
					}
					//我军状态恢复
					for each(_characterS in _ourlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						_characterS.resume();
					}
				}
				LSouSouObject.storyCtrl = false;
				return;
			}
			_roundCtrl.scaleY += 0.05;
			/**
			_roundText.height += 8;
			_roundText.y -= 4;
			_round_bitmap.height += 8;
			_round_bitmap.y -= 4;*/
		}
		private function findRoad(mx:int,my:int):void{
			var intX:int = int((mx - _mapCoordinate.x)/_nodeLength);
			var intY:int = int((my - _mapCoordinate.y)/_nodeLength);
			var isRoad:Boolean;
			var node:Node;
			for each(node in this._roadList){
				for each(_characterS in LSouSouObject.sMap.ourlist){
					if(_characterS.visible && _characterS.index != LSouSouObject.charaSNow.index && _characterS.locationX == intX && _characterS.locationY == intY){
						return;
					}
				}
				for each(_characterS in LSouSouObject.sMap.friendlist){
					if(_characterS.visible && _characterS.locationX == intX && _characterS.locationY == intY){
						return;
					}
				}
				if(mx >= node.x*_nodeLength + _mapCoordinate.x && mx < node.x*_nodeLength + _mapCoordinate.x + _nodeLength && 
					my >= node.y*_nodeLength + _mapCoordinate.y && my < node.y*_nodeLength + _mapCoordinate.y + _nodeLength){
					isRoad = true;
					break;
				}
			}

			if(!isRoad)return;
			//LSouSouObject.charaSNow.tagerCoordinate = new LCoordinate(LSouSouObject.charaSNow.locationX,LSouSouObject.charaSNow.locationY);
			moveToCoordinate(mx,my);
		}
		public function moveToCoordinate(mx:int,my:int,toCoordinate:LCoordinate = null):void{
			if(toCoordinate == null)toCoordinate = new LCoordinate(int((mx - this._mapCoordinate.x)/_nodeLength),int((my - this._mapCoordinate.y)/_nodeLength));
			LSouSouObject.charaSNow.path = LSouSouObject.sStarQuery.path(
				new LCoordinate(LSouSouObject.charaSNow.locationX,
					LSouSouObject.charaSNow.locationY),toCoordinate
				);
			
			if(LSouSouObject.charaSNow.path){
				this._roadList = null;
				LSouSouObject.charaSNow.addEventListener(LEvent.CHARACTER_MOVE_COMPLETE,onMoveComplete);
			}
		}
		private function onMoveComplete(event:LEvent):void{
			LSouSouObject.charaSNow.removeEventListener(LEvent.CHARACTER_MOVE_COMPLETE,onMoveComplete);
			if(LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF){
				showCtrlMenu();
			}else{
				if(LSouSouObject.charaSNow.targetCharacter){
					if(LSouSouObject.charaSNow.aiForStrategy){
						trace("法术攻击目标确定，进行攻击",LSouSouObject.charaSNow.index);
						LSouSouObject.charaSNow.strategyAttackCalculate();
					}else{
						trace("攻击目标确定，进行攻击");
						//攻击目标确定，进行攻击
						LSouSouObject.charaSNow.attackCalculate();
					}
				}else{
					trace("没有攻击目标，进行下一个行动");
					if(LSouSouObject.charaSNow.member.troops < LSouSouObject.charaSNow.member.maxTroops*0.25){
						LSouSouObject.charaSNow.action = LSouSouCharacterS.PANT;
					} else {
						LSouSouObject.charaSNow.action = LSouSouCharacterS.DOWN + LSouSouObject.charaSNow.direction;
					}
					LSouSouObject.charaSNow.action_mode = LSouSouCharacterS.MODE_STOP;
					LSouSouSMapMethod.checkCharacterSOver(LSouSouObject.charaSNow.belong);
				}
			}
		}
		public function showCtrlMenu(menuname:String="ctrl"):void{
			_menu = _sMenu.addSMenu(LSouSouObject.charaSNow.xy,menuname);
			this._menuLayer.addChild(_menu);
		}
		/**
		 * 贞事件
		 * 
		 * @param event 贞事件
		 */
		private function onFrame(event:Event):void{
			frames++;
			var g:int = getTimer();
			if(g - _timeCount >= 1000){
				_timeCount = g;
				text.htmlText = "<font color='#ffffff'><b>" + frames + "</b></font>";
				frames = 0;
			}
			
			if(!(++_speed % SPEED == 0))return;
			_speed = 0;
			if(this._mouseIsDown){
				mapMoveCheck();
			}
			if(++_speed2 % SPEED2 == 0)_speed2 = 0;
			
			//loopListCheck();
			
			mapMove();
			drawMap();
			//trace("onFrame");
		}
		private function mapMoveCheck():void{
			if(mouseX < this._nodeLength && this._mapCoordinate.x < 0 && !_mapMove["left"]){
				_mapMove["left"] = true;
			}
			if(mouseY < this._nodeLength && this._mapCoordinate.y < 0 && !_mapMove["up"]){
				_mapMove["up"] = true;
			}
			if(mouseX > this.SCREEN_WIDTH - this._nodeLength && mouseX < this.SCREEN_WIDTH 
				&& this._mapCoordinate.x > this.SCREEN_WIDTH - this.mapW && !_mapMove["right"]){
				_mapMove["right"] = true;
			}
			if(mouseY > this.SCREEN_HEIGHT - this._nodeLength && mouseY < this.SCREEN_HEIGHT 
				&& this._mapCoordinate.y > this.SCREEN_HEIGHT - this.mapH && !_mapMove["down"]){
				_mapMove["down"] = true;
			}
		}
		private function mapMove():void{
			if(_mapMove["left"]){
				_mapCoordinate.x += this._nodeLength/4;
				_mapToCoordinate.x = _mapCoordinate.x;
				if(_mapCoordinate.x % this._nodeLength == 0){
					_mapMove["left"] = false;
				}
			}else if(_mapMove["right"]){
				_mapCoordinate.x -= this._nodeLength/4;
				_mapToCoordinate.x = _mapCoordinate.x;
				if(_mapCoordinate.x % this._nodeLength == 0){
					_mapMove["right"] = false;
				}
			}
			if(_mapMove["up"]){
				_mapCoordinate.y += this._nodeLength/4;
				_mapToCoordinate.y = _mapCoordinate.y;
				if(_mapCoordinate.y % this._nodeLength == 0){
					_mapMove["up"] = false;
				}
			}else if(_mapMove["down"]){
				_mapCoordinate.y -= this._nodeLength/4;
				_mapToCoordinate.y = _mapCoordinate.y;
				if(_mapCoordinate.y % this._nodeLength == 0){
					_mapMove["down"] = false;
				}
			}
			if(this._mapCoordinate.x > this._mapToCoordinate.x){
				this._mapCoordinate.x -= this._nodeLength;
				if(this._menu)this._menu.x -= this._nodeLength;
			}else if(this._mapCoordinate.x < this._mapToCoordinate.x){
				this._mapCoordinate.x += this._nodeLength;
				if(this._menu)this._menu.x += this._nodeLength;
			}
			if(this._mapCoordinate.y > this._mapToCoordinate.y){
				this._mapCoordinate.y -= this._nodeLength;
				if(this._menu)this._menu.y -= this._nodeLength;
			}else if(this._mapCoordinate.y < this._mapToCoordinate.y){
				this._mapCoordinate.y += this._nodeLength;
				if(this._menu)this._menu.y += this._nodeLength;
			}
		}
		private function onDown(event:MouseEvent):void{
			if(_menu == null)this._mouseIsDown = true;
		}
		private function findAttackTarget(mx:int,my:int):void{
			var nodeStr:String;
			var nodeArr:Array;
			var intX:int = int((mx - this._mapCoordinate.x)/_nodeLength);
			var intY:int = int((my - this._mapCoordinate.y)/_nodeLength);
			for each(nodeStr in _attackRange){
				nodeArr = nodeStr.split(",");
				if(mx >= LSouSouObject.charaSNow.x + nodeArr[0]*_nodeLength + _mapCoordinate.x && 
					mx < LSouSouObject.charaSNow.x + nodeArr[0]*_nodeLength + _mapCoordinate.x + _nodeLength &&
					my >= LSouSouObject.charaSNow.y + nodeArr[1]*_nodeLength + _mapCoordinate.y && 
					my < LSouSouObject.charaSNow.y + nodeArr[1]*_nodeLength + _mapCoordinate.y + _nodeLength){
					if(LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF){
						
						for each(_characterS in this._enemylist){
							if(_characterS.visible && _characterS.locationX == intX && _characterS.locationY == intY){
								_attackRange = null;
								cancel_menu.removeAllEventListener();
								cancel_menu.visible = false;
								LSouSouObject.charaSNow.targetCharacter = _characterS;
								LSouSouObject.charaSNow.setAttackNumber();
								LSouSouObject.charaSNow.attackCalculate();
								return;
							}
						}
					}
				}
			}

		}
		/**
		 * 鼠标弹起事件
		 * 
		 * @param event 鼠标事件
		 */
		private function onUp(event:MouseEvent):void{
			if(LSouSouObject.storyCtrl)return;
			if(_roundCtrl)return;
			if(this.belong_mode != LSouSouObject.BELONG_SELF)return;
			var charaList:Vector.<LSouSouCharacterS>;
			var getcharacter:Boolean;
			var nodeStr:String;
			var nodeArr:Array;
			
			this._mouseIsDown = false;
			if(this._roadList != null){
				findRoad(mouseX,mouseY);
			}else if(this._attackRange != null){
				findAttackTarget(mouseX,mouseY);
			}else if(_props != null){
				charaList = new Vector.<LSouSouCharacterS>();
				
				for each(_characterS in this._ourlist){
					if(!_characterS.visible || _characterS.member.troops == 0)continue;
					charaList.push(_characterS);
				}
				for each(_characterS in this._friendlist){
					if(!_characterS.visible || _characterS.member.troops == 0)continue;
					charaList.push(_characterS);
				}
				
				for each(_characterS in charaList){
					if(!_characterS.visible)continue;
					if(mouseX > _characterS.x + this._mapCoordinate.x && mouseX < _characterS.x + this._mapCoordinate.x + this._nodeLength && 
						mouseY > _characterS.y + this._mapCoordinate.y && mouseY < _characterS.y + this._mapCoordinate.y + this._nodeLength){
						getcharacter = true;
						if(mouseX > LSouSouObject.charaSNow.x + this._mapCoordinate.x - this._nodeLength && mouseX < LSouSouObject.charaSNow.x + this._mapCoordinate.x + 2*this._nodeLength
							&& mouseY > LSouSouObject.charaSNow.y + this._mapCoordinate.y - this._nodeLength && mouseY < LSouSouObject.charaSNow.y + this._mapCoordinate.y + 2*this._nodeLength){
								LSouSouObject.charaSNow.targetCharacter = _characterS;
								
								var xmllist:XML;
								var ishava:Boolean;
								for each(xmllist in LSouSouObject.propsList.elements()){
									if(int(xmllist.@index) == int(_props.index.toString())){
										xmllist.@num = int(xmllist.@num) - 1;
										ishava = true;
										break;
									}
								}
								cancel_menu.removeAllEventListener();
								cancel_menu.visible = false;
								LSouSouObject.charaSNow.propsCalculate();
								break;
						}
						if(getcharacter)break;
					}
				}
				
			}else if(_strategy != null){
				var intX:int = int((mouseX - _mapCoordinate.x)/_nodeLength);
				var intY:int = int((mouseY - _mapCoordinate.y)/_nodeLength);
				if(!LSouSouCalculate.canUseMeff(intX,intY,_strategy)){
					var window:LSouSouWindow = new LSouSouWindow();
					window.setMsg(["此地形无法使用",1,30]);
					LGlobal.script.scriptLayer.addChild(window);
					return;
				}
				
				if(_strategy.Belong == 1){
					charaList = _enemylist;
				}else if(_strategy.Belong == 0){
					
					charaList = new Vector.<LSouSouCharacterS>();
					
					for each(_characterS in this._ourlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						charaList.push(_characterS);
					}
					for each(_characterS in this._friendlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						charaList.push(_characterS);
					}
				}
				/*
				for each(_characterS in this._ourlist){
				}
				for each(_characterS in this._friendlist){
				}
				*/
				for each(_characterS in charaList){
					if(!_characterS.visible)continue;
					if(mouseX > _characterS.x + this._mapCoordinate.x && mouseX < _characterS.x + this._mapCoordinate.x + this._nodeLength && 
						mouseY > _characterS.y + this._mapCoordinate.y && mouseY < _characterS.y + this._mapCoordinate.y + this._nodeLength){
						getcharacter = true;
						
						for each(nodeStr in _strategy.Range.elements()){
							nodeArr = nodeStr.split(",");
							if(LSouSouObject.charaSNow.locationX  + int(nodeArr[0]) == _characterS.locationX && 
								LSouSouObject.charaSNow.locationY + int( nodeArr[1]) == _characterS.locationY){
								if(!LSouSouCalculate.belongMeff(_characterS)){
									return;
								}else{
									LSouSouObject.sMap.cancel_menu.removeAllEventListener();
									LSouSouObject.sMap.cancel_menu.visible = false;
									LSouSouObject.charaSNow.targetCharacter = _characterS;
									LSouSouObject.charaSNow.strategyAttackCalculate();
								}
								break;
							}
						}
						if(getcharacter)break;
					}
				}
			}else{
				var isChara:Boolean;
				if(_menu != null){
					_sMenu.onClick(_menu,mouseX,mouseY);
				}else{
					var sx:int;
					var sy:int;
					var act:int;
					for each(_characterS in this._ourlist){
						if(!_characterS.visible)continue;
						if(mouseX > _characterS.x + this._mapCoordinate.x && mouseX < _characterS.x + this._mapCoordinate.x + this._nodeLength && 
							mouseY > _characterS.y + this._mapCoordinate.y && mouseY < _characterS.y + this._mapCoordinate.y + this._nodeLength){
							LSouSouObject.charaSNow = _characterS;
							
							sx = LSouSouObject.charaSNow.x;
							sy = LSouSouObject.charaSNow.y;
							act = LSouSouObject.charaSNow.action;
							LSouSouObject.returnFunction = function ():void{
								LSouSouObject.charaSNow.x = sx;
								LSouSouObject.charaSNow.y = sy;
								LSouSouObject.charaSNow.action = act;
								LSouSouObject.charaSNow.tagerCoordinate=LSouSouObject.charaSNow.xy; 
								
								_menu = _sMenu.addSMenu(LSouSouObject.charaSNow.xy,"select");
								_menuLayer.addChild(_menu);
							}
							LSouSouObject.returnFunction();
							return;
						}
					}
					for each(_characterS in this._friendlist){
						if(!_characterS.visible)continue;
						if(mouseX > _characterS.x + this._mapCoordinate.x && mouseX < _characterS.x + this._mapCoordinate.x + this._nodeLength && 
							mouseY > _characterS.y + this._mapCoordinate.y && mouseY < _characterS.y + this._mapCoordinate.y + this._nodeLength){
							LSouSouObject.charaSNow = _characterS;
							
							sx = LSouSouObject.charaSNow.x;
							sy = LSouSouObject.charaSNow.y;
							act = LSouSouObject.charaSNow.action;
							LSouSouObject.returnFunction = function ():void{
								LSouSouObject.charaSNow.x = sx;
								LSouSouObject.charaSNow.y = sy;
								LSouSouObject.charaSNow.action = act;
								LSouSouObject.charaSNow.tagerCoordinate=LSouSouObject.charaSNow.xy; 
								
								_menu = _sMenu.addSMenu(LSouSouObject.charaSNow.xy,"select");
								_menuLayer.addChild(_menu);
							}
							LSouSouObject.returnFunction();
							return;
						}
					}
					for each(_characterS in this._enemylist){
						if(!_characterS.visible)continue;
						if(mouseX > _characterS.x + this._mapCoordinate.x && mouseX < _characterS.x + this._mapCoordinate.x + this._nodeLength && 
							mouseY > _characterS.y + this._mapCoordinate.y && mouseY < _characterS.y + this._mapCoordinate.y + this._nodeLength){
							LSouSouObject.charaSNow = _characterS;
							
							sx = LSouSouObject.charaSNow.x;
							sy = LSouSouObject.charaSNow.y;
							act = LSouSouObject.charaSNow.action;
							LSouSouObject.returnFunction = function ():void{
								LSouSouObject.charaSNow.x = sx;
								LSouSouObject.charaSNow.y = sy;
								LSouSouObject.charaSNow.action = act;
								LSouSouObject.charaSNow.tagerCoordinate=LSouSouObject.charaSNow.xy; 
								
								_menu = _sMenu.addSMenu(LSouSouObject.charaSNow.xy,"select");
								_menuLayer.addChild(_menu);
							}
							LSouSouObject.returnFunction();
							return;
						}
					}
				}
			}
		}
		
		private function drawMap():void{
			var node:Node;
			var nodeStr:String;
			var nodeArr:Array;
			var statusBit:BitmapData;
			var meffShow:LSouSouMeffShow,i:int;
			_drawLayer.graphics.clear();
			
			/**画地图*/
			this._map.bitmapData.copyPixels(_mapBitmapData,new Rectangle(-_mapCoordinate.x,-_mapCoordinate.y,SCREEN_WIDTH,SCREEN_HEIGHT),new Point(0,0));
			/**画小地图*/
			_miniMap.bitmapData.copyPixels(_minimapBitmapData,_minimapBitmapData.rect,new Point(5,5));
			if(mouseX < 300){
				_miniWindow.x = SCREEN_WIDTH - _miniMap.width;
			}else if(mouseX > 500){
				_miniWindow.x = 0;
			}
			/**画人物*/
			for each(_characterS in _ourlist){
				if(!_characterS.visible)continue;
				_characterS.onFrame();
				drawMiniMap(_characterS);
				/**判断是否需要绘制人物*/
				if(_characterS.x + _mapCoordinate.x >= 0 && _characterS.x + _mapCoordinate.x < SCREEN_WIDTH &&
					_characterS.y + _mapCoordinate.y >= 0 && _characterS.y + _mapCoordinate.y < SCREEN_HEIGHT){
					
					if(_characterS.action_mode == LSouSouCharacterS.MODE_STOP)_characterS.colorTrans(-70);
					if(_characterS.action_mode == LSouSouCharacterS.MODE_BREAKOUT)_characterS.colorTrans(100);
					this._map.bitmapData.copyPixels(_characterS.bitmapData,
						new Rectangle(0,0,_characterS.width,_characterS.height),
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
							_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
					statusBit = _characterS.drawStatus();
					if(statusBit)_map.bitmapData.copyPixels(statusBit,statusBit.rect,
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x + _characterS.statusX,
							_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
					//船
					if(LSouSouObject.sMap.mapData[_characterS.locationY][_characterS.locationX] == 13)
						this._map.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"boatmask"+(_characterS.animation.currentframe + 2) % 2),
							new Rectangle(0,0,_characterS.width,_characterS.height),
							new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
								_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
				}
			}
			
			for each(_characterS in _enemylist){
				if(!_characterS.visible)continue;
				_characterS.onFrame();
				drawMiniMap(_characterS);
				/**判断是否需要绘制人物*/
				if(_characterS.x + _mapCoordinate.x >= 0 && _characterS.x + _mapCoordinate.x < SCREEN_WIDTH &&
					_characterS.y + _mapCoordinate.y >= 0 && _characterS.y + _mapCoordinate.y < SCREEN_HEIGHT){
					
					if(_characterS.action_mode == LSouSouCharacterS.MODE_STOP)_characterS.colorTrans(-70);
					if(_characterS.action_mode == LSouSouCharacterS.MODE_BREAKOUT)_characterS.colorTrans(100);
					this._map.bitmapData.copyPixels(_characterS.bitmapData,
						new Rectangle(0,0,_characterS.width,_characterS.height),
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
							_characterS.y + _mapCoordinate.y + _characterS.point.y));
					statusBit = _characterS.drawStatus();
					if(statusBit)_map.bitmapData.copyPixels(statusBit,statusBit.rect,
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x + _characterS.statusX,
							_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
					//船
					if(LSouSouObject.sMap.mapData[_characterS.locationY][_characterS.locationX] == 13)
						this._map.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"boatmask" + (_characterS.animation.currentframe + 2) % 2),
							new Rectangle(0,0,_characterS.width,_characterS.height),
							new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
								_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
				}
			}
			for each(_characterS in _friendlist){
				if(!_characterS.visible)continue;
				_characterS.onFrame();
				drawMiniMap(_characterS);
				/**判断是否需要绘制人物*/
				if(_characterS.x + _mapCoordinate.x >= 0 && _characterS.x + _mapCoordinate.x < SCREEN_WIDTH &&
					_characterS.y + _mapCoordinate.y >= 0 && _characterS.y + _mapCoordinate.y < SCREEN_HEIGHT){
					
					if(_characterS.action_mode == LSouSouCharacterS.MODE_STOP)_characterS.colorTrans(-70);
					if(_characterS.action_mode == LSouSouCharacterS.MODE_BREAKOUT)_characterS.colorTrans(100);
					this._map.bitmapData.copyPixels(_characterS.bitmapData,
						new Rectangle(0,0,_characterS.width,_characterS.height),
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
							_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
					statusBit = _characterS.drawStatus();
					if(statusBit)_map.bitmapData.copyPixels(statusBit,statusBit.rect,
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x + _characterS.statusX,
							_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
					//船
					if(LSouSouObject.sMap.mapData[_characterS.locationY][_characterS.locationX] == 13)
						this._map.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"boatmask" + (_characterS.animation.currentframe + 2) % 2),
							new Rectangle(0,0,_characterS.width,_characterS.height),
							new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
								_characterS.y + _mapCoordinate.y + (_nodeLength - _characterS.height)/2));
				}
			}
			//小地图框架
			LSouSouObject.addBoxBitmapdata(_miniMap.bitmapData);
			
			/**画法术*/
			if(_meff != null){
				_meff.onFrame();
				var meffarr:Array;
				for each(meffarr in _meff.animationList){
					this._map.bitmapData.copyPixels(meffarr[0].dataBMP,meffarr[0].dataBMP.rect,
						new Point(_meff.x + meffarr[2] + _mapCoordinate.x,_meff.y + meffarr[3] + _mapCoordinate.y));
				}
				
				_meff.checkOver();
			}
			/**画绝招*/
			if(_skill != null){
				this._map.bitmapData.copyPixels(_skill.bitmapData,_skill.bitmapData.rect,
					new Point(_skill.x,_skill.y));
				_skill.onFrame();
			}
			/**画法术演示*/
			i=0;
			for each(meffShow in _meffShowList){
				this._map.bitmapData.copyPixels(meffShow.bitmapData,meffShow.bitmapData.rect,
					new Point(meffShow.x + _mapCoordinate.x,meffShow.y + _mapCoordinate.y));
				meffShow.onFrame(i);
				i++;
			}
			/**画路径*/
			if(this._roadList != null){
				for each(node in this._roadList){
					LDisplay.drawRect(_drawLayer.graphics,
						[node.x*_nodeLength + _mapCoordinate.x,node.y*_nodeLength + _mapCoordinate.y,
							_nodeLength-1,_nodeLength-1],
						true,0x0000FF,0.5,3);
				}
				for each(nodeStr in LSouSouObject.charaSNow.rangeAttack){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[LSouSouObject.charaSNow.x + nodeArr[0]*_nodeLength + _mapCoordinate.x,
							LSouSouObject.charaSNow.y + nodeArr[1]*_nodeLength + _mapCoordinate.y,
							_nodeLength,_nodeLength],
						false,0xFF0000,0.5,5);
				}
			}else if(_attackRange != null){
				for each(nodeStr in _attackRange){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[LSouSouObject.charaSNow.x + nodeArr[0]*_nodeLength + _mapCoordinate.x,
							LSouSouObject.charaSNow.y + nodeArr[1]*_nodeLength + _mapCoordinate.y,
							_nodeLength-1,_nodeLength-1],
						true,0xFF0000,0.5,1);
				}
				for each(nodeStr in this._attackTargetRange){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[int(mouseX/this._nodeLength)*_nodeLength + nodeArr[0]*_nodeLength,
							int(mouseY/this._nodeLength)*_nodeLength + nodeArr[1]*_nodeLength,
							_nodeLength,_nodeLength],
						false,0xFF0000,1,2);
				}
			}else if(_strategy != null && _meff == null && LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF){
				for each(nodeStr in _strategy.Range.elements()){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[LSouSouObject.charaSNow.x + nodeArr[0]*_nodeLength + _mapCoordinate.x,
							LSouSouObject.charaSNow.y + nodeArr[1]*_nodeLength + _mapCoordinate.y,
							_nodeLength-1,_nodeLength-1],
						true,0xFF0000,0.5,1);
				}
				for each(nodeStr in _strategy.Att.elements()){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[int(mouseX/this._nodeLength)*_nodeLength + nodeArr[0]*_nodeLength,
							int(mouseY/this._nodeLength)*_nodeLength + nodeArr[1]*_nodeLength,
							_nodeLength,_nodeLength],
						false,0xFF0000,1,2);
				}
			}
			/**画方框*/
			if(mouseX<SCREEN_WIDTH)LDisplay.drawRect(_drawLayer.graphics,[int(mouseX/_nodeLength)*_nodeLength,int(mouseY/_nodeLength)*_nodeLength,_nodeLength,_nodeLength],false,0xffffff,0.8,3);
			/**画战场物件*/
			if(_stageList.length > 0){
				////战场物件，火，船等[icon,index,maxindex,x，y，fun,stageindex]
				for each(nodeArr in _stageList){
					var stageImg:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],nodeArr[0] + nodeArr[1]);
					var upX:int = int((stageImg.width/2)/this._nodeLength)*this._nodeLength;
					var upY:int = int((stageImg.height/2)/this._nodeLength)*this._nodeLength;
					this._map.bitmapData.copyPixels(stageImg,stageImg.rect,	
						new Point(nodeArr[3] + _mapCoordinate.x - upX,nodeArr[4] + _mapCoordinate.y - upY));
					nodeArr[1] = int(nodeArr[1]) + 1;
					if(int(nodeArr[1]) > nodeArr[2])(nodeArr[5] as Function)(nodeArr);
				}
			}
			/**画伤害值等*/
			if(_numList.length > 0)drawNum();
			
			/**画回合*/
			if(_roundCtrl)roundShow();
			
			/**画menu*/
			if(_menu != null){
				_sMenu.onMove(_menu,mouseX,mouseY);
			}
			/**画单条*/
			if(LSouSouObject.window != null && LSouSouObject.window.name == "singled"){
				LSouSouObject.window.windowSingled.draw();
			}
		}
	}
}