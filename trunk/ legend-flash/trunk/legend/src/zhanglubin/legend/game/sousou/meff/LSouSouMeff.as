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
			/**
			if(_meffCharacter.belong == LSouSouObject.BELONG_SELF || _meffCharacter.belong == LSouSouObject.BELONG_FRIEND){
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
			}*/
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
			var nodeStr:String;
			var nodeArr:Array;
			var ax:int,ay:int;
			for each(nodeStr in LSouSouObject.sMap.strategy.Att.elements()){
				nodeArr = nodeStr.split(",");
				charas = _charalist[(_meffCharacter.targetCharacter.locationX + int(nodeArr[0])) + "," + (_meffCharacter.targetCharacter.locationY + int(nodeArr[1]))];
				trace("LSouSouMeff setImage charas = " + charas);
				if(!charas)continue;
				
				this._animation = new LAnimation(_dataArray);
				this._animation.rowIndex = 0;
				this._animation.run(LAnimation.POSITIVE);
				this.bitmapData = this._animation.dataBMP;
				ax = (_meffCharacter.targetCharacter.width - bitmapData.width)/2 + nodeArr[0]*LSouSouObject.sMap._nodeLength;
				ay = (_meffCharacter.targetCharacter.height - bitmapData.height)/2 + nodeArr[1]*LSouSouObject.sMap._nodeLength;
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
						LSouSouObject.sMap.strategy.Type.toString() == "3"){
						toHert(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "4"){
						toAdd(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "5"){
						toChangeStatus(arr[1]);
					}else if(LSouSouObject.sMap.strategy.Type.toString() == "6"){
						toChangeStatus2(arr[1]);
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
		public function toChangeStatus2(charas:LSouSouCharacterS):void{
			var hitrate:Boolean =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
			var hitrate2:Boolean =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
			
			if(hitrate){
				charas.setReturnAction(LSouSouCharacterS.DOWN + charas.direction);
				if(LSouSouObject.sMap.strategy.Type2.toString() == "poison_1"){
					charas.action = LSouSouCharacterS.HERT;
					if(int(LSouSouObject.sMap.strategy.Status.toString()) == LSouSouCharacterS.STATUS_ATTACK){
						charas.statusArray[LSouSouCharacterS.STATUS_POISON][0] = 1;
						charas.statusArray[LSouSouCharacterS.STATUS_POISON][1] = 0;
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(charas.member.attack*0.2);
					}
					if(hitrate2){
						var hertValue:int = LSouSouCalculate.getHertStrategyValue(_meffCharacter,charas);
					}
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
				if(charas.index == _meffCharacter.targetCharacter.index){
					charas.targetCharacter = _meffCharacter;
					if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
						if(_meffCharacter.member.lv <= charas.member.lv){
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 3;
						}else{
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 2;
						}
					}
				}
			}
			
		}
		public function toChangeStatus(charas:LSouSouCharacterS):void{
			var hitrate:Boolean =LSouSouCalculate.getHitrateStrategy(_meffCharacter,charas);
			
			if(hitrate){
				charas.setReturnAction(LSouSouCharacterS.DOWN + charas.direction);
				if(LSouSouObject.sMap.strategy.Belong.toString() == "1"){
					
					charas.action = LSouSouCharacterS.HERT;
					if(int(LSouSouObject.sMap.strategy.Status.toString()) == LSouSouCharacterS.STATUS_ATTACK){
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
						charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(charas.member.attack*0.2);
					}
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
				if(charas.index == _meffCharacter.targetCharacter.index){
					charas.targetCharacter = _meffCharacter;
					if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
						if(_meffCharacter.member.lv <= charas.member.lv){
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 3;
						}else{
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 2;
						}
					}
				}
			}
			
		}
		public function toAdd(charas:LSouSouCharacterS):void{
			var hitrate:Boolean = LSouSouCalculate.getHitrateRestoration(_meffCharacter,charas);
			
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
				if(charas.index == _meffCharacter.targetCharacter.index){
					charas.targetCharacter = _meffCharacter;
					if(int(_meffCharacter.member.weapon) > 0 && int(LSouSouObject.item["Child"+_meffCharacter.member.weapon].Spirit.@add) > 0){
						if(_meffCharacter.member.lv <= charas.member.lv){
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 3;
						}else{
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 2;
						}
					}
				}
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
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 3;
						}else{
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 2;
						}
					}
				}
				if(charas.member.lv <= _meffCharacter.member.lv){
					charas.member.equipment.@exp = int(_meffCharacter.member.equipment.@exp.toString()) + 4;
				}else{
					charas.member.equipment.@exp = int(_meffCharacter.member.equipment.@exp.toString()) + 3;
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
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 3;
						}else{
							_meffCharacter.member.weapon.@exp = int(_meffCharacter.member.weapon.@exp.toString()) + 2;
						}
					}
				}
			}
			
		}
	}
}