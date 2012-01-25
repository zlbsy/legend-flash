package zhanglubin.legend.game.sousou.map
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;
	import zhanglubin.legend.utils.transitions.LManager;

	public class LSouSouSingled extends LSprite
	{
		private var _leftFace:LBitmap;
		private var _rightFace:LBitmap;
		private var _leftCharaUp:LSouSouCharacterS;
		private var _leftChara:LSouSouCharacterS;
		private var _leftCharaDown:LSouSouCharacterS;
		private var _rightCharaUp:LSouSouCharacterS;
		private var _rightChara:LSouSouCharacterS;
		private var _rightCharaDown:LSouSouCharacterS;
		private var _background:LBitmap;
		private var _leftTalk:LLabel;
		private var _rightTalk:LLabel;
		private var _leftName:LLabel;
		private var _rightName:LLabel;
		private var _nowChara:int;
		private var _targetChara:int;
		private var _nowMode:String;
		public function LSouSouSingled(leftIndex:int,rightIndex:int,leftUpIndex:int=0,rightUpIndex:int=0,leftDownIndex:int=0,rightDownIndex:int=0)
		{
			LDisplay.drawRect(this.graphics,[0,0,600,380],true,0x000000,1,5);
			LDisplay.drawRoundRect(this.graphics,[130,20,400,80,10,10],true,0xffffff,1,5);
			LDisplay.drawRoundRect(this.graphics,[70,280,400,80,10,10],true,0xffffff,1,5);
			
			if(leftUpIndex > 0){
				_leftCharaUp = this.getChara(leftUpIndex);
				_leftCharaUp = new LSouSouCharacterS(_leftCharaUp.member,0,3,0);
				_leftCharaUp.x = 132 + 12
				_leftCharaUp.y= 180-24;
				//_leftCharaUp.xy = new LCoordinate(132 + 12,180-24);
			}
			if(rightUpIndex > 0){
				_rightCharaUp = this.getChara(rightUpIndex);
				_rightCharaUp = new LSouSouCharacterS(_rightCharaUp.member,1,1,0);
				_rightCharaUp.x = 468 + 12;
				_rightCharaUp.y = 180-24;
				//_rightCharaUp.xy = new LCoordinate(468 + 12,180-24);
			}
			
			_leftChara = this.getChara(leftIndex);
			_rightChara = this.getChara(rightIndex);
			_leftChara = new LSouSouCharacterS(_leftChara.member,0,3,0);
			_leftChara.x = 132;
			_leftChara.y = 180;
			_rightChara = new LSouSouCharacterS(_rightChara.member,1,1,0);
			_rightChara.x = 468;
			_rightChara.y = 180;
			//_leftChara.xy = new LCoordinate(132,180);
			//_rightChara.xy = new LCoordinate(468,180);
			
			if(leftDownIndex > 0){
				_leftCharaDown = this.getChara(leftDownIndex);
				_leftCharaDown = new LSouSouCharacterS(_leftCharaDown.member,0,3,0);
				_leftCharaDown.x = 132 - 12;
				_leftCharaDown.y = 180+24;
				//_leftCharaDown.xy = new LCoordinate(132 - 12,180+24);
			}
			if(rightDownIndex > 0){
				_rightCharaDown = this.getChara(rightDownIndex);
				_rightCharaDown = new LSouSouCharacterS(_rightCharaDown.member,1,1,0);
				_rightCharaDown.x = 468 - 12;
				_rightCharaDown.y = 180+24;
				//_rightCharaDown.xy = new LCoordinate(468 - 12,180+24);
			}
			var facedata:BitmapData;
			var faceIndex:int;
			faceIndex = _leftChara.member.face;
			if(faceIndex >= LSouSouObject.charaFaceList.length){
				facedata = new BitmapData(150,150,false,0x000000);
			}else{
				facedata = LSouSouObject.charaFaceList[faceIndex];
			}
			
			/*
			var facedata:BitmapData;
			facedata = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["face"],
				"face" + _leftChara.member.face +"-0");*/
			_leftFace = new LBitmap(facedata);
			_leftFace.width = 100;
			_leftFace.height = 100;
			_leftFace.xy = new LCoordinate(10,10);
			this.addChild(_leftFace);
			
			//facedata = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["face"],
				//"face" + _rightChara.member.face +"-0");
			faceIndex = _rightChara.member.face;
			if(faceIndex >= LSouSouObject.charaFaceList.length){
				facedata = new BitmapData(150,150,false,0x000000);
			}else{
				facedata = LSouSouObject.charaFaceList[faceIndex];
			}
			_rightFace = new LBitmap(facedata);
			_rightFace.width = 100;
			_rightFace.height = 100;
			_rightFace.xy = new LCoordinate(490,270);
			this.addChild(_rightFace);
			//singledBackground
			_background = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"singledBackground"));
			_background.y = 110;
			this.addChild(_background);
			
			
			_leftName = new LLabel();
			_leftName.selectable = false;
			_leftName.wordWrap = true;
			_leftName.width = 380;
			_leftName.height = 60;
			_leftName.xy = new LCoordinate(140,28);
			_leftName.htmlText = "<font size='22'><b>"+_leftChara.member.name+"</b></font>";
			this.addChild(_leftName);
			
			_rightName = new LLabel();
			_rightName.selectable = false;
			_rightName.wordWrap = true;
			_rightName.width = 380;
			_rightName.height = 60;
			_rightName.xy = new LCoordinate(80,288);
			_rightName.htmlText = "<font size='22'><b>"+_rightChara.member.name+"</b></font>";
			this.addChild(_rightName);
			
			_leftTalk = new LLabel();
			_leftTalk.selectable = false;
			_leftTalk.wordWrap = true;
			_leftTalk.width = 380;
			_leftTalk.height = 60;
			_leftTalk.xy = new LCoordinate(140,50);
			_leftTalk.htmlText = "<font size='18'><b></b></font>";
			this.addChild(_leftTalk);
			
			_rightTalk = new LLabel();
			_rightTalk.selectable = false;
			_rightTalk.wordWrap = true;
			_rightTalk.width = 380;
			_rightTalk.height = 60;
			_rightTalk.xy = new LCoordinate(80,310);
			_rightTalk.htmlText = "<font size='18'><b></b></font>";
			this.addChild(_rightTalk);
			
			/*
			this.addEventListener(MouseEvent.CLICK,function(){
			LSouSouObject.window.removeFromParent();});*/
		}

		public function get targetChara():int
		{
			return _targetChara;
		}

		public function set targetChara(value:int):void
		{
			_targetChara = value;
		}

		public function draw():void{
			/**画背景*/
			_background.bitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"singledBackground");
			if(_leftCharaUp != null)showChara(_leftCharaUp);
			if(_rightCharaUp != null)showChara(_rightCharaUp);
			showChara(_leftChara);
			showChara(_rightChara);
			if(_leftCharaDown != null)showChara(_leftCharaDown);
			if(_rightCharaDown != null)showChara(_rightCharaDown);
		}
		private function showChara(chara:LSouSouCharacterS):void{
			if(!chara.visible)return;
			if(chara.action_mode == LSouSouCharacterS.MODE_BREAKOUT){
				chara.colorTrans(100);
			}else if(chara.action_mode == LSouSouCharacterS.MODE_STOP){
				chara.colorTrans(-70);
			}
			_background.bitmapData.copyPixels(chara.bitmapData,
				new Rectangle(0,0,chara.width,chara.height),
				new Point(chara.x + chara.point.x,
					chara.y - _background.y + chara.point.y));
			chara.onFrame();
		}
		public function showResult(value:int):void{
			var strResult:String = "单条胜利";
			if(value==0){
				strResult = "单条平手";
			}else if(value<0){
				strResult = "单条失败";
			}
			var resultLayer:LSprite = new LSprite();
			this.addChild(resultLayer);
			LDisplay.drawRect(resultLayer.graphics,[0,0,600,380],true,0x000000,0.8,5);
			//LDisplay.drawRoundRect(resultLayer.graphics,[130,20,400,80,10,10],true,0xffffff,0.8,5);
			var res:LLabel = new LLabel();
			res.selectable = false;
			res.xy = new LCoordinate(200,150);
			res.htmlText = "<font color='#ff0000' size='60'><b>"+strResult+"</b></font>";
			resultLayer.addChild(res);
			LManager.wait(100,function():void{LGlobal.script.analysis();});
		}
		public function setTalk(_characterS:LSouSouCharacterS,text:String):void{
			
			var facedata:BitmapData;
			var faceIndex:int;
			faceIndex = _characterS.member.face;
			if(faceIndex >= LSouSouObject.charaFaceList.length){
				facedata = new BitmapData(150,150,false,0x000000);
			}else{
				facedata = LSouSouObject.charaFaceList[faceIndex];
			}
			//facedata = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["face"],
				//"face" + _characterS.member.face +"-0");
			
			if(_characterS.belong == 0){
				_leftFace.bitmapData = facedata;
				_leftName.htmlText = "<font size='22'><b>"+_characterS.member.name+"</b></font>";
				_leftTalk.htmlText = "<font size='18'><b>" + text + "</b></font>";
			}else{
				_rightFace.bitmapData = facedata;
				_rightName.htmlText = "<font size='22'><b>"+_characterS.member.name+"</b></font>";
				_rightTalk.htmlText = "<font size='18'><b>" + text + "</b></font>";
			}
			LGlobal.script.analysis();
		}
		public function move(_characterS:LSouSouCharacterS,tox:int):void{
			/**
			var _characterS:LSouSouCharacterS;
			if(isleft){
				_characterS = _leftChara;
			}else{
				_characterS = _rightChara;
			}
			*/
			if(_characterS.member.armsMoveType == 0){
				LSouSouObject.sound.play("Se24");
			}else{
				LSouSouObject.sound.play("Se23");
			}
			_characterS.tagerCoordinate=new LCoordinate(_characterS.x + tox*LSouSouObject.sMap._nodeLength,_characterS.y);
			_characterS.path = new Array();
			//_characterS.path = new Array(new Node(_characterS.tagerCoordinate.x,_characterS.tagerCoordinate.y));
			trace(_characterS.xy,_characterS.tagerCoordinate,_characterS.path);
			_characterS.addEventListener(LEvent.CHARACTER_MOVE_COMPLETE,function(event:LEvent):void{
				trace("move over");
				_characterS.removeAllEventListener();
				LGlobal.script.analysis();
			});
		}
		public function move2(_characterS:LSouSouCharacterS,tox:int,speed:int):void{
			/**
			var _characterS:LSouSouCharacterS;
			if(isleft){
				_characterS = _leftChara;
			}else{
				_characterS = _rightChara;
			}
			*/
			if(_characterS.member.armsMoveType == 0){
				LSouSouObject.sound.play("Se24");
			}else{
				LSouSouObject.sound.play("Se23");
			}
			_characterS.tagerCoordinate=new LCoordinate(_characterS.x + tox*LSouSouObject.sMap._nodeLength,_characterS.y);
			LManager.moveTo(_characterS,_characterS.tagerCoordinate.x,_characterS.tagerCoordinate.y,speed,function ():void{
				trace("move2 over");
				LGlobal.script.analysis();
			});
		}

		public function getChara(index:int):LSouSouCharacterS{
			var _characterS:LSouSouCharacterS;
			for each(_characterS in LSouSouObject.sMap.ourlist){
				if(_characterS.index == index)return _characterS;
			}
			for each(_characterS in LSouSouObject.sMap.friendlist){
				if(_characterS.index == index)return _characterS;
			}
			for each(_characterS in LSouSouObject.sMap.enemylist){
				if(_characterS.index == index)return _characterS;
			}
			return null;
		}
		
		public function get rightCharaDown():LSouSouCharacterS
		{
			return _rightCharaDown;
		}
		
		public function set rightCharaDown(value:LSouSouCharacterS):void
		{
			_rightCharaDown = value;
		}
		
		public function get rightCharaUp():LSouSouCharacterS
		{
			return _rightCharaUp;
		}
		
		public function set rightCharaUp(value:LSouSouCharacterS):void
		{
			_rightCharaUp = value;
		}
		
		public function get leftCharaDown():LSouSouCharacterS
		{
			return _leftCharaDown;
		}
		
		public function set leftCharaDown(value:LSouSouCharacterS):void
		{
			_leftCharaDown = value;
		}
		
		public function get leftCharaUp():LSouSouCharacterS
		{
			return _leftCharaUp;
		}
		
		public function set leftCharaUp(value:LSouSouCharacterS):void
		{
			_leftCharaUp = value;
		}
		public function get nowMode():String
		{
			return _nowMode;
		}
		
		public function set nowMode(value:String):void
		{
			_nowMode = value;
		}
		
		public function get nowChara():int
		{
			return _nowChara;
		}
		
		public function set nowChara(value:int):void
		{
			_nowChara = value;
		}
		public function get rightChara():LSouSouCharacterS
		{
			return _rightChara;
		}
		
		public function get leftChara():LSouSouCharacterS
		{
			return _leftChara;
		}


	}
}