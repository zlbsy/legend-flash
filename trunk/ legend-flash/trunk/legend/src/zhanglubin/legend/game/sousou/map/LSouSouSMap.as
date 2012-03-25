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
	import zhanglubin.legend.game.sousou.map.smap.LSouSouSMapClick;
	import zhanglubin.legend.game.sousou.map.smap.LSouSouSMapDraw;
	import zhanglubin.legend.game.sousou.map.window.LSouSouWindwoTerrain;
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
		private var _roundCtrl:LSouSouRound;
		private var _round_show:int = 0;
		private var _roundCount:int = 1;
		/**
		 * 最大回合数
		 * */
		private var _roundMax:int = 100;
		/**
		 * 天气
		 * */
		private var _weatherIndex:int = 0;
		/**
		 * 天气数组
		 * */
		private var _weather:Array = [
		["晴",60],
		["阴",30],
		["雨",10],
		["豪雨",0],
		["雪",0]
		];
		private var _mouseIsDown:Boolean;
		private var _mapIsMove:Boolean;
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
		
		private var _draw:LSouSouSMapDraw;
		private var _smapClick:LSouSouSMapClick;
		private var _smapName:String;
		
		public function LSouSouSMap()
		{
			LSouSouObject.sMap = this;
			_draw = new LSouSouSMapDraw();
			_smapClick = new LSouSouSMapClick();
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
				trace(LSouSouObject.sMapSaveXml.toXMLString());
				this._condition = LSouSouObject.sMapSaveXml.condition.toString().split(",");
				this._weatherIndex = LSouSouObject.sMapSaveXml.weather.weatherIndex;
				var weatherArray:Array = LSouSouObject.sMapSaveXml.weather.weatherArray.toString().split(",");
				this._weather[0][1] = int(weatherArray[0]);
				this._weather[1][1] = int(weatherArray[1]);
				this._weather[2][1] = int(weatherArray[2]);
				this._weather[3][1] = int(weatherArray[3]);
				this._weather[4][1] = int(weatherArray[4]);
				this._roundCount = int(LSouSouObject.sMapSaveXml.roundCount);
				var saveCoordinate:Array = LSouSouObject.sMapSaveXml.mapCoordinate.toString().split(",");
				this._mapCoordinate.x = saveCoordinate[0];
				this._mapCoordinate.y = saveCoordinate[1];
				
			}
			this.addChild(_mapLayer);
			this.addChild(_characterLayer);
			this.addChild(_drawLayer);
			this.addChild(_menuLayer);
			
		}

		public function set mouseIsDown(value:Boolean):void
		{
			_mouseIsDown = value;
		}

		public function get mouseIsDown():Boolean
		{
			return _mouseIsDown;
		}

		public function get mapIsMove():Boolean
		{
			return _mapIsMove;
		}

		public function get miniScale():Number
		{
			return _miniScale;
		}

		public function get miniCoordinate():int
		{
			return _miniCoordinate;
		}

		public function get miniEnemy():BitmapData
		{
			return _miniEnemy;
		}

		public function get miniFriend():BitmapData
		{
			return _miniFriend;
		}

		public function get miniSelf():BitmapData
		{
			return _miniSelf;
		}

		/**
		 *回合显示，设定等相关 
		 */
		public function get roundCtrl():LSouSouRound
		{
			return _roundCtrl;
		}

		public function get attackTargetRange():XMLList
		{
			return _attackTargetRange;
		}

		public function get attackRange():XMLList
		{
			return _attackRange;
		}

		public function get meff():LSouSouMeff
		{
			return _meff;
		}

		public function get miniWindow():LSprite
		{
			return _miniWindow;
		}

		public function get miniMap():LBitmap
		{
			return _miniMap;
		}

		public function get minimapBitmapData():BitmapData
		{
			return _minimapBitmapData;
		}

		public function get mapBitmapData():BitmapData
		{
			return _mapBitmapData;
		}

		public function get map():LBitmap
		{
			return _map;
		}

		public function get weather():Array
		{
			return _weather;
		}

		public function get weatherIndex():int
		{
			return _weatherIndex;
		}

		public function set weatherIndex(value:int):void
		{
			_weatherIndex = value;
		}

		public function get roundMax():int
		{
			return _roundMax;
		}

		public function set roundMax(value:int):void
		{
			_roundMax = value;
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
			
			
			trace("******* round_show _round_show = " + _round_show);
			_roundCtrl = new LSouSouRound(_round_show == 1?0:(_round_show == 2?1:-1),_roundCount);
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
			this._mapBitmapData.dispose();
			this.minimapBitmapData.dispose();
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

		public function setSaveCharas():void{
			//存档数据恢复
			var xmldata:XML,charas:LSouSouCharacterS;
			for each(xmldata in LSouSouObject.sMapSaveXml.charalist.elements()){
				trace("LSouSouSMap setSaveCharas xmldata = " + xmldata.toXMLString());
				var mbr:LSouSouMember = new LSouSouMember(new XML(xmldata["peo" + xmldata.index].toXMLString()));
				
				charas = new LSouSouCharacterS(mbr,xmldata.belong,xmldata.direction,xmldata.command);
				charas.xy = new LCoordinate(xmldata.x,xmldata.y);

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
				
			}
		}
		/**
		 * 读取地图
		 * 
		 * @param param [地图名，后缀名]
		 */
		public function addMap(param:Array):void{
			_smapName = param[0] + "/" + param[1];
			_loadBar = new LLoading(400);
			_loadBar.xy = new LCoordinate((LGlobal.stage.stageWidth - _loadBar.width)/2,(LGlobal.stage.stageHeight - _loadBar.height)/2);
			this.addChild(_loadBar);
			_urlloader = new LURLLoader();
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.addEventListener(Event.COMPLETE,loadMapOver);
			_urlloader.addEventListener(ProgressEvent.PROGRESS,progress);
			_urlloader.load(new URLRequest(_smapName));
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
			
			this._sMapScript.initialization();
			
			_draw.drawMap(mouseX,mouseY);
		}
		public function setDetails(value:String):void{
			_labelDetailsList.push(value);
			if(_labelDetailsList.length > 6)_labelDetailsList.shift();
			_labelDetails.htmlText = "<font color='#ffffff'>"+_labelDetailsList.join("\n")+"</font>";
			_labelDetails.scrollV = _labelDetails.bottomScrollV;
		}
		/**
		 * 回合显示_roundCtrl
		 * */
		public function roundShow():void{
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
					
					//天气变化
					weatherChange();
					
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
		private function weatherChange():void{
			var index:int = int(Math.random() * 100);
			var i:int,num:int = 0;
			for(i=0;i<this.weather.length;i++){
				if(this.weather[i] + num > index){
					if(this.weatherIndex != i)_draw.weatherObjectClear();
					this.weatherIndex = i;
					break;
				}else{
					num += weather[i];
				}
			}
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
			
			_draw.drawMap(mouseX,mouseY);
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
				_mapIsMove = true;
				_mapCoordinate.x += this._nodeLength/4;
				_mapToCoordinate.x = _mapCoordinate.x;
				if(_mapCoordinate.x % this._nodeLength == 0){
					_mapMove["left"] = false;
				}
			}else if(_mapMove["right"]){
				_mapIsMove = true;
				_mapCoordinate.x -= this._nodeLength/4;
				_mapToCoordinate.x = _mapCoordinate.x;
				if(_mapCoordinate.x % this._nodeLength == 0){
					_mapMove["right"] = false;
				}
			}
			if(_mapMove["up"]){
				_mapIsMove = true;
				_mapCoordinate.y += this._nodeLength/4;
				_mapToCoordinate.y = _mapCoordinate.y;
				if(_mapCoordinate.y % this._nodeLength == 0){
					_mapMove["up"] = false;
				}
			}else if(_mapMove["down"]){
				_mapIsMove = true;
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
			_mapIsMove = false;
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
			_smapClick.onUp(mouseX,mouseY);
		}

	}
}