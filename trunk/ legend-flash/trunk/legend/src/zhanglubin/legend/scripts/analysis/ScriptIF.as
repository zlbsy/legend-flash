package zhanglubin.legend.scripts.analysis
{
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	
	public class ScriptIF
	{
		
		/**
		 * 脚本解析
		 * if
		 * @param 脚本信息
		 * if(1==1 && 2>1);
		 * Img.d();
		 * elseif(2==2);
		 * Img.d();
		 * else;
		 * K.sr();
		 * endif;
		 */
		public static function getIF(value:String):void{
			var script:LScript = LGlobal.script;
			var startifIndex:int = 0;
			var endifIndex:int = 0;
			var ifArr:Array;
			var childArray:Array = new Array();
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var str:String = value.substring(start + 1,end);
			ifArr = str.split("&&");
			var ifvalue:Boolean = checkCondition(ifArr);
			var ifvalueend:Boolean = false;
			var sCount:int = 0;
			var eCount:int = 0;
			
			while(startifIndex<script.lineList.length){
				sCount = 0;
				
				if(script.lineList[startifIndex].indexOf("elseif") >= 0){
					if(ifvalue){
						ifvalueend = true;
						startifIndex++;
						continue;
					}
					start = script.lineList[startifIndex].indexOf("(");
					end = script.lineList[startifIndex].indexOf(")");
					str = script.lineList[startifIndex].substring(start + 1,end);
					str = ScriptVarlable.getVarlable(str);
					ifArr = str.split("&&");
					ifvalue = checkCondition(ifArr);
					startifIndex++;
					continue;
				}else if(script.lineList[startifIndex].indexOf("else") >= 0){
					if(ifvalue){
						ifvalueend = true;
						startifIndex++;
						continue;
					}
					ifvalue = true;
					endifIndex = startifIndex;
					startifIndex++;
					continue;
				}else if(script.lineList[startifIndex].indexOf("endif") >= 0){
					startifIndex++;
					break;
				}else if(script.lineList[startifIndex].indexOf("if") >= 0){
					if(ifvalue && !ifvalueend){
						childArray.push(script.lineList[startifIndex]);
					}
					startifIndex++;
					sCount = 1;
					eCount = 0;
					while(sCount > eCount){
						if(script.lineList[startifIndex].indexOf("if") >= 0 && 
							script.lineList[startifIndex].indexOf("else") < 0 && 
							script.lineList[startifIndex].indexOf("end") < 0){
							sCount++;
						}else if(script.lineList[startifIndex].indexOf("endif") >= 0){
							eCount++;
						}
						if(ifvalue && !ifvalueend){
							childArray.push(script.lineList[startifIndex]);
						}
						startifIndex++;
					}
				}
				if(sCount==0){
					if(ifvalue && !ifvalueend){
						childArray.push(script.lineList[startifIndex]);
					}
					startifIndex++;
				}
			}
			script.lineList.splice(0,startifIndex);
			
			for(var i:int=childArray.length - 1;i>=0;i--){
				script.lineList.unshift(childArray[i]);
			}
			
			
			script.analysis();
		} 
		/**
		 * 脚本解析
		 * 条件
		 * @param 脚本信息
		 * 1==1 && 2=>2
		 */
		public static function checkCondition(arr:Array):Boolean{
			for(var i:int = 0;i<arr.length;i++){
				trace("ScriptIF checkCondition arr[" + i + "] = ",arr[i],condition(arr[i]));
				if(!condition(arr[i])){
					return false;
				}	
			}
			return true;
		}
		/**
		 * 脚本解析
		 * 条件
		 * @param 脚本信息
		 * 1==1
		 * 2=>2
		 */
		private static function condition(value:String):Boolean{
			var arr:Array;
			if(value.indexOf("==") >= 0){
				//==
				arr=getCheckInt(value,"==");
				return arr[0] == arr[1];
			}else if(value.indexOf("===") >= 0){
				//===
				arr=getCheckStr(value,"===");
				return arr[0] == arr[1];
			}else if(value.indexOf("!=") >= 0){
				//!=
				arr=getCheckInt(value,"!=");
				return arr[0] != arr[1];
			}else if(value.indexOf("!==") >= 0){
				//!==
				arr=getCheckStr(value,"!==");
				return arr[0] != arr[1];
			}else if(value.indexOf(">=") >= 0){
				//>=
				arr=getCheckInt(value,">=");
				return arr[0] >= arr[1];
			}else if(value.indexOf("<=") >= 0){
				//<=
				arr=getCheckInt(value,"<=");
				return arr[0] <= arr[1];
			}else if(value.indexOf(">") >= 0){
				//>
				arr=getCheckInt(value,">");
				return arr[0] > arr[1];
			}else if(value.indexOf("<") >= 0){
				//<
				arr=getCheckInt(value,"<");
				return arr[0] < arr[1];
			}
			return false;
		}
		private static function getCheckInt(value:String,s:String):Array{
			var arr:Array;
			arr = value.split(s);
			arr[0] = int(arr[0]);
			arr[1] = int(arr[1]);
			
			return arr;
		}
		private static function getCheckStr(value:String,s:String):Array{
			var arr:Array;
			arr = value.split(s);
			arr[0] = LString.trim((arr[0] as String).replace('"',''));
			arr[1] = LString.trim((arr[1] as String).replace('"',''));
			
			
			return arr;
		}
	}
}