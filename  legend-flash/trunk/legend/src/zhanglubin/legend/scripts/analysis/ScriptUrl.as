package zhanglubin.legend.scripts.analysis
{
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.text.ScriptLabel;
	import zhanglubin.legend.scripts.analysis.text.ScriptWind;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.transitions.LManager;

	public class ScriptUrl
	{
		
		public function ScriptUrl()
		{
		}
		/**
		 * 脚本解析
		 * 添加Wait
		 *
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Url.get":
					break;
				case "Url.post":
					break;
				default:
					LGlobal.script.analysis();
			}
			
		}
		/**
		 * 脚本解析
		 * Url.get(a=0,c=aaa,...);
		 * 
		 * @param 脚本信息
		 */
		private static function get(value:String,start:int,end:int):void{
		}
		/**
		 * 脚本解析
		 * Url.post(a=0,c=aaa,...);
		 * 
		 * @param 脚本信息
		 */
		private static function post(value:String,start:int,end:int):void{
		}
	}
}