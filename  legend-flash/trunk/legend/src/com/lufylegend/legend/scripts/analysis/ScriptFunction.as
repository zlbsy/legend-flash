package com.lufylegend.legend.scripts.analysis
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import com.lufylegend.legend.display.LImageLoader;
	import com.lufylegend.legend.display.LLoader;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.display.LURLLoader;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LString;

	public class ScriptFunction
	{
		private static var _loader:LLoader;
		private static var _urlloader:LURLLoader;
		private static var _imgLoader:LImageLoader;
		private static var _data:Array;
		public function ScriptFunction()
		{
		}
		/**
		 * 脚本解析
		 * 函数
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			trace("ScriptFunction analysis value = " + value);
			var script:LScript = LGlobal.script;
			var point:int = value.indexOf(".");
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var name:String = value.substring(point + 1,start);
			var funArr:Array = script.scriptArray.funList[name];
			if(funArr == null){
				script.analysis();
				return;
			}
			_data = value.substring(start+1,end).split(",");
			var param:Array = funArr["param"];
			var i:int;
			for(i=0;i<param.length;i++){
				script.scriptArray.varList[param[i]] = _data[i];
			}
			var funLineArr:Array = funArr["function"];
			/**
			var data:String = "";
			for(i=0;i<funLineArr.length;i++){
				data += funLineArr[i] + ";";
				trace("ScriptFunction analysis funLineArr[i] = " + funLineArr[i]);
				script.lineList.unshift(funLineArr[i]);
			}
			script.saveList();
			script.dataList.unshift([data]);
			script.toList(data);
			*/
			
			for(i=funLineArr.length-1;i>=0;i--)script.lineList.unshift(funLineArr[i]);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * funjction
		 * @param 脚本信息
		 * function test(5,"p");
		 *     ****
		 * endfunction;
		 */
		public static function setFunction(value:String):void{
			var script:LScript = LGlobal.script;
			var startNameIndex:int = value.indexOf(" ");
			var child:String;
			var funArr:Array = new Array();
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var strParam:String = value.substring(start + 1,end);
			var param:Array = strParam.split(",");
			funArr["param"] = new Array();
			var i:uint;
			for(i=0;i<param.length;i++){
				param[i] = LString.trim(param[i]);
				if((param[i] as String).length > 0)	{
					(funArr["param"] as Array).push("param_" + param[i]);
				}
			}
			funArr["name"] = LString.trim(value.substring(startNameIndex + 1,start));
			
			var funLineArr:Array = new Array();
			while(script.lineList[0].indexOf("endfunction") < 0){
				child = script.lineList.shift();
				for(i=0;i<param.length;i++){
					if((param[i] as String).length > 0)	child = child.replace("@"+param[i],"@param_"+param[i]);
				}
				funLineArr.push(child);
			}
			script.lineList.shift();
			funArr["function"] = funLineArr;
			script.scriptArray.funList[funArr["name"]] = funArr;
			script.analysis();
		} 
	}
}