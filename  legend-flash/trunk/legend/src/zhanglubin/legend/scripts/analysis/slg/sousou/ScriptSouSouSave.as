package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.character.LSouSouMember;
	import zhanglubin.legend.game.sousou.map.LSouSouSingled;
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.transitions.LManager;

	public class ScriptSouSouSave
	{
		private static var _file:FileReference;
		public function ScriptSouSouSave()
		{
		}
		/**
		 * 脚本解析
		 * 存档
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var params:Array = value.substring(start + 1,end).split(",");
			var type:String = params[0];
			if(type == "read"){
				if(int(params[1]) == 1){
					readGameAsFile();
				}
			}else if(type == "save"){
				if(int(params[1]) == 1){
					saveGameAsFile();
				}
			}
		}
		/**
		 * 存档功能
		 * @param name 存档名称
		 */
		public static function saveGameAsFile(name:String = "save1"):String{
			var start_file:String = LGlobal.script.scriptArray.varList["save_file"];
			var start_word:String = LGlobal.script.scriptArray.varList["save_word"];
			var saveArray:Array,i:int;
			//var bytes:ByteArray = new ByteArray();
			//已加入我军队列的人员信息
			var mbr:LSouSouMember,xmlMember:XML = new XML("<data></data>");
			for each(mbr in LSouSouObject.memberList){
				xmlMember.appendChild(mbr.data);
			}
			
			var varlable:String = "<data>";
			for(var key:String in LGlobal.script.scriptArray.varList){
				if(LGlobal.script.scriptArray.varList[key] != null && LGlobal.script.scriptArray.varList[key].toString().length > 0){
					varlable += "<varlable name='" + key + "'>"+LGlobal.script.scriptArray.varList[key]+"</varlable>";
				}
			}
			varlable += "</data>";
			
			//如果R剧情进行中，则储存R存档，否则进行S存档
			if(LSouSouObject.sMap == null){
				/*
				bytes.writeUTF("R");
				bytes.writeUTF(start_file);
				bytes.writeUTF(start_word);
				bytes.writeUTF(xml.toXMLString());
				bytes.writeUTF(LSouSouObject.itemsList.toXMLString());
				bytes.writeUTF(LSouSouObject.propsList.toXMLString());
				bytes.writeInt(LSouSouObject.money);*/
				
				saveArray = [
					"R",
					start_file,
					start_word,
					xmlMember.toXMLString(),
					LSouSouObject.itemsList.toXMLString(),
					LSouSouObject.propsList.toXMLString(),
					LSouSouObject.money,
					varlable,
					new XML("<data></data>")
				];
			}else{
				var mapXml:XML = new XML("<data></data>");
				var charaXml:XML = new XML("<charalist></charalist>");
				var stageList:XML = new XML("<stagelist></stagelist>");
				var weatherXml:XML = new XML("<weather>" + 
					"<weatherIndex>" + LSouSouObject.sMap.weatherIndex + "</weatherIndex>" + 
					"<weatherArray>" + 
					LSouSouObject.sMap.weather[0][1] + "," + 
					LSouSouObject.sMap.weather[1][1] + "," + 
					LSouSouObject.sMap.weather[2][1] + "," + 
					LSouSouObject.sMap.weather[3][1] + "," + 
					LSouSouObject.sMap.weather[4][1] +  
					"</weatherArray>" + 
					"</weather>");
				var conditionXml:XML = new XML("<condition>" + LSouSouObject.sMap.condition.join(",") + "</condition>");
				var charas:LSouSouCharacterS;
				mapXml.appendChild(conditionXml);
				mapXml.appendChild(weatherXml);
				mapXml.roundCount = LSouSouObject.sMap.roundCount;
				mapXml.mapCoordinate = LSouSouObject.sMap.mapCoordinate.toString();
				LSouSouObject.sMap.stageList;
				if(LSouSouObject.sMap.stageList.length > 0){
					////战场物件，火，船等[icon,index,maxindex,x，y，fun,stageindex]
					for each(stageList in LSouSouObject.sMap.stageList){
						var stageIndex:int = stageList[6];
						var x:int = stageList[3];
						var y:int = stageList[4];
						stageList.appendChild(new XML("<stage><index>"+stageIndex+"</index><x>"+x+"</x><y>"+y+"</y></stage>"));
					}
				};
				for each(charas in LSouSouObject.sMap.ourlist){
					charaXml.appendChild(charas.getSaveData());
				}
				for each(charas in LSouSouObject.sMap.friendlist){
					charaXml.appendChild(charas.getSaveData());
				}
				for each(charas in LSouSouObject.sMap.enemylist){
					charaXml.appendChild(charas.getSaveData());
				}
				mapXml.appendChild(charaXml);
				//trace("mapXml = " + mapXml);
				saveArray = [
					"S",
					start_file,
					start_word,
					xmlMember.toXMLString(),
					LSouSouObject.itemsList.toXMLString(),
					LSouSouObject.propsList.toXMLString(),
					LSouSouObject.money,
					varlable,
					mapXml.toXMLString()
				];
				
			}
			//trace("saveGameAsFile saveArray = " + saveArray);
			var savepath:String = LGlobal.script.scriptArray.varList["savepath"];
			//return "ScriptSouSouSave saveGameAsFile over";
			return LGlobal.script.scriptLayer["saveGame"](saveArray,name + ".slf",savepath);
		}
		/**
		 * 脚本解析
		 * 
		 * @param 脚本信息
		 */
		public static function readGameAsFile(name:String = "save1"):void{
			var savepath:String = LGlobal.script.scriptArray.varList["savepath"];
			var saveArray:Array = LGlobal.script.scriptLayer["readGame"](name,savepath);
			
			var type:String = saveArray[0];
			var start_file:String = saveArray[1];
			var start_word:String = saveArray[2];
			var member_str:String = saveArray[3];
			if(!LSouSouObject.memberList)LSouSouObject.memberList = new Array();
			LSouSouObject.memberList.splice(0,LSouSouObject.memberList.length);
			var mbr:LSouSouMember,cxml:XML,xml:XML = new XML(member_str);
			for each(cxml in xml.elements()){
				mbr = new LSouSouMember();
				mbr.data = new XML(cxml.toXMLString());
				LSouSouObject.memberList.push(mbr);
			}
			LSouSouObject.itemsList = new XML(saveArray[4]);
			LSouSouObject.propsList = new XML(saveArray[5]);
			LSouSouObject.money = saveArray[6];
			var varlable:XML = new XML(saveArray[7]);
			var childxml:XML;
			for each(childxml in varlable.elements()){
				LGlobal.script.scriptArray.varList[childxml.@name] = childxml.toString();
			}
			LGlobal.isreading = start_word;
			
			if(type == "S"){
				LSouSouObject.sMapSaveXml = new XML(saveArray[8]);
			}
			//存档数据读取完毕，开始读取相关RS文件
			LGlobal.script.saveList();
			LGlobal.script.lineList.unshift("Exit.run();");
			LGlobal.script.lineList.unshift("Load.script(script/"+start_file+".lf);");
			LGlobal.script.lineList.unshift("Text.label(-,load,Loading……,280,230,30,#ffffff);");
			LGlobal.script.lineList.unshift("Layer.drawRect(-,0,0,800,480,0x000000,1);");
			LGlobal.script.lineList.unshift("Layer.clear(-);");
			LGlobal.script.analysis();
		}
	}
}