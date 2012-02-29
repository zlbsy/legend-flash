package zhanglubin.legend.game.sousou.character
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.xml.XMLDocument;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.character.characterS.LSouSouCharacterSAI;
	import zhanglubin.legend.game.sousou.meff.LSouSouMeff;
	import zhanglubin.legend.game.sousou.meff.LSouSouMeffShow;
	import zhanglubin.legend.game.sousou.meff.LSouSouSkill;
	import zhanglubin.legend.game.sousou.object.LSouSouCalculate;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.sousou.object.LSouSouSMapMethod;
	import zhanglubin.legend.game.sousou.script.LSouSouSMapScript;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.objects.LAnimation;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouCharacterS extends LSouSouCharacter
	{
		private var SPEED:int = 3;
		
		
		/**站立*/
		public static const DOWN:int = 0;
		/**站立*/
		public static const LEFT:int = 1;
		/**站立*/
		public static const UP:int = 2;
		/**站立*/
		public static const RIGHT:int = 3;
		/**移动*/
		public static const MOVE_DOWN:int = 4;
		/**移动*/
		public static const MOVE_LEFT:int = 5;
		/**移动*/
		public static const MOVE_UP:int = 6;
		/**移动*/
		public static const MOVE_RIGHT:int = 7;
		/**攻击*/
		public static const ATK_DOWN:int = 8;
		/**攻击*/
		public static const ATK_LEFT:int = 9;
		/**攻击*/
		public static const ATK_UP:int = 10;
		/**攻击*/
		public static const ATK_RIGHT:int = 11;
		/**档格*/
		public static const BLOCK_DOWN:int = 12;
		/**档格*/
		public static const BLOCK_LEFT:int = 13;
		/**档格*/
		public static const BLOCK_UP:int = 14;
		/**档格*/
		public static const BLOCK_RIGHT:int = 15;
		/**攻击预备*/
		public static const ATKPREPARE_DOWN:int = 16;
		/**攻击预备*/
		public static const ATKPREPARE_LEFT:int = 17;
		/**攻击预备*/
		public static const ATKPREPARE_UP:int = 18;
		/**攻击预备*/
		public static const ATKPREPARE_RIGHT:int = 19;
		/**受伤*/
		public static const HERT:int = 20;
		/**升级*/
		public static const UPGRADE:int = 21;
		/**喘气*/
		public static const PANT:int = 22;
		/**死亡*/
		public static const DIE:int = 23;
		/**阵亡*/
		public static const KILLED:int = 24;
		/**转圈*/
		public static const PANIC:int = 25;
		
		/**主动攻击*/
		public static const COMMAND_INITIATIVE:int = 0;
		/**被动攻击*/
		public static const COMMAND_PASSIVE:int = 1;
		/**原地防守*/
		public static const COMMAND_STAND_DEFENSE:int = 2;
		
		
		public static const MODE_NONE:String = "";
		public static const MODE_STOP:String = "stop";
		public static const MODE_ATTACK:String = "attack";
		public static const MODE_STRATEGY_ATTACK:String = "strategy_attack";
		public static const MODE_PROPS:String = "props";
		public static const MODE_BREAKOUT:String = "breakout";
		
		private var _speed:int = 0;
		private var _saveAction:int;
		
		private var _member:LSouSouMember;
		/**
		 *所属 （0我方，1敌方，-1友方）
		 **/
		private var _belong:int;
		
		private var _data:BitmapData;
		private var _bitmap:LBitmap;
		//private var _index:int;
		private var _dataArray:Array;
		private var _animation:LAnimation;
		private var _mode:int = LAnimation.POSITIVE;
		private var _direction:int = 0;
		private var _path:Array;
		private var _tagerCoordinate:LCoordinate;
		private var _ismoving:Boolean;
		private var _targetCharacter:LSouSouCharacterS;
		private var _pointList:Vector.<Point>;
		private var _action_mode:String;
		/**人工智能*/
		private var _aiIntelligent:Boolean;
		private var _charalist:Array;
		private var _attackNumber:int;
		private var _attackIndex:int;
		private var _breakoutIndex:int;
		private var _breakoutNumber:int;
		private var _targetArray:Array;
		private var _aiForStrategy:Object;
		private var _status:int = 0;
		private var _skillRun:Boolean;
		private var isCanBreakout:Boolean;
		private var _skillViewOver:Boolean;
		/**武将状态 普通*/
		//public static const STATUS_NORMAL:int = 0;
		/**武将状态 混乱*/
		public static const STATUS_CHAOS:int = 0;
		/**武将状态 定身*/
		public static const STATUS_FIXED:int = 1;
		/**武将状态 中毒*/
		public static const STATUS_POISON:int = 2;
		/**武将状态 禁咒*/
		public static const STATUS_STATEGY:int = 3;
		/**武将状态 攻击加成*/
		public static const STATUS_ATTACK:int = 4;
		/**武将状态 精神加成*/
		public static const STATUS_SPIRIT:int = 5;
		/**武将状态 防御加成*/
		public static const STATUS_DEFENSE:int = 6;
		/**武将状态 爆发加成*/
		public static const STATUS_BREAKOUT:int = 7;
		/**武将状态 士气加成*/
		public static const STATUS_MORALE:int = 8;
		/**武将状态 移动加成*/
		public static const STATUS_MOVE:int = 9;
		/**武将状态 怯力*/
		public static const STATUS_NOATK:int = 10;
		/**
		 * 武将状态
		 * 0混乱[状态，回合数，图片]
		 * 1定身[状态，回合数，图片] 
		 * 2中毒[状态，回合数，图片] 
		 * 3禁咒[状态，回合数，图片] 
		 * 4攻击加成[状态，回合数，加成数值]
		 * 5精神加成[状态，回合数，加成数值]
		 * 6防御加成[状态，回合数，加成数值]
		 * 7爆发加成[状态，回合数，加成数值]
		 * 8士气加成[状态，回合数，加成数值]
		 * 9士气加成[状态，回合数，移动数值]
		 * 10怯力[状态，回合数，图片] 
		 * */
		private var _statusArray:Array = [
			[0,0,"chaos_sign"],
			[0,0,"fixed_sign"],
			[0,0,"poison_sign"],
			[0,0,"stategy_sign"],
			[0,0,0],
			[0,0,0],
			[0,0,0],
			[0,0,0],
			[0,0,0],
			[0,0,0],
			[0,0,"fixed_sign"]];
		/**不良状态用index*/
		private var _statusIndex:Number = 0;
		/**不良状态描画位置x坐标*/
		private var _statusX:int = 0;
		/**行动方针[0主动出击，1被动出击，2原地防守]*/
		private var _command:int;
		/**
		 * 行动是否进行中
		 * */
		private var _isActionRun:Boolean;
		public function LSouSouCharacterS(mbr:LSouSouMember,belongInt:int,direct:int,comm:int)
		{
			super();
			this._member = mbr;
			this._belong = belongInt;
			this._direction = direct;
			this._command = comm;
			
			if(LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] == LSouSouObject.FAST){
				this.SPEED = 2;
			}else{
				this.SPEED = 3;
			}
			
			setImage();
		}
		/**
		 * 将人物数据化返回
		 */
		public function getSaveData():XML{
			var xmldata:XML =  new XML("<charas></charas>");
			xmldata.index = this.index;
			xmldata.belong = this.belong;
			xmldata.visible = this.visible;
			xmldata.mode = this.mode;
			xmldata.direction = this.direction;
			xmldata.action_mode = this.action_mode;
			xmldata.x = this.x;
			xmldata.y = this.y;
			xmldata.action = this.action;
			xmldata.command = this.command;
			
			xmldata.status = new XMLList();
			xmldata.status.chaos = _statusArray[LSouSouCharacterS.STATUS_CHAOS];
			xmldata.status.fixed = _statusArray[LSouSouCharacterS.STATUS_FIXED];
			xmldata.status.poison = _statusArray[LSouSouCharacterS.STATUS_POISON];
			xmldata.status.stategy = _statusArray[LSouSouCharacterS.STATUS_STATEGY];
			xmldata.status.attack = _statusArray[LSouSouCharacterS.STATUS_ATTACK];
			xmldata.status.spirit = _statusArray[LSouSouCharacterS.STATUS_SPIRIT];
			xmldata.status.defense = _statusArray[LSouSouCharacterS.STATUS_DEFENSE];
			xmldata.status.breakout = _statusArray[LSouSouCharacterS.STATUS_BREAKOUT];
			xmldata.status.morale = _statusArray[LSouSouCharacterS.STATUS_MORALE];
			xmldata.status.move = _statusArray[LSouSouCharacterS.STATUS_MOVE];
			xmldata.status.noatk = _statusArray[LSouSouCharacterS.STATUS_NOATK];
			
			xmldata.appendChild(this.member.data);
			return xmldata;
		}
		public function get skillRun():Boolean
		{
			return _skillRun;
		}

		public function set skillRun(value:Boolean):void
		{
			_skillRun = value;
		}

		public function set runspeed(value:int):void{
			SPEED = value;
		}
		public function get command():int
		{
			return _command;
		}

		public function set command(value:int):void
		{
			_command = value;
		}

		public function get statusArray():Array
		{
			return _statusArray;
		}

		public function set statusArray(value:Array):void
		{
			_statusArray = value;
		}
		
		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function get aiForStrategy():Object
		{
			return _aiForStrategy;
		}

		public function set aiForStrategy(value:Object):void
		{
			_aiForStrategy = value;
		}

		public function get animation():LAnimation
		{
			return _animation;
		}

		public function get attackIndex():int
		{
			return _attackIndex;
		}

		public function set attackIndex(value:int):void
		{
			_attackIndex = value;
		}

		public function get attackNumber():int
		{
			return _attackNumber;
		}

		public function set attackNumber(value:int):void
		{
			_attackNumber = value;
		}

		public function get member():LSouSouMember
		{
			return _member;
		}

		public function set member(value:LSouSouMember):void
		{
			_member = value;
		}
		
		/**
		 *人物智能AI
		 */
		public function ai():void{
			LSouSouObject.sMap.setDetails(this.member.name + "行动");
			LSouSouObject.charaSNow = this;
			LSouSouSMapMethod.setLocation(true);
			if(_statusArray[LSouSouCharacterS.STATUS_CHAOS][0] > 0){
				toActionEnd();
				return;
			}
			_aiIntelligent = true;
			var obj:Object;
			//obj = getAttTarget();
			obj = LSouSouCharacterSAI.getAttTarget(this);
			if(obj == null){
				toActionEnd();
				return;
			}else if(obj.nodeparent == null){
				LSouSouObject.sMap.moveToCoordinate(0,0,new LCoordinate(obj.mx,obj.my));
				return;
			}
			
			this._targetCharacter = obj.charas;
			this._skillViewOver = true;
			this._skillRun = false;
			if(this._aiForStrategy == null)setAttackNumber();
			LSouSouObject.sMap.moveToCoordinate(0,0,new LCoordinate(obj.nodeparent.x,obj.nodeparent.y));
		}
		public function get action_mode():String
		{
			return _action_mode;
		}

		public function set action_mode(value:String):void
		{
			_action_mode = value;
		}

		public function get targetCharacter():LSouSouCharacterS
		{
			return _targetCharacter;
		}

		public function set targetCharacter(value:LSouSouCharacterS):void
		{
			_targetCharacter = value;
		}
		/**
		 *所属 （0我方，1敌方，-1友方）
		 **/
		public function get belong():int
		{
			return _belong;
		}
		public function set belong(value:int):void
		{
			_belong = value;
		}
		public function get rangeAttack():XMLList{
			return this._member.rangeAttack;
		}

		public function get ismoving():Boolean
		{
			return _ismoving;
		}
		
		public function set ismoving(value:Boolean):void
		{
			_ismoving = value;
		}
		
		public function get path():Array
		{
			return _path;
		}
		
		public function set path(value:Array):void
		{
			_path = value;
		}
		
		public function get tagerCoordinate():LCoordinate
		{
			return _tagerCoordinate;
		}
		
		public function set tagerCoordinate(value:LCoordinate):void
		{
			_tagerCoordinate = value;
		}
		
		public function get index():int
		{
			return this._member.index;
		}
		public function get arms():int{
			return this._member.arms;
		}
		/**
		 *设定人物明暗度
		 */
		public function colorTrans(value:int):void{
			this.bitmapData = this._animation.dataBMP.clone();
			var color:ColorTransform = this.transform.colorTransform;
			color.redOffset = value;
			color.greenOffset = value;
			color.blueOffset = value;
			this.bitmapData.draw(this.bitmapData,null,color,null,new Rectangle(0,0,this.width,this.height));
		}
		/**
		 *贞
		 */
		public function onFrame():void{
			move();
			if(!(_speed++ % SPEED == 0) && this.action != LSouSouCharacterS.PANIC)return;
			_speed -= SPEED;
			this._animation.run(_mode);
			this.bitmapData = this._animation.dataBMP;
			
			if(_action_mode == LSouSouCharacterS.MODE_ATTACK || _action_mode == LSouSouCharacterS.MODE_BREAKOUT)toAttackTargets();
			else if(_action_mode == LSouSouCharacterS.MODE_STRATEGY_ATTACK)toStrategyAttackTargets();
			
			setStatusX();
		}
		public function setStatusX():void{
			//if(index == 35)trace("_statusIndex = " + _statusIndex);
			_statusIndex += 0.25;
			if(_statusIndex % 0.5 == 0){
				if(_statusX == 0){
					_statusX = 30;
				}else{
					_statusX = 0;
				}
			}
			if(_statusIndex >= _statusArray.length){
				_statusIndex = 0;
				return;
			}
			if(_statusArray[int(_statusIndex)][0] == 0)setStatusX();
		}
		/**
		 * 状态恢复
		 * */
		public function resume():void{
			var resumeArray:Array = [20,40,60,80];
			var i:int;
			var num:int;
			for(i=0;i<_statusArray.length;i++){
				if(_statusArray[i][0] == 0)continue;
				if(_statusArray[i][1] > resumeArray.length - 1){
					num = 80;
				}else{
					num = resumeArray[_statusArray[i][1]];
					_statusArray[i][1] += 1;
				}
				if(Math.random()*100 < num){
					_statusArray[i][0] = 0;
					_statusArray[i][1] = 0;
					if(_statusArray[i][2] is int)_statusArray[i][2] = 0;
				}
			}
			//如果中毒，则中毒状态处理
			this.poison_run();
			if(this.member.troops < this.member.maxTroops){
				var arr:Array;
				var addValue:int;
				var addNum:String;
				if(LSouSouObject.sMap.mapData[this.locationY][this.locationX] == 5){
					addValue = int(this.member.maxTroops*0.2);
					if(addValue > this.member.maxTroops - this.member.troops)addValue=this.member.maxTroops - this.member.troops;
					this.member.troops += addValue;
					arr = [];
					addNum = "+"+addValue;
					arr[0] = addNum;
					arr[1] = this.x + LSouSouObject.sMap.mapCoordinate.x + (this.width - addNum.length*20)/2;
					arr[2] = this.y + LSouSouObject.sMap.mapCoordinate.y;
					arr[3] = 0;
					LSouSouObject.sMap.numList.push(arr);
				}else if(LSouSouObject.sMap.mapData[this.locationY][this.locationX] == 7){
					addValue = int(this.member.maxTroops*0.1);
					if(addValue > this.member.maxTroops - this.member.troops)addValue=this.member.maxTroops - this.member.troops;
					this.member.troops += addValue;
					arr = [];
					addNum = "+"+addValue;
					arr[0] = addNum;
					arr[1] = this.x + LSouSouObject.sMap.mapCoordinate.x + (this.width - addNum.length*20)/2;
					arr[2] = this.y + LSouSouObject.sMap.mapCoordinate.y;
					arr[3] = 0;
					LSouSouObject.sMap.numList.push(arr);
				}
			}
		}
		/**
		 *中毒状态每回合掉血
		 * */
		public function poison_run():void{
			if(this._statusArray[LSouSouCharacterS.STATUS_POISON][0] == 0)return;
			if(this.member.troops > 1){
				var arr:Array;
				var addValue:int;
				var addNum:String;
				addValue = int(this.member.maxTroops*0.1);
				if(addValue > this.member.troops - 1)addValue=this.member.troops - 1;
				this.member.troops -= addValue;
				arr = [];
				addNum = "-"+addValue;
				arr[0] = addNum;
				arr[1] = this.x + LSouSouObject.sMap.mapCoordinate.x + (this.width - addNum.length*20)/2;
				arr[2] = this.y + LSouSouObject.sMap.mapCoordinate.y;
				arr[3] = 0;
				LSouSouObject.sMap.numList.push(arr);
			}
		}
		/**
		 *不良状态描画
		 * */
		public function drawStatus():BitmapData{
			//if(index == 35)trace("drawStatus _statusIndex = " + _statusIndex);
			var returnBitmapdata:BitmapData;
			if(_statusArray[int(_statusIndex)][0] > 0 && _statusArray[int(_statusIndex)][2] is String){
				//returnBitmapdata = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],_statusArray[int(_statusIndex)][2]);
				returnBitmapdata = LSouSouObject.meffImg[_statusArray[int(_statusIndex)][2]];
			}
			
			return returnBitmapdata;
		}
		public function get statusX():int{
			return _statusX;
		}
		/**
		 *攻击动作
		 */
		public function toStrategyAttackTargets():void{
			if(this._animation.currentframe == 1 && !_isActionRun){
				_isActionRun = true;
				LSouSouObject.sMap.meff = new LSouSouMeff(LSouSouObject.sMap.strategy,this);

			}else if(this._animation.currentframe == 3){
				this._animation.currentframe -= 1;
			}
		}
		/**
		 *攻击动作
		 */
		public function toAttackTargets():void{
			if(this.member.troops == 0 || !this._targetCharacter)return;
			var self:LSouSouCharacterS = this;
			var charas:LSouSouCharacterS;
			if(this._animation.currentframe == 0){
				if(_breakoutIndex++ < _breakoutNumber){
					this._animation.currentframe = -1;
					this._action_mode = LSouSouCharacterS.MODE_BREAKOUT;
				}else{
					this._action_mode = LSouSouCharacterS.MODE_ATTACK;
				}
			}else if(this._animation.currentframe == 2){
				_charalist = new Array();
				if(this.belong == LSouSouObject.BELONG_SELF || this.belong == LSouSouObject.BELONG_FRIEND){
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
				_targetArray = new Array();
				var skill_index:int,i:int;
				var skill_charaList:Array;
				var anime:LSouSouMeffShow;
				//特技测试
				var skill_chara:LSouSouCharacterS;
				if(_skillRun && this.member.skill == 2){
					//隔山打牛
					skill_charaList = new Array();
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY));
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY + 1));
					
					charas = _charalist[(targetCharacter.locationX) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX) + "," + (targetCharacter.locationY + 1));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY + 1));
					
					if(skill_charaList.length > 0){
						skill_index = int(Math.random()*skill_charaList.length);
						for(i=0;i<skill_charaList.length;i++){
							if((i == skill_index) || Math.random() < 0.3){
								skill_chara = _charalist[skill_charaList[i]];
								toAttackTarget(skill_chara);
							}
						}
						
					}
					_skillRun = false;
				}else if(_skillRun && this.member.skill == 5){
					//天下无双
					skill_charaList = new Array();
					
					targetCharacter.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
					targetCharacter.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
					targetCharacter.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(targetCharacter.member.attack*0.2);
					anime = new LSouSouMeffShow(targetCharacter.x,targetCharacter.y,LSouSouObject.strategy["Strategy100"]);
					LSouSouObject.sMap.meffShowList.push(anime);
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY));
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY + 1));
					
					charas = _charalist[(targetCharacter.locationX) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX) + "," + (targetCharacter.locationY + 1));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY + 1));
					
					if(skill_charaList.length > 0){
						skill_index = int(Math.random()*skill_charaList.length);
						for(i=0;i<skill_charaList.length;i++){
							if((i == skill_index) || Math.random() < 0.2){
								skill_chara = _charalist[skill_charaList[i]];
								skill_chara.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
								skill_chara.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
								skill_chara.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(skill_chara.member.attack*0.2);
								
								
								anime = new LSouSouMeffShow(skill_chara.x,skill_chara.y,LSouSouObject.strategy["Strategy100"]);
								LSouSouObject.sMap.meffShowList.push(anime);
							}
						}
						
					}
					_skillRun = false;
				}else if(_skillRun && this.member.skill == 6){
					//幻影银枪
					skill_charaList = new Array();
					
					targetCharacter.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
					targetCharacter.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
					targetCharacter.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(targetCharacter.member.attack*0.2);
					anime = new LSouSouMeffShow(targetCharacter.x,targetCharacter.y,LSouSouObject.strategy["Strategy100"]);
					LSouSouObject.sMap.meffShowList.push(anime);
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY - 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY - 1));
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY));
					
					charas = _charalist[(targetCharacter.locationX - 1) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX - 1) + "," + (targetCharacter.locationY + 1));
					
					charas = _charalist[(targetCharacter.locationX) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX) + "," + (targetCharacter.locationY + 1));
					
					charas = _charalist[(targetCharacter.locationX + 1) + "," + (targetCharacter.locationY + 1)];
					if(charas && charas.member.troops > 0)skill_charaList.push((targetCharacter.locationX + 1) + "," + (targetCharacter.locationY + 1));
					
					if(skill_charaList.length > 0){
						skill_index = int(Math.random()*skill_charaList.length);
						var status_index : int;
						var status_arr:Array;
						for(i=0;i<skill_charaList.length;i++){
							skill_chara = _charalist[skill_charaList[i]];
							status_index = int(skill_chara.statusArray.length*Math.random());
							switch(status_index){
								case LSouSouCharacterS.STATUS_CHAOS:
									skill_chara.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] = 1;
									skill_chara.statusArray[LSouSouCharacterS.STATUS_CHAOS][1] = 0;
									
									anime = new LSouSouMeffShow(skill_chara.x,skill_chara.y,LSouSouObject.strategy["Strategy100"]);
									LSouSouObject.sMap.meffShowList.push(anime);
									break;
								case LSouSouCharacterS.STATUS_FIXED:
									skill_chara.statusArray[LSouSouCharacterS.STATUS_FIXED][0] = 1;
									skill_chara.statusArray[LSouSouCharacterS.STATUS_FIXED][1] = 0;
									
									anime = new LSouSouMeffShow(skill_chara.x,skill_chara.y,LSouSouObject.strategy["Strategy100"]);
									LSouSouObject.sMap.meffShowList.push(anime);
									break;
								case LSouSouCharacterS.STATUS_ATTACK:
									skill_chara.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
									skill_chara.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
									skill_chara.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(skill_chara.member.attack*0.2);
									
									anime = new LSouSouMeffShow(skill_chara.x,skill_chara.y,LSouSouObject.strategy["Strategy100"]);
									LSouSouObject.sMap.meffShowList.push(anime);
									break;
								case LSouSouCharacterS.STATUS_DEFENSE:
									skill_chara.statusArray[LSouSouCharacterS.STATUS_DEFENSE][0] = 1;
									skill_chara.statusArray[LSouSouCharacterS.STATUS_DEFENSE][1] = 0;
									skill_chara.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2] = -int(skill_chara.member.defense*0.2);
									
									anime = new LSouSouMeffShow(skill_chara.x,skill_chara.y,LSouSouObject.strategy["Strategy101"]);
									LSouSouObject.sMap.meffShowList.push(anime);
									break;
							}
						}
						
					}
					_skillRun = false;
				}
				
				for each(nodeStr in this.member.rangeAttackTarget){
					nodeArr = nodeStr.split(",");
					charas = _charalist[(targetCharacter.locationX + int(nodeArr[0])) + "," + (targetCharacter.locationY + int(nodeArr[1]))];
					if(skill_chara && charas && skill_chara.index == charas.index)continue;
					if(charas)toAttackTarget(charas);
				}
				
			}
		}
		public function toAttackTarget(charas:LSouSouCharacterS):void{
			trace("toAttackTarget ",this.index,charas.index);
			_targetArray.push(charas);
			var hitrate:Boolean = LSouSouCalculate.getHitrate(this,charas);
			var lv_up:int;
			var exp_up:int;
			var arr:Array;
			if(hitrate){
				if(charas.index == this.targetCharacter.index){
					if(_breakoutNumber){
						LSouSouObject.sound.play("Se36");
					}else{
						LSouSouObject.sound.play("Se35");
					}
					charas.targetCharacter = this;
					if(int(this.member.weapon) > 0 && int(LSouSouObject.item["Child"+this.member.weapon].Attack.@add) > 0){
						if(this.member.lv <= charas.member.lv){
							this.member.weapon.@exp = int(this.member.weapon.@exp.toString()) + 3;
						}else{
							this.member.weapon.@exp = int(this.member.weapon.@exp.toString()) + 2;
						}
					}
					lv_up = this.member.lv - charas.member.lv;
					if(lv_up > 0){
						exp_up = 8 - lv_up;
					}else{
						exp_up = 8 - lv_up*2;
					}
					if(exp_up<1)exp_up=1;
					this.member.exp += exp_up;
				}
				if(charas.member.lv <= this.member.lv){
					charas.member.equipment.@exp = int(this.member.equipment.@exp.toString()) + 4;
				}else{
					charas.member.equipment.@exp = int(this.member.equipment.@exp.toString()) + 3;
				}
				/**攻击*/
				//charas.setReturnAction(charas.action);
				/**计算伤害值*/
				var hertValue:int = LSouSouCalculate.getHertValue(this,charas);
				if(_breakoutNumber)hertValue = int(hertValue*1.2);
				if(this.belong != LSouSouObject.charaSNow.belong)hertValue = int(hertValue*0.75);
				if(hertValue >= charas.member.troops){
					hertValue = charas.member.troops;
					this.member.exp += 3*exp_up;
				}
				
				var skillXml:XMLList;
				//特技测试
				if(charas.member.skill>0){
					skillXml = LSouSouObject.skill["Skill"+charas.member.skill];
					
					if(int(skillXml.Type.toString()) == 1){
						var skillvalue:int = int(Math.random()*100);
						switch(charas.member.skill){
							case 1:
								if(skillvalue < int(skillXml.Probability.toString())){
									LSouSouObject.sMap.setDetails(this.member.name + "特技["+skillXml.Name+"]发动");
									hertValue = 0;
								}
								break;
							default:
						}
					}
				}
				charas.member.troops -= hertValue;
				charas.action = LSouSouCharacterS.HERT;
				arr = [];
				var hertNum:String = "-"+hertValue;
				arr[0] = hertNum;
				arr[1] = charas.x + LSouSouObject.sMap.mapCoordinate.x + (charas.width - hertNum.length*20)/2;
				arr[2] = charas.y + LSouSouObject.sMap.mapCoordinate.y;
				arr[3] = 0;
				LSouSouObject.sMap.numList.push(arr);
			}else{
				if(charas.index == this.targetCharacter.index){
					if(_breakoutNumber){
						LSouSouObject.sound.play("Se31");
					}else{
						LSouSouObject.sound.play("Se30");
					}
					if(int(this.member.weapon) > 0 && int(LSouSouObject.item["Child"+this.member.weapon].Attack.@add) > 0){
						this.member.weapon.@exp = int(this.member.weapon.@exp.toString()) + 1;
					}
					lv_up = this.member.lv - charas.member.lv;
					if(lv_up > 0){
						exp_up = 8 - lv_up;
					}else{
						exp_up = 8 - lv_up*2;
					}
					if(exp_up<1)exp_up=1;
					this.member.exp += exp_up;
					charas.targetCharacter = this;
				}
				charas.member.equipment.@exp = int(this.member.equipment.@exp.toString()) + 1;
				/**档格*/
				if(this.x > charas.x){
					//charas.setReturnAction(LSouSouCharacterS.MOVE_RIGHT);
					charas._animation.rowIndex = LSouSouCharacterS.BLOCK_RIGHT;
				}else if(this.x < charas.x){
					//charas.setReturnAction(LSouSouCharacterS.MOVE_LEFT);
					charas._animation.rowIndex = LSouSouCharacterS.BLOCK_LEFT;
				}else{
					if(this.y > charas.y){
						//charas.setReturnAction(LSouSouCharacterS.MOVE_DOWN);
						charas._animation.rowIndex = LSouSouCharacterS.BLOCK_DOWN;
					}else{
						//charas.setReturnAction(LSouSouCharacterS.MOVE_UP);
						charas._animation.rowIndex = LSouSouCharacterS.BLOCK_UP;
					}
				}
				
			}
			
			if(this.member.exp == 100 && this.member.lv < 50){
				this.member.lvUp();
				arr = [];
				arr[0] = "lv+1";
				arr[1] = this.x + LSouSouObject.sMap.mapCoordinate.x + (this.width - (arr[0] as String).length*20)/2;
				arr[2] = this.y + LSouSouObject.sMap.mapCoordinate.y;
				arr[3] = 0;
				LSouSouObject.sMap.numList.push(arr);
			}
		}
		/**
		 *人物移动
		 */
		public function move():void{
			if(this._path == null)return;
			if(this.x == this._tagerCoordinate.x && this.y == this._tagerCoordinate.y){
				if(this._path.length == 0){
					this._tagerCoordinate = this.xy;
					//if(this._animation.rowIndex >= 4)this._animation.rowIndex -= 4;
					//this._animation.run(_mode);
					//this._mode = LAnimation.CIRCULATION;
					this._path = null;
					dispatchEvent(new LEvent(LEvent.CHARACTER_MOVE_COMPLETE));
					
					return;
				}else{
					if(this.member.armsMoveType == 0){
						LSouSouObject.sound.play("Se24");
					}else{
						LSouSouObject.sound.play("Se23");
					}
					this._tagerCoordinate.x = this._path[0].x*LSouSouObject.sMap.nodeLength;
					this._tagerCoordinate.y = this._path[0].y*LSouSouObject.sMap.nodeLength;
					this._path.shift();
					
				}
				LSouSouSMapMethod.setLocationAtChara(this);
			}
			
			this._mode = LAnimation.POSITIVE;
			if(this.x > this._tagerCoordinate.x){
				this.x -= 8;
				this._animation.rowIndex =	LSouSouCharacterS.MOVE_LEFT
			}else if(this.y < this._tagerCoordinate.y){
				this.y += 8;
				this._animation.rowIndex =	LSouSouCharacterS.MOVE_DOWN;
			}else if(this.y > this._tagerCoordinate.y){
				this.y -= 8;
				this._animation.rowIndex =	LSouSouCharacterS.MOVE_UP;
			}else{
				this.x += 8;
				this._animation.rowIndex =	LSouSouCharacterS.MOVE_RIGHT;
			}
			if(LSouSouObject.sMap.roadList)LSouSouObject.sMap.roadList = null;

		}
		/**
		 *给人物添加图片 
		 */
		private function setImage():void{
			var atk:BitmapData = LSouSouObject.charaATKList[this._member.data["S"]];
			var mov:BitmapData =LSouSouObject.charaMOVList[this._member.data["S"]];
			var spc:BitmapData =LSouSouObject.charaSPCList[this._member.data["S"]];
			/**
			var atk:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["S"],
				this._member.data["S"] + "atk");
			var mov:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["S"],
				this._member.data["S"] + "mov");
			var spc:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["S"],
				this._member.data["S"] + "spc");
				 * */
			var transparent:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"transparent.png");
			var atklist:Array = LImage.divideByCopyPixels(atk,12,1);
			var movlist:Array = LImage.divideByCopyPixels(mov,11,1);
			var spclist:Array = LImage.divideByCopyPixels(spc,5,1);
			_dataArray = new Array();
			_pointList = new Vector.<Point>();
			/*********站立*********/
			//下
			_dataArray.push([movlist[6][0]]);
			_pointList.push(new Point(0,0));
			//左
			_dataArray.push([movlist[8][0]]);
			_pointList.push(new Point(0,0));
			//上
			_dataArray.push([movlist[7][0]]);
			_pointList.push(new Point(0,0));
			//右
			_dataArray.push([LImage.horizontal(movlist[8][0])]);
			_pointList.push(new Point(0,0));
			/*********移動*********/
			//下
			_dataArray.push([movlist[0][0],movlist[1][0]]);
			_pointList.push(new Point(0,0));
			//左
			_dataArray.push([movlist[4][0],movlist[5][0]]);
			_pointList.push(new Point(0,0));
			//上
			_dataArray.push([movlist[2][0],movlist[3][0]]);
			_pointList.push(new Point(0,0));
			//右
			_dataArray.push([LImage.horizontal(movlist[4][0]),LImage.horizontal(movlist[5][0])]);
			_pointList.push(new Point(0,0));
			
			/*********攻击*********/
			//下
			_dataArray.push([atklist[0][0],atklist[0][0],atklist[1][0],atklist[2][0],atklist[3][0]]);
			_pointList.push(new Point(-10,0));
			//左
			_dataArray.push([atklist[8][0],atklist[8][0],atklist[9][0],atklist[10][0],atklist[11][0]]);
			_pointList.push(new Point(0,-10));
			//上
			_dataArray.push([atklist[4][0],atklist[4][0],atklist[5][0],atklist[6][0],atklist[7][0]]);
			_pointList.push(new Point(0,0));
			//右
			_dataArray.push([LImage.horizontal(atklist[8][0]),LImage.horizontal(atklist[8][0]),LImage.horizontal(atklist[9][0]),LImage.horizontal(atklist[10][0]),LImage.horizontal(atklist[11][0])]);
			_pointList.push(new Point(0,-10));
			
			/*********挡格*********/
			//下
			_dataArray.push([spclist[0][0]]);
			_pointList.push(new Point(0,0));
			//左
			_dataArray.push([spclist[2][0]]);
			_pointList.push(new Point(0,0));
			//上
			_dataArray.push([spclist[1][0]]);
			_pointList.push(new Point(0,0));
			//右
			_dataArray.push([LImage.horizontal(spclist[2][0])]);
			_pointList.push(new Point(0,0));
			/**攻击预备*/
			//下
			_dataArray.push([atklist[0][0]]);
			_pointList.push(new Point(-10,0));
			//左
			_dataArray.push([atklist[8][0]]);
			_pointList.push(new Point(0,-10));
			//上
			_dataArray.push([atklist[4][0]]);
			_pointList.push(new Point(0,0));
			//右
			_dataArray.push([LImage.horizontal(atklist[8][0])]);
			_pointList.push(new Point(0,-10));
			
			/*********受伤*********/
			_dataArray.push([spclist[3][0],spclist[3][0]]);
			_pointList.push(new Point(0,0));
			
			/*********升级*********/
			_dataArray.push([spclist[4][0],spclist[4][0],spclist[4][0]]);
			_pointList.push(new Point(0,0));
			
			/*********喘气*********/
			_dataArray.push([movlist[9][0],movlist[9][0],movlist[10][0],movlist[10][0],movlist[9][0],movlist[9][0],movlist[10][0],movlist[10][0]]);
			_pointList.push(new Point(0,0));
			
			/*********死亡*********/
			_dataArray.push([movlist[9][0],transparent,movlist[9][0],transparent,movlist[9][0],transparent,movlist[9][0]]);
			_pointList.push(new Point(0,0));
			
			/*********阵亡*********/
			_dataArray.push([movlist[9][0]]);
			_pointList.push(new Point(0,0));
			
			/*********转圈*********/
			_dataArray.push([movlist[0][0],movlist[1][0],movlist[0][0],movlist[1][0],
				movlist[4][0],movlist[5][0],movlist[4][0],movlist[5][0],
				movlist[2][0],movlist[3][0],movlist[2][0],movlist[3][0],
				LImage.horizontal(movlist[4][0]),LImage.horizontal(movlist[5][0]),LImage.horizontal(movlist[4][0]),LImage.horizontal(movlist[5][0]),
				movlist[0][0],movlist[1][0],movlist[0][0],movlist[1][0]]);
			_pointList.push(new Point(0,0));
			
			this._animation = new LAnimation(_dataArray);
			this._animation.rowIndex = this._direction + 4;
			this._animation.run(this.mode);
			this.bitmapData = this._animation.dataBMP;
		}
		/**
		 *取得人物位置修正
		 */
		public function get point():Point{
			return _pointList[this._animation.rowIndex];
		}
		public function get action():int
		{
			return this._animation.rowIndex;
		}
		
		/**
		 *设定人物动作
		 */
		public function set action(value:int):void
		{
			this._animation.rowIndex = value;
			if(this._animation.rowIndex<LSouSouCharacterS.HERT)_direction = _animation.rowIndex%4;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			//this._mode = LAnimation.CIRCULATION;
		}
		public function get mode():int
		{
			return _mode;
		}
		
		public function set mode(value:int):void
		{
			_mode = value;
		}

		public function get locationX():int{
			return int(this.x/LSouSouObject.sMap.nodeLength);
		}
		public function get locationY():int{
			return int(this.y/LSouSouObject.sMap.nodeLength);
		}
		/**
		 *取得攻击次数
		 */
		public function setAttackNumber():void{
			var self:LSouSouCharacterS = this;
			
			//是否双击
			var doubleatt:Boolean = LSouSouCalculate.getDoubleAtt(this,this._targetCharacter);
			if(doubleatt){
				_attackNumber = 2;
			}else{
				_attackNumber = 1;
			}
			var skillXml:XMLList;
			
			if(this.index == 35)trace("************************************************************************************************this.member.skill = " + this.member.skill);
			
			//特技测试
			if(this.member.skill>0){
				skillXml = LSouSouObject.skill["Skill"+this.member.skill];
				if(int(skillXml.Type.toString()) == 0){
					var skillvalue:int = int(Math.random()*100);
					switch(self.member.skill){
						case 2:
							if(skillvalue < int(skillXml.Probability.toString()))_skillRun = true;
							self._skillViewOver = false;
							break;
						case 3:
							if(skillvalue < int(skillXml.Probability.toString()))_skillRun = true;
							if(_skillRun){
								_attackNumber = 3;
								self._skillViewOver = false;
							}
							break;
						case 5:
							if(skillvalue < int(skillXml.Probability.toString()))_skillRun = true;
							if(_skillRun){
								_attackNumber = 2;
								self._skillViewOver = false;
							}
							break;
						case 6:
							if(skillvalue < int(skillXml.Probability.toString()))_skillRun = true;
							break;
						default:
					}
				}
			}
			
			this._attackIndex = 0;
			this._targetCharacter.attackIndex = 0;
			//是否无反击攻击
			var backAttack:Boolean = false;
			if(backAttack){
				this._targetCharacter.attackNumber = 0;
			}else{
				this._targetCharacter.attackNumber = 1;
			}
		}
		/**
		 *准备攻击，并计算是否爆发攻击
		 */
		public function attackCalculate():void{
			var self:LSouSouCharacterS = this;
			var skillXml:XMLList;
			//特技测试
			if(this.member.skill>0){
				skillXml = LSouSouObject.skill["Skill"+this.member.skill];
			}
			if(_skillRun && int(skillXml.Type.toString()) == 0 && !self._skillViewOver){
				LSouSouObject.sMap.setDetails(this.member.name + "特技["+skillXml.Name+"]发动");
				
				self._skillViewOver = true;
				var anime:LSouSouSkill = new LSouSouSkill(self.toAttackStart);
				LSouSouObject.sMap.skill = anime;
			}else{
				LSouSouObject.sMap.setDetails(this.member.name + "物理攻击");
				self.toAttackStart();
			}
			
		}
		public function toAttackStart():void{
			var self:LSouSouCharacterS = this;
			if(self.member.troops == 0 || !self._targetCharacter)return;
			if(self.x > self.targetCharacter.x){
				self._animation.rowIndex = LSouSouCharacterS.ATK_LEFT;
			}else if(self.x < self.targetCharacter.x){
				self._animation.rowIndex = LSouSouCharacterS.ATK_RIGHT;
			}else{
				if(self.y > self.targetCharacter.y){
					self._animation.rowIndex = LSouSouCharacterS.ATK_UP;
				}else{
					self._animation.rowIndex = LSouSouCharacterS.ATK_DOWN;
				}
			}
			_speed = 0;
			//是否爆发
			self.isCanBreakout = LSouSouCalculate.getFatalAtt(self,self._targetCharacter);
			
			
			self._breakoutIndex = 0;
			if(self.isCanBreakout){
				self._breakoutNumber = 4;
				LSouSouObject.sound.play("Se33");
			}else{
				self._breakoutNumber = 0;
				LSouSouObject.sound.play("Se32");
			}
			self._action_mode = LSouSouCharacterS.MODE_ATTACK;
			self._animation.addEventListener(LEvent.ANIMATION_COMPLETE,self.attackOver);
		}
		public function propsCalculate():void{
			if(this.member.troops == 0 || !this._targetCharacter)return;
			if(this.x > this.targetCharacter.x){
				this._animation.rowIndex = LSouSouCharacterS.ATK_LEFT;
			}else if(this.x < this.targetCharacter.x){
				this._animation.rowIndex = LSouSouCharacterS.ATK_RIGHT;
			}else{
				if(this.y > this.targetCharacter.y){
					this._animation.rowIndex = LSouSouCharacterS.ATK_UP;
				}else{
					this._animation.rowIndex = LSouSouCharacterS.ATK_DOWN;
				}
			}
			_speed = 0;
			_action_mode = LSouSouCharacterS.MODE_PROPS;
			this._animation.addEventListener(LEvent.ANIMATION_COMPLETE,useProps);
		}
		/**
		 *使用道具
		 * 
		 * @param 结束事件
		 */
		private function useProps(event:LEvent):void{
			this._animation.removeEventListener(LEvent.ANIMATION_COMPLETE,useProps);
			this._animation.rowIndex -= 8;
			//this.setReturnAction(this._animation.rowIndex);
			this.targetCharacter.atProps();
		}
		public function atProps():void{
			//this.setReturnAction(this._animation.rowIndex);
			this._animation.rowIndex = LSouSouCharacterS.UPGRADE;
			_speed = 0;
			var addhp:int = int(LSouSouObject.sMap.props.Hp.toString());
			var addmp:int = int(LSouSouObject.sMap.props.Mp.toString());
			var addValue:int;
			if(addhp > 0){
				addValue = addhp;
				if(addValue > this.member.maxTroops - this.member.troops)addValue=this.member.maxTroops-this.member.troops;
				this.member.troops += addValue;
			}else if(addmp > 0){
				addValue = addmp;
				if(addValue > this.member.maxStrategy - this.member.strategy)addValue=this.member.maxStrategy-this.member.strategy;
				this.member.strategy += addValue;
			}
			var arr:Array = [];
			var addNum:String = "+"+addValue;
			arr[0] = addNum;
			arr[1] = this.x + LSouSouObject.sMap.mapCoordinate.x + (this.width - addNum.length*20)/2;
			arr[2] = this.y + LSouSouObject.sMap.mapCoordinate.y;
			arr[3] = 0;
			LSouSouObject.sMap.numList.push(arr);
			this._animation.addEventListener(LEvent.ANIMATION_COMPLETE,propsOver);
		}
		/**
		 *使用道具结束
		 * 
		 * @param 结束事件
		 */
		private function propsOver(event:LEvent):void{
			this._animation.removeEventListener(LEvent.ANIMATION_COMPLETE,propsOver);
			trace("LSouSouCharacterS 使用道具结束");
			//this.returnAction();
			this.action = LSouSouCharacterS.MOVE_DOWN + this.direction;
			LSouSouObject.sMap.props = null;
			LSouSouObject.charaSNow.action_mode = LSouSouCharacterS.MODE_STOP;
			LSouSouObject.charaSNow.targetCharacter = null;
			LSouSouSMapMethod.checkCharacterSOver(LSouSouObject.charaSNow.belong);
		}
		/**
		 *准备法术攻击
		 */
		public function strategyAttackCalculate():void{
			if(this.member.troops == 0 || !this._targetCharacter)return;
			if(this.x > this.targetCharacter.x){
				this._animation.rowIndex = LSouSouCharacterS.MOVE_LEFT;
			}else if(this.x < this.targetCharacter.x){
				this._animation.rowIndex = LSouSouCharacterS.MOVE_RIGHT;
			}else{
				if(this.y > this.targetCharacter.y){
					this._animation.rowIndex = LSouSouCharacterS.MOVE_UP;
				}else{
					this._animation.rowIndex = LSouSouCharacterS.MOVE_DOWN;
				}
			}
			LSouSouObject.sMap.setDetails(LSouSouObject.charaSNow.member.name + "使用策略["+LSouSouObject.sMap.strategy.Name+"]");
			
			var costMp:int = int(LSouSouObject.sMap.strategy.Cost);
			var skillXml:XMLList;
			var self:LSouSouCharacterS = this;
			//特技测试
			if(this.member.skill>0){
				skillXml = LSouSouObject.skill["Skill"+this.member.skill];
				
				if(int(skillXml.Type.toString()) == 3){
					var skillvalue:int = int(Math.random()*100);
					switch(self.member.skill){
						case 4:
							if(skillvalue < int(skillXml.Probability.toString()))_skillRun = true;
							if(_skillRun){
								LSouSouObject.sMap.setDetails(this.member.name + "特技["+skillXml.Name+"]发动");
								costMp = 0;
								self._skillViewOver = false;
							}
							break;
						default:
					}
				}
			}
			this._member.strategy -= costMp;
			
			if(_skillRun && int(skillXml.Type.toString()) == 3 && !self._skillViewOver){
				self._skillViewOver = true;
				var anime:LSouSouSkill = new LSouSouSkill(self.toStrategyAttackStart);
				LSouSouObject.sMap.skill = anime;
			}else{
				self.toStrategyAttackStart();
			}
			
			//this._animation.addEventListener(LEvent.ANIMATION_COMPLETE,strategyOver);
		}
		public function toStrategyAttackStart():void{
			
			_speed = 0;
			this.aiForStrategy = false;
			_action_mode = LSouSouCharacterS.MODE_STRATEGY_ATTACK;
			this._animation.rowIndex = LSouSouCharacterS.ATK_DOWN + this.direction;
			
		}
		/**
		 *动作保存
		 */
		public function setReturnAction(value:int):void{
			this._saveAction = value;
		}
		/**
		 *恢复之前保存动作
		 */
		public function returnAction():void{
			this._animation.rowIndex = this._saveAction;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			this._mode = LAnimation.POSITIVE;
		}
		/**
		 *法术攻击结束
		 * 
		 * @param 结束事件
		 */
		public function strategyOver():void{
			var target:LSouSouCharacterS;
			var charas:LSouSouCharacterS;
			var checkBelong:int;
			
			if(this.belong == LSouSouObject.charaSNow.belong){
				checkBelong = this.belong;
			}else{
				checkBelong = this._targetCharacter.belong;
			}
			target = this._targetCharacter;
			if(target.action_mode == LSouSouCharacterS.MODE_STOP){
				target.action = LSouSouCharacterS.DOWN + target.direction;
			}else{
				target.action = LSouSouCharacterS.MOVE_DOWN + target.direction;
			}
			
			for each(charas in _targetArray){
				if(charas.action_mode == LSouSouCharacterS.MODE_STOP){
					charas.action = LSouSouCharacterS.DOWN + charas.direction;
				}else{
					charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
				}
			}
			if(this.belong == LSouSouObject.charaSNow.belong){
				this.action = LSouSouCharacterS.DOWN + this.direction;
				//this._animation.rowIndex -= 8;
				//this._animation.run(_mode);
				this._aiIntelligent = false;
				_action_mode = LSouSouCharacterS.MODE_STOP;
				this._targetCharacter.targetCharacter = null;
				this._targetCharacter = null;
				LSouSouSMapMethod.checkCharacterSOver(checkBelong);
			}else{
				this.action = LSouSouCharacterS.DOWN + this.direction;
				//this._animation.rowIndex -= 4;
				//this._animation.run(_mode);
				this._aiIntelligent = false;
				this._targetCharacter.action_mode = LSouSouCharacterS.MODE_STOP;
				
				
				if(_targetCharacter.member.troops > 0)LSouSouSMapMethod.checkCharacterSOver(checkBelong);
				this._targetCharacter.targetCharacter = null;
				this._targetCharacter = null;
			}
			_isActionRun = false;
			troopsCheck();
		}
		/**
		 *攻击结束
		 * 
		 * @param 结束事件
		 */
		private function attackOver(event:LEvent):void{
			var target:LSouSouCharacterS;
			var charas:LSouSouCharacterS;
			var checkBelong:int;
			
			checkBelong = LSouSouObject.sMap.belong_mode;

			target = this._targetCharacter;
			this._animation.removeEventListener(LEvent.ANIMATION_COMPLETE,attackOver);
			this._attackIndex++;
			if(this.attackIndex < this.attackNumber){
				
				//双击或双击以上攻击
				this.attackCalculate();
			}else if(targetCharacter.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] == 0 && 
					targetCharacter.member.troops > 0 && this.targetCharacter.attackIndex < this.targetCharacter.attackNumber){
				
				//对方没有混乱，兵力大于0，并且可以反击
				//this._animation.rowIndex -= 8;
				this.action = LSouSouCharacterS.DOWN + this.direction;
				for each(charas in _targetArray){
					if(charas.action_mode == LSouSouCharacterS.MODE_STOP){
						charas.action = LSouSouCharacterS.DOWN + charas.direction;
					}else{
						charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
					}
				}
				if(targetCharacter.targetCharacter && LSouSouCharacterSAI.atAttackRect(targetCharacter,new LCoordinate(this.locationX,this.locationY))){
					this.targetCharacter.attackCalculate();
				}else{
					this._animation.run(_mode);
					this._aiIntelligent = false;
					_action_mode = LSouSouCharacterS.MODE_STOP;
					this._targetCharacter.targetCharacter = null;
					this._targetCharacter = null;
					troopsCheck();
					//LSouSouSMapMethod.checkCharacterSOver(checkBelong);
				}
			}else{
				for each(charas in _targetArray){
					if(charas.action_mode == LSouSouCharacterS.MODE_STOP){
						charas.action = LSouSouCharacterS.DOWN + charas.direction;
					}else{
						charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
					}
				}
				if(this.belong == LSouSouObject.charaSNow.belong){
					//this._animation.rowIndex -= 8;
					//this._animation.run(_mode);
					this._aiIntelligent = false;
					_action_mode = LSouSouCharacterS.MODE_STOP;
					this.action = LSouSouCharacterS.DOWN + this.direction;
					this._targetCharacter.targetCharacter = null;
					this._targetCharacter = null;
					//if(target.member.troops > 0)LSouSouSMapMethod.checkCharacterSOver(checkBelong);
				}else{
					//this._animation.rowIndex -= 4;
					//this._animation.run(_mode);
					this._aiIntelligent = false;
					this.action = LSouSouCharacterS.MOVE_DOWN + this.direction;
					_targetCharacter.action = LSouSouCharacterS.DOWN + _targetCharacter.direction;
					_targetCharacter.action_mode = LSouSouCharacterS.MODE_STOP;
					
					if(this.skillRun)this.skillRun = false;
					if(_targetCharacter && _targetCharacter.skillRun)_targetCharacter.skillRun = false;
					if(_targetCharacter.targetCharacter && _targetCharacter.targetCharacter.skillRun)_targetCharacter.targetCharacter.skillRun = false;
					//if(_targetCharacter.member.troops > 0)LSouSouSMapMethod.checkCharacterSOver(checkBelong);
					this._targetCharacter.targetCharacter = null;
					this._targetCharacter = null;
				}
				troopsCheck();
			}
		}
		public function troopsCheck():void{
			var charas:LSouSouCharacterS;
			for each(charas in LSouSouObject.sMap.enemylist){
				if(!charas.visible)continue;
				if(charas.member.troops >= charas.member.pantTroops)continue;
				if(charas.member.troops > 0 && charas.member.troops <  charas.member.pantTroops){
					charas.action = LSouSouCharacterS.PANT;
					continue;
				}
				
				LSouSouSMapScript.loopListCheck("SouSouSCharacter.checkHp");
				if(LSouSouObject.sMap.loopIsRun){
					LSouSouObject.checkFunction = function():void{
						troopsCheck();
					}
					return;
				}else{
					
					LSouSouObject.checkFunction = function():void{
						LSouSouObject.runSChara = charas;
						LSouSouSMapScript.loopListCheck();
						if(LSouSouObject.sMap.loopIsRun){
							return;
						}
						troopsCheck();
					}
					charas.toDie();
					return;
				}
			}
			for each(charas in LSouSouObject.sMap.ourlist){
				if(!charas.visible)continue;
				if(charas.member.troops >= charas.member.pantTroops)continue;
				if(charas.member.troops > 0 && charas.member.troops <  charas.member.pantTroops){
					charas.action = LSouSouCharacterS.PANT;
					continue;
				}
				LSouSouSMapScript.loopListCheck("SouSouSCharacter.checkHp");
				if(LSouSouObject.sMap.loopIsRun){
					LSouSouObject.checkFunction = function():void{
						troopsCheck();
					}
					return;
				}else{
					
					LSouSouObject.checkFunction = function():void{
						LSouSouObject.runSChara = charas;
						LSouSouSMapScript.loopListCheck();
						if(LSouSouObject.sMap.loopIsRun){
							return;
						}
						troopsCheck();
					}
					charas.toDie();
					return;
				}
			}
			for each(charas in LSouSouObject.sMap.friendlist){
				if(!charas.visible)continue;
				if(charas.member.troops >= charas.member.pantTroops)continue;
				if(charas.member.troops > 0 && charas.member.troops <  charas.member.pantTroops){
					charas.action = LSouSouCharacterS.PANT;
					continue;
				}
				LSouSouSMapScript.loopListCheck("SouSouSCharacter.checkHp");
				if(LSouSouObject.sMap.loopIsRun){
					LSouSouObject.checkFunction = function():void{
						troopsCheck();
					}
					return;
				}else{
					
					LSouSouObject.checkFunction = function():void{
						LSouSouObject.runSChara = charas;
						LSouSouSMapScript.loopListCheck();
						if(LSouSouObject.sMap.loopIsRun){
							return;
						}
						troopsCheck();
					}
					charas.toDie();
					return;
				}
			}
			
			LSouSouSMapMethod.checkCharacterSOver(LSouSouObject.sMap.belong_mode);
		}
		/**
		 *人物准备撤退喘气
		 */
		public function toDie():void{
			LSouSouObject.sound.play("Se16");
			this._animation.rowIndex = LSouSouCharacterS.DIE;
			this._animation.addEventListener(LEvent.ANIMATION_COMPLETE,dieOver);
		}
		/**
		 *撤退事件触发
		 */
		private function dieOver(event:LEvent):void{
			this._animation.removeEventListener(LEvent.ANIMATION_COMPLETE,dieOver);
			var _characterS:LSouSouCharacterS;
			var list:Vector.<LSouSouCharacterS>;
			if(this._belong == LSouSouObject.BELONG_SELF){
				list = LSouSouObject.sMap.ourlist;
			}else if(this._belong == LSouSouObject.BELONG_FRIEND){
				list = LSouSouObject.sMap.friendlist;
			}else if(this._belong == LSouSouObject.BELONG_ENEMY){
				list = LSouSouObject.sMap.enemylist;
			}
			var i:int;
			for(i=0;i<list.length;i++){
				if(list[i].index == this.index){
					//人物撤退
					list[i].visible = false;
					break;
				}
			}
			LSouSouObject.checkFunction();
		}
		public function toActionEnd():void{
			this.action = LSouSouCharacterS.DOWN + this._direction;
			this.action_mode = LSouSouCharacterS.MODE_STOP;
			this._targetCharacter = null;
			LSouSouObject.sMap.roadList = null;
			LSouSouSMapMethod.checkCharacterSOver(this.belong);
		}
	}
}