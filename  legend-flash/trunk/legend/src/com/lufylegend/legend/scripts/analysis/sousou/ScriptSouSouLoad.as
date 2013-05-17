package com.lufylegend.legend.scripts.analysis.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LImageLoader;
	import com.lufylegend.legend.display.LLoader;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.display.LURLLoader;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.load.LLoading;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LString;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class ScriptSouSouLoad
	{
		private static var _loader:LLoader;
		private static var _urlloader:LURLLoader;
		private static var _imgLoader:LImageLoader;
		private static var _data:Array;
		private static var _urlData:Array;
		private static var _loadBar:LLoading;
		private static var _path:String = "images/";
		public function ScriptSouSouLoad()
		{
		}
		/**
		 * 脚本解析
		 * 添加层
		 * SouSouObjectLoad.load(path,swf);
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			trace("ScriptSouSouLoad analysis");
			_loadBar = new LLoading(400);
			_loadBar.xy = new LCoordinate((LGlobal.stage.stageWidth - _loadBar.width)/2,(LGlobal.stage.stageHeight - _loadBar.height)/2);
			LGlobal.script.scriptLayer.addChild(_loadBar);
			
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var params:Array = value.substring(start+1,end).split(",");
			switch(LString.trim(value.substr(0,start))){
				case "SouSouObjectLoad.loadimg":
					_data = ["images","swf"];
					loadSwfImg();
					break;
				case "SouSouObjectLoad.loadfile":
					_data = ["initialization","sgj",int(params[0])];
					loadSouSou(_data);
					break;
				default:
					
			}
			//_data = value.substring(start+1,end).split(",");
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Load.swf(backdata,22.swf);
		 * @param 脚本信息
		 */
		private static function loadSwfImg():void{
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfImgOver);
			_loader.load(_data[0] + "/img." + _data[1]);
		}
		private static function loadSwfImgOver(event:Event):void{
			_loadBar.per = 10;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["img"] = _loader.content;
			_loader.die();
			_loader = null;
			//loadSwfR();
			loadSwfR0();
		}
		/**
		 * 脚本解析
		 * 读取R正面形象
		 */
		private static function loadSwfR0():void{
			trace("loadSwfR0");
			//_loader = new LLoader();
			//_loader.addEventListener(Event.COMPLETE,loadR0Over);
			//_loader.load("images/r0.limg");
			//_loader.load("images/R.swf");
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadR0Over);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"r0.limg"));
			
		}
		private static function loadR0Over(event:Event):void{
			trace("loadR0Over");
			_loadBar.per = 15;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.charaR0List.push(bitmapdata);
				//var b:LBitmap = new LBitmap(bitmapdata);
				//Global.script.scriptLayer.addChild(b);
				//trace("ok");
				//return;
				
				size = w*h*4 + 8;
			}
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadR1Over);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"r1.limg"));
			
			/*
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["R"] = _loader.content;
			
			_loader.die();
			_loader = null;
			loadSwfS();
			*/
		}
		private static function loadR1Over(event:Event):void{
			trace("loadR1Over");
			_loadBar.per = 20;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.charaR1List.push(bitmapdata);
				size = w*h*4 + 8;
			}
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadATKOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"atk.limg"));
		}
		private static function loadATKOver(event:Event):void{
			trace("loadATKOver");
			_loadBar.per = 30;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.charaATKList.push(bitmapdata);
				size = w*h*4 + 8;
			}
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadMOVOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"mov.limg"));
		}
		private static function loadMOVOver(event:Event):void{
			trace("loadMOVOver");
			_loadBar.per = 40;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.charaMOVList.push(bitmapdata);
				size = w*h*4 + 8;
			}
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadSPCOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"spc.limg"));
		}
		private static function loadSPCOver(event:Event):void{
			trace("loadSPCOver");
			_loadBar.per = 50;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.charaSPCList.push(bitmapdata);
				size = w*h*4 + 8;
			}
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadFaceOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"face.limg"));
		}
		private static function loadFaceOver(event:Event):void{
			trace("loadFaceOver");
			_loadBar.per = 60;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.charaFaceList.push(bitmapdata);
				size = w*h*4 + 8;
			}
			_urlloader.die();
			_urlloader = null;
			
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfSoundOver);
			_loader.load(_data[0] + "/sound." + _data[1]);
		}
		private static function loadSwfSoundOver(event:Event):void{
			trace("loadSwfSoundOver");
			_loadBar.per = 70;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["sound"] = _loader.content;
			
			_loader.die();
			_loader = null;
			//loadSwfMeff();
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadMeffImgOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"meff.limg2"));
		}
		private static function loadMeffImgOver(event:Event):void{
			_loadBar.per = 80;
			var script:LScript = LGlobal.script;
			//script.scriptArray.swfList["meff"] = _loader.content;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var limg2:String;
			var l:uint,w:uint,h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				l = bytes.readUnsignedInt();
				limg2 = bytes.readUTFBytes(l);
				trace("img2 meff = " + limg2);
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.meffImg[limg2] = bitmapdata;
				size = l + w*h*4 + 12;
			}
			trace("loadMeffOver");
			_urlloader.die();
			//_urlloader = null;
			//loadSwfItem();
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadItemImgOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_path+"item.limg2"));
		}
		private static function loadItemImgOver(event:Event):void{
			_loadBar.per = 80;
			var script:LScript = LGlobal.script;
			
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			//return;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var limg2:String;
			var l:uint,w:uint,h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			for(i=0;i<bytes.length;i+=size){
				l = bytes.readUnsignedInt();
				limg2 = bytes.readUTFBytes(l);
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				LSouSouObject.itemImg[limg2] = bitmapdata;
				size = l + w*h*4 + 12;
			}
			trace("loadMeffOver");
			_urlloader.die();
			_urlloader = null;
			//loadSwfItem();
			loadSwfStage();
			
		}
		/**
		private static function loadSwfMeff():void{
			trace("loadSwfMeff");
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfMeffOver);
			_loader.load(_data[0] + "/meff." + _data[1]);
		}
		private static function loadSwfMeffOver(event:Event):void{
			_loadBar.per = 80;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["meff"] = _loader.content;
			
			trace("loadSwfMeffOver");
			_loader.die();
			_loader = null;
			loadSwfItem();
		}
		private static function loadSwfItem():void{
			trace("loadSwfItem");
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfItemOver);
			_loader.load(_data[0] + "/item." + _data[1]);
		}
		private static function loadSwfItemOver(event:Event):void{
			_loadBar.per = 90;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["item"] = _loader.content;
			
			trace("loadSwfItemOver");
			_loader.die();
			_loader = null;
			loadSwfStage();
		}*/
		private static function loadSwfStage():void{
			trace("loadSwfStage");
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfStageOver);
			_loader.load(_data[0] + "/stage." + _data[1]);
		}
		private static function loadSwfStageOver(event:Event):void{
			_loadBar.per = 100;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["stage"] = _loader.content;
			trace("loadSwfStageOver");
			_loadBar.removeFromParent();
			_loader.die();
			_loader = null;
			script.analysis();
		}
		
		
		/**
		 * 脚本解析
		 * 
		 * Load.sousou(data/initialization);
		 * @param 脚本信息
		 */
		public static function loadSouSou(urldata:Array):void{
			_urlData = urldata;
			trace("loadSouSou ",_urlData[0] + "/chara." + _urlData[1]);
			_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadCharaOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/chara." + _urlData[1]));
		}
		private static function loadCharaOver(event:Event):void{
			trace("loadCharaOver start");
			_loadBar.per = 20;
			LSouSouObject.chara = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			trace("loadCharaOver ",_urlData[0] + "/Arms." + _urlData[1]);
			_urlloader.addEventListener(Event.COMPLETE,loadArmsOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Arms." + _urlData[1]));
		}
		private static function loadArmsOver(event:Event):void{
			_loadBar.per = 40;
			trace(_urlloader.data);
			LSouSouObject.arms = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			
			//_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadStrategyOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Strategy." + _urlData[1]));
			
		}
		private static function loadStrategyOver(event:Event):void{
			_loadBar.per = 50;
			LSouSouObject.strategy = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			
			//_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadSkillOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Skill." + _urlData[1]));
		}
		private static function loadSkillOver(event:Event):void{
			_loadBar.per = 60;
			LSouSouObject.skill = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			
			//_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadTerrainOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Terrain." + _urlData[1]));
		}
		private static function loadTerrainOver(event:Event):void{
			_loadBar.per = 70;
			LSouSouObject.terrain = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			
			//_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadPropsOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Props." + _urlData[1]));
		}
		private static function loadPropsOver(event:Event):void{
			_loadBar.per = 80;
			LSouSouObject.props = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			//_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadStageOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Stage." + _urlData[1]));
		}
		private static function loadStageOver(event:Event):void{
			_loadBar.per = 90;
			LSouSouObject.mapStage = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			
			_urlloader.addEventListener(Event.COMPLETE,loadItemOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/Item." + _urlData[1]));
		}
		private static function loadItemOver(event:Event):void{
			_loadBar.per = 100;
			LSouSouObject.item = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			if(_data[2] == 1){
				LGlobal.script.scriptLayer.die();
			}
			_loadBar.removeFromParent();
			LGlobal.script.analysis();
		}
	}
}