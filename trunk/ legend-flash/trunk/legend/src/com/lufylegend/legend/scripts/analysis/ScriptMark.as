package com.lufylegend.legend.scripts.analysis
{
	import flash.events.MouseEvent;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.scripts.analysis.text.ScriptLabel;
	import com.lufylegend.legend.scripts.analysis.text.ScriptWind;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LString;
	import com.lufylegend.legend.utils.transitions.LManager;

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