package
{
	import flash.desktop.NativeApplication;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LString;
	
	[SWF(width="800",height="480",frameRate="50",backgroundcolor="0x000000")]
	public class Sanguoji extends LSprite
	{
		public function Sanguoji()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var sc:String = "Load.script(script/MainSLG.lf);";
			
			var spcript:LScript = new LScript(this,sc);
		}
		public function gameClose():void{
			NativeApplication.nativeApplication.exit();
		}
		public function saveGame(saveList:Array,name:String,path:String,saveName:String):String{
			if(path == null || path == "")path = "SanGuoJi";
			
			var stream:FileStream = new FileStream();
			var file:File = File.userDirectory.resolvePath("/sdcard/legend/" + path + "/" + name);
			stream.open(file,FileMode.WRITE);
			var i:int;
			for(i=0;i<saveList.length;i++){
				stream.writeUTF(saveList[i]);
			}
			/**
			stream.writeUTF(saveList[0]);//S
			stream.writeUTF(saveList[1]);//start_file
			stream.writeUTF(saveList[2]);//start_word
			stream.writeUTF(saveList[3]);//xmlMember.toXMLString()
			stream.writeUTF(saveList[4]);//LSouSouObject.itemsList.toXMLString()
			stream.writeUTF(saveList[5]);//LSouSouObject.propsList.toXMLString()
			stream.writeInt(saveList[6]);//LSouSouObject.money
			stream.writeUTF(saveList[7]);//varlable
			stream.writeUTF(saveList[8]);//mapXml.toXMLString()
			stream.writeUTF(saveList[9]);//mapXml.toXMLString()
			stream.writeUTF(saveList[10]);//mapXml.toXMLString()
			stream.writeUTF(saveList[11]);//mapXml.toXMLString()
			stream.writeUTF(dateStr);*/
			var date:Date = new Date();
			var dateStr:String = date.fullYear+"年"+date.month+"月"+date.date+"日 "+date.hours+":"+date.minutes+":"+date.seconds;
			/**
			var saveData:String = "<data>"
				+"<type>"+saveList[0]+"</type>"
				+"<start_file>"+saveList[1]+"</start_file>"
				+"<start_word>"+saveList[2]+"</start_word>"
				+"<xmlMember>"+saveList[3]+"</xmlMember>"
				+"<itemsList>"+saveList[4]+"</itemsList>"
				+"<propsList>"+saveList[5]+"</propsList>"
				+"<money>"+saveList[6]+"</money>"
				+"<varlable>"+saveList[7]+"</varlable>"
				+"<mapXml>"+saveList[8]+"</mapXml>"
				+"<name>"+dateStr+"</name>"
				+"</data>";
			stream.writeUnsignedInt(saveData.length);
			stream.writeUTFBytes(saveData);
			 * */
			stream.close();
			
			/**
			var save:SharedObject = SharedObject.getLocal(path+name);
			var i:int;
			for(i=0;i<saveList.length;i++){
				save.data["save"+i] = saveList[i];
			}
			var date:Date = new Date();
			var dateStr:String = date.fullYear+"年"+date.month+"月"+date.date+"日 "+date.hours+":"+date.minutes+":"+date.seconds;
			save.data["save"+i] = dateStr;
			save.flush();
			*/
			if(saveName != null && saveName.length > 0){
				return saveName;
			}
			return dateStr;
		}
		public function readGame(name:String,path:String = null):Array{
			if(path == null || path == "")path = "SanGuoJi";
			trace("/sdcard/legend/" + path + "/" + name);
			try{
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
			
			/**
			saveList[6] =stream.readInt();
			saveList[7] = new XML(stream.readUTF());
			saveList[8] = new XML(stream.readUTF());
			saveList[9] = stream.readUTF();
			*/
			
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
			
			/**
			 var save:SharedObject = SharedObject.getLocal(path+name);
			 var saveList:Array = new Array();
			 if(save.data["save0"] == null || save.data["save0"] == "")return null;
			 var i:int;
			 for(i=0;i<10;i++){
			 saveList.push(save.data["save"+i]);
			 }
			 */
			}catch(e:Error){
				trace(e.message);
				return null;
			}
			return saveList;
		}
	}
}