package com.lufylegend.legend.scripts.analysis
{
	import flash.net.SharedObject;
	
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LGlobal;

	public class ScriptSave
	{
		public function ScriptSave()
		{
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Var.set(test,5);
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Save.set":
					save(value,start,end);
					break;
				case "Save.get":
					read(value,start,end);
					break;
				default:
					
			}
			
		}
		/**
		 * 脚本解析
		 * 移动层
		 * Save.set(savename,name,path,0);
		 * @param 脚本信息
		 */
		private static function save(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var sharedName:String = lArr[0];
			var varName:String = "";
			var size:uint = 0;
			var path:String = null;
			if(lArr.length > 1){
				varName = lArr[1];
			}
			if(lArr.length > 2){
				path = lArr[2];
			}
			if(lArr.length > 3){
				size = uint(lArr[3]);
			}
			var save:SharedObject = SharedObject.getLocal(sharedName,path);
			if(varName.length == 0){
				for (var key:String in script.scriptArray.varList){ 
					save.data[key] = script.scriptArray.varList[key];
				}    
			}else{
				save.data[varName] = script.scriptArray.varList[varName];
			}
			save.flush(size);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 移动层
		 * Save.get(savename,name,path);
		 * @param 脚本信息
		 */
		private static function read(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var sharedName:String = lArr[0];
			var varName:String = "";
			var size:uint = 0;
			var path:String = null;
			if(lArr.length > 1){
				varName = lArr[1];
			}
			if(lArr.length > 2){
				path = lArr[2];
			}
			if(lArr.length > 3){
				size = uint(lArr[3]);
			}
			var save:SharedObject = SharedObject.getLocal(sharedName,path);
			for (var key:String in script.scriptArray.varList){ 
				save.data[key] = script.scriptArray.varList[key];
			}    
			script.analysis();
		}
	}
}