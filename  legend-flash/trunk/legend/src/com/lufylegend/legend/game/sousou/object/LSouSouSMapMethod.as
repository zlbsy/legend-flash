package com.lufylegend.legend.game.sousou.object
{
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterS;
	import com.lufylegend.legend.game.sousou.script.LSouSouSMapScript;
	import com.lufylegend.legend.scripts.analysis.ScriptFunction;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LSouSouSMapMethod
	{
		public function LSouSouSMapMethod()
		{
		}
		public static function analysis(value:String):void{
			trace("ScriptSouSouMember analysis = " + value);
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var params:Array = value.substring(start + 1,end).split(",");
			var listlength:int,i:int;
			switch(value.substr(0,start)){
				case "SouSouSMapChange.addStage":
					addStage(params);
					break;
				case "SouSouSMapChange.removeStage":
					removeStage(params);
					break;
				case "SouSouSMapChange.setWeather":
					chageWeather(params);
					break;
				case "SouSouSMapChange.chageWeather":
					chageWeather(params);
					break;
				case "SouSouSMapChange.maxRound":
					maxRound(params);
					break;
			}
		}
		private static function maxRound(params:Array):void{
			LSouSouObject.sMap.roundMax = int(params[0]);
			LGlobal.script.analysis();
		}
		private static function setWeather(params:Array):void{
			LSouSouObject.sMap.weather[0][1] = int(params[0]);
			LSouSouObject.sMap.weather[1][1] = int(params[1]);
			LSouSouObject.sMap.weather[2][1] = int(params[2]);
			LSouSouObject.sMap.weather[3][1] = int(params[3]);
			LSouSouObject.sMap.weather[4][1] = int(params[4]);
			LGlobal.script.analysis();
		}
		private static function chageWeather(params:Array):void{
			if(params.length > 0)LSouSouObject.sMap.weatherIndex = int(params[0]);
			LGlobal.script.analysis();
		}
		private static function removeStage(params:Array):void{
			var i:int;
			var nodeArr:Array;
			for(i=0;i<LSouSouObject.sMap.stageList.length;i++){
				nodeArr = LSouSouObject.sMap.stageList[i];
				if(int(params[0])*LSouSouObject.sMap.nodeLength == int(nodeArr[3]) && 
					int(params[1])*LSouSouObject.sMap.nodeLength == int(nodeArr[4])){
					LSouSouObject.sMap.stageList.splice(i,1);
				}
			}
			LGlobal.script.analysis();
		}
		private static function addStage(params:Array):void{
			var stageIndex:int = params[0];
			var stageXml:XMLList = LSouSouObject.mapStage["Stage" + stageIndex];
			if(stageXml == null){LGlobal.script.analysis();return;}
			var fun:Function;
			setLocationAtXY(new LCoordinate(int(params[1])*LSouSouObject.sMap.nodeLength,int(params[2])*LSouSouObject.sMap.nodeLength));
			
			if(params.length > 3 && int(params[3]) == 1){
				fun = function (arr:Array):void{
					var nodeArr:Array;
					var i:int;
					for(i=0;i<LSouSouObject.sMap.stageList.length;i++){
						nodeArr = LSouSouObject.sMap.stageList[i];
						if(arr[6] == nodeArr[6] && arr[3] == nodeArr[3] && arr[4] == nodeArr[4]){
							LSouSouObject.sMap.stageList.splice(i,1);
							break;
						}
					}
					LGlobal.script.analysis();
				}
				LSouSouObject.sMap.stageList.push(
					[stageXml.Img.toString(),
						0,
						stageXml.MaxIndex.toString(),
						int(params[1])*LSouSouObject.sMap.nodeLength,
						int(params[2])*LSouSouObject.sMap.nodeLength,
						fun,
						stageIndex,
						int(stageXml.Cost.toString())]);
			}else{
				fun = function (arr:Array):void{
					arr[1] = 0;
				}
				LSouSouObject.sMap.stageList.push(
					[stageXml.Img.toString(),
						0,
						stageXml.MaxIndex.toString(),
						int(params[1])*LSouSouObject.sMap.nodeLength,
						int(params[2])*LSouSouObject.sMap.nodeLength,
						fun,
						stageIndex,
						int(stageXml.Cost.toString())]);
				LGlobal.script.analysis();
			}
			
		}
		public static function setLocation(value:Boolean = false):void{
			LSouSouObject.sMap.mapToCoordinate.x = 384 - LSouSouObject.charaSNow.x;
			LSouSouObject.sMap.mapToCoordinate.y = 240 - LSouSouObject.charaSNow.y;
			
			if(LSouSouObject.sMap.mapToCoordinate.x > 0)LSouSouObject.sMap.mapToCoordinate.x=0;
			if(LSouSouObject.sMap.mapToCoordinate.x < LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.mapW)LSouSouObject.sMap.mapToCoordinate.x=LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.mapW;
			if(LSouSouObject.sMap.mapToCoordinate.y > 0)LSouSouObject.sMap.mapToCoordinate.y=0;
			if(LSouSouObject.sMap.mapToCoordinate.y < LSouSouObject.sMap.SCREEN_HEIGHT - LSouSouObject.sMap.mapH)LSouSouObject.sMap.mapToCoordinate.y=LSouSouObject.sMap.SCREEN_HEIGHT - LSouSouObject.sMap.mapH;
			if(value){
				LSouSouObject.sMap.mapCoordinate.x = LSouSouObject.sMap.mapToCoordinate.x;
				LSouSouObject.sMap.mapCoordinate.y = LSouSouObject.sMap.mapToCoordinate.y;
			}
		}
		public static function setLocationAtXY(coor:LCoordinate,value:Boolean = false):void{
			LSouSouObject.sMap.mapToCoordinate.x = 384 - coor.x;
			LSouSouObject.sMap.mapToCoordinate.y = 240 - coor.y;
			
			if(LSouSouObject.sMap.mapToCoordinate.x > 0)LSouSouObject.sMap.mapToCoordinate.x=0;
			if(LSouSouObject.sMap.mapToCoordinate.x < LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.mapW)LSouSouObject.sMap.mapToCoordinate.x=LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.mapW;
			if(LSouSouObject.sMap.mapToCoordinate.y > 0)LSouSouObject.sMap.mapToCoordinate.y=0;
			if(LSouSouObject.sMap.mapToCoordinate.y < LSouSouObject.sMap.SCREEN_HEIGHT - LSouSouObject.sMap.mapH)LSouSouObject.sMap.mapToCoordinate.y=LSouSouObject.sMap.SCREEN_HEIGHT - LSouSouObject.sMap.mapH;
			if(value){
				LSouSouObject.sMap.mapCoordinate.x = LSouSouObject.sMap.mapToCoordinate.x;
				LSouSouObject.sMap.mapCoordinate.y = LSouSouObject.sMap.mapToCoordinate.y;
			}
		}
		public static function setLocationAtChara(charas:LSouSouCharacterS,value:Boolean = false):void{
			LSouSouObject.sMap.mapToCoordinate.x = 384 - charas.x;
			LSouSouObject.sMap.mapToCoordinate.y = 240 - charas.y;
			
			if(LSouSouObject.sMap.mapToCoordinate.x > 0)LSouSouObject.sMap.mapToCoordinate.x=0;
			if(LSouSouObject.sMap.mapToCoordinate.x < LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.mapW)LSouSouObject.sMap.mapToCoordinate.x=LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.mapW;
			if(LSouSouObject.sMap.mapToCoordinate.y > 0)LSouSouObject.sMap.mapToCoordinate.y=0;
			if(LSouSouObject.sMap.mapToCoordinate.y < LSouSouObject.sMap.SCREEN_HEIGHT - LSouSouObject.sMap.mapH)LSouSouObject.sMap.mapToCoordinate.y=LSouSouObject.sMap.SCREEN_HEIGHT - LSouSouObject.sMap.mapH;
			if(value){
				LSouSouObject.sMap.mapCoordinate.x = LSouSouObject.sMap.mapToCoordinate.x;
				LSouSouObject.sMap.mapCoordinate.y = LSouSouObject.sMap.mapToCoordinate.y;
			}
		}
		public static function checkCharacterSOver(value:int,type:String = ""):void{
			if(LSouSouObject.sMap.belong_mode >= 100){
				LSouSouObject.sMap.belong_mode = 0;
			}else{
				LSouSouSMapScript.loopListCheck(type);
				if(LSouSouObject.sMap.loopIsRun){
					trace("loopisrun over");
					return;
				}
			}
			trace("---LSouSouSMapMethod checkCharacterSOver",value);
			var overCount:int = 0;
			var _characterS:LSouSouCharacterS;
			var selectCharacterS:LSouSouCharacterS;
			var friendCheck:Boolean;
			var victoryDefeat:Boolean;
			if(value == LSouSouObject.BELONG_SELF){
				
				for each(_characterS in LSouSouObject.sMap.enemylist){
					trace("_characterS.member.index = " + _characterS.member.index,",_characterS.member.troops = " + _characterS.member.troops);
					if(_characterS.member.troops > 0){
						victoryDefeat = true;
						break;
					}
				}
				if(!victoryDefeat){
					trace("胜利函数调用");
					ScriptFunction.analysis("Call.win();");
					return;
				}
				for each(_characterS in LSouSouObject.sMap.ourlist){
					if(!_characterS.visible || 
						_characterS.action_mode == LSouSouCharacterS.MODE_STOP){
						overCount++;				
					}
				}
				if(overCount == LSouSouObject.sMap.ourlist.length){
					for each(_characterS in LSouSouObject.sMap.enemylist){
						if(_characterS.member.troops > 0){
							victoryDefeat = true;
							break;
						}
					}
					if(!victoryDefeat){
						trace("胜利函数调用");
						ScriptFunction.analysis("Call.win();");
						return;
					}
					
					for each(_characterS in LSouSouObject.sMap.friendlist){
						if(_characterS.visible && _characterS.action_mode != LSouSouCharacterS.MODE_STOP){
							friendCheck = true;
							break;
						}
					}
					if(friendCheck){
						LSouSouObject.sMap.friendIsNull = false;
						LSouSouObject.sMap.belong_mode = LSouSouObject.BELONG_FRIEND;
						LSouSouObject.sMap.round_show = 3;
					}else{
						LSouSouObject.sMap.friendIsNull = true;
						LSouSouObject.sMap.belong_mode = LSouSouObject.BELONG_ENEMY;
						LSouSouObject.sMap.round_show = 2;
					}
				}
				
			}else if(value == LSouSouObject.BELONG_FRIEND){
				for each(_characterS in LSouSouObject.sMap.enemylist){
					if(_characterS.member.troops > 0){
						victoryDefeat = true;
						break;
					}
				}
				if(!victoryDefeat){
					trace("胜利函数调用");
					ScriptFunction.analysis("Call.win();");
					return;
				}
				
				
				for each(_characterS in LSouSouObject.sMap.friendlist){
					if(!_characterS.visible || 
						_characterS.action_mode == LSouSouCharacterS.MODE_STOP){
						overCount++;				
					}else{
						if(!selectCharacterS && _characterS.visible){
							selectCharacterS = _characterS;
						}
					}
				}
				if(overCount == LSouSouObject.sMap.friendlist.length){
					LSouSouObject.sMap.belong_mode = LSouSouObject.BELONG_ENEMY;
					LSouSouObject.sMap.round_show = 2;
				}else if(selectCharacterS){
					LSouSouObject.sMap.belong_mode = LSouSouObject.BELONG_FRIEND;
					selectCharacterS.ai();
				}
				
			}else if(value == LSouSouObject.BELONG_ENEMY){
				for each(_characterS in LSouSouObject.sMap.ourlist){
					if(_characterS.member.troops > 0){
						victoryDefeat = true;
						break;
					}
				}
				if(!victoryDefeat){
					trace("败北函数调用");
					ScriptFunction.analysis("Call.lose();");
					return;
				}
				for each(_characterS in LSouSouObject.sMap.enemylist){
					if(!_characterS.visible || 
						_characterS.action_mode == LSouSouCharacterS.MODE_STOP){
						overCount++;				
					}else{
						if(!selectCharacterS && _characterS.visible){
							selectCharacterS = _characterS;
						}
					}
				}
				if(overCount == LSouSouObject.sMap.enemylist.length){
					LSouSouObject.sMap.belong_mode = LSouSouObject.BELONG_SELF;
					LSouSouObject.sMap.roundCount++;
					LSouSouObject.sMap.round_show = 1;
				}else if(selectCharacterS){
					LSouSouObject.sMap.belong_mode = LSouSouObject.BELONG_ENEMY;
					selectCharacterS.ai();
				}
				
			}
		}
	}
}