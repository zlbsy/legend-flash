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
			for(i = 0;i<1000;i++){
				if(LGlobal.script.scriptArray.varList["sousou" + i] != null && LGlobal.script.scriptArray.varList["sousou" + i].toString().length > 0){
					varlable += "<varlable name='sousou"+i+"'>"+LGlobal.script.scriptArray.varList["sousou" + i]+"<varlable>";
				}
			}
			varlable += "</data>";
			
			//如果R剧情进行中，则储存R存档，否则进行S存档
			if(LSouSouObject.rMap != null){
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
					varlable
				];
			}else{
				var mapXml:XML = new XML("<data></data>");
				var charaXml:XML = new XML("<charalist></charalist>");
				var stageList:XML = new XML("<stagelist></stagelist>");
				var charas:LSouSouCharacterS;
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
				trace("mapXml = " + mapXml);
				saveArray = [
					"S",
					start_file,
					start_word,
					xmlMember.toXMLString(),
					LSouSouObject.itemsList.toXMLString(),
					LSouSouObject.propsList.toXMLString(),
					LSouSouObject.money,
					varlable
				];
				
			}
			var savepath:String = LGlobal.script.scriptArray.varList["savepath"];
			return "ScriptSouSouSave saveGameAsFile over";
			return LGlobal.script.scriptLayer["saveGame"](saveArray,name + ".slf",savepath);
		}
		/**
		 * 脚本解析
		 * 
		 * @param 脚本信息
		 */
		public static function readGameAsFile(name:String = "save1"):void{
			var savepath:String = LGlobal.script.scriptArray.varList["savepath"];
			var saveArray:Array = LGlobal.script.scriptLayer["readGame"](name+".slf",savepath);
			
			
			var start_file:String = saveArray[0];
			var start_word:String = saveArray[1];
			var member_str:String = saveArray[2];
			if(!LSouSouObject.memberList)LSouSouObject.memberList = new Array();
			LSouSouObject.memberList.splice(0,LSouSouObject.memberList.length);
			var mbr:LSouSouMember,cxml:XML,xml:XML = new XML(member_str);
			for each(cxml in xml.elements()){
				mbr = new LSouSouMember();
				mbr.data = new XML(cxml.toXMLString());
				LSouSouObject.memberList.push(mbr);
			}
			LSouSouObject.itemsList = new XML(saveArray[3]);
			LSouSouObject.propsList = new XML(saveArray[4]);
			LSouSouObject.money = saveArray[5];
			var varlable:XML = new XML(saveArray[6]);
			var childxml:XML;
			for each(childxml in varlable.elements()){
				LGlobal.script.scriptArray.varList[childxml.@name] = childxml.toString();
			}
			
			LGlobal.isreading = start_word;
			//LGlobal.script.scriptArray.varList["isreading"] = start_word;
			LGlobal.script.saveList();
			
			
			LGlobal.script.lineList.unshift("Exit.run();");
			LGlobal.script.lineList.unshift("Load.script(script/"+start_file+".lf);");
			LGlobal.script.lineList.unshift("Text.label(-,load,Loading……,280,230,30,#ffffff);");
			LGlobal.script.lineList.unshift("Layer.drawRect(-,0,0,800,480,0x000000,1);");
			LGlobal.script.lineList.unshift("Layer.clear(-);");
			//LGlobal.script.lineList.unshift("Mark.goto("+start_word+");");
			LGlobal.script.analysis();
			
			/**
			trace("readGameAsFile is run");
			_file = new FileReference();
			_file.browse([new FileFilter("save files", "*.slf")] );
			_file.addEventListener(Event.SELECT,openSaveFile);
			*/
		}
		public static function openSaveFile(event:Event):void{
			_file.removeEventListener(Event.SELECT,openSaveFile);
			_file.load();
			_file.addEventListener(Event.COMPLETE,readFile);
		}
		public static function readFile(event:Event):void{
			_file.removeEventListener(Event.COMPLETE,readFile);
			
			var bytes:ByteArray = event.target.data as ByteArray;
			//bytes.uncompress();
			var start_file:String = bytes.readUTF();
			var start_word:String = bytes.readUTF();
			var member_str:String = bytes.readUTF();
			if(!LSouSouObject.memberList)LSouSouObject.memberList = new Array();
			LSouSouObject.memberList.splice(0,LSouSouObject.memberList.length);
			var mbr:LSouSouMember,cxml:XML,xml:XML = new XML(member_str);
			for each(cxml in xml.elements()){
				mbr = new LSouSouMember();
				mbr.data = new XML(cxml.toXMLString());
				LSouSouObject.memberList.push(mbr);
			}
			LSouSouObject.itemsList = new XML(bytes.readUTF());
			LSouSouObject.propsList = new XML(bytes.readUTF());
			LSouSouObject.money = bytes.readInt();
			
			LGlobal.isreading = start_word;
			//LGlobal.script.scriptArray.varList["isreading"] = start_word;
			LGlobal.script.saveList();
			LGlobal.script.lineList.unshift("Exit.run();");
			LGlobal.script.lineList.unshift("Load.script(script/"+start_file+".lf);");
			LGlobal.script.lineList.unshift("Layer.clear(-);");
			//LGlobal.script.lineList.unshift("Mark.goto("+start_word+");");
			LGlobal.script.analysis();
		}
	}
}