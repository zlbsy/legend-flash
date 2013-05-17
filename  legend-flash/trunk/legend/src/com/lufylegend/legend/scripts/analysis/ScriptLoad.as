package com.lufylegend.legend.scripts.analysis
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import com.lufylegend.legend.display.LImageLoader;
	import com.lufylegend.legend.display.LLoader;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.display.LURLLoader;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.scripts.analysis.sousou.ScriptSouSouLoad;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LString;

	public class ScriptLoad
	{
		private static var _loader:LLoader;
		private static var _urlloader:LURLLoader;
		private static var _imgLoader:LImageLoader;
		private static var _data:Array;
		public function ScriptLoad()
		{
		}
		/**
		 * 脚本解析
		 * 读取文件
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			_data = value.substring(start+1,end).split(",");
			switch(LString.trim(value.substr(0,start))){
				case "Load.img":
					loadImg();
					break;
				case "Load.script":
					loadScript();
					break;
				case "Load.swf":
					loadSwf();
					break;
				/**
				case "Load.sousou":
					ScriptSouSouLoad.loadSouSou(_data);
					break;
				*/
				default:
					
			}
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Load.script(data/script/Main.lf);
		 * @param 脚本信息
		 */
		private static function loadScript():void{
			_urlloader = new LURLLoader();
			
			_urlloader.addEventListener(Event.COMPLETE,loadScriptOver);

			_urlloader.load(new URLRequest(_data[0]));
		}
		private static function loadScriptOver(event:Event):void{
			var script:LScript = LGlobal.script;
			var data:String = script.removeComment(event.target.data);
			_urlloader.die();
			_urlloader = null;
			script.saveList();
			script.dataList.unshift([data]);
			script.toList(data);
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Load.img(backdata,22.png);
		 * @param 脚本信息
		 */
		private static function loadImg():void{
			_imgLoader = new LImageLoader(_data[1]);
			_imgLoader.addEventListener(Event.COMPLETE,loadImgOver);
		}
		private static function loadImgOver(event:Event):void{
			var script:LScript = LGlobal.script;
			script.scriptArray.bitmapdataList[_data[0]] = _imgLoader.data;
			_imgLoader.die();
			_imgLoader = null;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Load.swf(backdata,22.swf);
		 * @param 脚本信息
		 */
		private static function loadSwf():void{
			_loader = new LLoader();
			_loader.addEventListener(Event.COMPLETE,loadSwfOver);
			_loader.load(_data[1]);
		}
		private static function loadSwfOver(event:Event):void{
			var script:LScript = LGlobal.script;
			script.scriptArray.swfList[_data[0]] = _loader.content;
			_loader.die();
			_loader = null;
			script.analysis();
		}
	}
}