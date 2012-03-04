package zhanglubin.legend.game.sousou.map
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
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
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterR;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.load.LLoading;
	import zhanglubin.legend.objects.LAnimation;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.ScriptFunction;
	import zhanglubin.legend.text.LTextField;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LHitTest;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouRMap extends LMap
	{
		
		private var SPEED:int = 4;
		private const SPEED2:int = 50;
		
		
		private var _speed:int = 0;
		private var _speed2:int = 0;
		
		
		private var _mapData:Array;
		private var _characterR:LSouSouCharacterR;
		private var _map:LBitmap;
		private var _urlloader:LURLLoader;
		private var _hero:LSouSouCharacterR;
		private var _funList:Array = new Array();
		private var _characterList:Vector.<LSouSouCharacterR> = new Vector.<LSouSouCharacterR>();
		
		private var _linecolor:int = 0xff0000;
		private var _linesize:int = 1;
		private var _nodeLength:int = 24;
		private var grid:LShape = new LShape();
		
		private var mapH:int;
		private var mapW:int;
		
		private var _menu:LBitmap;
		private var frames:int;
		private var _timeCount:int;
		private var text:LLabel = new LLabel();
		
		private var _mapLayer:LSprite;
		private var _characterLayer:LSprite;
		private var _menuLayer:LSprite;
		
		private var _loopList:Array = new Array();
		private var _loopIsRun:Boolean;
		private var _loadBar:LLoading;
		
		//menu
		private var _btn_lib:LButton;
		private var _btn_game:LButton;
		private var _btn_member:LButton;
		private var _btn_equipment:LButton;
		private var _btn_luggage:LButton;
		private var _btn_system:LButton;
		private var _btn_gameclose:LButton;
		public function LSouSouRMap()
		{
			LGlobal.script.scriptArray.funList = new Array();
			analysis();
			LGlobal.script.scriptLayer.addChild(this);
			LSouSouObject.rMap = this;
			_mapLayer = new LSprite();
			_characterLayer = new LSprite();
			_menuLayer = new LSprite();
			
			//LSouSouObject.R_CLICK_MODE = false;
			LSouSouObject.storyCtrl = true;
			
			if(LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] == LSouSouObject.FAST){
				this.SPEED = 2;
			}else{
				this.SPEED = 4;
			}
			this.addChild(_mapLayer);
			this.addChild(_characterLayer);
			this.addChild(_menuLayer);
		}

		public function get characterList():Vector.<LSouSouCharacterR>
		{
			return _characterList;
		}

		public function set characterList(value:Vector.<LSouSouCharacterR>):void
		{
			_characterList = value;
		}

		override public function die():void{
			LGlobal.script.scriptArray.funList = new Array();
			LSouSouObject.rMap = null;
			LSouSouObject.rStarQuery = null;
			super.die();
		}
		private function analysis():void{
			var script:LScript = LGlobal.script;
			if(script.lineList.length == 0)return;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				analysis();
				return;
			}
			trace("LSouSouRMap analysis lineValue = " + lineValue);
			switch(lineValue){
				case "SouSouRMap.end()":
					this.addChild(text);
					setMenu();
					this.addEventListener(Event.ENTER_FRAME,onFrame);
					this.addEventListener(MouseEvent.MOUSE_UP,onUp);
					/**
					LGlobal.script.scriptArray.varList["isreading"] = LGlobal.script.scriptArray.varList["isreading"] + "";
					if(LGlobal.script.scriptArray.varList["isreading"].length > 0 && LString.trim(LGlobal.script.scriptArray.varList["isreading"]) != "null"){
						LGlobal.script.lineList.unshift("Mark.goto("+LGlobal.script.scriptArray.varList["isreading"]+");");
						LGlobal.script.scriptArray.varList["isreading"] = "";
					}*/
					LGlobal.script.analysis();
					return;
				case "initialization.start":
					this.initialization();
					break;
				case "function.start":
					this.addFunction();
					break;
				case "loop.start":
					this.loop();
					break;
				default:
					analysis();
			}
		}
		private function setMenu():void{
			_btn_lib = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"lib"));
			_btn_lib.filters = [new GlowFilter()];
			_btn_lib.xy = new LCoordinate(755,0);
			_btn_lib.addEventListener(MouseEvent.MOUSE_UP,libExplanation);
			_menuLayer.addChild(_btn_lib);

			_btn_game = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"game"));
			_btn_game.filters = [new GlowFilter()];
			_btn_game.xy = new LCoordinate(755,45);
			_btn_game.addEventListener(MouseEvent.MOUSE_UP,libGameExplanation);
			_menuLayer.addChild(_btn_game);
			
			_btn_member = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"member"));
			_btn_member.filters = [new GlowFilter()];
			_btn_member.xy = new LCoordinate(755,90);
			_btn_member.addEventListener(MouseEvent.MOUSE_UP,memberView);
			_menuLayer.addChild(_btn_member);
			
			_btn_equipment = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"equipment_menu.png"));
			_btn_equipment.filters = [new GlowFilter()];
			_btn_equipment.xy = new LCoordinate(755,135);
			_btn_equipment.addEventListener(MouseEvent.MOUSE_UP,equipmentChange);
			_menuLayer.addChild(_btn_equipment);
			
			_btn_luggage = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"luggage_menu.png"));
			_btn_luggage.filters = [new GlowFilter()];
			_btn_luggage.xy = new LCoordinate(755,180);
			_btn_luggage.addEventListener(MouseEvent.MOUSE_UP,luggageShow);
			_menuLayer.addChild(_btn_luggage);
			
			_btn_system = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"system_menu.png"));
			_btn_system.filters = [new GlowFilter()];
			_btn_system.xy = new LCoordinate(755,225);
			_btn_system.addEventListener(MouseEvent.MOUSE_UP,systemShow);
			_menuLayer.addChild(_btn_system);
			
			_btn_gameclose = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"gameclose"));
			_btn_gameclose.filters = [new GlowFilter()];
			_btn_gameclose.xy = new LCoordinate(755,400);
			_btn_gameclose.addEventListener(MouseEvent.MOUSE_UP,gameClose);
			_menuLayer.addChild(_btn_gameclose);
			_menuLayer.x = 6;
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
			var window:LSouSouWindow = new LSouSouWindow();
			window.systemShow();
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
			var window:LSouSouWindow = new LSouSouWindow();
			window.equipmentChange();
			LGlobal.script.scriptLayer.addChild(window);
		}
		private function addFunction():void{
			var script:LScript = LGlobal.script;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				addFunction();
				return;
			}
			if(lineValue == "function.end"){
				analysis();
				return;
			}
			if(lineValue.indexOf("function") >= 0){
				setFunction(lineValue);
			}
			addFunction();
		}
		public function setFunction(value:String):void{
			var script:LScript = LGlobal.script;
			var startNameIndex:int = value.indexOf(" ");
			var child:String;
			var funArr:Array = new Array();
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var strParam:String = value.substring(start + 1,end);
			var param:Array = strParam.split(",");
			funArr["param"] = new Array();
			var i:uint;
			for(i=0;i<param.length;i++){
				param[i] = LString.trim(param[i]);
				if((param[i] as String).length > 0)	{
					(funArr["param"] as Array).push("param_" + param[i]);
				}
			}
			funArr["name"] = LString.trim(value.substring(startNameIndex + 1,start));
			
			var funLineArr:Array = new Array();
			while(script.lineList[0].indexOf("endfunction") < 0){
				child = script.lineList.shift();
				for(i=0;i<param.length;i++){
					child = child.replace("@"+param[i],"@param_"+param[i]);
				}
				funLineArr.push(child);
			}
			script.lineList.shift();
			funArr["function"] = funLineArr;
			_funList.push(funArr["name"]);
			script.scriptArray.funList[funArr["name"]] = funArr;
			
		} 
		private function loop():void{
			var script:LScript = LGlobal.script;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				loop();
				return;
			}
			if(lineValue == "loop.end"){
				analysis();
				return;
			}
			var start:int = lineValue.indexOf("(");
			var end:int = lineValue.indexOf(")");
			switch(lineValue.substr(0,start)){
				case "SouSouRCharacter.atCoordinate":
					CharacterAtCoordinate(lineValue.substring(start+1,end).split(","));
					break;
				case "addCharacter":
					addCharacter(lineValue.substring(start+1,end).split(","));
					break;
				default:
			}
			
		}
		public function loopListCheck():void{
			var arr:Array;
			for each(arr in _loopList){
				if(arr["type"] == "SouSouRCharacter.atCoordinate"){
					var coordinateCharacter:LSouSouCharacterR = arr["character"];
					var atCoordinate:LCoordinate = arr["at"];
					if(coordinateCharacter.xy.x == atCoordinate.x && coordinateCharacter.xy.y == atCoordinate.y){
						if(_loopIsRun)return;
						_loopIsRun = true;
						ScriptFunction.analysis("Call.characterAt_" + coordinateCharacter.index + "_" + int(atCoordinate.x/this._nodeLength) + "_" +  int(atCoordinate.y/this._nodeLength) + "();");
						return;
					}
				}
			}
			_loopIsRun = false;
		}
		private function CharacterAtCoordinate(param:Array):void{
			var coordinateCharacter:LSouSouCharacterR;
			for each(coordinateCharacter in _characterList){
				if(coordinateCharacter.index == int(param[0]))break;
			}
			if(coordinateCharacter == null){
				loop();
				return;
			}
			var arr:Array = new Array();
			arr["type"] = "SouSouRCharacter.atCoordinate";
			arr["character"] = coordinateCharacter;
			arr["at"] = new LCoordinate(int(param[1])*this._nodeLength,int(param[2])*this._nodeLength);
			_loopList.push(arr);
			loop();
		}
		private function initialization():void{
			var script:LScript = LGlobal.script;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				initialization();
				return;
			}
			if(lineValue == "initialization.end"){
				analysis();
				return;
			}
			var start:int = lineValue.indexOf("(");
			var end:int = lineValue.indexOf(")");
			switch(lineValue.substr(0,start)){
				case "addMap":
					addMap(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouRCharacter.add":
					addCharacter(lineValue.substring(start+1,end).split(","),false);
					break;
				default:
					initialization();
			}
			
		}
		/**
		 * 添加人物
		 * 
		 */
		public function addCharacter(param:Array,isGlobal:Boolean = true):void{
			//* @param param [是否可控制，人物编号，方向，x坐标,y坐标，]，是否从初始化加入（flash表示初始化加入）
			var ismoving:Boolean = false;
			if(param.length > 5 && int(param[5]) == 1){
				ismoving = true;
			}
			_characterR = new LSouSouCharacterR(int(param[1]),int(param[2]),ismoving);
			_characterR.xy = new LCoordinate(int(param[3])*_nodeLength,int(param[4])*_nodeLength);
			_characterR.tagerCoordinate = new LCoordinate(int(param[3])*_nodeLength,int(param[4])*_nodeLength);
			this._characterList.push(_characterR);
			_characterLayer.addChild(_characterR);
			if(int(param[0]) == 1)this._hero = _characterR;
			if(isGlobal){
				LGlobal.script.analysis();
			}else{
				initialization();
			}
		}
		/**
		 * 读取地图
		 * 
		 * @param param [地图名，后缀名]
		 */
		private function addMap(param:Array):void{
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
			LSouSouObject.rStarQuery = new LSouSouStarR(_mapData);
			
			/**tt*/
			/*
			var bmd:BitmapData = new BitmapData(mapW, mapH, true, 0);
			var bmd2:BitmapData = new BitmapData(mapW, mapH, true, 0);
			bmd.setPixels(bmd.rect, bytes);
			this._map = new LBitmap(bmd2);
			this._map.bitmapData.copyPixels(bmd,new Rectangle(0,0,335,bmd.height),new Point(465,0));
			this._map.bitmapData.copyPixels(bmd,new Rectangle(335,0,465,bmd.height),new Point(0,0));
			//this._map.bitmapData.copyPixels(bmd,new Rectangle(400,0,200,bmd.height),new Point(400,0));
			//this._map.bitmapData.copyPixels(bmd,new Rectangle(600,0,200,bmd.height),new Point(600,0));
			*/
			var bmd:BitmapData = new BitmapData(mapW, mapH, true, 0);
			bmd.setPixels(bmd.rect, bytes);
			this._map = new LBitmap(bmd);
			
			_mapLayer.addChild(_map);
			
			_loadBar.removeFromParent();
			
			this.drawGrid();
			this.initialization();
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
			if(++_speed2 % SPEED2 == 0)_speed2 = 0;
			
			
			var charaArray:Array = new Array();
			
			for each(_characterR in _characterList){
				_characterR.onFrame();
				charaArray.push({chara:_characterR,y:_characterR.y});
				if(_speed2 == 0 && this._hero != null && _characterR.index != this._hero.index && 
					(_characterR.path == null || _characterR.path.length == 0)){
					if(!_characterR.ismoving)continue;
					if(LSouSouObject.storyCtrl)continue;
					if(Math.random() > 0.2)continue;
					var indexX:int = Math.floor(Math.random()*800/_nodeLength);
					var indexY:int = Math.floor(Math.random()*480/_nodeLength);

					if(indexX == _characterR.tagerCoordinate.x && indexY == _characterR.tagerCoordinate.y)continue;
					
					var mx:int = mouseX - indexX*_nodeLength;
					var my:int = mouseY - indexY*_nodeLength;
					
					var toCoordinate:LCoordinate;
					if((indexX + indexY) & 1 == 1){
						if(mx >= my){
							toCoordinate = new LCoordinate(indexX + 1,indexY);
						}else{
							toCoordinate = new LCoordinate(indexX,indexY + 1);
						}
					}else{
						if(mx <= _nodeLength-my){
							toCoordinate = new LCoordinate(indexX,indexY);
						}else{
							toCoordinate = new LCoordinate(indexX + 1,indexY + 1);
						}
						
					}
					_characterR.path = LSouSouObject.rStarQuery.path(new LCoordinate(int(_characterR.xy.x/24),int(_characterR.xy.y/24)),toCoordinate);
					
				}
				if(_characterR.inHitPoint(mouseX - _characterR.x,mouseY - _characterR.y)){
					_characterR.filters = [new GlowFilter()];
				}else if(_characterR.filters)_characterR.filters = null;
				
			}
			try{
				gameSort(charaArray);
			}catch(e:Object){
			}
			loopListCheck();
		}
		//人物深度排序
		private function gameSort(charaArray:Array):void{
			var charaCount:int = _characterList.length;
			if(charaCount <= 1){
				return;
			}
			
			var result:Array;
			result = charaArray.sortOn("y",Array.NUMERIC|Array.RETURNINDEXEDARRAY); 
			for (var i:int = 0; i < result.length; i++){
				var v:DisplayObject = charaArray[result[i]].chara as DisplayObject; 
				if (v.parent == _characterLayer && _characterLayer.getChildIndex(v) != i) {
					_characterLayer.setChildIndex(v,i);
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
			var isChara:Boolean;
			for each(_characterR in _characterList){
				if(_characterR.inHitPoint(mouseX - _characterR.x,mouseY - _characterR.y)){
					ScriptFunction.analysis("Call.characterclick"+_characterR.index + "();");
					isChara = true;
					break;
				}
			}
			if(isChara)return;
			
			
			var indexX:int = Math.floor(mouseX/_nodeLength);
			var indexY:int = Math.floor(mouseY/_nodeLength);
			
			if(this._hero == null || indexX == this._hero.tagerCoordinate.x && indexY == this._hero.tagerCoordinate.y)return;
			
			var mx:int = mouseX - indexX*_nodeLength;
			var my:int = mouseY - indexY*_nodeLength;
			var toCoordinate:LCoordinate;
			if((indexX + indexY) & 1 == 1){
				if(mx >= my){
					toCoordinate = new LCoordinate(indexX + 1,indexY);
				}else{
					toCoordinate = new LCoordinate(indexX,indexY + 1);
				}
			}else{
				if(mx <= _nodeLength-my){
					toCoordinate = new LCoordinate(indexX,indexY);
				}else{
					toCoordinate = new LCoordinate(indexX + 1,indexY + 1);
				}
				
			}
			this._hero.path = LSouSouObject.rStarQuery.path(new LCoordinate(int(this._hero.xy.x/_nodeLength),int(this._hero.xy.y/_nodeLength)),toCoordinate);
			
		}
		/**
		 * 控制人物移动
		 * 
		 * @param param [类型（0相对，1绝对），人物编号，方向(0:down,1:left,2:up,3:right)，坐标]
		 */
		public function moveTo(param:Array):void{
			var isChara:Boolean;
			for each(_characterR in _characterList){
				if(_characterR.index == int(param[1])){
					isChara = true;
					break;
				}
			}
			if(!isChara){
				LGlobal.script.analysis();
				return;
			}
			var toCoordinate:LCoordinate;
			if(int(param[0]) == 0){
				if(int(param[2]) == 0){
					//down
					toCoordinate = new LCoordinate(_characterR.xy.x/_nodeLength - int(param[3]),_characterR.xy.y/_nodeLength + int(param[3]));
					if(toCoordinate.x < 0){
						toCoordinate.y += toCoordinate.x;
						toCoordinate.x = 0;
					}else if(toCoordinate.y >= this._mapData.length){
						toCoordinate.x += (toCoordinate.y - this._mapData.length + 1);
						toCoordinate.y = this._mapData.length - 1;
					}
				}else if(int(param[2]) == 1){
					//left
					toCoordinate = new LCoordinate(_characterR.xy.x/_nodeLength - int(param[3]),_characterR.xy.y/_nodeLength - int(param[3]));
					if(toCoordinate.x < 0){
						toCoordinate.y -= toCoordinate.x;
						toCoordinate.x = 0;
					}else if(toCoordinate.y < 0){
						toCoordinate.x -= toCoordinate.y;
						toCoordinate.y = 0;
					}
				}else if(int(param[2]) == 2){
					//up
					toCoordinate = new LCoordinate(_characterR.xy.x/_nodeLength + int(param[3]),_characterR.xy.y/_nodeLength - int(param[3]));
					if(toCoordinate.x > this._mapData[0].length){
						toCoordinate.y += (toCoordinate.x - this._mapData[0].length + 1);
						toCoordinate.x = this._mapData[0].length - 1;
					}else if(toCoordinate.y < 0){
						toCoordinate.x -= toCoordinate.y;
						toCoordinate.y = 0;
					}
				}else if(int(param[2]) == 3){
					//right
					toCoordinate = new LCoordinate(_characterR.xy.x/_nodeLength + int(param[3]),_characterR.xy.y/_nodeLength + int(param[3]));
					if(toCoordinate.x > this._mapData[0].length){
						toCoordinate.y += (toCoordinate.x - this._mapData[0].length + 1);
						toCoordinate.x = this._mapData[0].length - 1;
					}else if(toCoordinate.y >= this._mapData.length){
						toCoordinate.x += (toCoordinate.y - this._mapData.length + 1);
						toCoordinate.y = this._mapData.length - 1;
					}
				}
			}else{
				toCoordinate = new LCoordinate(int(param[2]),int(param[3]));
			}
			_characterR.path = LSouSouObject.rStarQuery.path(new LCoordinate(int(_characterR.xy.x/_nodeLength),int(_characterR.xy.y/_nodeLength)),toCoordinate);
			if((LGlobal.script.lineList[0] as String).indexOf("SouSouRCharacter.moveTo")>=0){
				LGlobal.script.analysis();
			}else{
				_characterR.addEventListener(LEvent.CHARACTER_MOVE_COMPLETE,characterMoveComplete);
			}
		}
		
		/**
		 * 人物移动完成事件
		 * 
		 * @param event 移动完成事件
		 */
		private function characterMoveComplete(event:LEvent):void{
			event.target.removeEventListener(LEvent.CHARACTER_MOVE_COMPLETE,characterMoveComplete);
			LGlobal.script.analysis();
		}
		/**
		 * 改变人物方向
		 * 
		 * @param param [人物编号，方向(0:down,1:left,2:up,3:right)]
		 */
		public function changeAction(param:Array):void{
			for each(_characterR in _characterList){
				if(_characterR.index == int(param[0])){
					_characterR.action = int(param[1]);
					break;
				}
			}
			LGlobal.script.analysis();
		}
		/**
		 * 移除人物
		 * 
		 * @param param 人物编号
		 */
		public function removeCharacter(index:int):void{
			var i:int;
			for each(_characterR in _characterList){
				if(_characterR.index == index){
					_characterList.splice(i,1);
					_characterR.removeFromParent();
					break;
				}
				i++;
			}
			LGlobal.script.analysis();
		}
		
		/**
		 * 画网格
		 * 
		 * @param type 网格类型
		 */
		private function drawGrid(type:int = 0):void{
			var i:int,j:int;
			this.addChild(grid);
			return;
			if(type == 0){
				grid.graphics.lineStyle(1,0x000000,1);
				for(i = 0;i<_mapData.length;i++){
					for(j = 0;j<_mapData[i].length;j++){
						if((i+j) %2 == 0 && _mapData[i][j] == 1){
							drawTriangle2(j,i);
						}
					}
				}
				grid.graphics.lineStyle(_linesize,_linecolor,1);
				for(i = 0;i<_mapData.length;i++){
					if(i % 2 == 1){
						grid.graphics.moveTo( 0, i*_nodeLength );
						grid.graphics.lineTo(_mapData.length * _nodeLength - i*_nodeLength ,_mapData.length * _nodeLength);
					}
				}
				grid.graphics.lineStyle(_linesize,_linecolor,1);
				for(i = 0;i<_mapData[0].length;i++){
					if(i % 2 == 1){
						grid.graphics.moveTo(i*_nodeLength ,0);
						if(_mapData[0].length * _nodeLength - i*_nodeLength >= _mapData.length*_nodeLength){
							grid.graphics.lineTo(_mapData.length * _nodeLength + i*_nodeLength,_mapData.length * _nodeLength);
						}else{
							grid.graphics.lineTo(_mapData[0].length * _nodeLength,_mapData[0].length * _nodeLength-i*_nodeLength);
						}
					}
				}
				
				grid.graphics.lineStyle(_linesize,_linecolor,1);
				for(i = 0;i<_mapData[0].length;i++){
					if(i % 2 == 0){
						grid.graphics.moveTo(i*_nodeLength + _nodeLength ,0);
						if(i*_nodeLength + _nodeLength > _mapData.length*_nodeLength){
							grid.graphics.lineTo(i*_nodeLength + _nodeLength - _mapData.length*_nodeLength,_mapData.length*_nodeLength);
						}else{
							grid.graphics.lineTo(0,i*_nodeLength + _nodeLength);
						}
					}
				}
				grid.graphics.lineStyle(_linesize,_linecolor,1);
				var add:int = _nodeLength;
				if(_mapData[0].length % 2 == 1)add = 0;
				for(i = 0;i<_mapData.length;i++){
					if(i % 2 == 0){
						grid.graphics.moveTo( _mapData[0].length * _nodeLength, i*_nodeLength + add);
						
						grid.graphics.lineTo(_mapData[0].length * _nodeLength - (_mapData.length * _nodeLength - i*_nodeLength) + add, _mapData.length * _nodeLength);
					}
				}
			}else{
				var tex:LTextField;
				for( i = 0;i<_mapData[0].length;i++){
					
					for(j = 0;j<_mapData.length;j++){
						if(_mapData[j][i] == 1){
							
							grid.graphics.beginFill(0xff0000,0.2);
							grid.graphics.lineStyle(2, 0xff0000,0.8);     
							grid.graphics.drawRect(i*24,j*24,24,24);
							grid.graphics.endFill(); 
						}else{
							grid.graphics.beginFill(0xffffff,0.2);
							grid.graphics.lineStyle(2, 0xffffff,0.8);     
							grid.graphics.drawRect(i*24,j*24,24,24);
							grid.graphics.endFill(); 
							
							tex = new LTextField();
							tex.x = i*24 + 5;
							tex.y = j*24 + 5;
							tex.selectable = false;
							tex.htmlText = "<font size='9' color='#000000'>" + i + "," + j + "</font>";
							this.addChild(tex);
						}
					}
					
				}
			}
		}
		private function drawTriangle2(nx:int,ny:int):void{
			drawTriangle(nx - 1,ny - 1,4);
			drawTriangle(nx,ny - 1,2);
			drawTriangle(nx - 1,ny,1);
			drawTriangle(nx,ny,0);
		}
		private function drawTriangle(nx:int,ny:int,type:int):void{
			if(nx < 0 || nx >= _mapData[0].length || ny < 0 || ny >= _mapData.length)return;
			
			if(type == 0){//left up
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength,nx*_nodeLength,ny*_nodeLength + _nodeLength],true,_linecolor,0.5);
			}else if(type == 1){//right up
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength + _nodeLength],true,_linecolor,0.5);
			}else if(type == 2){//left down
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength + _nodeLength,nx*_nodeLength,ny*_nodeLength + _nodeLength],true,_linecolor,0.5);
			}else{//right down
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength + _nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength + _nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength],true,_linecolor,0.5);
			}
			
		}
	}
}