package zhanglubin.legend.game.sousou.meff
{
	import flash.display.BitmapData;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouCalculate;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.objects.LAnimation;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	
	public class LSouSouMeff
	{
		private const SPEED:int = 1;
		private var _speed:int = 0;
		private var _dataArray:Array;
		private var _animation:LAnimation;
		private var _animationList:Array ;
		private var _meffXml:XMLList;
		private var _atHert:int;
		private var _meffCharacter:LSouSouCharacterS;
		private var bitmapData:BitmapData;
		public var x:int;
		public var y:int;
		
		public function LSouSouMeff(_xml:XMLList,chara:LSouSouCharacterS)
		{
			super();
			this._meffXml = _xml;
			_meffCharacter = chara;
			trace("LSouSOuMeff _meffCharacter = " + _meffCharacter);
			trace("LSouSOuMeff _meffCharacter = " + _meffCharacter.member.name);
			this.x = _meffCharacter.targetCharacter.x;
			this.y = _meffCharacter.targetCharacter.y;
			setImage();
		}
		
		public function get animationList():Array
		{
			return _animationList;
		}
		
		public function get atHert():int
		{
			return _atHert;
		}
		
		public function set atHert(value:int):void
		{
			_atHert = value;
		}
		
		private function setImage():void{
			
			_animationList = [];
			var _mefflength:int = int(_meffXml.Num.toString());
			var charas:LSouSouCharacterS;
			var _charalist:Array = [];
			trace("LSouSouMeff setImage _meffXml.Img.toString() = " + _meffXml.Img.toString());
			var bit:BitmapData = LSouSouObject.meffImg[_meffXml.Img.toString()];
			trace("LSouSouMeff setImage bit = " + bit);
			
			var arr:Array = LImage.divideByCopyPixels(bit,_mefflength,1);
			_dataArray = new Array();
			var i:int;
			var bitarr:Array = new Array();
			for(i=0;i<_mefflength;i++){
				bitarr.push(arr[i][0]);
			}
			_dataArray.push(bitarr);
			
			if(_meffCharacter.belong == LSouSouObject.BELONG_SELF || _meffCharacter.belong == LSouSouObject.BELONG_FRIEND){
				if(LSouSouObject.sMap.strategy.Belong.toString() == "1"){
					for each(charas in LSouSouObject.sMap.enemylist){
						if(!charas.visible || charas.member.troops == 0)continue;
						_charalist[charas.locationX + "," + charas.locationY] = charas;
					}
				}else{
					for each(charas in LSouSouObject.sMap.ourlist){
						if(!charas.visible || charas.member.troops == 0)continue;
						_charalist[charas.locationX + "," + charas.locationY] = charas;
					}
					for each(charas in LSouSouObject.sMap.friendlist){
						if(!charas.visible || charas.member.troops == 0)continue;
						_charalist[charas.locationX + "," + charas.locationY] = charas;
					}
				}
			}else{
				if(LSouSouObject.sMap.strategy.Belong.toString() == "1"){
					for each(charas in LSouSouObject.sMap.ourlist){
						if(!charas.visible || charas.member.troops == 0)continue;
						_charalist[charas.locationX + "," + charas.locationY] = charas;
					}
					for each(charas in LSouSouObject.sMap.friendlist){
						if(!charas.visible || charas.member.troops == 0)continue;
						_charalist[charas.locationX + "," + charas.locationY] = charas;
					}
				}else{
					for each(charas in LSouSouObject.sMap.enemylist){
						if(!charas.visible || charas.member.troops == 0)continue;
						_charalist[charas.locationX + "," + charas.locationY] = charas;
					}
				}
			}
			var nodeStr:String;
			var nodeArr:Array;
			var ax:int,ay:int;
			for each(nodeStr in LSouSouObject.sMap.strategy.Att.elements()){
				nodeArr = nodeStr.split(",");
				trace("LSouSouMeff setImage _meffCharacter.targetCharacter = " + _meffCharacter.targetCharacter.index);
				charas = _charalist[(_meffCharacter.targetCharacter.locationX + int(nodeArr[0])) + "," + (_meffCharacter.targetCharacter.locationY + int(nodeArr[1]))];
				trace("LSouSouMeff setImage charas = " + charas);
				if(!charas)continue;
				
				this._animation = new LAnimation(_dataArray);
				this._animation.rowIndex = 0;
				this._animation.run(LAnimation.POSITIVE);
				this.bitmapData = this._animation.dataBMP;
				ax = (_meffCharacter.targetCharacter.width - bitmapData.width)/2 + nodeArr[0]*LSouSouObject.sMap.nodeLength;
				ay = (_meffCharacter.targetCharacter.height - bitmapData.height) + nodeArr[1]*LSouSouObject.sMap.nodeLength;
				_animationList.push([this._animation,charas,ax,ay]);
			}
			/*
			this._animation = new LAnimation(_dataArray);
			this._animation.rowIndex = 0;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			this.x += (_meffCharacter.targetCharacter.width - this.width)/2;
			this.y += (_meffCharacter.targetCharacter.height - this.height)/2;
			*/
			_atHert = int(_meffXml.At.toString());
		}
		/**
		 *贞
		 */
		public function onFrame():void{
			if(!(_speed++ % SPEED == 0))return;
			_speed -= SPEED;
			var arr:Array;
			for each(arr in _animationList){
				_animation = arr[0];
				_animation.run(LAnimation.POSITIVE);
				bitmapData = _animation.dataBMP;
				if(_atHert == _animation.currentframe){
					
					if(LSouSouObject.sMap.strategy.Type.toString() == "1" ||
						LSouSouObject.sMap.strategy.Type.toString() == "2" ||
						LSouSouObject.sMap.strategy.Type.toString() == "3" ||
						LSouSouObject.sMap.strategy.Type.toString() == "4"){
						toHert(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "5"){
						toChangeStatus(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "6"){
						toChangeStatus2(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "7"){
						toWake(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "8"){
						toAdd(arr[1]);
					}else{
						trace("LSouSouMeff onFrame 该策略功能尚未实现");
					}
					/**
					 if(LSouSouObject.sMap.strategy.Belong.toString() == "1"){
					 toHert(arr[1]);
					 }else{
					 if(LSouSouObject.sMap.strategy.Type.toString() == "4"){
					 toAdd(arr[1]);
					 }else if(LSouSouObject.sMap.strategy.Type.toString() == "5"){
					 toChangeStatus(arr[1]);
					 }else{
					 trace("LSouSouMeff onFrame 该策略功能尚未实现");
					 }
					 }
					 //toHert(_meffCharacter.targetCharacter);*/
				}
			}
			/*
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			if(_atHert == this._animation.currentframe){
			toHert(_meffCharacter.targetCharacter);
			}
			*/
		}
		public function checkOver():void{
			this._animation = _animationList[0][0];
			trace("checkOver",this._animation.currentframe , this._animation.currentframeCount - 1);
			if(this._animation.currentframe == this._animation.currentframeCount - 1){
				LSouSouObject.sMap.meff = null;
				LSouSouObject.sMap.strategy = null;
				var arr:Array;
				for each(arr in _animationList){
					//charas.returnAction();
					if(arr[1].action_mode == LSouSouCharacterS.MODE_STOP){
						arr[1].action = LSouSouCharacterS.DOWN + arr[1].direction;
					}else{
						arr[1].action = LSouSouCharacterS.MOVE_DOWN + arr[1].direction;
					}
				}
				_meffCharacter.strategyOver();
			}
		}
		public function toWake(charas:LSouSouCharacterS):void{
			var hitrate:Boolean = LSouSouCalculate.getHitrateRestoration(_meffCharacter,charas);
			
			if(charas.index == _meffCharacter.targetCharacter.index){
				charas.targetCharacter = _meffCharacter;
				if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
					if(_meffCharacter.member.lv <= charas.member.lv){
						_meffCharacter.member.setWeaponExp(3);
					}else{
						_meffCharacter.member.setWeaponExp(2);
					}
				}
				getExp(charas);
			}
			if(hitrate){
				charas.setReturnAction(LSouSouCharacterS.DOWN + charas.direction);
				/**状态恢复*/
				charas.action = LSouSouCharacterS.UPGRADE;
				charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] = 0;
				charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][1] = 0;
				
				charas.statusArray[LSouSouCharacterS.STATUS_FIXED][0] = 0;
				charas.statusArray[LSouSouCharacterS.STATUS_FIXED][1] = 0;
				
				charas.statusArray[LSouSouCharacterS.STATUS_POISON][0] = 0;
				charas.statusArray[LSouSouCharacterS.STATUS_POISON][1] = 0;
				
				charas.statusArray[LSouSouCharacterS.STATUS_STATEGY][0] = 0;
				charas.statusArray[LSouSouCharacterS.STATUS_STATEGY][1] = 0;
				
				charas.statusArray[LSouSouCharacterS.STATUS_NOATK][0] = 0;
				charas.statusArray[LSouSouCharacterS.STATUS_NOATK][1] = 0;
			}else{
				/**档格*/
			}
			
		}
		public function toChangeStatus2(charas:LSouSouCharacterS):void{
			var hitrate:Boolean =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
			var hitrate2:Boolean;
			var hertValue:int;
			var arr:Array;
			var hertNum:String;
			if(charas.index == _meffCharacter.targetCharacter.index){
				charas.targetCharacter = _meffCharacter;
				if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
					if(_meffCharacter.member.lv <= charas.member.lv){
						_meffCharacter.member.setWeaponExp(3);
					}else{
						_meffCharacter.member.setWeaponExp(2);
					}
				}
				getExp(charas);
			}
			if(hitrate){
				charas.setReturnAction(LSouSouCharacterS.DOWN + charas.direction);
				if(LSouSouObject.sMap.strategy.Type2.toString() == "poison_1"){
					hitrate2 =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
					charas.action = LSouSouCharacterS.HERT;
					charas.statusArray[LSouSouCharacterS.STATUS_POISON][0] = 1;
					charas.statusArray[LSouSouCharacterS.STATUS_POISON][1] = 0;
					if(hitrate2){
						hertValue = LSouSouCalculate.getHertStrategyValue(_meffCharacter,charas);
						if(_meffCharacter.skillRun && _meffCharacter.member.skill == 4){
							hertValue = 2*hertValue;
							_meffCharacter.skillRun = false;
						}
						if(hertValue > charas.member.troops)hertValue = charas.member.troops;
						charas.member.troops -= hertValue;
						charas.action = LSouSouCharacterS.HERT;
						arr = [];
						hertNum = "-"+hertValue;
						arr[0] = hertNum;
						arr[1] = charas.x + LSouSouObject.sMap.mapCoordinate.x + (charas.width - hertNum.length*20)/2;
						arr[2] = charas.y + LSouSouObject.sMap.mapCoordinate.y;
						arr[3] = 0;
						LSouSouObject.sMap.numList.push(arr);
					}
				}else if(LSouSouObject.sMap.strategy.Type2.toString() == "fixed_1"){
					hitrate2 =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
					charas.action = LSouSouCharacterS.HERT;
					charas.statusArray[LSouSouCharacterS.STATUS_FIXED][0] = 1;
					charas.statusArray[LSouSouCharacterS.STATUS_FIXED][1] = 0;
					if(hitrate2){
						hertValue = LSouSouCalculate.getHertStrategyValue(_meffCharacter,charas);
						if(_meffCharacter.skillRun && _meffCharacter.member.skill == 4){
							hertValue = 2*hertValue;
							_meffCharacter.skillRun = false;
						}
						if(hertValue > charas.member.troops)hertValue = charas.member.troops;
						charas.member.troops -= hertValue;
						charas.action = LSouSouCharacterS.HERT;
						arr = [];
						hertNum = "-"+hertValue;
						arr[0] = hertNum;
						arr[1] = charas.x + LSouSouObject.sMap.mapCoordinate.x + (charas.width - hertNum.length*20)/2;
						arr[2] = charas.y + LSouSouObject.sMap.mapCoordinate.y;
						arr[3] = 0;
						LSouSouObject.sMap.numList.push(arr);
					}
				}else if(LSouSouObject.sMap.strategy.Type2.toString() == "chaos_1"){
					charas.action = LSouSouCharacterS.HERT;
					charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] = 1;
					charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][1] = 0;
				}else if(LSouSouObject.sMap.strategy.Type2.toString() == "stategy_1"){
					charas.action = LSouSouCharacterS.HERT;
					charas.statusArray[LSouSouCharacterS.STATUS_STATEGY][0] = 1;
					charas.statusArray[LSouSouCharacterS.STATUS_STATEGY][1] = 0;
				}else{
					charas.action = LSouSouCharacterS.UPGRADE;
					if(int(LSouSouObject.sMap.strategy.Status.toString()) == LSouSouCharacterS.STATUS_ATTACK){
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = int(charas.member.attack*0.2);
					}
				}
			}else{
				/**档格*/
			}
			
		}
		public function toChangeStatus(charas:LSouSouCharacterS):void{
			var hitrate:Boolean =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
			var hitValueArray:Array,intStatus:int,numHert:Number;
			if(charas.index == _meffCharacter.targetCharacter.index){
				charas.targetCharacter = _meffCharacter;
				if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
					if(_meffCharacter.member.lv <= charas.member.lv){
						_meffCharacter.member.setWeaponExp(3);
					}else{
						_meffCharacter.member.setWeaponExp(2);
					}
				}
				getExp(charas);
			}
			if(hitrate){
				charas.setReturnAction(LSouSouCharacterS.DOWN + charas.direction);
				intStatus = int(LSouSouObject.sMap.strategy.Status.toString());
				numHert = Number(LSouSouObject.sMap.strategy.Hert.toString());
				hitValueArray = [];
				hitValueArray[LSouSouCharacterS.STATUS_ATTACK] = int(charas.member.attack*numHert);
				hitValueArray[LSouSouCharacterS.STATUS_DEFENSE] = int(charas.member.defense*numHert);
				hitValueArray[LSouSouCharacterS.STATUS_BREAKOUT] = int(charas.member.breakout*numHert);
				hitValueArray[LSouSouCharacterS.STATUS_MORALE] = int(charas.member.morale*numHert);
				hitValueArray[LSouSouCharacterS.STATUS_SPIRIT] = int(charas.member.spirit*numHert);
				if(LSouSouObject.sMap.strategy.Belong.toString() == "1"){
					
					charas.action = LSouSouCharacterS.HERT;
					charas.statusArray[intStatus][0] = 1;
					charas.statusArray[intStatus][1] = 0;
					charas.statusArray[intStatus][2] = -hitValueArray[intStatus];
				}else{
					charas.action = LSouSouCharacterS.UPGRADE;
					charas.statusArray[intStatus][0] = 1;
					charas.statusArray[intStatus][1] = 0;
					charas.statusArray[intStatus][2] = hitValueArray[intStatus];
				}
			}else{
				/**档格*/
			}
			
		}
		public function toAdd(charas:LSouSouCharacterS):void{
			var hitrate:Boolean = LSouSouCalculate.getHitrateRestoration(_meffCharacter,charas);
			if(charas.index == _meffCharacter.targetCharacter.index){
				charas.targetCharacter = _meffCharacter;
				if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
					if(_meffCharacter.member.lv <= charas.member.lv){
						_meffCharacter.member.setWeaponExp(3);
					}else{
						_meffCharacter.member.setWeaponExp(2);
					}
				}
				getExp(charas);
			}
			
			if(hitrate){
				charas.setReturnAction(LSouSouCharacterS.DOWN + charas.direction);
				/**计算补给值*/
				var addValue:int;
				if(LSouSouObject.sMap.strategy.Hert.toString() == "hp_1"){
					addValue = _meffCharacter.member.spirit/10 + 40;
				}
				
				
				if(_meffCharacter.skillRun && _meffCharacter.member.skill == 4){
					addValue = addValue*2;
					_meffCharacter.skillRun = false;
				}
				if(addValue > charas.member.maxTroops - charas.member.troops)addValue = charas.member.maxTroops - charas.member.troops;
				charas.member.troops += addValue;
				charas.action = LSouSouCharacterS.UPGRADE;
				var arr:Array = [];
				var addNum:String = "+"+addValue;
				arr[0] = addNum;
				arr[1] = charas.x + LSouSouObject.sMap.mapCoordinate.x + (charas.width - addNum.length*20)/2;
				arr[2] = charas.y + LSouSouObject.sMap.mapCoordinate.y;
				arr[3] = 0;
				LSouSouObject.sMap.numList.push(arr);
			}else{
				/**档格*/
			}
			
		}
		public function getExp(charas:LSouSouCharacterS):void{
			var exp_up:int;
			var lv_up:int = _meffCharacter.member.lv - charas.member.lv;
			if(lv_up > 0){
				exp_up = 8 - lv_up;
			}else{
				exp_up = 8 - lv_up*2;
			}
			
			if(exp_up<1)exp_up=1;
			_meffCharacter.member.exp += exp_up;
			if(_meffCharacter.member.exp == 100 && _meffCharacter.member.lv < 50){
				_meffCharacter.member.lvUp();
				var arr:Array = [];
				arr[0] = "lv+1";
				arr[1] = _meffCharacter.x + LSouSouObject.sMap.mapCoordinate.x + (_meffCharacter.width - (arr[0] as String).length*20)/2;
				arr[2] = _meffCharacter.y + LSouSouObject.sMap.mapCoordinate.y;
				arr[3] = 0;
				LSouSouObject.sMap.numList.push(arr);
			}
		}
		public function toHert(charas:LSouSouCharacterS):void{
			var hitrate:Boolean = LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
			
			if(hitrate){
				/**攻击*/
				if(charas.index == _meffCharacter.targetCharacter.index){
					charas.targetCharacter = _meffCharacter;
					if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
						if(_meffCharacter.member.lv <= charas.member.lv){
							_meffCharacter.member.setWeaponExp(3);
						}else{
							_meffCharacter.member.setWeaponExp(2);
						}
					}
					getExp(charas);
				}
				if(charas.member.lv <= _meffCharacter.member.lv){
					charas.member.setEquipmentExp(4);
				}else{
					charas.member.setEquipmentExp(3);
				}
				
				charas.setReturnAction(charas.action);
				/**计算伤害值*/
				var hertValue:int = LSouSouCalculate.getHertStrategyValue(_meffCharacter,charas);
				
				
				if(_meffCharacter.skillRun && _meffCharacter.member.skill == 4){
					hertValue = 2*hertValue;
					_meffCharacter.skillRun = false;
				}
				if(hertValue > charas.member.troops)hertValue = charas.member.troops;
				charas.member.troops -= hertValue;
				charas.action = LSouSouCharacterS.HERT;
				var arr:Array = [];
				var hertNum:String = "-"+hertValue;
				arr[0] = hertNum;
				arr[1] = charas.x + LSouSouObject.sMap.mapCoordinate.x + (charas.width - hertNum.length*20)/2;
				arr[2] = charas.y + LSouSouObject.sMap.mapCoordinate.y;
				arr[3] = 0;
				LSouSouObject.sMap.numList.push(arr);
			}else{
				/**档格*/
				if(charas.index == _meffCharacter.targetCharacter.index){
					charas.targetCharacter = _meffCharacter;
					if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
						if(_meffCharacter.member.lv <= charas.member.lv){
							_meffCharacter.member.setWeaponExp(3);
						}else{
							_meffCharacter.member.setWeaponExp(2);
						}
					}
					getExp(charas);
				}
			}
			
		}
	}
}