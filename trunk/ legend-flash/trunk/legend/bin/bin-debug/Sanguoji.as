package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.fscommand;
	
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LString;
	
	[SWF(width="800",height="480",frameRate="50",backgroundcolor="0x000000")]
	public class Sanguoji extends LSprite
	{
		public static var _4399_function_ad_id:String = "92d6cef76cd06829e088932fe9fd819b";
		public function Sanguoji()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var sc:String = "Load.script(script/MainSLG.lf);";
			
			var spcript:LScript = new LScript(this,sc);
		}
		public function gameClose():void{
			//NativeApplication.nativeApplication.exit();
			fscommand("quit");
		}
		public function saveGame(saveList:Array,name:String,path:String,saveName:String):String{
			if(path == null || path == "")path = "SanGuoJi";
			/**
			 var stream:FileStream = new FileStream();
			 var file:File = File.userDirectory.resolvePath("/sdcard/legend/" + path + "/" + name);
			 stream.open(file,FileMode.WRITE);
			 var i:int;
			 for(i=0;i<saveList.length;i++){
			 stream.writeUTF(saveList[i]);
			 }
			 
			 stream.close();
			 */
			
			var save:SharedObject = SharedObject.getLocal(path+name);
			var i:int;
			for(i=0;i<saveList.length;i++){
				save.data["save"+i] = saveList[i];
			}
			save.flush();
			
			if(saveName != null && saveName.length > 0){
				return saveName;
			}
			var date:Date = new Date();
			var dateStr:String = date.fullYear+"年"+date.month+"月"+date.date+"日 "+date.hours+":"+date.minutes+":"+date.seconds;
			return dateStr;
		}
		public function readGame(name:String,path:String = null):Array{
			if(path == null || path == "")path = "SanGuoJi";
			//trace("/sdcard/legend/" + path + "/" + name);
			try{
				/**
				 var file:File = File.userDirectory.resolvePath("/sdcard/legend/" + path + "/" + name);
				 if(!file.exists)return null;
				 var stream:FileStream = new FileStream();
				 stream.open(file,FileMode.READ);
				 var saveList:Array = new Array();
				 saveList[0] = stream.readUTF();
				 saveList[1] = stream.readUTF();
				 saveList[2] = stream.readUTF();
				 saveList[3] = new XML(stream.readUTF());
				 saveList[4] = new XML(stream.readUTF());
				 saveList[5] = new XML(stream.readUTF());
				 saveList[6] = int(stream.readUTF());
				 saveList[7] = new XML(stream.readUTF());
				 var mapXml:XML = new XML(stream.readUTF());
				 var i:int,l:int= int(mapXml.charaLength);
				 var charaXml:XML = new XML("<charalist></charalist>");
				 for(i=0;i<l;i++){
				 charaXml.appendChild(new XML(stream.readUTF()));
				 }
				 mapXml.appendChild(charaXml);
				 saveList[8] = mapXml;
				 saveList[9] = mapXml.saveName;
				 stream.close();
				 */
				
				var save:SharedObject = SharedObject.getLocal(path+name);
				var saveList:Array = new Array();
				if(save.data["save0"] == null || save.data["save0"] == "")return null;
				saveList[0] = save.data["save0"];
				saveList[1] = save.data["save1"];
				saveList[2] = save.data["save2"];
				saveList[3] = new XML(save.data["save3"]);
				saveList[4] = new XML(save.data["save4"]);
				saveList[5] = new XML(save.data["save5"]);
				saveList[6] = int(save.data["save6"]);
				saveList[7] = new XML(save.data["save7"]);
				var mapXml:XML = new XML(save.data["save8"]);
				var i:int,l:int= int(mapXml.charaLength);
				var charaXml:XML = new XML("<charalist></charalist>");
				for(i=9;i<9 + l;i++){
					charaXml.appendChild(new XML(save.data["save" + i]));
				}
				mapXml.appendChild(charaXml);
				saveList[8] = mapXml;
				saveList[9] = mapXml.saveName;
				
			}catch(e:Error){
				trace(e.message);
				return null;
			}
			return saveList;
		}
	}
}