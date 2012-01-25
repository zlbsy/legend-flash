package zhanglubin.legend.scripts
{
	import zhanglubin.legend.game.sousou.map.LSouSouRMap;
	import zhanglubin.legend.game.sousou.map.LSouSouSMap;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.sousou.object.LSouSouSMapMethod;
	import zhanglubin.legend.game.sousou.script.LSouSouSoundScript;
	import zhanglubin.legend.scripts.analysis.slg.sousou.*;
	import zhanglubin.legend.utils.LGlobal;

	internal class LScriptSLGSouSou
	{
		public function LScriptSLGSouSou()
		{
		}
		public static function analysis(childType:String, lineValue:String):void{
			
			var start:int;
			var end:int;
			var params:Array;
			switch(childType){
				case "SouSouObjectLoad":
					ScriptSouSouLoad.analysis(lineValue);
					break;
				case "SouSouRMap":
					var rMap:LSouSouRMap = new LSouSouRMap();
					break;
				case "SouSouTalk":
					ScriptSouSouTalk.analysis(lineValue);
					break;
				case "SouSouRCharacter":
					ScriptSouSouRCharacter.analysis(lineValue);
					break;
				case "SouSouSCharacter":
					ScriptSouSouSCharacter.analysis(lineValue);
					break;
				case "SouSouRunMode":
					start = lineValue.indexOf("(");
					end = lineValue.indexOf(")");
					params = lineValue.substring(start + 1,end).split(",");
					LSouSouObject.storyCtrl = (params[0]=="0"?false:true);
					trace("SouSouSAttack.story LSouSouObject.storyCtrl=",LSouSouObject.storyCtrl,"params[0]="+params[0],"lineValue="+lineValue);
					LGlobal.script.analysis();
					
					//LSouSouObject.rMap.setRunMode(lineValue);
					break;
				case "SouSouMember":
					ScriptSouSouMember.analysis(lineValue);
					break;
				case "SouSouSMap":
					var sMap:LSouSouSMap = new LSouSouSMap();
					break;
				case "SouSouSMapChange":
					LSouSouSMapMethod.analysis(lineValue);
					break;
				case "SouSouSMapCheck":
					start = lineValue.indexOf("(");
					end = lineValue.indexOf(")");
					switch(lineValue.substr(0,start)){
						case "SouSouSMapCheck.actionOver":
							if(LSouSouObject.dieIsRuning){
								LSouSouObject.dieIsRuning = false;
								LSouSouObject.runSChara.toDie();
							}else if(LSouSouObject.sMap){
								LSouSouSMapMethod.checkCharacterSOver(LSouSouObject.sMap.belong_mode);
							}
							break;
					}
					break;
				case "SouSouWindow":
					ScriptSouSouWindow.analysis(lineValue);
					break;
				case "SouSouSingled":
					ScriptSouSouSingled.analysis(lineValue);
					break;
				case "SouSouSAttack":
					start = lineValue.indexOf("(");
					end = lineValue.indexOf(")");
					switch(lineValue.substr(0,start)){
						case "SouSouSAttack.start":
							params = lineValue.substring(start + 1,end).split(",");
							LSouSouSMapMethod.checkCharacterSOver(params[0]);
							//LSouSouObject.sMap.round_show = int(params[0]);
							break;
					}
					break;
				case "SouSouSound":
					//不使用音乐
					//LGlobal.script.analysis();
					//break;
				
					LSouSouObject.sound.analysis(lineValue);
					break;
				case "SouSouSave":
					ScriptSouSouSave.analysis(lineValue);
					break;
				case "SouSouGame":
					start = lineValue.indexOf("(");
					end = lineValue.indexOf(")");
					if(lineValue.substr(0,start) == "SouSouGame.close"){
						LGlobal.script.scriptLayer["gameClose"]();
					}else if(lineValue.substr(0,start) == "SouSouGame.taobao"){
						LGlobal.script.scriptLayer["taobao"]();
					}else if(lineValue.substr(0,start) == "SouSouGame.savetaobao"){
						LGlobal.script.scriptLayer["saveTaobao"]();
						LGlobal.script.analysis();
					}
					break;
				default:
			}
		}
	}
}