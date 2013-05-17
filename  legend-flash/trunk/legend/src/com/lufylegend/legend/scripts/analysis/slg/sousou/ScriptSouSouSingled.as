package com.lufylegend.legend.scripts.analysis.slg.sousou
{
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterS;
	import com.lufylegend.legend.game.sousou.map.LSouSouSingled;
	import com.lufylegend.legend.game.sousou.map.LSouSouWindow;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.utils.LFilter;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;
	import com.lufylegend.legend.utils.transitions.LManager;

	public class ScriptSouSouSingled
	{
		public function ScriptSouSouSingled()
		{
		}
		/**
		 * 脚本解析
		 * 对话操作
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			trace("ScriptSouSouSingled run");
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var singled:LSouSouSingled = LSouSouObject.window.windowSingled;
			var param:Array = value.substring(start + 1,end).split(",");
			var charas:LSouSouCharacterS;
			switch(value.substr(0,start)){
				case "SouSouSingled.talk":
					trace("SouSouSingled.talk run");
					charas = getChara(param[0]);
					singled.setTalk(charas,param[1]);
					break;
				case "SouSouSingled.show":
					trace("SouSouSingled.show run");
					charas = getChara(param[0]);
					if(int(param[1]) == 0){
						charas.visible = false;
					}else{
						charas.visible = true;
					}
					LGlobal.script.analysis();
					break;
				case "SouSouSingled.move":
					trace("SouSouSingled.move run");
					charas = getChara(param[0]);
					//charas = param[0]=="0"?LSouSouObject.window.windowSingled.leftChara:LSouSouObject.window.windowSingled.rightChara;
					charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
					//singled.move(param[0]=="0"?true:false,int(param[1]));
					singled.move(charas,int(param[1]));
					break;
				case "SouSouSingled.move2":
					trace("SouSouSingled.move2 run");
					charas = getChara(param[0]);
					//charas = param[0]=="0"?LSouSouObject.window.windowSingled.leftChara:LSouSouObject.window.windowSingled.rightChara;
					charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
					//singled.move2(param[0]=="0"?true:false,int(param[1]),int(param[2]));
					singled.move2(charas,int(param[1]),int(param[2]));
					break;
				case "SouSouSingled.changeDir":/**动作防御*/
					trace("SouSouSingled.changeDir run");
					charas = getChara(param[0]);
					if(int(param[1]) == 0){
						charas.action = LSouSouCharacterS.MOVE_LEFT;
					}else{
						charas.action = LSouSouCharacterS.MOVE_RIGHT;
					}
					LGlobal.script.analysis();
					return;
				case "SouSouSingled.atkPrepare":/**动作攻击预备*/
					trace("SouSouSingled.atkPrepare run");
					param[1] = "ATKPREPARE";
					changeAction(param);
					break;
				case "SouSouSingled.block":/**动作防御*/
					trace("SouSouSingled.block run");
					param[1] = "BLOCK";
					changeAction(param);
					break;
				case "SouSouSingled.atkBlock":
					param[2] = param[1];
					param[1] = "ATKBLOCK";
					trace("SouSouSingled.atkBlock run",param);
					changeAction(param);
					break;
				case "SouSouSingled.atkBlockMove":
					trace("SouSouSingled.atkBlockMove run");
					param[2] = param[1];
					param[1] = "ATKBLOCKMOVE";
					changeAction(param);
					break;
				case "SouSouSingled.atkHert":
					trace("SouSouSingled.atkHert run");
					param[2] = param[1];
					param[1] = "ATKHERT";
					changeAction(param);
					break;
				case "SouSouSingled.atkHertFatal":
					trace("SouSouSingled.atkHertFatal run");
					param[2] = param[1];
					param[1] = "ATKHERTFATAL";
					changeAction(param);
					break;
				case "SouSouSingled.atkDodge":
					trace("SouSouSingled.atkDodge run");
					param[2] = param[1];
					param[1] = "ATKDODGE";
					changeAction(param);
					break;
				case "SouSouSingled.atkDodge2":
					trace("SouSouSingled.atkDodge2 run");
					param[2] = param[1];
					param[1] = "ATKDODGE2";
					changeAction(param);
					break;
				case "SouSouSingled.pant":
					trace("SouSouSingled.pant run");
					param[1] = "PANT";
					changeAction(param);
					break;
				case "SouSouSingled.killed":
					trace("SouSouSingled.killed run");
					param[1] = "KILLED";
					changeAction(param);
					break;
				case "SouSouSingled.result":
					singled.showResult(param[0]);
					break;
				default:
			}
			
		}
		private static function getChara(index:int):LSouSouCharacterS{
			switch(index){
				case 0:
					return LSouSouObject.window.windowSingled.leftChara;
				case 1:
					return LSouSouObject.window.windowSingled.rightChara;
				case 2:
					return LSouSouObject.window.windowSingled.leftCharaUp;
				case 3:
					return LSouSouObject.window.windowSingled.rightCharaUp;
				case 4:
					return LSouSouObject.window.windowSingled.leftCharaDown;
				case 5:
					return LSouSouObject.window.windowSingled.rightCharaDown;
				default :
					return null;
			}
		}
		private static function changeAction(params:Array):void{
			var charas:LSouSouCharacterS;
			LSouSouObject.window.windowSingled.nowChara = int(params[0]);
			charas = getChara(params[0]);
			//charas = params[0]=="0"?LSouSouObject.window.windowSingled.leftChara:LSouSouObject.window.windowSingled.rightChara;
			LSouSouObject.window.windowSingled.nowMode = params[1];
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
				case "KILLED":
					charas.action_mode = LSouSouCharacterS.MODE_STOP;
					charas.action = LSouSouCharacterS.KILLED;
					LSouSouObject.sound.play("Se38");
					LManager.wait(100,function():void{LGlobal.script.analysis();});
					break;
				case "PANT":
					charas.setReturnAction(charas.action);
					charas.action = LSouSouCharacterS.PANT;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "ATKPREPARE":
					trace("ATKPREPARE start ");
					LSouSouObject.sound.play("Se06");
					charas.action = LSouSouCharacterS.ATKPREPARE_DOWN + charas.direction;
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
				case "BLOCK":
					LSouSouObject.sound.play("Se06");
					charas.action = LSouSouCharacterS.BLOCK_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
					break;
				case "ATKBLOCK":
					LSouSouObject.window.windowSingled.targetChara = int(params[2]);	
					charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.runspeed = 1;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
					break;
				case "ATKBLOCKMOVE":
					LSouSouObject.window.windowSingled.targetChara = int(params[2]);
					charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.runspeed = 1;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
					break;
				case "ATKHERT":
					LSouSouObject.window.windowSingled.targetChara = int(params[2]);
					charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.runspeed = 1;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
					break;
				case "ATKHERTFATAL":
					LSouSouObject.window.windowSingled.targetChara = int(params[2]);
					charas.action = LSouSouCharacterS.ATKPREPARE_DOWN + charas.direction;
					LSouSouObject.sound.play("Se33");
					charas.action_mode = LSouSouCharacterS.MODE_BREAKOUT;
					LManager.wait(40,function():void{
						charas.action_mode = LSouSouCharacterS.MODE_NONE;
						charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
						charas.setReturnAction(charas.action);
						charas.runspeed = 1;
						charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
					});
					break;
				case "ATKDODGE":
					LSouSouObject.window.windowSingled.targetChara = int(params[2]);
					charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.runspeed = 1;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
					break;
				case "ATKDODGE2":
					LSouSouObject.window.windowSingled.targetChara = int(params[2]);
					charas.action = LSouSouCharacterS.ATK_DOWN + charas.direction;
					charas.setReturnAction(charas.action);
					charas.runspeed = 1;
					charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
					break;
				default:
					LGlobal.script.analysis();
			}
		}
		private static function actionAtkBlockOver(event:LEvent):void{
			event.currentTarget.removeEventListener(LEvent.ANIMATION_COMPLETE,actionAtkBlockOver);
			var charas:LSouSouCharacterS;
			var targetCharas:LSouSouCharacterS;
			charas = getChara(LSouSouObject.window.windowSingled.nowChara);
			targetCharas = getChara(LSouSouObject.window.windowSingled.targetChara);
			charas.runspeed = 3;
			targetCharas.runspeed = 3;
			charas.action = LSouSouCharacterS.DOWN + charas.direction;
			
			//LSouSouObject.window.windowSingled.nowChara = LSouSouObject.window.windowSingled.targetChara;
			
			trace("actionAtkBlockOver LSouSouObject.window.windowSingled.nowMode = " + LSouSouObject.window.windowSingled.nowMode,LSouSouObject.window.windowSingled.targetChara);
			/**
			charas = LSouSouObject.window.windowSingled.rightChara;
			LSouSouObject.window.windowSingled.leftChara.action = LSouSouCharacterS.DOWN + LSouSouObject.window.windowSingled.leftChara.direction;
			
			LSouSouObject.window.windowSingled.leftChara.runspeed = 3;
			LSouSouObject.window.windowSingled.rightChara.runspeed = 3;
			if(LSouSouObject.window.windowSingled.nowChara == 0){
				LSouSouObject.window.windowSingled.nowChara = 1;
				charas = LSouSouObject.window.windowSingled.rightChara;
				LSouSouObject.window.windowSingled.leftChara.action = LSouSouCharacterS.DOWN + LSouSouObject.window.windowSingled.leftChara.direction;
			}else{
				LSouSouObject.window.windowSingled.nowChara = 0;
				charas = LSouSouObject.window.windowSingled.leftChara;
				LSouSouObject.window.windowSingled.rightChara.action = LSouSouCharacterS.DOWN + LSouSouObject.window.windowSingled.rightChara.direction;
			}
			*/
			
			if(LSouSouObject.window.windowSingled.nowMode == "ATKBLOCK" || 
				LSouSouObject.window.windowSingled.nowMode == "ATKBLOCKMOVE"){
				LSouSouObject.sound.play("Se30");
				targetCharas.direction = (charas.direction + 2)%4;
				//charas = targetCharas;
				targetCharas.action = LSouSouCharacterS.BLOCK_DOWN + targetCharas.direction;
				targetCharas.setReturnAction(targetCharas.action);
				targetCharas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
				
			}else if(LSouSouObject.window.windowSingled.nowMode == "ATKHERT"){
				LSouSouObject.sound.play("Se35");
				charas = targetCharas;
				charas.setReturnAction(charas.action);
				charas.action = LSouSouCharacterS.HERT;
				charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
				
			}else if(LSouSouObject.window.windowSingled.nowMode == "ATKHERTFATAL"){
				LSouSouObject.sound.play("Se36");
				charas = targetCharas;
				charas.setReturnAction(charas.action);
				charas.action = LSouSouCharacterS.HERT;
				charas.animation.addEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
				
			}else if(LSouSouObject.window.windowSingled.nowMode == "ATKDODGE"){
				LSouSouObject.sound.play("Se07");
				charas = targetCharas;
				if(charas.direction == 1){
					charas.x += 48;
				}else{
					charas.x -= 48;
				}
				LManager.wait(50,function():void{LGlobal.script.analysis();});
				
			}else if(LSouSouObject.window.windowSingled.nowMode == "ATKDODGE2"){
				LSouSouObject.sound.play("Se07");
				charas = targetCharas;
				if(charas.direction == 1){
					charas.direction = 3;
					charas.x -= 96;
				}else{
					charas.direction = 1;
					charas.x += 96;
				}
				charas.action = LSouSouCharacterS.MOVE_DOWN + charas.direction;
				LManager.wait(50,function():void{LGlobal.script.analysis();});
				
			}				
		}
		private static function actionOver(event:LEvent):void{
			trace("actionOver");
			event.currentTarget.removeEventListener(LEvent.ANIMATION_COMPLETE,actionOver);
			var charas:LSouSouCharacterS;
			charas = getChara(LSouSouObject.window.windowSingled.targetChara);
			/**
			if(LSouSouObject.window.windowSingled.nowChara == 0){
				charas = LSouSouObject.window.windowSingled.leftChara;
			}else{
				charas = LSouSouObject.window.windowSingled.rightChara;
			}
			*/
			trace("nowMode=",LSouSouObject.window.windowSingled.nowMode);
			switch(LSouSouObject.window.windowSingled.nowMode){
				case "ATKBLOCKMOVE":
					LSouSouObject.window.windowSingled.nowMode = "MOVE";
					LSouSouObject.window.windowSingled.move2(getChara(LSouSouObject.window.windowSingled.targetChara),
						charas.direction==1?1:-1,4);
					break;
				default:
					LGlobal.script.analysis();
			}			
		}
	}
}