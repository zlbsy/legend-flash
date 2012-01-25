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

	public class ScriptMark
	{
		
		public function ScriptMark()
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
				case "Mark.goto":
					var isFound:Boolean = false;
					var mark:String = LString.trim(value.substring(start+1,end));
					var copyArray:Array = LGlobal.script.copyList.concat();
					var foundStr:String;
					while(copyArray.length){
						foundStr = copyArray.shift();
						if(foundStr.indexOf("Mark."+mark) >= 0){
							isFound = true;
							LGlobal.script.lineList = copyArray;
							LGlobal.script.analysis();
							return;
						}
					}
					break;
				default:
					LGlobal.script.analysis();
			}
			
		}
		/**
		 * 脚本解析
		 * 添加waitclick
		 * 
		 * @param 脚本信息
		 */
		private static function waitclick():void{
			var layer:LSprite = LGlobal.script.scriptLayer;
			layer.addEventListener(MouseEvent.CLICK,clickEvent);
		}
		private static function clickEvent(event:MouseEvent):void{
			LGlobal.script.scriptLayer.removeEventListener(MouseEvent.CLICK,clickEvent);
			LGlobal.script.analysis();
		}
	}
}