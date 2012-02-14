package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.meff.LSouSouMeffShow;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.sousou.object.LSouSouSMapMethod;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;
	import zhanglubin.legend.utils.transitions.LManager;

	public class ScriptSouSouSCharacter
	{
		public function ScriptSouSouSCharacter()
		{
		}
		/**
		 * 脚本解析
		 * 对话操作
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "SouSouSCharacter.changeDirection":
					changeDirection(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.change":
					charasChange(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.changeRect":
					charasChangeRect(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.changeAction":
					changeAction(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.checkHp":
					checkHp(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.pullout":
					pullout(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.outRect":
					outRect(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.show":
					show(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.showPre":
					showPreparation(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.moveTo":
					moveTo(value.substring(start + 1,end).split(","));
					break;
				case "SouSouSCharacter.moveToPre":
					moveToPreparation(value.substring(start + 1,end).split(","));
					break;
				
			}
		}
		/**
		 * 区域消失
		 * [所属，startx,starty,endx,endy]
		*/
		private static function outRect(params:Array):void{
			var charaList:Vector.<LSouSouCharacterS>;
			var i:int;
			var belong:int = params[0];
			var startx:int = params[1];
			var starty:int = params[2];
			var endx:int = params[3];
			var endy:int = params[4];
			if(belong == LSouSouObject.BELONG_SELF){
				charaList = LSouSouObject.sMap.ourlist;
			}else if(belong == LSouSouObject.BELONG_FRIEND){
				charaList = LSouSouObject.sMap.friendlist;
			}else if(belong == LSouSouObject.BELONG_ENEMY){
				charaList = LSouSouObject.sMap.enemylist;
			}else{
				LGlobal.script.analysis();
			}
			var isGetCharas:Boolean = false;
			var charas:LSouSouCharacterS;
			for(i=0;i<charaList.length;i++){
				charas = charaList[i];
				if(charas.visible && charas.locationX>=startx && charas.locationX <= endx && 
					charas.locationY >= starty && charas.locationY <= endy){
					charas.visible=false;
				}
			}
			LGlobal.script.analysis();
		}
		private static function charasChangeRect(params:Array):void{
			var charaList:Vector.<LSouSouCharacterS>;
			var belong:int = params[0];
			if(belong == LSouSouObject.BELONG_SELF){
				charaList = LSouSouObject.sMap.ourlist;
			}else if(belong == LSouSouObject.BELONG_FRIEND){
				charaList = LSouSouObject.sMap.friendlist;
			}else if(belong == LSouSouObject.BELONG_ENEMY){
				charaList = LSouSouObject.sMap.enemylist;
			}else{
				LGlobal.script.analysis();
			}
			
			var charas:LSouSouCharacterS;
			
			switch(params[1]){
				case "hp":
					for each(charas in charaList){
						if(!charas.visible)continue;
						if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
							charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
							charas.member.troops += int(params[2]);
							if(charas.member.troops < 1) charas.member.troops = 1;
							if(charas.member.troops > charas.member.maxTroops) charas.member.troops = charas.member.maxTroops;
							checkHp(params);
						}
					}
					LGlobal.script.analysis();
					break;
				case "status":
					var anime:LSouSouMeffShow,i:int=0;
					switch(params[2]){
						case "chaos":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][1] = 0;
								}
							}
							LGlobal.script.analysis();
							break;
						case "fixed":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									charas.statusArray[LSouSouCharacterS.STATUS_FIXED][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_FIXED][1] = 0;
								}
							}
							LGlobal.script.analysis();
							break;
						case "poison":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									charas.statusArray[LSouSouCharacterS.STATUS_POISON][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_POISON][1] = 0;
								}
							}
							LGlobal.script.analysis();
							break;
						case "attack_down":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									
									charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
									charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(charas.member.attack*0.2);
									
									if(i++ == 0){
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy100"],LGlobal.script.analysis);
									}else{
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy100"]);
									}
									LSouSouObject.sMap.meffShowList.push(anime);
								}
							}
							break;
						case "attack_up":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									
									charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
									charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = int(charas.member.attack*0.2);
									
									if(i++ == 0){
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy100"],LGlobal.script.analysis);
									}else{
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy100"]);
									}
									LSouSouObject.sMap.meffShowList.push(anime);
								}
							}
							break;
						case "defense_down":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][1] = 0;
									charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2] = -int(charas.member.defense*0.2);
									
									if(i++ == 0){
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy101"],LGlobal.script.analysis);
									}else{
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy101"]);
									}
									LSouSouObject.sMap.meffShowList.push(anime);
								}
							}
							break;
						case "defense_up":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][1] = 0;
									charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2] = int(charas.member.defense*0.2);
									
									if(i++ == 0){
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy101"],LGlobal.script.analysis);
									}else{
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy101"]);
									}
									LSouSouObject.sMap.meffShowList.push(anime);
								}
							}
							break;
						case "move_up":
							for each(charas in charaList){
								if(!charas.visible)continue;
								if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
									charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
									charas.statusArray[LSouSouCharacterS.STATUS_MOVE][0] = 1;
									charas.statusArray[LSouSouCharacterS.STATUS_MOVE][1] = 0;
									charas.statusArray[LSouSouCharacterS.STATUS_MOVE][2] = 2;
									
									if(i++ == 0){
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy102"],LGlobal.script.analysis);
									}else{
										anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy102"]);
									}
									LSouSouObject.sMap.meffShowList.push(anime);
								}
							}
							break;
					}
					
					break;
				case "command":
					for each(charas in charaList){
						if(!charas.visible)continue;
						if(charas.locationX >= int(params[3]) && charas.locationX <= int(params[5]) && 
							charas.locationY >= int(params[4]) && charas.locationY <= int(params[6])){
							charas.command = int(params[2]);
						}
					}
					LGlobal.script.analysis();
					break;
				default:
					LGlobal.script.analysis();
			}
		}
		private static function moveTo(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[1]));
			if(charas == null){LGlobal.script.analysis();return;}
			LSouSouSMapMethod.setLocationAtChara(charas);
			LSouSouObject.runSChara = charas;
			var toCoordinate:LCoordinate;
			var moveFlg:int = int(params[0]);
			if(moveFlg == 1){
				toCoordinate = new LCoordinate(int(params[2]),int(params[3]));
			}else{
				toCoordinate = new LCoordinate(charas.locationX+int(params[2]),charas.locationY+int(params[3]));
				/**
				if(int(params[2]) == LSouSouCharacterS.DOWN){
					toCoordinate.y += int(params[3]);
				}else if(int(params[2]) == LSouSouCharacterS.LEFT){
					toCoordinate.x -= int(params[3]);
				}else if(int(params[2]) == LSouSouCharacterS.UP){
					toCoordinate.y -= int(params[3]);
				}else if(int(params[2]) == LSouSouCharacterS.RIGHT){
					toCoordinate.x += int(params[3]);
				}
				 * */
			}
			charas.path = LSouSouObject.sStarQuery.path(
				new LCoordinate(charas.locationX,charas.locationY),toCoordinate,charas
			);
			if(charas.path == null || charas.path.length == 0){
				LGlobal.script.analysis();
				return;
			}
			charas.addEventListener(LEvent.CHARACTER_MOVE_COMPLETE,onMoveComplete);
			
		}
		private static function moveToPreparation(params:Array):void{
			if(int(params[1]) >= LSouSouObject.sMap.ourlist.length){LGlobal.script.analysis();return;}
			
			var charas:LSouSouCharacterS = LSouSouObject.sMap.ourlist[int(params[1])];

			if(charas == null){LGlobal.script.analysis();return;}
			LSouSouSMapMethod.setLocationAtChara(charas);
			LSouSouObject.runSChara = charas;
			var toCoordinate:LCoordinate;
			var moveFlg:int = int(params[0]);
			if(moveFlg == 1){
				toCoordinate = new LCoordinate(int(params[2]),int(params[3]));
			}else{
				toCoordinate = new LCoordinate(charas.locationX+int(params[2]),charas.locationY+int(params[3]));
				
			}
			charas.path = LSouSouObject.sStarQuery.path(
				new LCoordinate(charas.locationX,charas.locationY),toCoordinate,charas
			);
			if(charas.path == null || charas.path.length == 0){
				LGlobal.script.analysis();
				return;
			}
			charas.addEventListener(LEvent.CHARACTER_MOVE_COMPLETE,onMoveComplete);
			
		}
		private static function show(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[0]));
			if(charas == null){LGlobal.script.analysis();return;}
			LSouSouSMapMethod.setLocationAtChara(charas);
			var showFlg:int = int(params[1]);
			if(showFlg == 1){
				charas.visible = true;
				LManager.wait(20,function ():void{LGlobal.script.analysis();});
				return;
			}
			if(params.length > 2 && int(params[2]) == 1)charas.member.troops = 0;
			charas.visible = false;
			LManager.wait(20,function ():void{LGlobal.script.analysis();});
			
		}
		private static function showPreparation(params:Array):void{
			if(int(params[0]) >= LSouSouObject.sMap.ourlist.length){LGlobal.script.analysis();return;}
			
			var charas:LSouSouCharacterS = LSouSouObject.sMap.ourlist[int(params[0])];

			if(charas == null){LGlobal.script.analysis();return;}
			LSouSouSMapMethod.setLocationAtChara(charas);
			var showFlg:int = int(params[1]);
			if(showFlg == 1){
				charas.visible = true;
				LManager.wait(20,function ():void{LGlobal.script.analysis();});
				return;
			}
			if(params.length > 2 && int(params[2]) == 1)charas.member.troops = 0;
			charas.visible = false;
			LManager.wait(20,function ():void{LGlobal.script.analysis();});
			
		}
		private static function changeDirection(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[0]));
			if(charas == null){LGlobal.script.analysis();return;}
			
			if(int(params[1]) == 0){
				charas.action = LSouSouCharacterS.MOVE_DOWN + int(params[2]);
				checkHp(params);
				LGlobal.script.analysis();
				return;
			}
			
			var charastarget:LSouSouCharacterS = getCharacterS(int(params[2]));
			if(Math.abs(charas.x - charastarget.x) > Math.abs(charas.y - charastarget.y)){
				if(charas.x > charastarget.x){
					charas.action =	LSouSouCharacterS.MOVE_LEFT;
				}else{
					charas.action =	LSouSouCharacterS.MOVE_RIGHT;
				}
			}else{
				if(charas.y > charastarget.y){
					charas.action =	LSouSouCharacterS.MOVE_UP;
				}else{
					charas.action =	LSouSouCharacterS.MOVE_DOWN;
				}
			}
			checkHp(params);
			LGlobal.script.analysis();
		}
		public static function getCharacterS(index:int):LSouSouCharacterS{
			var charas:LSouSouCharacterS;
			var isget:Boolean;
			for each(charas in LSouSouObject.sMap.ourlist){if(charas.index == index){isget = true;break;}}
			if(!isget){for each(charas in LSouSouObject.sMap.friendlist){if(charas.index == index){isget = true;break;}}}
			if(!isget){for each(charas in LSouSouObject.sMap.enemylist){if(charas.index == index){isget = true;break;}}}
			if(!isget)return null;
			return charas;
		}
		private static function checkHp(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[0]));
			if(charas == null){LGlobal.script.analysis();return;}
			if(charas.member.troops < charas.member.maxTroops*0.25){
				charas.animation.rowIndex = LSouSouCharacterS.PANT;
			} 
		}
		private static function pullout(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[0]));
			if(charas == null){LGlobal.script.analysis();return;}
			charas.member.troops = 0;
			LSouSouObject.runSChara = charas;
			charas.setReturnAction(charas.action);
			charas.action = LSouSouCharacterS.DIE;
			charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,dieActionOver);
			
		}
		private static function dieActionOver(event:LEvent):void{
			LSouSouObject.runSChara.animation.removeEventListener(LEvent.ANIMATION_COMPLETE,dieActionOver);
			LSouSouObject.runSChara.returnAction();
			LSouSouObject.runSChara.visible = false;
			LSouSouObject.runSChara = null;
			LGlobal.script.analysis();
		}
		private static function charasChange(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[0]));
			if(charas == null){LGlobal.script.analysis();return;}
			
			switch(params[1]){
				case "hp":
					charas.member.troops += int(params[2]);
					if(charas.member.troops < 1) charas.member.troops = 1;
					if(charas.member.troops > charas.member.maxTroops) charas.member.troops = charas.member.maxTroops;
					checkHp(params);
					LGlobal.script.analysis();
					break;
				case "status":
					var anime:LSouSouMeffShow;
					switch(params[2]){
						case "chaos":
							charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][1] = 0;
							LGlobal.script.analysis();
							break;
						case "fixed":
							charas.statusArray[LSouSouCharacterS.STATUS_FIXED][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_FIXED][1] = 0;
							LGlobal.script.analysis();
							break;
						case "poison":
							charas.statusArray[LSouSouCharacterS.STATUS_POISON][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_POISON][1] = 0;
							LGlobal.script.analysis();
							break;
						case "attack_down":
							charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
							charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = -int(charas.member.attack*0.2);
							
							anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy100"],LGlobal.script.analysis);
							LSouSouObject.sMap.meffShowList.push(anime);
							break;
						case "defense_down":
							charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][1] = 0;
							charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2] = -int(charas.member.defense*0.2);
							
							anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy101"],LGlobal.script.analysis);
							LSouSouObject.sMap.meffShowList.push(anime);
							break;
						case "attack_up":
							charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][1] = 0;
							charas.statusArray[LSouSouCharacterS.STATUS_ATTACK][2] = int(charas.member.attack*0.2);
							
							anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy100"],LGlobal.script.analysis);
							LSouSouObject.sMap.meffShowList.push(anime);
							break;
						case "defense_up":
							charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][0] = 1;
							charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][1] = 0;
							charas.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2] = int(charas.member.defense*0.2);
							
							anime = new LSouSouMeffShow(charas.x,charas.y,LSouSouObject.strategy["Strategy101"],LGlobal.script.analysis);
							LSouSouObject.sMap.meffShowList.push(anime);
							break;
					}
					break;
				case "command":
					charas.command = int(params[2]);
					LGlobal.script.analysis();
					break;
				default:
					LGlobal.script.analysis();
			}
		}
		private static function changeAction(params:Array):void{
			var charas:LSouSouCharacterS = getCharacterS(int(params[0]));
			if(charas == null){LGlobal.script.analysis();return;}
			LSouSouSMapMethod.setLocationAtChara(charas);
			LSouSouObject.runSChara = charas;
			switch(params[1]){
				case "ATK":
					charas.setReturnAction(charas.action);
					charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "HERT":
					charas.setReturnAction(charas.action);
					charas.action = LSouSouCharacterS.HERT;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "DIE":
					charas.setReturnAction(charas.action);
					charas.action = LSouSouCharacterS.DIE;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "PANT":
					charas.setReturnAction(charas.action);
					charas.action = LSouSouCharacterS.PANT;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "ATKPREPARE":
					charas.action = LSouSouCharacterS.ATKPREPARE_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "MOVE":
					charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "PANIC":
					charas.setReturnAction(charas.action);
					charas.action = LSouSouCharacterS.PANIC;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				default:
					LGlobal.script.analysis();
			}
		}
		private static function actionOver(event:LEvent):void{
			LSouSouObject.runSChara.animation.removeEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
			LSouSouObject.runSChara.returnAction();
			//LSouSouObject.runSChara.action = LSouSouCharacterS.MOVE_DOWN + LSouSouObject.runSChara.direction;
			LSouSouObject.runSChara = null;
			LGlobal.script.analysis();
		}
		private static function toHide(event:LEvent):void{
			if(LSouSouObject.runSChara.alpha <= 0){
				LSouSouObject.runSChara.alpha = 1;
				LSouSouObject.runSChara.visible = false;
				LSouSouObject.runSChara.animation.removeEventListener(LEvent.ANIMATION_COMPLETE,toHide);
				LSouSouObject.runSChara = null;
				LGlobal.script.analysis();
			}
			LSouSouObject.runSChara.alpha -= 0.1;
		}
		private static function onMoveComplete(event:LEvent):void{
			LSouSouObject.runSChara.removeEventListener(LEvent.CHARACTER_MOVE_COMPLETE,onMoveComplete);
			
			LSouSouObject.runSChara = null;
			LGlobal.script.analysis();
		}
	}
}