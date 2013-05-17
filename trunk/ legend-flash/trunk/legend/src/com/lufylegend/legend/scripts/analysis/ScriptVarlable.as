package com.lufylegend.legend.scripts.analysis
{
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LGlobal;

	public class ScriptVarlable
	{
		public function ScriptVarlable()
		{
		}
		/**
		 * 脚本解析
		 * 变量
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Var.set":
					setVarlable(value,start,end);
					break;
				default:
					
			}
			
		}
		/**
		 * 脚本解析
		 * 移动层
		 * Var.set(test,5);
		 * @param 脚本信息
		 */
		private static function setVarlable(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			script.scriptArray.varList[lArr[0]] = lArr[1];
			trace(lArr[0],lArr[1]);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 移动层
		 * Var.get(test);
		 * @param 脚本信息
		 */
		public static function getVarlable(str:String):String{
			var script:LScript = LGlobal.script;
			var iIndex:int = 0;
			var sIndex:int;
			var eIndex:int;
			var sStr:String;
			var eStr:String;
			var vStr:String;
			var result:String = "";
			var r:RegExp = new RegExp("[0-9]|[a-z]|[A-Z]|_");
			sIndex = str.indexOf("@");
			while(sIndex >=0){
				eIndex = str.indexOf("@",sIndex+1);
				if(sIndex + 1 == eIndex){
					sStr = str.substr(iIndex,sIndex);
					vStr = "@";
					eStr = str.substr(eIndex + 1);
					iIndex = eIndex + 1;
				}else{
					sStr = str.substring(iIndex,sIndex);
					vStr = "";
					sIndex++;
					while(r.test(str.charAt(sIndex))){
						vStr += str.charAt(sIndex);
						sIndex++;
					}
					vStr = script.scriptArray.varList[vStr];
					eStr = str.substr(sIndex);
					iIndex = sIndex;
				};
				result += (sStr + vStr);
				sIndex = str.indexOf("@",iIndex);
			}
			result += str.substr(iIndex);
			return result;
		}
	}
}