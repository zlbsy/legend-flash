package zhanglubin.legend.scripts.analysis
{
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	
	public class ScriptExit
	{
		
		/**
		 * 脚本解析
		 * 添加层
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var params:Array = value.substring(start+1,end).split(",");
			var script:LScript = LGlobal.script;
			var dataList:Array = LGlobal.script.dataList;
			var arr:Array;
			LGlobal.script.lineList.splice(0,LGlobal.script.lineList.length);
			LGlobal.script.analysis();
		}
	}
}