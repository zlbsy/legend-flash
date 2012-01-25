package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import zhanglubin.legend.display.LImageLoader;
	import zhanglubin.legend.display.LLoader;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.load.LLoading;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class SouSouLoad
	{
		private static var _loader:LLoader;
		private static var _urlloader:LURLLoader;
		private static var _imgLoader:LImageLoader;
		private static var _data:Array;
		private static var _urlData:Array;
		private static var _loadBar:LLoading;
		public function SouSouLoad()
		{
		}
		/**
		 * 脚本解析
		 * 添加层
		 * SouSouObjectLoad.load(path,swf);
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			_loadBar = new LLoading(400);
			_loadBar.xy = new LCoordinate((LGlobal.stage.stageWidth - _loadBar.width)/2,(LGlobal.stage.stageHeight - _loadBar.height)/2);
			LGlobal.script.scriptLayer.addChild(_loadBar);
			
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			_data = value.substring(start+1,end).split(",");
			loadSwfImg();
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
			_loadBar.per = 20;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["img"] = _loader.content;
			_loader.die();
			_loader = null;
			loadSwfR();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * @param 脚本信息
		 */
		private static function loadSwfR():void{
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfROver);
			_loader.load(_data[0] + "/R." + _data[1]);
		}
		private static function loadSwfROver(event:Event):void{
			_loadBar.per = 30;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["R"] = _loader.content;
			
			_loader.die();
			_loader = null;
			loadSwfS();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * @param 脚本信息
		 */
		private static function loadSwfS():void{
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfSOver);
			_loader.load(_data[0] + "/S." + _data[1]);
		}
		private static function loadSwfSOver(event:Event):void{
			_loadBar.per = 40;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["S"] = _loader.content;
			
			_loader.die();
			_loader = null;
			loadSwfFace();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * @param 脚本信息
		 */
		private static function loadSwfFace():void{
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfFaceOver);
			_loader.load(_data[0] + "/face." + _data[1]);
		}
		private static function loadSwfFaceOver(event:Event):void{
			_loadBar.per = 70;
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList["face"] = _loader.content;
			trace("SouSouLoad loadSwfFaceOver");
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
			
			_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadCharaOver);
			_urlloader.load(new URLRequest(_urlData[0] + "/chara." + _urlData[1]));
		}
		private static function loadCharaOver(event:Event):void{
			_loadBar.per = 100;
			LSouSouObject.chara = new XML(_urlloader.data);
			_urlloader.removeAllEventListener();
			LGlobal.script.scriptLayer.die();
			LGlobal.script.analysis();
		}
	}
}