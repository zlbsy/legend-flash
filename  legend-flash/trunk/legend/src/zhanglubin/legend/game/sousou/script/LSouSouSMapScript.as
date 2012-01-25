package zhanglubin.legend.game.sousou.script
{
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.ScriptFunction;
	import zhanglubin.legend.scripts.analysis.ScriptIF;
	import zhanglubin.legend.scripts.analysis.ScriptVarlable;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouSMapScript
	{
		public function LSouSouSMapScript()
		{
		}
		public function analysis():void{
			var script:LScript = LGlobal.script;
			if(script.lineList.length == 0)return;
			var lineValue:String = LString.trim(script.lineList.shift());
			if(lineValue.length == 0){
				analysis();
				return;
			}
			trace("LSouSouSMapScript analysis lineValue = " + lineValue);
			
			switch(lineValue){
				case "SouSouSMap.end()":
					LSouSouObject.sMap.setMenu();
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
				case "SouSouSCharacter.atCoordinate":
					CharacterAtCoordinate(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.atBelongCoordinate":
					BelongAtCoordinate(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.atBelongCoordinates":
					BelongAtCoordinates(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.adjacent":
					CharacterAdjacent(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.atRound":
					atRound(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.checkHp":
					checkHp(lineValue.substring(start+1,end).split(","));
					break;
				default:
			}
			
		}
		private function checkHp(param:Array):void{
			trace("SouSouSCharacter.checkHp start");
			var coordinateCharacter:LSouSouCharacterS;
			var isChara:Boolean;
			for each(coordinateCharacter in LSouSouObject.sMap.ourlist){
				if(coordinateCharacter.index == int(param[0])){
					isChara = true;
					break;
				}
			}
			if(!isChara){
				for each(coordinateCharacter in LSouSouObject.sMap.friendlist){
					if(coordinateCharacter.index == int(param[0])){
						isChara = true;
						break;
					}
				}
			}
			if(!isChara){
				for each(coordinateCharacter in LSouSouObject.sMap.enemylist){
					if(coordinateCharacter.index == int(param[0])){
						isChara = true;
						break;
					}
				}
			}
			if(!isChara){
				loop();
				return;
			}
			var arr:Array = new Array();
			arr["type"] = "SouSouSCharacter.checkHp";
			arr["character"] = coordinateCharacter;
			arr["minhp"] = param[1];
			arr["maxhp"] = param[2];
			arr["if"] = param[3];
			LSouSouObject.sMap.loopList.push(arr);
			trace("SouSouSCharacter.checkhp over");
			loop();
		}
		private function atRound(param:Array):void{
			var arr:Array = new Array();
			arr["type"] = "SouSouSCharacter.atRound";
			arr["belong"] = param[0];
			arr["roundCount"] = param[1];
			arr["if"] = param[2];
			LSouSouObject.sMap.loopList.push(arr);
			loop();
		}
		private function BelongAtCoordinate(param:Array):void{
			var arr:Array = new Array();
			arr["type"] = "SouSouSCharacter.atBelongCoordinate";
			arr["belong"] = param[0];
			arr["at"] = new LCoordinate(int(param[1]),int(param[2]));
			arr["if"] = param[3];
			LSouSouObject.sMap.loopList.push(arr);
			loop();
		}
		private function BelongAtCoordinates(param:Array):void{
			var arr:Array = new Array();
			arr["type"] = "SouSouSCharacter.atBelongCoordinates";
			arr["belong"] = param[0];
			arr["from"] = new LCoordinate(int(param[1]),int(param[2]));
			arr["to"] = new LCoordinate(int(param[3]),int(param[4]));
			arr["if"] = param[5];
			LSouSouObject.sMap.loopList.push(arr);
			loop();
		}
		private function CharacterAdjacent(param:Array):void{
			var coordinateCharacter:LSouSouCharacterS;
			var chara1:LSouSouCharacterS;
			var chara2:LSouSouCharacterS;
			for each(coordinateCharacter in LSouSouObject.sMap.ourlist){
				if(chara1 && chara2)break;
				//if(!coordinateCharacter.visible || coordinateCharacter.member.troops == 0)continue;
				if(chara1 == null && coordinateCharacter.index == int(param[0])){
					chara1 = coordinateCharacter;
				}else if(chara2 == null && coordinateCharacter.index == int(param[1])){
					chara2 = coordinateCharacter;
				}
			}
			for each(coordinateCharacter in LSouSouObject.sMap.friendlist){
				if(chara1 && chara2)break;
				//if(!coordinateCharacter.visible || coordinateCharacter.member.troops == 0)continue;
				if(chara1 == null && coordinateCharacter.index == int(param[0])){
					chara1 = coordinateCharacter;
				}else if(chara2 == null && coordinateCharacter.index == int(param[1])){
					chara2 = coordinateCharacter;
				}
			}
			for each(coordinateCharacter in LSouSouObject.sMap.enemylist){
				if(chara1 && chara2)break;
				//if(!coordinateCharacter.visible || coordinateCharacter.member.troops == 0)continue;
				if(chara1 == null && coordinateCharacter.index == int(param[0])){
					chara1 = coordinateCharacter;
				}else if(chara2 == null && coordinateCharacter.index == int(param[1])){
					chara2 = coordinateCharacter;
				}
			}
			if(chara1 == null || chara2 == null){
				loop();
				return;
			}
			
			var arr:Array = new Array();
			arr["type"] = "SouSouSCharacter.adjacent";
			arr["chara1"] = chara1;
			arr["chara2"] = chara2;
			arr["if"] = param[2];
			LSouSouObject.sMap.loopList.push(arr);
			loop();
		}
		private function CharacterAtCoordinate(param:Array):void{
			var coordinateCharacter:LSouSouCharacterS;
			var isChara:Boolean;
			for each(coordinateCharacter in LSouSouObject.sMap.ourlist){
				if(coordinateCharacter.index == int(param[0])){
					isChara = true;
					break;
				}
			}
			if(!isChara){
				for each(coordinateCharacter in LSouSouObject.sMap.friendlist){
					if(coordinateCharacter.index == int(param[0])){
						isChara = true;
						break;
					}
				}
			}
			if(!isChara){
				for each(coordinateCharacter in LSouSouObject.sMap.enemylist){
					if(coordinateCharacter.index == int(param[0])){
						isChara = true;
						break;
					}
				}
			}
			if(!isChara){
				loop();
				return;
			}
			var arr:Array = new Array();
			arr["type"] = "SouSouSCharacter.atCoordinate";
			arr["character"] = coordinateCharacter;
			arr["at"] = new LCoordinate(int(param[1])*LSouSouObject.sMap._nodeLength,int(param[2])*LSouSouObject.sMap._nodeLength);
			LSouSouObject.sMap.loopList.push(arr);
			loop();
		}
		
		public static function loopListCheck(type:String = ""):void{
			LSouSouObject.sMap.loopIsRun = false;
			trace("LSouSouObject.storyCtrl =",LSouSouObject.storyCtrl);
			if(LSouSouObject.storyCtrl)return;
			var arr:Array;
			var i:int,j:int;
			var charas:LSouSouCharacterS;
			var chara1:LSouSouCharacterS;
			var chara2:LSouSouCharacterS;
			var ifArr:Array;
			var ifvalue:Boolean;
			var coor:LCoordinate;
			var coorTo:LCoordinate;
			var _charalist:Array = new Array();
			
			for each(charas in LSouSouObject.sMap.enemylist){
				if(!charas.visible || charas.member.troops == 0)continue;
				_charalist[charas.locationX + "," + charas.locationY] = charas;
			}
			for each(charas in LSouSouObject.sMap.ourlist){
				if(!charas.visible || charas.member.troops == 0)continue;
				_charalist[charas.locationX + "," + charas.locationY] = charas;
			}
			for each(charas in LSouSouObject.sMap.friendlist){
				if(!charas.visible || charas.member.troops == 0)continue;
				_charalist[charas.locationX + "," + charas.locationY] = charas;
			}
			for each(arr in LSouSouObject.sMap.loopList){
				trace("LSouSouSMapScript loopListCheck type="+arr["type"]);
				if(type.length > 0 && type != arr["type"])continue;
				if(arr["type"] == "SouSouSCharacter.atCoordinate"){
					var coordinateCharacter:LSouSouCharacterS = arr["character"];
					var atCoordinate:LCoordinate = arr["at"];
					if(coordinateCharacter.xy.x == atCoordinate.x && coordinateCharacter.xy.y == atCoordinate.y){
						if(LSouSouObject.sMap.loopIsRun)return;
						LSouSouObject.sMap.loopIsRun = true;
						ScriptFunction.analysis("Call.characterAt_" + coordinateCharacter.index + "_" + int(atCoordinate.x/LSouSouObject.sMap._nodeLength) + "_" +  int(atCoordinate.y/LSouSouObject.sMap._nodeLength) + "();");
						return;
					}
				}else if(arr["type"] == "SouSouSCharacter.atBelongCoordinate"){
					trace("LSouSouSMapScript 所属坐标测试");
					coor = arr["at"];
					charas = _charalist[coor.x +","+ coor.y];
					if( charas== null)continue;
					if(charas.belong != int(arr["belong"]))continue;
					ifArr = ScriptVarlable.getVarlable(arr["if"]).split("&&");
					ifvalue = ScriptIF.checkCondition(ifArr);
					if(ifvalue){
						if(LSouSouObject.sMap.loopIsRun)return;
						LSouSouObject.sMap.loopIsRun = true;
						ScriptFunction.analysis("Call.atBelongCoordinate(" + charas.belong + "," + coor.x + "," + coor.y + ");");
						return;
					}
				}else if(arr["type"] == "SouSouSCharacter.atBelongCoordinates"){
					trace("LSouSouSMapScript 所属坐标区域测试");
					coor = arr["from"];
					coorTo = arr["to"];
					charas = LSouSouObject.charaSNow;
					if( charas== null)continue;
					if(charas.locationX < coor.x || charas.locationX > coorTo.x || charas.locationY < coor.y || charas.locationY > coorTo.y)continue;
					if(charas.belong != int(arr["belong"]))continue;
					ifArr = ScriptVarlable.getVarlable(arr["if"]).split("&&");
					ifvalue = ScriptIF.checkCondition(ifArr);
					if(ifvalue){
						if(LSouSouObject.sMap.loopIsRun)return;
						LSouSouObject.sMap.loopIsRun = true;
						LGlobal.script.scriptArray.varList["nowcharax"] = charas.locationX;
						LGlobal.script.scriptArray.varList["nowcharay"] = charas.locationY;
						ScriptFunction.analysis("Call.atBelongCoordinates(" + charas.belong + "," + coor.x + "," + coor.y + "," + coorTo.x + "," + coorTo.y + ");");
						return;
					}
				}else if(arr["type"] == "SouSouSCharacter.adjacent"){
					trace("LSouSouSMapScript 武将相邻测试");
					chara1 = arr["chara1"];
					chara2 = arr["chara2"];
					if(!chara1.visible || !chara2.visible)continue;
					ifArr = ScriptVarlable.getVarlable(arr["if"]).split("&&");
					ifvalue = ScriptIF.checkCondition(ifArr);
					if(ifvalue && Math.abs(chara1.locationX - chara2.locationX) <= 1 && Math.abs(chara1.locationY - chara2.locationY) <= 1){
						if(LSouSouObject.sMap.loopIsRun)return;
						LSouSouObject.sMap.loopIsRun = true;
						ScriptFunction.analysis("Call.adjacent(" + chara1.index + "," + chara2.index + ");");
						return;
					}
				}else if(arr["type"] == "SouSouSCharacter.atRound"){
					if(arr["roundCount"] != "-" && LSouSouObject.sMap.roundCount != int(arr["roundCount"]))continue;
					if(int(arr["belong"]) != LSouSouObject.sMap.belong_mode && arr["belong"] != "-")continue;
					ifArr = ScriptVarlable.getVarlable(arr["if"]).split("&&");
					trace("LSouSouSMapScript 回合测试",arr["if"],"ifArr="+ifArr);
					ifvalue = ScriptIF.checkCondition(ifArr);
					if(ifvalue){
						if(LSouSouObject.sMap.loopIsRun)return;
						LSouSouObject.sMap.loopIsRun = true;
						ScriptFunction.analysis("Call.atRound(" + LSouSouObject.sMap.belong_mode + "," + LSouSouObject.sMap.roundCount + ");");
						return;
					} 
				}else if(arr["type"] == "SouSouSCharacter.checkHp"){
					charas = arr["character"];
					trace("charas.index = ",charas.index);
					if(charas.member.troops < int(arr["minhp"]) || charas.member.troops > int(arr["maxhp"]))continue;
					ifArr = ScriptVarlable.getVarlable(arr["if"]).split("&&");
					trace("LSouSouSMapScript Hp 测试 -------------",arr["if"],"ifArr="+ifArr);
					ifvalue = ScriptIF.checkCondition(ifArr);
					if(ifvalue){
						if(LSouSouObject.sMap.loopIsRun)return;
						LSouSouObject.sMap.loopIsRun = true;
						LSouSouObject.dieIsRuning = true;
						LSouSouObject.runSChara = charas;
						LGlobal.script.scriptArray.varList["nowcharahp"] = charas.member.troops;
						ScriptFunction.analysis("Call.checkHp(" + charas.index + "," + arr["minhp"] + "," + arr["maxhp"] + ");");
						return;
					}
				}
			}
			LSouSouObject.sMap.loopIsRun = false;
		}
		public function initialization():void{
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
					LSouSouObject.sMap.addMap(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.addOur":
					LSouSouObject.sMap.addOurCharacter(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.addEnemy":
					LSouSouObject.sMap.addEnemyCharacter(lineValue.substring(start+1,end).split(","));
					break;
				case "SouSouSCharacter.addFriend":
					LSouSouObject.sMap.addFriendCharacter(lineValue.substring(start+1,end).split(","));
					break;
				default:
					initialization();
			}
			
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
			funLineArr.push("SouSouSMapCheck.actionOver();");
			script.lineList.shift();
			funArr["function"] = funLineArr;
			LSouSouObject.sMap.funList.push(funArr["name"]);
			script.scriptArray.funList[funArr["name"]] = funArr;
			
		} 
	}
}