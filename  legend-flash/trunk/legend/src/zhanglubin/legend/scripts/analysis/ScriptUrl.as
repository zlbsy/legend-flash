package zhanglubin.legend.scripts.analysis
{
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import zhanglubin.legend.net.LNet;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;

	public class ScriptUrl
	{
		private static var _error:Function;
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
					run(URLRequestMethod.GET,value,start,end);
					break;
				case "Url.post":
					run(URLRequestMethod.POST,value,start,end);
					break;
				case "Url.error":
					setError(value,start,end);
					break;
				default:
					LGlobal.script.analysis();
			}
			
		}
		/**
		 * 脚本解析
		 * Url.error(errorFun);
		 * 
		 * @param 脚本信息
		 */
		private static function setError(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			_error = function():void{
				ScriptFunction.analysis("Call." + params[0] + "();");
			}
		}
		private static function complete(str:String):void{
			var script:LScript = LGlobal.script;
			var data:String = script.removeComment(str);
			script.saveList();
			script.dataList.unshift([data]);
			script.toList(data);
		}
		/**
		 * 脚本解析
		 * Url.get(url,a=0,c=aaa,...);
		 * Url.post(url,a=0,c=aaa,...);
		 * 
		 * @param 脚本信息
		 */
		private static function run(method:String,value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var params:Array = value.substring(start+1,end).split(",");
			var variables:URLVariables = new URLVariables();
			var i:int,param:Array;
			if(params.length > 1){
				for(i=1;i<params.length;i++){
					param = (params[i] as String).split("=");
					variables[param[0]] = param[1];
				}
			}
			if(_error==null)_error=function():void{};
			LGlobal.url.setVariables(params[0],variables,_error,complete);
			LGlobal.url.run(method,LNet.TYPE_STRING);
		}
	}
}